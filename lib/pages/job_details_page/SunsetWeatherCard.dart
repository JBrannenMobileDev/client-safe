import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';
import '../sunset_weather_page/SunsetWeatherPage.dart';
import 'JobDetailsPageState.dart';

class SunsetWeatherCard extends StatefulWidget {
  const SunsetWeatherCard({Key key}) : super(key: key);


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
                MaterialPageRoute(
                    builder: (context) => SunsetWeatherPage()),
              );
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.only(left: 16, top: 26, right: 16),
              height: 300,
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Sunset & Weather',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 64),
                    child: pageState.weatherIcon.isNotEmpty ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.only(top: 0.0, bottom: 16.0),
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: pageState.weatherIcon != null
                              ? Image.asset(pageState.weatherIcon, color: Color(ColorConstants.getBlueLight()),)
                              : const SizedBox(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 22, left: 0.0, bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: <Widget>[
                                  SizedBox(
                                    width: 88.0,
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: '${pageState.tempHigh}° - ${pageState.tempLow}°',
                                      textAlign: TextAlign.end,
                                      color: const Color(
                                          ColorConstants
                                              .primary_black),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Chance of rain:',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: ' ${pageState.chanceOfRain}%',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: <Widget>[
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Cloud coverage:',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: ' ${pageState.cloudCoverage}%',
                                    textAlign: TextAlign.end,
                                    color: const Color(
                                        ColorConstants
                                            .primary_black),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ) : Container(
                      margin: const EdgeInsets.only(left: 32, right: 32, top: 28),
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
                    padding: const EdgeInsets.only(top: 164, left: 16, right: 0, bottom: 8),
                    child: pageState.selectedLocation != null && pageState.selectedDate != null ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 16, top: 0),
                              height: 82,
                              width: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 168,
                                  height: 32,
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 168,
                                  height: 32,
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 168,
                                  height: 32,
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
                          margin: const EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.chevron_right,
                            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                          ),
                        ),
                      ],
                    ) : Container(
                      margin: const EdgeInsets.only(left: 32, right: 32, top: 28),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Sunset data is only available once there is a location and date are selected for this job.',
                        textAlign: TextAlign.center,
                        color:
                        Color(ColorConstants.getPeachDark()),
                      ),
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
