import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/widgets/bouncing_loading_animation/BouncingLoadingAnimatedIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

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
          store.dispatch(SetLastKnowPosition(store.state.sunsetWeatherPageState));
        },
        converter: (store) => SunsetWeatherPageState.fromStore(store),
        builder: (BuildContext context, SunsetWeatherPageState pageState) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.white,
                        pinned: true,
                        centerTitle: true,
                        title: Container(
                          child: Text(
                            "Sunset & Weather",
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 8.0, left: 0.0),
                              child: Text(
                                pageState.weatherDescription,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w800,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ),
                            pageState.isWeatherDataLoading ? pageState.showFartherThan7DaysError ? Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 64.0, right: 64.0, bottom: 16.0),
                              height: (MediaQuery.of(context).size.width/4) + 16,
                              child: Text(
                                'Weather data is not available yet for the date selected. Check back within 7 days of your desired date.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w800,
                                  color: Color(ColorConstants.getPeachDark()),
                                ),
                              ),
                            ) : Container(
                              height: (MediaQuery.of(context).size.width/4) + 16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Loading weather data',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w800,
                                      color: Color(ColorConstants.getPeachDark()),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 32.0),
                                    child: BouncingLoadingAnimatedIcon(),
                                  ),
                                ],
                              ),
                            ) : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 0.0, bottom: 16.0),
                                  height: MediaQuery.of(context).size.width/4,
                                  width: MediaQuery.of(context).size.width/4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: pageState.weatherIcon != null ? Image(image: pageState.weatherIcon) : SizedBox(),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16, left: 0.0, bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: 88.0,
                                            child: Text(
                                              pageState.tempHigh + '° - ' +  pageState.tempLow + '°',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: 'simple',
                                                color: const Color(ColorConstants.primary_black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: 158.0,
                                            child: Text(
                                            'Chance of rain:',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              color: const Color(ColorConstants.primary_black),
                                            ),
                                          ),
                                          ),
                                          Container(
                                            width: 42.0,
                                            child: Text(
                                              ' ' + pageState.chanceOfRain + '%',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: 'simple',
                                                color: const Color(ColorConstants.primary_black),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: 158.0,
                                            child: Text(
                                            'Cloud coverage:',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              color: const Color(ColorConstants.primary_black),
                                            ),
                                          ),
                                          ),
                                          Container(
                                            width: 42.0,
                                            child: Text(
                                            ' ' + pageState.cloudCoverage + '%',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w800,
                                              color: const Color(ColorConstants.primary_black),
                                            ),
                                          ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                                FlatButton(
                                  onPressed: () {
                                    UserOptionsUtil.showDateSelectionCalendarDialog(context);
                                  },
                                  padding: EdgeInsets.all(0.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/4 + 200,
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                                    height: 48.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(26.0),
                                        color: Color(ColorConstants.getPeachDark())
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                              margin: EdgeInsets.only(right: 16.0),
                                              height: 26.0,
                                              width: 26.0,
                                              child: Image.asset('assets/images/icons/location_icon_white.png'),
                                        ),
                                        Container(
                                          child: Text(
                                            pageState.locationName,
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'simple',
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants.getPrimaryWhite()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(
                                          context,
                                          dateFormat: 'MMMM dd yyyy',
                                          pickerMode: DateTimePickerMode.date,
                                          onConfirm: (dateTime, intList) {
                                            pageState.onDateSelected(dateTime);
                                          }
                                      );
                                    },
                                    padding: EdgeInsets.all(0.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/4 + 200,
                                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(26.0),
                                          color: Color(ColorConstants.getPeachDark())
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 16.0),
                                            height: 26.0,
                                            width: 26.0,
                                            child: Image.asset('assets/images/icons/calendar_icon_white.png'),
                                          ),
                                          Container(
                                            child: Text(
                                              DateFormat('MMM dd, yyy').format(pageState.selectedDate),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontFamily: 'simple',
                                                fontWeight: FontWeight.w600,
                                                color: Color(ColorConstants.getPrimaryWhite()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            Container(
                              margin: EdgeInsets.only(top: 32.0, left: 0.0),
                              child: Text(
                                DateFormat('EEEE').format(pageState.selectedDate),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w800,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ),
                            pageState.isWeatherDataLoading ? Container(
                              height: 156.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Loading hourly weather data',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w800,
                                      color: Color(ColorConstants.getPeachDark()),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 32.0),
                                    child: BouncingLoadingAnimatedIcon(),
                                  ),
                                ],
                              ),
                            ) : Container(
                              padding: EdgeInsets.all(0.0),
                              margin: EdgeInsets.only(top: 0.0, bottom: 32.0),
                              height: 124.0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 12,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: _buildItem,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0.0, bottom: 8.0, left: 0.0),
                              child: Text(
                                'Evening',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w800,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ),
                            pageState.isSunsetDataLoading ? Container(
                              height: (MediaQuery.of(context).size.width/4) + 16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Loading sunset data',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w800,
                                      color: Color(ColorConstants.getPeachDark()),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 32.0),
                                    child: BouncingLoadingAnimatedIcon(),
                                  ),
                                ],
                              ),
                            ) : Column(

                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Golden Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPrimaryColor()),
                                        ),
                                      ),
                                      Text(
                                        pageState.eveningGoldenHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPrimaryColor()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Sunset',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPeachDark()),
                                        ),
                                      ),
                                      Text(
                                        pageState.sunset,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPeachDark()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Blue Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getBlueLight()),
                                        ),
                                      ),
                                      Text(
                                        pageState.eveningBlueHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getBlueLight()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 0.0),
                              child: Text(
                                'Morning',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w800,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ),
                            pageState.isSunsetDataLoading ? Container(
                              height: (MediaQuery.of(context).size.width/4) + 16,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Loading sunset data',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w800,
                                      color: Color(ColorConstants.getPeachDark()),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 32.0),
                                    child: BouncingLoadingAnimatedIcon(),
                                  ),
                                ],
                              ),
                            ) : Column(

                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Blue Hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getBlueLight()),
                                        ),
                                      ),
                                      Text(
                                        pageState.morningBlueHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getBlueLight()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Sunrise',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPeachDark()),
                                        ),
                                      ),
                                      Text(
                                        pageState.sunrise,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPeachDark()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 26.0, right: 26.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Golden hour',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPrimaryColor()),
                                        ),
                                      ),
                                      Text(
                                        pageState.morningGoldenHour,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'simple',
                                          fontWeight: FontWeight.w800,
                                          color: Color(ColorConstants.getPrimaryColor()),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
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

void vibrate() async {
  HapticFeedback.mediumImpact();
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, SunsetWeatherPageState>(
    converter: (store) => SunsetWeatherPageState.fromStore(store),
    builder: (BuildContext context, SunsetWeatherPageState pageState) =>
        GestureDetector(
          onTap: () {

          },
          child: Container(
            margin: EdgeInsets.only(left: index == 0 ? 16.0 : 0.0),
            width: 72.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  _getHourText(pageState.selectedFilterIndex, index),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 16.0),
                  height: 36.0,
                  width: 36.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/icons/sunny_icon_gold.png'),
                ),
                Text(
                  '87°',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

String _getHourText(int selectorIndex, int index) {
  if(selectorIndex == 0) {
    switch(index){
      case 0:
        return '12pm';
        break;
      case 1:
        return '1pm';
        break;
      case 2:
        return '2pm';
        break;
      case 3:
        return '3pm';
        break;
      case 4:
        return '4pm';
        break;
      case 5:
        return '5pm';
        break;
      case 6:
        return '6pm';
        break;
      case 7:
        return '7pm';
        break;
      case 8:
        return '8pm';
        break;
      case 9:
        return '9pm';
        break;
      case 10:
        return '10pm';
        break;
      case 11:
        return '11pm';
        break;
    }
    return '';
  } else {
    switch(index){
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
    }
    return '';
  }
}
