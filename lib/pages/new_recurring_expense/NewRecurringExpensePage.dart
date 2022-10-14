import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseAutoPaySelection.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseBillingPeriod.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseCost.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseName.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:dandylight/pages/new_recurring_expense/RecurringExpenseDateSelection.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewRecurringExpensePage extends StatefulWidget {
  @override
  _NewRecurringExpensePageState createState() {
    return _NewRecurringExpensePageState();
  }
}

class _NewRecurringExpensePageState extends State<NewRecurringExpensePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount = 4;
  NewRecurringExpensePageState pageState;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      currentPageIndex = controller.page.toInt();
    });
    return StoreConnector<AppState, NewRecurringExpensePageState>(
      onInit: (store) {
        if(store.state.newRecurringExpensePageState.shouldClear) store.dispatch(ClearRecurringExpenseStateAction(store.state.newRecurringExpensePageState));
      },
      onDidChange: (prev, pageState) {
        this.pageState = pageState;
      },
      converter: (store) => NewRecurringExpensePageState.fromStore(store),
      builder: (BuildContext context, NewRecurringExpensePageState pageState) =>
          Scaffold(
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
                            pageState.shouldClear ? "New Recurring Expense" : "Edit Recurring Expense",
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
                      height: 248.0,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        pageSnapping: true,
                        children: <Widget>[
                          NewRecurringExpenseName(),
                          RecurringExpenseDateSelection(),
                          NewRecurringExpenseBillingPeriod(),
                          NewRecurringExpenseCost(),
                          NewRecurringExpenseAutoPaySelection(),
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
                            // disabledColor: Colors.white,
                            // disabledTextColor:
                            //     Color(ColorConstants.primary_bg_grey),
                            // splashColor: Color(ColorConstants.getPrimaryColor()),
                            onPressed: () {
                              onNextPressed(pageState);
                            },
                            child: Text(
                              pageState.pageViewIndex == pageCount
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
    );
  }

  void onNextPressed(NewRecurringExpensePageState pageState) {
    bool canProgress = false;
    if (pageState.pageViewIndex != pageCount) {
      switch (pageState.pageViewIndex) {
        case 0:
          if (pageState.expenseName.length > 0) {
            canProgress = true;
          } else {
            HapticFeedback.heavyImpact();
          }
          break;
        case 1:
          if(pageState.expenseDate != null) {
            canProgress = true;
          } else {
            DandyToastUtil.showErrorToast('Expense charge date is required');
          }
          break;
        case 2:
          if(pageState.billingPeriod != null){
            canProgress = true;
          }else {
            DandyToastUtil.showErrorToast('You must select a billing period');
          }
          break;
        case 3:
          canProgress = true;
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

  Future<void> _ackAlert(BuildContext context, NewRecurringExpensePageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This expense will be permanently gone!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteRecurringExpenseSelected();
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This expense will be permanently gone!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteRecurringExpenseSelected();
                Navigator.of(context).pop(true);
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

  void onBackPressed(NewRecurringExpensePageState pageState) {
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
