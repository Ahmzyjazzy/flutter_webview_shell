import 'package:app_shell/ui/screens/screens.dart';
import 'package:app_shell/utils/elotto_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_shell/ui/widgets/button_outline.dart';
import 'package:app_shell/ui/widgets/header_text.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class IntroScreen extends StatefulWidget {
  static String id = 'intro';
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _slideIndex = 0;

  final IndexController controller = IndexController();
  Widget _controlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: <Widget>[
            _slideIndex == 0
                ? Indicator(active: true)
                : Indicator(active: false),
            _slideIndex == 1
                ? Indicator(active: true)
                : Indicator(active: false),
            _slideIndex == 2
                ? Indicator(active: true)
                : Indicator(active: false),
            _slideIndex == 3
                ? Indicator(active: true)
                : Indicator(active: false),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {

    TransformerPageView transformerPageView = TransformerPageView(
      pageSnapping: true,
      onPageChanged: (index) {
        setState(
          () {
            this._slideIndex = index;
          },
        );
      },
      loop: true,
      controller: controller,
      transformer: PageTransformerBuilder(
        builder: (Widget child, TransformInfo info) {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ParallaxContainer(
                      child: Image.asset(
                        Elotto.intro_images[info.index],
                        fit: BoxFit.contain,
                        height: 150,
                      ),
                      position: info.position,
                      translationFactor: 400.0,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Text(
                          Elotto.intro_titles[_slideIndex],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          Elotto.intro_descriptions[_slideIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      itemCount: 4,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: HeaderText(),
              ),
              Expanded(
                flex: 3,
                child: Container(
//                color: Colors.red,
                  child: transformerPageView,
                ),
              ),
              SizedBox(height: 20.0),
              _controlButtons(),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: ButtonOutline(
                          label: 'Get Started',
                          width: 150.0,
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        WebScreen(url: Elotto.app_url)));
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  Indicator({this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      decoration: BoxDecoration(
        color: active ? Elotto.app_color : Color.fromRGBO(158, 158, 158, 0.52),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
