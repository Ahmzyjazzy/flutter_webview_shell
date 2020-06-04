import 'package:app_shell/utils/edues_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivacyTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'By clicking Create an Account you agree to the\n',
              style:
                  TextStyle(fontSize: 10, color: Colors.black54, height: 1.5),
              children: <TextSpan>[
                TextSpan(
                  text: 'Privacy',
                  style: TextStyle(
                    color: Edues.app_color,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // navigate to desired screen
                    },
                ),
                TextSpan(
                  text: ' and ',
                  style: TextStyle(fontSize: 10),
                ),
                TextSpan(
                  text: 'Terms of Use',
                  style: TextStyle(color: Edues.app_color),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // navigate to desired screen
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
