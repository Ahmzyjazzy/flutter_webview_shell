import 'package:app_shell/utils/edues_settings.dart';
import 'package:flutter/material.dart';

class ButtonOutline extends StatelessWidget {
  ButtonOutline({
    this.onPressed,
    this.label,
    this.buttonIcon,
    this.textColor,
    this.width,
  });

  final Function onPressed;
  final String label;
  final Widget buttonIcon;
  final Color textColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == null ? MediaQuery.of(context).size.width : width,
      child: OutlineButton(
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
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
                            color: textColor != null
                                ? textColor
                                : Edues.app_color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Edues.app_color, fontSize: 15.0),
              ),
        borderSide: BorderSide(
          color: Edues.app_color, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 0.8, //width of the border
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
