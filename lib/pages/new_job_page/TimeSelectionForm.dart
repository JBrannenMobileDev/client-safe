import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../utils/NavigationUtil.dart';
import '../../utils/UserOptionsUtil.dart';
import '../sunset_weather_page/SunsetWeatherPage.dart';

class TimeSelectionForm extends StatefulWidget {
  @override
  _TimeSelectionFormState createState() {
    return _TimeSelectionFormState();
  }
}

class _TimeSelectionFormState extends State<TimeSelectionForm> with AutomaticKeepAliveClientMixin{

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                "Select a time for this job.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
            ),
            pageState.sunsetDateTime != null ? Padding(
              padding: EdgeInsets.only(top: 8.0),
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
            ) : SizedBox(),
            Container(
              height: 200.0,
              child: CupertinoDatePicker(
                initialDateTime: pageState.initialTimeSelectorTime,
                onDateTimeChanged: (DateTime time) {
                  vibrate();
                  _onConfirmedTime(time, pageState);
                },
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
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

  void _onConfirmedTime(DateTime time, NewJobPageState pageState) {
    pageState.onTimeSelected(time);
  }

  @override
  bool get wantKeepAlive => true;
}
