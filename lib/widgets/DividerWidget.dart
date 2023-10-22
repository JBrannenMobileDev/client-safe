import 'package:flutter/widgets.dart';

import '../utils/ColorConstants.dart';

class DividerWidget extends StatelessWidget {
  final double width;

  DividerWidget({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32, left: 16, right: 16),
      width: width,
      height: 1,
      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
    );
  }

}