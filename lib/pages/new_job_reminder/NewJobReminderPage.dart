import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';
import 'package:dandylight/pages/new_job_reminder/ReminderSelectionPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';
import 'NewJobReminderPageActions.dart';

class NewJobReminderPage extends StatefulWidget {
  final Job job;

  NewJobReminderPage(this.job);

  @override
  _NewJobReminderPageState createState() {
    return _NewJobReminderPageState(job);
  }
}

class _NewJobReminderPageState extends State<NewJobReminderPage> {
  final Job job;
  final int pageCount = 0;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  _NewJobReminderPageState(this.job);

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
    return StoreConnector<AppState, NewJobReminderPageState>(
      onInit: (store) {
        store.dispatch(ClearNewJobReminderStateAction(store.state.newJobReminderPageState));
      },
      converter: (store) => NewJobReminderPageState.fromStore(store),
      builder: (BuildContext context, NewJobReminderPageState pageState) =>
          WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
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
                        Container(
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'New Job Reminder',
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.getPrimaryBlack()),
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
                            child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPrimaryColor()),),
                          ),
                        ) : SizedBox(
                          height: 28.0,
                          width: 52.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0,),
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
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            style: Styles.getButtonStyle(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                            // disabledTextColor:
                            //     Color(ColorConstants.primary_bg_grey),
                            // splashColor: Color(ColorConstants.getPrimaryColor()),
                            onPressed: () {
                              onCancelSelected(pageState);
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Cancel',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          TextButton(
                            style: Styles.getButtonStyle(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                            // disabledTextColor:
                            //     Color(ColorConstants.primary_bg_grey),
                            // splashColor: Color(ColorConstants.getPrimaryColor()),
                            onPressed: () {
                              onSaveSelected(pageState);
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Save',
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
      ),
    );
  }

  void onSaveSelected(NewJobReminderPageState pageState) {
    if (pageState.selectedReminder != null) {
      pageState.onSavePressed(job);
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

  void onCancelSelected(NewJobReminderPageState pageState) {
    if (pageState.pageViewIndex == 0) {
      pageState.onCancelPressed();
      Navigator.of(context).pop();
    }
  }

  double getDialogHeight(int currentPageIndex) {
    double height = 380.0;
    switch(currentPageIndex){
      case 0:
        height = 500.0;
        break;
      case 1:
        height = 380.0;
        break;
    }
    return height;
  }
}
