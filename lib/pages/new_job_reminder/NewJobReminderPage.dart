import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/ClientSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/DateForm.dart';
import 'package:dandylight/pages/new_job_page/DepositSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/JobNameForm.dart';
import 'package:dandylight/pages/new_job_page/JobStageSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/JobTypeSelection.dart';
import 'package:dandylight/pages/new_job_page/LocationSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/PricingProfileSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/TimeSelectionForm.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';
import 'package:dandylight/pages/new_job_reminder/ReminderSelectionPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewJobReminderPage extends StatefulWidget {
  @override
  _NewJobReminderPageState createState() {
    return _NewJobReminderPageState();
  }
}

class _NewJobReminderPageState extends State<NewJobReminderPage> {
  final int pageCount = 1;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

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
      setState(() {
        currentPageIndex = controller.page.toInt();
      });
    });
    return StoreConnector<AppState, NewJobReminderPageState>(
      converter: (store) => NewJobReminderPageState.fromStore(store),
      builder: (BuildContext context, NewJobReminderPageState pageState) =>
          WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 450.0,
                padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                decoration: new BoxDecoration(
                    color: Color(ColorConstants.white),
                    borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 28.0,
                          width: 52.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'New Job Reminder',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        pageState.pageViewIndex == 0 ? GestureDetector(
                          onTap: () {
                            UserOptionsUtil.showNewReminderDialog(context, null);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 24.0),
                            height: 28.0,
                            width: 28.0,
                            child: Image.asset('assets/images/icons/plus_icon_peach.png'),
                          ),
                        ) : SizedBox(
                          height: 28.0,
                          width: 52.0,
                        ),
                      ],
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
                          ReminderSelectionPage(),
                          TimeSelectionForm(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                              pageState.pageViewIndex == 1 ? 'Back' : 'Cancel',
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
                              pageState.pageViewIndex == 1 ? 'Save' : 'Next',
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

  void onNextPressed(NewJobReminderPageState pageState) {
    bool canProgress = false;
    if (pageState.pageViewIndex != pageCount) {
      switch (pageState.pageViewIndex) {
        case 0:
          canProgress = pageState.selectedReminder != null;
          break;
        case 1:
          canProgress = pageState.selectedTime != null;
          break;
      }

      if (canProgress) {
        pageState.onNextPressed();
        controller.animateToPage(currentPageIndex + 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        FocusScope.of(context).unfocus();
      }
    }
    if (pageState.pageViewIndex == pageCount) {
      pageState.onSavePressed();
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
  }

  void onFlareCompleted(String unused, ) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  void onBackPressed(NewJobReminderPageState pageState) {
    if (pageState.pageViewIndex == 0) {
      pageState.onCancelPressed();
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed();
      controller.animateToPage(currentPageIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }

  double getDialogHeight(int currentPageIndex) {
    double height = 380.0;
    switch(currentPageIndex){
      case 0:
        height = 380.0;
        break;
      case 1:
        height = 380.0;
        break;
    }
    return height;
  }
}
