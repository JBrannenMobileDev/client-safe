import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';

class ColorThemeWidget extends StatelessWidget {
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
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 4),
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Color(ColorConstants.getBlueDark())
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 4),
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Color(ColorConstants.getPeachDark())
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 4),
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        width: 1,
                        color: Color(ColorConstants.getPrimaryBackgroundGrey())
                    ),
                    color: Color(ColorConstants.getPrimaryWhite())
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8),
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Color(ColorConstants.getPeachDark())
                ),
              ),
              Container(
                child: Icon(
                  Icons.chevron_right,
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}