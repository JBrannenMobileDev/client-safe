import 'dart:ui';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';


class BusinessAnalyticsInfo extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BusinessAnalyticsInfo();
  }
}

class _BusinessAnalyticsInfo extends State<BusinessAnalyticsInfo> {

  @override
  Widget build(BuildContext context) {
    return Container(
            alignment: Alignment.topCenter,
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Business Analytics',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(ColorConstants.getPrimaryColor()),
                        ),
                      ),
                      Container(
                        width: 56,
                        child: Image.asset('assets/images/icons/bar_chart_icon.png', color: Color(ColorConstants.getPrimaryWhite()),),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'View your income, lead source and job type breakdown to help make better business decisions.',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),

    );
  }
}
