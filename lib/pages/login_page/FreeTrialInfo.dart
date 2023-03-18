import 'dart:ui';

import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';


class FreeTrialInfo extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _FreeTrialInfo();
  }
}

class _FreeTrialInfo extends State<FreeTrialInfo> {

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
                    text: '14 Day Free Trial',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8, top: 8),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 88,
                        width: 88,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(ColorConstants.getBlueLight()),
                        ),
                      ),
                      Container(
                        width: 56,
                        child: Image.asset('assets/images/icons/no_card.png', color: Color(ColorConstants.getPrimaryWhite()),),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'NO CARD REQUIRED\nThen only \$9.99/month',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),

    );
  }
}
