import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/new_reminder_page/DandyLightTextField.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewReminderPage extends StatefulWidget {
  static const String BEFORE = "before";
  static const String ON = "on";
  static const String AFTER = "after";

  static const String DAYS = "Days";
  static const String WEEKS = "Weeks";
  static const String MONTHS = "Months";
  final Reminder reminder;

  NewReminderPage(this.reminder);

  @override
  _NewReminderPageState createState() {
    return _NewReminderPageState(reminder);
  }
}

class _NewReminderPageState extends State<NewReminderPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount = 2;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;
  final Reminder reminder;

  _NewReminderPageState(this.reminder);

  final descriptionTextController = TextEditingController();
  var daysWeeksMonthsController;
  var amount;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new CupertinoAlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('All unsaved information entered will be lost.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      currentPageIndex = controller.page.toInt();
    });
    if(daysWeeksMonthsController == null) {
      daysWeeksMonthsController = FixedExtentScrollController(initialItem: 2);//TODO fix this to be dynamic based on reminder object passed in.
    }
    if(amount == null) {
      amount = FixedExtentScrollController(initialItem: reminder != null ? reminder.amount - 1 : 1);
    }
    return StoreConnector<AppState, NewReminderPageState>(
      onInit: (store) {
        descriptionTextController.text = store.state.newReminderPageState.reminderDescription;
      },
      converter: (store) => NewReminderPageState.fromStore(store),
      builder: (BuildContext context, NewReminderPageState pageState) =>
          WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 375.0,
                padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                decoration: new BoxDecoration(
                    color: Color(ColorConstants.white),
                    borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            pageState.shouldClear ? "New Reminder" : "Edit Reminder",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 26.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                          !pageState.shouldClear ? GestureDetector(
                            onTap: () {
                              _ackAlert(context, pageState);
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 32.0),
                              height: 24.0,
                              width: 375.0,
                              child: Image.asset(
                                  'assets/images/icons/trash_icon_gold.png'),
                            ),
                          ) : SizedBox(),
                          !pageState.shouldClear ? Container(
                            margin: EdgeInsets.only(left: 300.0),
                            child: IconButton(
                              icon: const Icon(Icons.save),
                              tooltip: 'Save',
                              color: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                showSuccessAnimation();
                                pageState.onSavePressed();
                              },
                            ),
                          ) : SizedBox(),
                        ],
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
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
                              width: MediaQuery.of(context).size.width - 95,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'What do you want this reminder to say?',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: 'simple',
                                        fontWeight: FontWeight.w600,
                                        color: Color(ColorConstants.primary_black),
                                      ),
                                    ),
                                  ),
                                  DandyLightTextField(
                                    controller: descriptionTextController,
                                    hintText: 'Reminder description',
                                    inputType: TextInputType.text,
                                    focusNode: null,
                                    onFocusAction: null,
                                    height: 64.0,
                                    onTextInputChanged: pageState.onReminderDescriptionChanged,
                                    keyboardAction: TextInputAction.done,
                                    capitalization: TextCapitalization.words,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
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
                            pageState.whenSelected(NewReminderPage.BEFORE);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 8.0),
                            alignment: Alignment.center,
                            height: 32.0,
                            width: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32.0),
                              color: pageState.when == NewReminderPage.BEFORE
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
                                color: pageState.when == NewReminderPage.BEFORE
                                    ? Color(ColorConstants.getPrimaryWhite())
                                    : Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                          ),
                        ),
                    GestureDetector(
                      onTap: () {
                        pageState.whenSelected(NewReminderPage.ON);
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          alignment: Alignment.center,
                          height: 32.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.0),
                            color: pageState.when == NewReminderPage.ON
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
                              color: pageState.when == NewReminderPage.ON
                                  ? Color(ColorConstants.getPrimaryWhite())
                                  : Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageState.whenSelected(NewReminderPage.AFTER);
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          alignment: Alignment.center,
                          height: 32.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.0),
                            color: pageState.when == NewReminderPage.AFTER
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
                              color: pageState.when == NewReminderPage.AFTER
                                  ? Color(ColorConstants.getPrimaryWhite())
                                  : Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                    ),
                        Opacity(
                          opacity: pageState.when == NewReminderPage.ON
                              ? 0.25 : 1.0,
                          child: Row(
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
                                    Text(
                                      'Select how far ' + pageState.when + ' the shoot you want the reminder to be sent.',
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
                          absorbing: pageState.when == NewReminderPage.ON ? true : false,
                          child: Opacity(
                            opacity: pageState.when == NewReminderPage.ON
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
                                        pageState.onDaysWeeksMonthsAmountChanged(index);
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 26.0, right: 26.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.white,
                          textColor: Color(ColorConstants.primary_black),
                          disabledColor: Colors.white,
                          disabledTextColor:
                              Color(ColorConstants.primary_bg_grey),
                          padding: EdgeInsets.all(8.0),
                          splashColor: Color(ColorConstants.getPrimaryColor()),
                          onPressed: () {
                            onBackPressed(pageState);
                            },
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                          FlatButton(
                            color: Colors.white,
                            textColor: Color(ColorConstants.primary_black),
                            disabledColor: Colors.white,
                            disabledTextColor:
                                Color(ColorConstants.primary_bg_grey),
                            padding: EdgeInsets.all(8.0),
                            splashColor: Color(ColorConstants.getPrimaryColor()),
                            onPressed: () {
                              onNextPressed(pageState);
                            },
                            child: Text(
                              'Save',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.0,
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
      ),
    );
  }

  void onNextPressed(NewReminderPageState pageState) {
    if(pageState.reminderDescription.isNotEmpty && pageState.when.isNotEmpty && pageState.daysWeeksMonthsAmount > 0 && pageState.daysWeeksMonths.isNotEmpty) {
      showSuccessAnimation();
      pageState.onSavePressed();
    }
  }

  Future<void> _ackAlert(BuildContext context, NewReminderPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This reminder will be gone for good!'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                pageState.onDeleteReminderSelected();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This reminder will be gone for good!'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                pageState.onDeleteReminderSelected();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  void onBackPressed(NewReminderPageState pageState) {
    pageState.onCancelPressed();
    Navigator.of(context).pop();
  }
}
