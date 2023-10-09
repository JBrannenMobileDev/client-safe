import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:dandylight/widgets/bouncing_loading_animation/BouncingLoadingAnimatedIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';

class SunsetWeatherPage extends StatefulWidget {
  static const String FILTER_TYPE_EVENING = "Evening";
  static const String FILTER_TYPE_MORNING = "Morning";

  @override
  State<StatefulWidget> createState() {
    return _SunsetWeatherPageState();
  }
}

class _SunsetWeatherPageState extends State<SunsetWeatherPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SunsetWeatherPageState>(
      onInit: (store) async {
        await UserPermissionsUtil.showPermissionRequest(permission: Permission.locationWhenInUse, context: context);
        store.dispatch(SetLastKnowPosition(store.state.sunsetWeatherPageState));
      },
      converter: (store) => SunsetWeatherPageState.fromStore(store),
      builder: (BuildContext context, SunsetWeatherPageState pageState) =>
          Scaffold(
        backgroundColor: Color(ColorConstants.getPrimaryWhite()),
        body: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  brightness: Brightness.light,
                  backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                  pinned: true,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Device.get().isIos
                        ? Icons.arrow_back_ios
                        : Icons.arrow_back),
                    color: Color(ColorConstants.getPrimaryBlack()),
                    tooltip: 'Close',
                    onPressed: () {
                      pageState.clearPageState();
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Container(
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: "Sunset & Weather",
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 8.0, left: 0.0, bottom: 8),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: DateFormat('EEEE').format(pageState.selectedDate) +
                              ' - ' +
                              pageState.weatherDescription,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      pageState.isWeatherDataLoading
                          ? pageState.showFartherThan7DaysError
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 64.0, right: 64.0, bottom: 16.0),
                                  height:
                                      (MediaQuery.of(context).size.width / 4) +
                                          16,
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Weather data is not available yet for the date selected. Check back within 7 days of your desired date.',
                                    textAlign: TextAlign.center,
                                    color:
                                    Color(ColorConstants.getPeachDark()),
                                  ),
                                )
                              : Container(
                                  height:
                                      (MediaQuery.of(context).size.width / 4) +
                                          16,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Loading weather data',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPeachDark()),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 32.0),
                                        child: BouncingLoadingAnimatedIcon(),
                                      ),
                                    ],
                                  ),
                                )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 0.0, bottom: 16.0),
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
                                  margin: EdgeInsets.only(
                                      top: 16, left: 0.0, bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                            ),
                      TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          pageState.chooseLocationSelected();
                          UserOptionsUtil.showSelectLocationDialog(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 16, right: 8),
                          height: 48.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.0),
                              color: Color(ColorConstants.getPeachDark())),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 8.0, left: 16),
                                height: 26.0,
                                width: 26.0,
                                child: Image.asset(
                                    'assets/images/icons/pin_white.png', color: Color(ColorConstants.getPrimaryWhite()),),
                              ),
                              Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: TextDandyLight(
                                      type: TextDandyLight.MEDIUM_TEXT,
                                      text: pageState.locationName,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 32.0),
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                dateFormat: 'MMMM dd yyyy',
                                pickerMode: DateTimePickerMode.date,
                                onConfirm: (dateTime, intList) {
                              pageState.onDateSelected(dateTime);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 16, right: 16),
                            height: 48.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26.0),
                                color: Color(ColorConstants.getPeachDark())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 16.0),
                                  height: 26.0,
                                  width: 26.0,
                                  child: Image.asset(
                                      'assets/images/icons/calendar_bold_white.png'),
                                ),
                                Container(
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: DateFormat('MMM dd, yyy')
                                        .format(pageState.selectedDate),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    color: Color(
                                        ColorConstants.getPrimaryWhite()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      pageState.isWeatherDataLoading
                          ? pageState.hoursForecast.length == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 64.0, right: 64.0, bottom: 16.0),
                                  height:
                                      (MediaQuery.of(context).size.width / 4) +
                                          16,
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Hourly weather data is only available for the current day.',
                                    textAlign: TextAlign.center,
                                    color:
                                    Color(ColorConstants.getPeachDark()),
                                  ),
                                )
                              : Container(
                                  height: 156.0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Loading hourly weather data',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPeachDark()),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 32.0),
                                        child: BouncingLoadingAnimatedIcon(),
                                      ),
                                    ],
                                  ),
                                )
                          : pageState.hoursForecast.length > 0 ? Container(
                              padding: EdgeInsets.all(0.0),
                              margin: EdgeInsets.only(top: 0.0, bottom: 32.0),
                              height: 124.0,
                              child: ListView.builder(
                                controller: _controller,
                                shrinkWrap: true,
                                itemCount: pageState.hoursForecast.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: _buildSingleDayForecastItem,
                              ),
                            ) : Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            left: 64.0, right: 64.0, bottom: 16.0),
                        height:
                        (MediaQuery.of(context).size.width / 4) +
                            16,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Hourly weather data is only available for the current day.',
                          textAlign: TextAlign.center,
                          color:
                          Color(ColorConstants.getPeachDark()),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: 0.0, bottom: 8.0, left: 0.0),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Evening',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      pageState.isSunsetDataLoading
                          ? Container(
                              height:
                                  (MediaQuery.of(context).size.width / 4) + 16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Loading sunset data',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    color:
                                    Color(ColorConstants.getPeachDark()),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 32.0),
                                    child: BouncingLoadingAnimatedIcon(),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Golden Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryColor()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.eveningGoldenHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryColor()),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Sunset',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPeachDark()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.sunset,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPeachDark()),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Blue Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getBlueLight()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.eveningBlueHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getBlueLight()),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Container(
                        margin:
                            EdgeInsets.only(top: 16.0, bottom: 8.0, left: 0.0),
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Morning',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      pageState.isSunsetDataLoading
                          ? Container(
                              height:
                                  (MediaQuery.of(context).size.width / 4) + 16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: 'Loading sunset data',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    color: Color(ColorConstants.getPeachDark()),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 32.0),
                                    child: BouncingLoadingAnimatedIcon(),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Blue Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getBlueLight()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.morningBlueHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getBlueLight()),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Sunrise',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPeachDark()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.sunrise,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPeachDark()),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: 'Golden hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryColor()),
                                      ),
                                      TextDandyLight(
                                        type: TextDandyLight.MEDIUM_TEXT,
                                        text: pageState.morningGoldenHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        color: Color(
                                            ColorConstants.getPrimaryColor()),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      Container(
                        margin: EdgeInsets.only(left: 64.0, top: 64.0, right: 64.0, bottom: 64.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Sunrise - Sunset data is provided by ',
                              style: TextStyle(
                                fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
                                fontFamily: TextDandyLight.getFontFamily(),
                                fontWeight: TextDandyLight.getFontWeight(),
                                color: Color(
                                    ColorConstants.getPrimaryBlack()),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Sunrise-sunset.org',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      _launchURL();
                                    },
                                  style: TextStyle(
                                    fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
                                    fontFamily: TextDandyLight.getFontFamily(),
                                    fontWeight: TextDandyLight.getFontWeight(),
                                    color: Color(
                                        ColorConstants.getPeachDark()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _launchURL() async =>
    await canLaunchUrl(Uri.parse('https://sunrise-sunset.org/')) ? await launchUrl(Uri.parse('https://sunrise-sunset.org/')) : throw 'Could not launch';

void vibrate() async {
  HapticFeedback.mediumImpact();
}

Widget _buildSingleDayForecastItem(BuildContext context, int index) {
  return StoreConnector<AppState, SunsetWeatherPageState>(
    converter: (store) => SunsetWeatherPageState.fromStore(store),
    builder: (BuildContext context, SunsetWeatherPageState pageState) =>
        GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(left: index == 0 ? 16.0 : 0.0),
        width: 72.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: _getHourText(pageState.hoursForecast.elementAt(index).dateTime),
              textAlign: TextAlign.start,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 16.0),
              height: 36.0,
              width: 36.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(getWeatherIcon(pageState.hoursForecast.elementAt(index).weatherIcon), color: Color(ColorConstants.getBlueLight()),),
            ),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: pageState.hoursForecast
                      .elementAt(index)
                      .temperature.value.toInt().toString() +
                  '°',
              textAlign: TextAlign.start,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ],
        ),
      ),
    ),
  );
}

String _getHourText(String time) {
  DateTime dateTime = DateTime.parse(time).toLocal();
  switch (dateTime.hour) {
    case 0:
      return '12am';
      break;
    case 1:
      return '1am';
      break;
    case 2:
      return '2am';
      break;
    case 3:
      return '3am';
      break;
    case 4:
      return '4am';
      break;
    case 5:
      return '5am';
      break;
    case 6:
      return '6am';
      break;
    case 7:
      return '7am';
      break;
    case 8:
      return '8am';
      break;
    case 9:
      return '9am';
      break;
    case 10:
      return '10am';
      break;
    case 11:
      return '11am';
      break;
    case 12:
      return '12pm';
      break;
    case 13:
      return '1pm';
      break;
    case 14:
      return '2pm';
      break;
    case 15:
      return '3pm';
      break;
    case 16:
      return '4pm';
      break;
    case 17:
      return '5pm';
      break;
    case 18:
      return '6pm';
      break;
    case 19:
      return '7pm';
      break;
    case 20:
      return '8pm';
      break;
    case 21:
      return '9pm';
      break;
    case 22:
      return '10pm';
      break;
    case 23:
      return '11pm';
      break;
  }
  return '';
}

String getWeatherIcon(int iconId) {
  String imageToReturn = 'assets/images/icons/sunny_icon_gold.png';
  switch(iconId) {
    case 1:
    case 2:
    case 30:
      imageToReturn = 'assets/images/icons/sunny_icon_gold.png';
      break;
    case 3:
    case 4:
    case 5:
      imageToReturn = 'assets/images/icons/partly_cloudy_icon.png';
      break;
    case 6:
    case 7:
    case 8:
    case 31:
      imageToReturn = 'assets/images/icons/cloudy_icon.png';
      break;
    case 11:
      imageToReturn = 'assets/images/icons/fog.png';
      break;
    case 12:
    case 13:
    case 14:
    case 18:
    case 29:
      imageToReturn = 'assets/images/icons/rainy_icon.png';
      break;
    case 15:
    case 16:
    case 17:
    case 41:
    case 42:
      imageToReturn = 'assets/images/icons/lightning_rain_icon.png';
      break;
    case 19:
    case 20:
    case 21:
    case 22:
    case 23:
    case 24:
    case 43:
    case 44:
      imageToReturn = 'assets/images/icons/snowing_icon.png';
      break;
    case 25:
    case 26:
      imageToReturn = 'assets/images/icons/hail_icon.png';
      break;
    case 32:
      imageToReturn = 'assets/images/icons/windy.png';
      break;
    case 33:
    case 34:
      imageToReturn = 'assets/images/icons/clear_night.png';
      break;
    case 35:
    case 36:
    case 37:
    case 38:
      imageToReturn = 'assets/images/icons/partly_cloudy_night.png';
      break;
    case 39:
    case 40:
      imageToReturn = 'assets/images/icons/rainy_night.png';
      break;
  }
  return imageToReturn;
}
