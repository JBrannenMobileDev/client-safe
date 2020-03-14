import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_job_page/ClientSelectionForm.dart';
import 'package:client_safe/pages/new_job_page/DateForm.dart';
import 'package:client_safe/pages/new_job_page/DepositSelectionForm.dart';
import 'package:client_safe/pages/new_job_page/JobNameForm.dart';
import 'package:client_safe/pages/new_job_page/JobStageSelectionForm.dart';
import 'package:client_safe/pages/new_job_page/JobTypeSelection.dart';
import 'package:client_safe/pages/new_job_page/LocationSelectionForm.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/PricingProfileSelectionForm.dart';
import 'package:client_safe/pages/new_job_page/TimeSelectionForm.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewJobPage extends StatefulWidget {
  @override
  _NewJobPageState createState() {
    return _NewJobPageState();
  }
}

class _NewJobPageState extends State<NewJobPage> {
  final int pageCount = 8;
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
    return StoreConnector<AppState, NewJobPageState>(
      onInit: (store) => store.state.newJobPageState.shouldClear ? store.dispatch(ClearStateAction(store.state.newJobPageState)) : null,
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
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            pageState.shouldClear ? "New Job" : "Edit Job",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w800,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 300.0),
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
                          PricingProfileSelectionForm(),
                          DepositSelectionForm(),
                          LocationSelectionForm(),
                          DateForm(),
                          TimeSelectionForm(),
                          JobTypeSelection(),
                          JobStageSelectionForm(),
//                          JobNotesForm(),
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
                              pageState.pageViewIndex == 0 ? "Cancel" : "Back",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Raleway',
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
                              pageState.pageViewIndex == pageCount
                                  ? "Save"
                                  : "Next",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Raleway',
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
          canProgress = pageState.selectedClient != null;
          break;
        case 1:
          canProgress = pageState.jobTitle.length > 0;
          break;
        case 2:
          canProgress = true;
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
        case 6:
          canProgress = true;
          break;
        case 7:
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
        height = 380.0;
        break;
      case 1:
        height = 200.0;
        break;
      case 2:
        height = 414.0;
        break;
      case 3:
        height = 324.0;
        break;
      case 4:
        height = 500.0;
        break;
      case 5:
        height = 600.0;
        break;
      case 6:
        height = 325.0;
        break;
      case 7:
        height = 450.0;
        break;
      case 8:
        height = 500.0;
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
      case 5:
        width = 450.0;
        break;
      case 6:
        width = 450.0;
        break;
    }
    return width;
  }
}
