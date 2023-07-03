import 'package:flutter/widgets.dart';

import '../utils/ColorConstants.dart';

class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32, left: 32, right: 32),
      width: 1080,
      height: 1,
      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
    );
  }

}