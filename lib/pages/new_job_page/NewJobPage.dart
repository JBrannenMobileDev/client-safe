import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_job_page/ClientSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/DateForm.dart';
import 'package:dandylight/pages/new_job_page/JobNameForm.dart';
import 'package:dandylight/pages/new_job_page/JobTypeSelection.dart';
import 'package:dandylight/pages/new_job_page/LocationSelectionForm.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/TimeSelectionForm.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'JobReminderSelectionForm.dart';

class NewJobPage extends StatefulWidget {
  @override
  _NewJobPageState createState() {
    return _NewJobPageState();
  }
}

class _NewJobPageState extends State<NewJobPage> {
  final int pageCount = 5;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;
  bool hasJumpToBeenCalled = false;

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
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) {
        store.state.newJobPageState.shouldClear ? store.dispatch(ClearStateAction(store.state.newJobPageState)) : null;
        store.dispatch(FetchAllRemindersAction(store.state.newJobPageState));
      },
      onDidChange: (prev, pageState) {
        if(pageState.comingFromClientDetails && !hasJumpToBeenCalled) {
          controller.jumpToPage(1);
          hasJumpToBeenCalled = true;
        }
      },
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: getDialogWidth(currentPageIndex),
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
                        Container(
                          margin: EdgeInsets.only(left: 16.0),
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            tooltip: 'Delete',
                            color: Color(ColorConstants.getPrimaryColor()),
                            onPressed: () {
                              pageState.onCancelPressed();
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            pageState.shouldClear ? "New Job" : pageState.comingFromClientDetails ? "New Job" : "Edit Job",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 28.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        pageState.pageViewIndex == 2 || pageState.pageViewIndex == 4 ? GestureDetector(
                          onTap: () {
                            if(pageState.pageViewIndex == 2) UserOptionsUtil.showNewPriceProfileDialog(context);
                            if(pageState.pageViewIndex == 4) UserOptionsUtil.showNewLocationDialog(context);
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
                          ClientSelectionForm(),
                          JobNameForm(),
                          JobTypeSelection(),
                          LocationSelectionForm(),
                          DateForm(),
                          TimeSelectionForm(),
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
                              color: Colors.white,
                              textColor: Color(ColorConstants.primary_black),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            onPressed: () {
                              onBackPressed(pageState);
                            },
                            child: Text(
                              pageState.pageViewIndex == 0 ? "Cancel" : "Back",
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
                              pageState.pageViewIndex == pageCount
                                  ? "Save" : getNextBtText(pageState),
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

  void onNextPressed(NewJobPageState pageState) {
    bool canProgress = false;
    if (pageState.pageViewIndex != pageCount) {
      switch (pageState.pageViewIndex) {
        case 0:
          canProgress = pageState.selectedClient != null || pageState.clientFirstName.isNotEmpty;
          break;
        case 1:
          canProgress = pageState.jobTitle.length > 0;
          break;
        case 2:
          canProgress = pageState.selectedJobType != null;
          break;
        case 3:
          canProgress = true;
          break;
        case 4:
          canProgress = true;
          break;
        case 5:
          canProgress = true;
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

  void onBackPressed(NewJobPageState pageState) {
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
        height = 500.0;
        break;
      case 1:
        height = 200.0;
        break;
      case 2:
        height = 450.0;
        break;
      case 3:
        height = 500.0;
        break;
      case 4:
        height = 600.0;
        break;
      case 5:
        height = 325.0;
        break;
    }
    return height;
  }

  double getDialogWidth(int currentPageIndex) {
    double width = 450.0;
    switch(currentPageIndex){
      case 0:
        width = 450.0;
        break;
      case 1:
        width = 450.0;
        break;
      case 2:
        width = 450.0;
        break;
      case 3:
        width = 450.0;
        break;
      case 4:
        width = 450.0;
        break;
      case 5:
        width = 450.0;
        break;
    }
    return width;
  }

  getNextBtText(NewJobPageState pageState) {
    String btText = 'Next';
    switch(pageState.pageViewIndex) {
      case 3:
        if(pageState.selectedLocation == null) btText = 'Skip';
        break;
      case 4:
        DateTime today = DateTime.now();
        if(pageState.selectedDate.year == today.year && pageState.selectedDate.month == today.month && pageState.selectedDate.day == today.day) btText = 'Skip';
        break;
      case 5:
        if(pageState.selectedTime == null) btText = 'Skip';
        break;
    }
    return btText;
  }
}
