import 'package:app_shell/utils/edues_settings.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        Edues.app_name,
        style: TextStyle(
            color: Color(0xFF4D4D4D),
            fontSize: 30.0,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
