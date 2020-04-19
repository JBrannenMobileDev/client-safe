import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';

class GrayDividerWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 0.0),
      height: 1.0,
      color: Color(
          ColorConstants.getPrimaryBackgroundGrey()),
    );
  }
}