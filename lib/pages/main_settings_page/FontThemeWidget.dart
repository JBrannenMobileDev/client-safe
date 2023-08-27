import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';

class FontThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDandyLight(
            type: TextDandyLight.SMALL_TEXT,
            text: 'DandyLight Theme',
            textAlign: TextAlign.center,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          Container(
            child: Icon(
              Icons.chevron_right,
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
          ),
        ],
      ),
    );
  }

}