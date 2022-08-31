import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/new_reminder_page/DandyLightTextField.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'ReminderDescriptionWidget.dart';
import 'TimeSelectionWidget.dart';
import 'WhenSelectionWidget.dart';

class NewReminderPage extends StatefulWidget {
  final ReminderDandyLight reminder;

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
  final ReminderDandyLight reminder;

  _NewReminderPageState(this.reminder);

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
              TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                style: Styles.getButtonStyle(),
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
      setState(() {
        currentPageIndex = controller.page.toInt();
      });
    });
    return StoreConnector<AppState, NewReminderPageState>(
      onInit: (store) {
        if(reminder == null) {
          store.dispatch(ClearNewReminderStateAction(store.state.newReminderPageState));
        }
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: getDialogHeight(currentPageIndex),
                    ),
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: controller,
                      pageSnapping: true,
                      children: <Widget>[
                        ReminderDescriptionWidget(reminder),
                        WhenSelectionWidget(reminder),
                        TimeSelectionWidget(reminder),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 26.0, right: 26.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(
                            color: Colors.white,
                            textColor: Color(ColorConstants.primary_black),
                            left: 8.0,
                            top: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                          ),
                          // disabledColor: Colors.white,
                          // disabledTextColor:
                          //     Color(ColorConstants.primary_bg_grey),
                          // splashColor: Color(ColorConstants.getPrimaryColor()),
                          onPressed: () {
                            onBackPressed(pageState);
                            },
                            child: Text(
                              currentPageIndex == 0 ? 'Cancel' : 'Back',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                        TextButton(
                          style: Styles.getButtonStyle(
                            color: Colors.white,
                            textColor: Color(ColorConstants.primary_black),
                            left: 8.0,
                            top: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                          ),
                            onPressed: () {
                              onNextPressed(pageState);
                            },
                            child: Text(
                              currentPageIndex == 2 ? 'Save' : 'Next',
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
    bool canProgress = true;
    if (currentPageIndex != pageCount) {
      switch (currentPageIndex) {
        case 0:
          canProgress = pageState.reminderDescription.isNotEmpty;
          break;
      }

      if (canProgress) {
        controller.animateToPage(currentPageIndex + 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        FocusScope.of(context).unfocus();
      }
    }
    if (currentPageIndex == pageCount) {
      pageState.onSavePressed();
      showSuccessAnimation();
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
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
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
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
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
    if (currentPageIndex == 0) {
      pageState.onCancelPressed();
      Navigator.of(context).pop();
    } else {
      controller.animateToPage(currentPageIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }

  getDialogHeight(int currentPageIndex) {
    switch(currentPageIndex) {
      case 0:
        return 125.0;
      case 1:
        return 420.0;
      case 2:
        return 250.0;
      case 3:
        return 150.0;
    }
    return 300.0;
  }
}
