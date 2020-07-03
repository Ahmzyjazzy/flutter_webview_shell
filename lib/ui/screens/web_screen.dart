import 'dart:async';
import 'dart:ui';

import 'package:app_shell/utils/elotto_settings.dart';
import 'package:app_shell/utils/swift.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //PlatForm Exception
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

const kDesktopUserAgent =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36';

class WebScreen extends StatefulWidget {
  static String id = 'web';
  WebScreen({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> with WidgetsBindingObserver {
  //webview variable
  final _flutterWebviewPlugin = FlutterWebviewPlugin();
  bool _isLoading = true;
  double _progress = 0;

  //backkey press
  DateTime currentBackPressTime;

  //keyboard variable
  double _overlap = 0;
  bool _keyboardVisible = false;

  //connection variables
  bool _isConnected = true;
  String _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectionSubscription;

  // On destroy stream
  StreamSubscription _onDestroy;

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;
  StreamSubscription<double> _onScrollYChanged;
  StreamSubscription<double> _onScrollXChanged;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Elotto.app_color,
    ));

    _initConnectivity();
    _connectionSubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      print("InitConnectivity : $_connectionStatus $_isConnected");
      _initConnectivity();
    });

    _flutterWebviewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = _flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        print('onUrlChanged: $_');
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = _flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          print('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        _flutterWebviewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _progress = progress;
          print('Loading, please wait...${(progress * 100).toInt()}%');
        });
      }
    });

    _onScrollYChanged =
        _flutterWebviewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          print('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        _flutterWebviewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          print('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged = _flutterWebviewPlugin.onStateChanged.listen(
      (WebViewStateChanged viewState) {
        if (mounted) {
          print('onStateChanged: ${viewState.type} ${viewState.url}');
          if (viewState.type == WebViewState.startLoad) {
            print('webview start loading...');
          }

          if (viewState.type == WebViewState.abortLoad) {
            print('webview abort loading...');
          }

          if (viewState.type == WebViewState.finishLoad) {
            print('webview finished loading!');
          }
        }
      },
    );

    _onHttpError = _flutterWebviewPlugin.onHttpError.listen(
      (WebViewHttpError error) {
        if (mounted) {
          print('onHttpError: ${error.code} ${error.url}');
        }
      },
    );
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();
    _flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final renderObject = context.findRenderObject();
    final renderBox = renderObject as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap = widgetRect.bottom - keyboardTopPoints;
    if (overlap == 0 && _keyboardVisible == true) {
      setState(() {
        _overlap = overlap;
        _keyboardVisible = false;
      });
      print('keyboard closed $_overlap');
    }
    //render when keyboard is open once
    if (overlap > 0 && _keyboardVisible == false) {
      setState(() {
        _overlap = overlap;
        _keyboardVisible = true;
      });
      print('keyboard opened $_overlap');
    }
    //render when keyboard is close
  }

  //App Logic
  Future<bool> _backOrExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _flutterWebviewPlugin.evalJavascript('''
        if (\$('.page-current .pt-page-current div.header--control--item[data-action-name="backToHome"]').length > 0){
           \$('.page-current .pt-page-current div.header--control--item').click();
        } else if(\$('.page-current div.header--control--item[data-close="dropdown"]:first-child').length) {
           \$('.page-current div.header--control--item[data-close="dropdown"]:first-child').click();
        }
     ''');
      return Future.value(false);
    }
    print('Now close');
    _flutterWebviewPlugin.evalJavascript('''
        if (\$('.page-current .pt-page-current div.header--control--item[data-action-name="backToHome"]').length > 0){
           \$('.page-current .pt-page-current div.header--control--item').click();
        } else if(\$('.page-current div.header--control--item[data-close="dropdown"]:first-child').length) {
           \$('.page-current div.header--control--item[data-close="dropdown"]:first-child').click();
        }
        else {
            if(typeof(webInterface) !== undefined){
              webInterface.postMessage('closeApp');
            }
        }
     ''');
    return Future.value(true);
  }

  Future<Null> _initConnectivity() async {
    try {
      _connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      _connectionStatus = "Internet connectivity failed";
    }

    if (!mounted) {
      return;
    }

    if (_connectionStatus == "ConnectivityResult.mobile" ||
        _connectionStatus == "ConnectivityResult.wifi") {
      print("You are connected to internet 1");
      setState(() {
        _isConnected = true;
      });
    } else {
      print("You are not connected to internet 1");
      setState(() {
        _isConnected = false;
      });
    }
  }

  _addJavascriptHandlers(BuildContext context) {
    return [
      JavascriptChannel(
        name: 'webInterface',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
          switch (message.message) {
            case "closeApp":
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              break;
          }
        },
      )
    ].toSet();
  }

  // Web App
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _backOrExit,
      child: _isConnected
          ? SingleChildScrollView(
              child: Container(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: GestureDetector(
                  onLongPressEnd: (e) {
                    print(e);
                  },
                  onDoubleTap: () {
                    print('double type');
                  },
                  child: WebviewScaffold(
                    url: widget.url,
                    userAgent: kDesktopUserAgent,
                    appCacheEnabled: true,
                    debuggingEnabled: true,
                    clearCache: false,
                    withLocalStorage: true,
                    javascriptChannels: _addJavascriptHandlers(context),
                    resizeToAvoidBottomInset: true,
                    geolocationEnabled: true,
                    hidden: true,
                    initialChild: Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SpinKitDoubleBounce(
                              color: Elotto.app_color,
                              size: 50.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Prepairing application, please wait...${(_progress * 100).toInt()}%',
                              style: TextStyle(color: Color(0xFF222222)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ))
          : _connectionLost(),
    );
  }

  Widget _connectionLost() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                child: Image.asset(
                  'assets/images/network-failed.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'Something went wrong:-(',
                style: TextStyle(
                  color: Elotto.app_color,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Please check your connection.',
                style: TextStyle(color: Colors.black54, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                child: Text('Try again'),
                onPressed: () {
                  _initConnectivity();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
