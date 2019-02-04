import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  TitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 24.0,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w600,
          color: const Color(ColorConstants.primary_dark),
        ),
      ),
    );
  }
}
