import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:client_safe/pages/new_mileage_expense/SelectExpenseDatePage.dart';
import 'package:client_safe/pages/new_mileage_expense/SelectStartEndLocations.dart';
import 'package:client_safe/pages/new_mileage_expense/SetHomeLocationPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/DandyToastUtil.dart';
import 'package:client_safe/utils/KeyboardUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewMileageExpensePage extends StatefulWidget {
  @override
  _NewMileageExpensePageState createState() {
    return _NewMileageExpensePageState();
  }
}

class _NewMileageExpensePageState extends State<NewMileageExpensePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount = 2;
  final controller = PageController(
    initialPage: 0,
  );

  bool hasJumpToBeenCalled = false;
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
      currentPageIndex = controller.page.toInt();
    });
    return StoreConnector<AppState, NewMileageExpensePageState>(
      onInit: (store) {
        store.dispatch(FetchLastKnowPosition(store.state.newMileageExpensePageState));
        if(store.state.newSingleExpensePageState.shouldClear) store.dispatch(ClearMileageExpenseStateAction(store.state.newMileageExpensePageState));
      },
      onDidChange: (pageState) {
        if(pageState.profile != null && pageState.profile.hasDefaultHome() && !hasJumpToBeenCalled) {
          controller.jumpToPage(1);
          hasJumpToBeenCalled = true;
        }
      },
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) =>
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
                              pageState.shouldClear ? "New Mileage Expense" : "Edit Mileage Expense",
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
                      Container(
                        height: currentPageIndex == 0 ? 225.0 : 432.0,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller,
                          pageSnapping: true,
                          children: <Widget>[
                            SetHomeLocationPage(onNextPressed),
                            SelectStartEndLocationsPage(),
                            SelectExpenseDatePage(),
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
                                pageState.pageViewIndex == 0 && pageState.selectedHomeLocationName.isEmpty ? 'Skip' : pageState.pageViewIndex == pageCount
                                    ? "Save"
                                    : "Next",
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

  void onNextPressed(NewMileageExpensePageState pageState) {
    bool canProgress = false;
    if (pageState.pageViewIndex != pageCount) {
      switch (pageState.pageViewIndex) {
        case 0:
          canProgress = true;
          break;
        case 1:
          if(pageState.expenseDate != null) {
            canProgress = true;
          } else {
            DandyToastUtil.showErrorToast('Expense charge date is required');
          }
          break;
        default:
          canProgress = true;
          break;
      }

      if (canProgress) {
        pageState.onNextPressed();
        controller.animateToPage(currentPageIndex + 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);
      }
    }
    if (pageState.pageViewIndex == pageCount) {
      if(pageState.expenseCost > 0.0){
        showSuccessAnimation();
        pageState.onSavePressed();
      } else {
        DandyToastUtil.showErrorToast('Cost must be greater than \$0.0');
      }
    }
  }

  Future<void> _ackAlert(BuildContext context, NewMileageExpensePageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This price package will be gone for good!'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                pageState.onDeleteMileageExpenseSelected();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This price package will be gone for good!'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                pageState.onDeleteMileageExpenseSelected();
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

  void onBackPressed(NewMileageExpensePageState pageState) {
    if (pageState.pageViewIndex == 0) {
      pageState.onCancelPressed();
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed();
      controller.animateToPage(currentPageIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }
}
