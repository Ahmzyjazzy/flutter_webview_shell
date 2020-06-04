import 'package:app_shell/utils/edues_settings.dart';
import 'package:flutter/material.dart';

class ButtonSolid extends StatelessWidget {
  ButtonSolid(
      {@required this.onPressed,
      @required this.label,
      this.width,
      this.buttonIcon,
      this.textColor});

  final Function onPressed;
  final String label;
  final double width;
  final Widget buttonIcon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width == null ? MediaQuery.of(context).size.width : width,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      color: Edues.app_color,
      onPressed: onPressed,
      child: buttonIcon != null
          ? Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: buttonIcon,
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        label,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15.0,
                            color:
                                textColor != null ? textColor : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor != null ? textColor : Colors.white,
                  fontSize: 15.0),
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
