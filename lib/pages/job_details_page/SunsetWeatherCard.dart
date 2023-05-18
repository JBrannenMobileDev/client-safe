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
import '../sunset_weather_page/SunsetWeatherPage.dart';
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
          GestureDetector(
            onTap: () {
              pageState.onSunsetWeatherSelected();
              Navigator.of(context).push(
                new MaterialPageRoute(
                    builder: (context) => SunsetWeatherPage()),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
              height: 250,
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
                    margin: EdgeInsets.only(top: 44),
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
                      margin: EdgeInsets.only(left: 32, right: 32, top: 28),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Weather data is only available within 5 days of this job.',
                        textAlign: TextAlign.center,
                        color:
                        Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 124, left: 16, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 16),
                              height: 64,
                              width: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/images/icons/sunset_icon_peach.png',
                                  height: 32.0,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 220,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Golden Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.eveningGoldenHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 220,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Sunset',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.sunset,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 220,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Blue Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.eveningBlueHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryBlack()),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 36,
                          margin: EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.chevron_right,
                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }
}
