//import 'dart:async';
//import 'dart:ui';
//
//import 'package:app_shell/blocs/web/web_bloc.dart';
//import 'package:app_shell/utils/edues_settings.dart';
//import 'package:app_shell/utils/swift.dart';
//import 'package:connectivity/connectivity.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart'; //PlatForm Exception
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//
//class WebScreen extends StatefulWidget {
//  static String id = 'web';
//  WebScreen({Key key, this.url}) : super(key: key);
//
//  final String url;
//
//  @override
//  _WebScreenState createState() => _WebScreenState();
//}
//
//class _WebScreenState extends State<WebScreen> with WidgetsBindingObserver {
//  //webview variable
//  final _flutterWebviewPlugin = FlutterWebviewPlugin();
//  bool _isLoading = true;
//
//  //backkey press
//  DateTime currentBackPressTime;
//
//  //keyboard variable
//  double _overlap = 0;
//  bool _keyboardVisible = false;
//
//  //connection variables
//  StreamSubscription<ConnectivityResult> _connectionSubscription;
//
//  // On destroy stream
//  StreamSubscription _onDestroy;
//
//  // On urlChanged stream
//  StreamSubscription<String> _onUrlChanged;
//
//  // On urlChanged stream
//  StreamSubscription<WebViewStateChanged> _onStateChanged;
//  StreamSubscription<WebViewHttpError> _onHttpError;
//  StreamSubscription<double> _onProgressChanged;
//  StreamSubscription<double> _onScrollYChanged;
//  StreamSubscription<double> _onScrollXChanged;
//
//  // pull to refresh
//  Completer<void> _refreshCompleter;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    _refreshCompleter = Completer<void>();
//
//    WidgetsBinding.instance.addObserver(this);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//      statusBarColor: Edues.app_color,
//    ));
//
//    _flutterWebviewPlugin.close();
//
//    // Add a listener to on destroy WebView, so you can make came actions.
//    _onDestroy = _flutterWebviewPlugin.onDestroy.listen((_) {
//      if (mounted) {
//        // Actions like show a info toast.
//        print('onDestroy: $_');
//      }
//    });
//
//    // Add a listener to on url changed
//    _onUrlChanged = _flutterWebviewPlugin.onUrlChanged.listen((String url) {
//      if (mounted) {
//        setState(() {
//          print('onUrlChanged: $url');
//        });
//      }
//    });
//
//    _onProgressChanged =
//        _flutterWebviewPlugin.onProgressChanged.listen((double progress) {
//      if (mounted) {
//        setState(() {
//          Swift.showToast(
//              msg: 'Loading, please wait...${(progress * 100).toInt()}%');
//          print('onProgressChanged: ${(progress * 100).toInt()}%');
//        });
//      }
//    });
//
//    _onScrollYChanged =
//        _flutterWebviewPlugin.onScrollYChanged.listen((double y) {
//      if (mounted) {
//        setState(() {
//          print('Scroll in Y Direction: $y');
//        });
//      }
//    });
//
//    _onScrollXChanged =
//        _flutterWebviewPlugin.onScrollXChanged.listen((double x) {
//      if (mounted) {
//        setState(() {
//          print('Scroll in X Direction: $x');
//        });
//      }
//    });
//
//    _onStateChanged = _flutterWebviewPlugin.onStateChanged.listen(
//      (WebViewStateChanged viewState) {
//        if (mounted) {
//          print('onStateChanged: ${viewState.type} ${viewState.url}');
//          if (viewState.type == WebViewState.startLoad) {
//            print('webview start loading...');
//          }
//
//          if (viewState.type == WebViewState.abortLoad) {
//            print('webview abort loading...');
//          }
//
//          if (viewState.type == WebViewState.finishLoad) {
//            print('webview finished loading!');
//          }
//        }
//      },
//    );
//
//    _onHttpError = _flutterWebviewPlugin.onHttpError.listen(
//      (WebViewHttpError error) {
//        if (mounted) {
//          print('onHttpError: ${error.code} ${error.url}');
//        }
//      },
//    );
//  }
//
//  @override
//  void dispose() {
//    // Every listener should be canceled, the same should be done with this stream.
//    _onDestroy.cancel();
//    _onUrlChanged.cancel();
//    _onStateChanged.cancel();
//    _onHttpError.cancel();
//    _onProgressChanged.cancel();
//    _onScrollXChanged.cancel();
//    _onScrollYChanged.cancel();
//    _flutterWebviewPlugin.dispose();
//    super.dispose();
//  }
//
//  @override
//  void didChangeMetrics() {
//    print('did change met called');
//    final renderObject = context.findRenderObject();
//    final renderBox = renderObject as RenderBox;
//    final offset = renderBox.localToGlobal(Offset.zero);
//    final widgetRect = Rect.fromLTWH(
//      offset.dx,
//      offset.dy,
//      renderBox.size.width,
//      renderBox.size.height,
//    );
//    final keyboardTopPixels =
//        window.physicalSize.height - window.viewInsets.bottom;
//    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
//    final overlap = widgetRect.bottom - keyboardTopPoints;
//    if (overlap == 0 && _keyboardVisible == true) {
//      setState(() {
//        _overlap = overlap;
//        _keyboardVisible = false;
//      });
//      print('keyboard closed $_overlap');
//    }
//    //render when keyboard is open once
//    if (overlap > 0 && _keyboardVisible == false) {
//      setState(() {
//        _overlap = overlap;
//        _keyboardVisible = true;
//      });
//      print('keyboard opened $_overlap');
//    }
//    //render when keyboard is close
//  }
//
//  //App Logic
//  Future<bool> _backOrExit() {
//    DateTime now = DateTime.now();
//    if (currentBackPressTime == null ||
//        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//      currentBackPressTime = now;
//      _flutterWebviewPlugin.evalJavascript('''
//        if (\$('.page-current .pt-page-current div.header--control--item[data-action-name="backToHome"]').length > 0){
//           \$('.page-current .pt-page-current div.header--control--item').click();
//        } else if(\$('.page-current div.header--control--item[data-close="dropdown"]:first-child').length) {
//           \$('.page-current div.header--control--item[data-close="dropdown"]:first-child').click();
//        }
//     ''');
//      return Future.value(false);
//    }
//    print('Now close');
//    _flutterWebviewPlugin.evalJavascript('''
//        if (\$('.page-current .pt-page-current div.header--control--item[data-action-name="backToHome"]').length > 0){
//           \$('.page-current .pt-page-current div.header--control--item').click();
//        } else if(\$('.page-current div.header--control--item[data-close="dropdown"]:first-child').length) {
//           \$('.page-current div.header--control--item[data-close="dropdown"]:first-child').click();
//        }
//        else {
//            if(typeof(webInterface) !== undefined){
//              webInterface.postMessage('closeApp');
//            }
//        }
//     ''');
//    return Future.value(true);
//  }
//
//  _addJavascriptHandlers(BuildContext context) {
//    return [
//      JavascriptChannel(
//        name: 'webInterface',
//        onMessageReceived: (JavascriptMessage message) {
//          print(message.message);
//          switch (message.message) {
//            case "closeApp":
//              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//              break;
//          }
//        },
//      )
//    ].toSet();
//  }
//
//  // Web App
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        onWillPop: _backOrExit,
//        child: BlocBuilder<WebBloc, WebState>(
//            builder: (BuildContext context, WebState state) {
//          if (state is WebConnected) {
//            _connectionSubscription = state.connectivity.onConnectivityChanged
//                .listen((ConnectivityResult result) {
//              print(
//                  "InitConnectivity : ${state.connectionStatus}, ${state.connected}");
//            });
//            if (state.connected == false) return _connectionLost();
//            return SingleChildScrollView(
//              child: Container(
//                height: MediaQuery.of(context).size.height,
//                child: SafeArea(
//                  child: RefreshIndicator(
//                    child: WebviewScaffold(
//                      url: widget.url,
//                      userAgent: Swift.kDesktopUserAgent,
//                      appCacheEnabled: false,
//                      debuggingEnabled: true,
//                      clearCache: true,
//                      withLocalStorage: true,
//                      javascriptChannels: _addJavascriptHandlers(context),
//                      resizeToAvoidBottomInset: true,
//                      geolocationEnabled: true,
//                      initialChild: Loader(),
//                    ),
//                    onRefresh: () {
//                      BlocProvider.of<WebBloc>(context)..add(CheckConnection());
//                      return _refreshCompleter.future;
//                    },
//                  ),
//                ),
//              ),
//            );
//          }
//          if (state is WebLoading) {
//            return Loader();
//          }
//          return _connectionLost();
//        }));
//  }
//
//  Widget _connectionLost() {
//    return SafeArea(
//      child: Scaffold(
//        body: Container(
//          width: MediaQuery.of(context).size.width,
//          padding: EdgeInsets.all(20.0),
//          color: Colors.white,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              SizedBox(
//                height: 200.0,
//                child: Image.asset(
//                  'assets/images/network-failed.png',
//                  fit: BoxFit.contain,
//                ),
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              Text(
//                'Something went wrong:-(',
//                style: TextStyle(
//                  color: Edues.app_color,
//                  fontSize: 16.0,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//              SizedBox(
//                height: 10.0,
//              ),
//              Text(
//                'Please check your connection.',
//                style: TextStyle(color: Colors.black54, fontSize: 16.0),
//                textAlign: TextAlign.center,
//              ),
//              SizedBox(
//                height: 20.0,
//              ),
//              RaisedButton(
//                child: Text('Try again'),
//                onPressed: () {
////                  BlocProvider.of<WebBloc>(context).add(CheckConnection());
//                },
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class Loader extends StatelessWidget {
//  const Loader({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        color: Colors.white,
//        child: Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: [
//              CircularProgressIndicator(),
//              SizedBox(
//                height: 10,
//              ),
//              Text(
//                'Preparing application...',
//                style: TextStyle(color: Colors.black54, fontSize: 16.0),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
