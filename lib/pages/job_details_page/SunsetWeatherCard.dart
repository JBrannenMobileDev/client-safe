import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../AppState.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';
import 'JobDetailsPageState.dart';

class SunsetWeatherCard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SunsetWeatherCard();
  }
}

class _SunsetWeatherCard extends State<SunsetWeatherCard> {
  DateTime newDateTimeHolder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        newDateTimeHolder = store.state.jobDetailsPageState.job.selectedTime;
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Container(
            margin: EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
            height: 216,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Sunset & Weather',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 38),
                  child: pageState.weatherIcon.isNotEmpty ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 0.0, bottom: 16.0),
                        height: MediaQuery.of(context).size.width / 4,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: pageState.weatherIcon != null
                            ? Image.asset(pageState.weatherIcon, color: Color(ColorConstants.getBlueLight()),)
                            : SizedBox(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 22, left: 0.0, bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 88.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: pageState.tempHigh +
                                        '° - ' +
                                        pageState.tempLow +
                                        '°',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Chance of rain:',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                ),
                                Container(
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: ' ' +
                                        pageState.chanceOfRain +
                                        '%',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Cloud coverage:',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                ),
                                Container(
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: ' ' +
                                        pageState.cloudCoverage +
                                        '%',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ) : Container(
                    margin: EdgeInsets.only(left: 32, right: 32, top: 38),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Weather data is only available within 5 days of this job.',
                      textAlign: TextAlign.center,
                      color:
                      Color(ColorConstants.getPeachDark()),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }
}
