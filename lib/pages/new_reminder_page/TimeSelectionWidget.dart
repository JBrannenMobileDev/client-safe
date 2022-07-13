import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/Reminder.dart';
import '../../utils/ColorConstants.dart';
import 'NewReminderPage.dart';
import 'NewReminderPageState.dart';

class TimeSelectionWidget extends StatefulWidget {
  static const String BEFORE = "before";
  static const String ON = "on";
  static const String AFTER = "after";

  static const String DAYS = "Days";
  static const String WEEKS = "Weeks";
  static const String MONTHS = "Months";
  final Reminder reminder;

  TimeSelectionWidget(this.reminder);

  @override
  _TimeSelectionWidgetState createState() {
    return _TimeSelectionWidgetState(reminder);
  }
}

class _TimeSelectionWidgetState extends State<TimeSelectionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final Reminder reminder;
  var daysWeeksMonthsController;
  var amount;

  _TimeSelectionWidgetState(this.reminder);

  @override
  Widget build(BuildContext context) {
    if(daysWeeksMonthsController == null) {
      daysWeeksMonthsController = FixedExtentScrollController(initialItem: reminder != null ? (reminder.daysWeeksMonths == 'Days') ? 0 : reminder.daysWeeksMonths == 'Weeks' ? 1 : 2 : 0);
    }
    if(amount == null) {
      amount = FixedExtentScrollController(initialItem: reminder != null ? reminder.amount - 1 : 0);
    }
    return StoreConnector<AppState, NewReminderPageState>(
      converter: (store) => NewReminderPageState.fromStore(store),
      builder: (BuildContext context, NewReminderPageState pageState) =>
          Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(
            width: MediaQuery.of(context).size.width - 95,
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 48.0),
                      width: 24.0,
                      child: Text(
                        '1.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 48.0),
                      width: MediaQuery.of(context).size.width - 95,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'When do you want this reminder to be sent?',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    pageState.whenSelected(TimeSelectionWidget.BEFORE);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0),
                    alignment: Alignment.center,
                    height: 32.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: pageState.when == TimeSelectionWidget.BEFORE
                          ? Color(ColorConstants.getBlueLight())
                          : Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: Text(
                      'Before shoot date',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: pageState.when == TimeSelectionWidget.BEFORE
                            ? Color(ColorConstants.getPrimaryWhite())
                            : Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.whenSelected(TimeSelectionWidget.ON);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0),
                    alignment: Alignment.center,
                    height: 32.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: pageState.when == TimeSelectionWidget.ON
                          ? Color(ColorConstants.getBlueLight())
                          : Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: Text(
                      'On shoot date',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: pageState.when == TimeSelectionWidget.ON
                            ? Color(ColorConstants.getPrimaryWhite())
                            : Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.whenSelected(TimeSelectionWidget.AFTER);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 8.0),
                    alignment: Alignment.center,
                    height: 32.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: pageState.when == TimeSelectionWidget.AFTER
                          ? Color(ColorConstants.getBlueLight())
                          : Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: Text(
                      'After shoot date',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: pageState.when == TimeSelectionWidget.AFTER
                            ? Color(ColorConstants.getPrimaryWhite())
                            : Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: pageState.when == TimeSelectionWidget.ON ? 0.25 : 1.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 48.0),
                        width: 24.0,
                        child: Text(
                          '2.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 48.0),
                        width: MediaQuery.of(context).size.width - 95,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Select how far ' +
                                  pageState.when +
                                  ' the shoot you want the reminder to be sent.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AbsorbPointer(
                  absorbing: pageState.when == TimeSelectionWidget.ON ? true : false,
                  child: Opacity(
                    opacity: pageState.when == TimeSelectionWidget.ON
                        ? 0.25 : 1.0,
                    child: Container(
                      height: 150.0,
                      margin: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 100.0,
                            child: CupertinoPicker(
                              onSelectedItemChanged: (index) {
                                pageState.onDaysWeeksMonthsChanged(index == 0 ? 'Days' : index == 1 ? 'Weeks' : 'Months');
                              },
                              scrollController: daysWeeksMonthsController,
                              itemExtent: 24.0,
                              magnification: 1.25,
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              children: <Widget>[
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    'Days',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    'Weeks',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    'Months',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 100.0,
                            child: CupertinoPicker(
                              onSelectedItemChanged: (index) {
                                pageState.onDaysWeeksMonthsAmountChanged(index+1);
                              },
                              scrollController: amount,
                              itemExtent: 24.0,
                              magnification: 1.25,
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              children: <Widget>[
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '1',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '2',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '3',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '4',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '5',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '6',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '7',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '8',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '9',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '10',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '11',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '12',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '13',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '14',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '15',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '16',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '17',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '18',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '19',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '20',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '21',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '22',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '23',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '24',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '25',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '26',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '27',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '28',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '29',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: Text(
                                    '30',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorConstants.primary_black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 48.0),
                      width: 24.0,
                      child: Text(
                        '3.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 48.0),
                      width: MediaQuery.of(context).size.width - 95,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select a time for this job reminder.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 200.0,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
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
