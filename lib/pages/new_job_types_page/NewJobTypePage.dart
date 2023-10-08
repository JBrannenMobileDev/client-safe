import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypeActions.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypePageState.dart';
import 'package:dandylight/pages/new_job_types_page/JobStageSelectionForm.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import 'JobTypeNameSelectionWidget.dart';
import 'ReminderSelectionWidget.dart';

class NewJobTypePage extends StatefulWidget {
  final JobType jobType;

  NewJobTypePage(this.jobType);

  @override
  _NewJobTypePageState createState() {
    return _NewJobTypePageState(jobType);
  }
}

class _NewJobTypePageState extends State<NewJobTypePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount = 2;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;
  final JobType jobType;

  _NewJobTypePageState(this.jobType);

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
    return StoreConnector<AppState, NewJobTypePageState>(
      onInit: (store) {
        if(jobType == null) {
          store.dispatch(ClearNewJobTypeStateAction(store.state.newJobTypePageState));
        }else {
          store.dispatch(LoadExistingJobTypeData(store.state.newJobTypePageState, jobType));
        }
        store.dispatch(LoadPricesPackagesAndRemindersAction(store.state.newJobTypePageState));
      },
      converter: (store) => NewJobTypePageState.fromStore(store),
      builder: (BuildContext context, NewJobTypePageState pageState) =>
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
                          TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: pageState.shouldClear ? "New Job Type" : "Edit Job Type",
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.getPrimaryBlack()),
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
                                  'assets/images/icons/trash_icon_peach.png'),
                            ),
                          ) : SizedBox(),
                          !pageState.shouldClear && currentPageIndex != 2 ? Container(
                            margin: EdgeInsets.only(left: 300.0),
                            child: IconButton(
                              icon: const Icon(Icons.save),
                              tooltip: 'Save',
                              color: Color(ColorConstants.getPeachDark()),
                              onPressed: () {
                                showSuccessAnimation();
                                pageState.onSavePressed();
                              },
                            ),
                          ) : SizedBox(),
                          currentPageIndex == 2 ? GestureDetector(
                            onTap: () {
                              UserOptionsUtil.showNewReminderDialog(context, null);
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(right: 24.0),
                              height: 28.0,
                              child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPeachDark()),),
                            ),
                          ) : SizedBox(
                            height: 28.0,
                            width: 52.0,
                          ),
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
                        JobTypeNameSelectionWidget(jobType),
                        JobStageSelectionForm(),
                        ReminderSelectionWidget(),
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
                            color: Color(ColorConstants.getPrimaryWhite()),
                            textColor: Color(ColorConstants.getPrimaryBlack()),
                            left: 8.0,
                            top: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                          ),
                          onPressed: () {
                            onBackPressed(pageState);
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: currentPageIndex == 0 ? 'Cancel' : 'Back',
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
                            onPressed: () {
                              onNextPressed(pageState);
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: currentPageIndex == 2 ? 'Save' : 'Next',
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

  void onNextPressed(NewJobTypePageState pageState) {
    bool canProgress = true;
    if (currentPageIndex != pageCount) {
      switch (currentPageIndex) {
        case 0:
          canProgress = pageState.title.isNotEmpty;
          break;
        case 1:
          canProgress = pageState.selectedJobStages.isNotEmpty;
          break;
        case 2:
          canProgress = pageState.selectedReminders.isNotEmpty;
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

  Future<void> _ackAlert(BuildContext context, NewJobTypePageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This jobType will be gone for good!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteJobTypeSelected();
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
                pageState.onDeleteJobTypeSelected();
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

  void onBackPressed(NewJobTypePageState pageState) {
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
        return 144.0;
      case 1:
        return 564.0;
      case 2:
        return 550.0;
    }
    return 300.0;
  }
}
