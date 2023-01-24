import 'package:flutter/material.dart';

import '../ColorConstants.dart';

class Styles {

  static ButtonStyle getButtonStyle({
    double left = 8.0,
    double top = 0.0,
    double right = 8.0,
    double bottom = 0.0,
    OutlinedBorder shape,
    Color color,
    Color textColor,
  }) {
    return TextButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      shape: shape,
      foregroundColor: color,
      splashFactory: NoSplash.splashFactory,
      textStyle: TextStyle(
      fontSize: 20.0,
      fontFamily: 'simple',
      fontWeight: FontWeight.w600,
      color: Color(ColorConstants.primary_black),
      ),
    );
  }
}