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

class WhenSelectionWidget extends StatefulWidget {
  static const String BEFORE = "before";
  static const String ON = "on";
  static const String AFTER = "after";

  static const String DAYS = "Days";
  static const String WEEKS = "Weeks";
  static const String MONTHS = "Months";
  final ReminderDandyLight? reminder;

  WhenSelectionWidget(this.reminder);

  @override
  _WhenSelectionWidgetState createState() {
    return _WhenSelectionWidgetState(reminder);
  }
}

class _WhenSelectionWidgetState extends State<WhenSelectionWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final ReminderDandyLight? reminder;
  var daysWeeksMonthsController;
  var amount;

  _WhenSelectionWidgetState(this.reminder);

  @override
  Widget build(BuildContext context) {
    if(daysWeeksMonthsController == null) {
      daysWeeksMonthsController = FixedExtentScrollController(initialItem: reminder != null ? (reminder!.daysWeeksMonths == 'Days') ? 0 : reminder!.daysWeeksMonths == 'Weeks' ? 1 : 2 : 0);
    }
    if(amount == null) {
      amount = FixedExtentScrollController(initialItem: reminder != null ? reminder!.amount! - 1 : 0);
    }
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      width: 24.0,
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: '1.',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16.0),
                      width: MediaQuery.of(context).size.width - 95,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'When do you want this reminder to be sent?',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    pageState.whenSelected!(WhenSelectionWidget.BEFORE);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 4.0),
                    alignment: Alignment.center,
                    height: 32.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: pageState.when == WhenSelectionWidget.BEFORE
                          ? Color(ColorConstants.getBlueLight())
                          : Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Before shoot date',
                      textAlign: TextAlign.start,
                      color: pageState.when == WhenSelectionWidget.BEFORE
                          ? Color(ColorConstants.getPrimaryWhite())
                          : Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.whenSelected!(WhenSelectionWidget.ON);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 4.0),
                    alignment: Alignment.center,
                    height: 32.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: pageState.when == WhenSelectionWidget.ON
                          ? Color(ColorConstants.getBlueLight())
                          : Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'On shoot date',
                      textAlign: TextAlign.start,
                      color: pageState.when == WhenSelectionWidget.ON
                          ? Color(ColorConstants.getPrimaryWhite())
                          : Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageState.whenSelected!(WhenSelectionWidget.AFTER);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 4.0),
                    alignment: Alignment.center,
                    height: 32.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: pageState.when == WhenSelectionWidget.AFTER
                          ? Color(ColorConstants.getBlueLight())
                          : Color(ColorConstants.getPrimaryWhite()),
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'After shoot date',
                      textAlign: TextAlign.start,
                      color: pageState.when == WhenSelectionWidget.AFTER
                          ? Color(ColorConstants.getPrimaryWhite())
                          : Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                Opacity(
                  opacity: pageState.when == WhenSelectionWidget.ON ? 0.25 : 1.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 48.0),
                        width: 24.0,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '2.',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 48.0),
                        width: MediaQuery.of(context).size.width - 95,
                        child: Column(
                          children: <Widget>[
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Select how long ' +
                                  (pageState.when == WhenSelectionWidget.ON ? WhenSelectionWidget.BEFORE : pageState.when!) +
                                  ' the shoot you want the reminder to be sent.',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AbsorbPointer(
                  absorbing: pageState.when == WhenSelectionWidget.ON ? true : false,
                  child: Opacity(
                    opacity: pageState.when == WhenSelectionWidget.ON
                        ? 0.25 : 1.0,
                    child: Container(
                      height: 150.0,
                      margin: EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: 100.0,
                            child: CupertinoPicker(
                              onSelectedItemChanged: (index) {
                                pageState.onDaysWeeksMonthsChanged!(index == 0 ? 'Days' : index == 1 ? 'Weeks' : 'Months');
                              },
                              scrollController: daysWeeksMonthsController,
                              itemExtent: 24.0,
                              magnification: 1.25,
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              children: <Widget>[
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Days',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Weeks',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: 'Months',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
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
                                pageState.onDaysWeeksMonthsAmountChanged!(index+1);
                              },
                              scrollController: amount,
                              itemExtent: 24.0,
                              magnification: 1.25,
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              children: <Widget>[
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '1',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '2',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '3',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '4',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '5',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '6',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '7',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '8',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '9',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '10',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '11',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '12',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '13',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '14',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '15',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '16',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '17',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '18',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '19',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '20',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '21',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '22',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '23',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '24',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '25',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '26',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '27',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '28',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '29',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                                Container(
                                  height: 32.0,
                                  child: TextDandyLight(
                                    type: TextDandyLight.LARGE_TEXT,
                                    text: '30',
                                    textAlign: TextAlign.start,
                                    color: Color(ColorConstants.getPrimaryBlack()),
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
