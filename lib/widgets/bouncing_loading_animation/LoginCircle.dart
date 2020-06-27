import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class LoginCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(3.0),
      width: 5.0,
      height: 5.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Color(ColorConstants.getPrimaryWhite()),
      ),
    );
  }
}
