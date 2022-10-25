import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../utils/NavigationUtil.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/styles/Styles.dart';
import '../sunset_weather_page/SunsetWeatherPage.dart';

class TimeSelectionForm extends StatefulWidget {
  @override
  _TimeSelectionFormState createState() {
    return _TimeSelectionFormState();
  }
}

class _TimeSelectionFormState extends State<TimeSelectionForm> with AutomaticKeepAliveClientMixin{
  DateTime startTime = null;
  DateTime endTime = null;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.dispatch(FetchTimeOfSunsetAction(store.state.newJobPageState));
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) => Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
                "Select a start and end time for this job.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
            ),
            pageState.sunsetDateTime != null ? Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      pageState.onSunsetWeatherSelected();
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) => SunsetWeatherPage()),
                      );
                    },
                    child: Container(
                        child: Image.asset(
                          'assets/images/icons/sunset_icon_peach.png',
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      "Sunset is at " +
                          (pageState.sunsetDateTime != null
                              ? DateFormat('h:mm a').format(pageState.sunsetDateTime)
                              : ""),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w800,
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                  )
                ],
              ),
            ) : SizedBox(height: 48.0,),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                showTimeSelectionSheet(pageState, true);
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 4 + 100,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                height: 48.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26.0),
                    color: Color(ColorConstants.getPeachDark())),
                child:
                    Container(
                      child: Text(
                        pageState.selectedStartTime != null ? 'Start - ' + DateFormat('h:mm a').format(pageState.selectedStartTime) : 'Start time',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color:
                          Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 32.0),
              padding: EdgeInsets.only(top: 8.0),
              child: TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () {
                  showTimeSelectionSheet(pageState, false);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 4 + 100,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  height: 48.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26.0),
                      color: Color(ColorConstants.getPeachDark())),
                  child: Container(
                        child: Text(
                          pageState.selectedEndTime != null ? 'End - ' + DateFormat('h:mm a').format(pageState.selectedEndTime) : 'End time',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(
                                ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showTimeSelectionSheet(NewJobPageState pageState, bool isStartTime) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  height: MediaQuery.of(context).copyWith().size.height / 3,
                  child: CupertinoDatePicker(
                    initialDateTime: pageState.initialTimeSelectorTime,
                    onDateTimeChanged: (DateTime time) {
                      vibrate();
                      if(isStartTime) {
                        startTime = time;
                      } else {
                        endTime = time;
                      }
                    },
                    use24hFormat: false,
                    minuteInterval: 1,
                    mode: CupertinoDatePickerMode.time,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants
                              .getPrimaryBlack()),
                        ),
                      ),
                    ),
                    pageState.sunsetDateTime != null ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: new Image.asset(
                            'assets/images/icons/sunset_icon_peach.png',
                            height: 32.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            DateFormat('h:mm a').format(pageState.sunsetDateTime),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPeachDark()),
                            ),
                          ),
                        ),
                      ],
                    ) : SizedBox(),
                    TextButton(
                      style: Styles.getButtonStyle(),
                      onPressed: () {
                        if(isStartTime) {
                          pageState.onStartTimeSelected(startTime);
                        } else {
                          pageState.onEndTimeSelected(endTime);
                        }
                        VibrateUtil.vibrateHeavy();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Done',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }

  @override
  bool get wantKeepAlive => true;
}
