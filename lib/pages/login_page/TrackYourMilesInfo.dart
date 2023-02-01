import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ImportantDate.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../widgets/TextDandyLight.dart';


class TrackYourMilesInfo extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TrackYourMilesInfo();
  }
}

class _TrackYourMilesInfo extends State<TrackYourMilesInfo> {

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
                    text: 'Mileage Tracking',
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
                          color: Color(ColorConstants.getBlueDark()),
                        ),
                      ),
                      Container(
                        width: 56,
                        child: Image.asset('assets/images/icons/driving_directions_icon_white.png', color: Color(ColorConstants.getPrimaryWhite()),),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Easily track and save business mileage for your tax deduction using our distance calculator.',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),

    );
  }
}
