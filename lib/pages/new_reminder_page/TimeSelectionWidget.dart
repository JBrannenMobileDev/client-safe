import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/ReminderDandyLight.dart';
import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewReminderPage.dart';
import 'NewReminderPageState.dart';

class TimeSelectionWidget extends StatefulWidget {
  static const String BEFORE = "before";
  static const String ON = "on";
  static const String AFTER = "after";

  static const String DAYS = "Days";
  static const String WEEKS = "Weeks";
  static const String MONTHS = "Months";
  final ReminderDandyLight reminder;

  TimeSelectionWidget(this.reminder);

  @override
  _TimeSelectionWidgetState createState() {
    return _TimeSelectionWidgetState(reminder);
  }
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final ReminderDandyLight reminder;

  _TimeSelectionWidgetState(this.reminder);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewReminderPageState>(
      converter: (store) => NewReminderPageState.fromStore(store),
      builder: (BuildContext context, NewReminderPageState pageState) =>
          Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(
            color: Color(ColorConstants.white),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16.0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: "Select a time for this job reminder.",
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200.0,
                  child: CupertinoDatePicker(
                    initialDateTime: pageState.selectedTime,
                    onDateTimeChanged: (DateTime time) {
                      vibrate();
                      pageState.onTimeSelected(time);
                    },
                    use24hFormat: false,
                    minuteInterval: 1,
                    mode: CupertinoDatePickerMode.time,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }
}
