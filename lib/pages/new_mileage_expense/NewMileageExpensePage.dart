import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/pages/new_mileage_expense/SelectExpenseDatePage.dart';
import 'package:dandylight/pages/new_mileage_expense/SelectStartEndLocations.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/MileageExpense.dart';
import '../../widgets/TextDandyLight.dart';

class NewMileageExpensePage extends StatefulWidget {
  final MileageExpense? trip;

  const NewMileageExpensePage(this.trip, {Key? key}) : super(key: key);

  @override
  _NewMileageExpensePageState createState() {
    return _NewMileageExpensePageState(trip);
  }
}

class _NewMileageExpensePageState extends State<NewMileageExpensePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final int pageCount = 1;
  final controller = PageController(
    initialPage: 0,
  );
  final MileageExpense? trip;

  _NewMileageExpensePageState(this.trip);

  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      setState(() {
        currentPageIndex = controller.page!.toInt();
      });
    });
    return StoreConnector<AppState, NewMileageExpensePageState>(
      onInit: (store) {
        store.dispatch(FetchLastKnowPosition(store.state.newMileageExpensePageState));
        if(store.state.newMileageExpensePageState!.shouldClear!) store.dispatch(ClearMileageExpenseStateAction(store.state.newMileageExpensePageState));
        if(trip != null) {
          store.dispatch(LoadExistingMileageExpenseAction(store.state.newMileageExpensePageState, trip));
        }
      },
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) =>
          WillPopScope(
          onWillPop: () async {
            final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text('Are you sure?'),
                content: Text('All unsaved information entered will be lost.'),
                actions: <Widget>[
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    style: Styles.getButtonStyle(),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            );
            return shouldPop!;
          },
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  width: 375.0,
                  padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.white),
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
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
                              text: pageState.shouldClear! ? "New Mileage Trip" : "Edit Mileage Trip",
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                            !pageState.shouldClear! ? GestureDetector(
                              onTap: () {
                                _ackAlert(context, pageState);
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 32.0),
                                height: 24.0,
                                width: 375.0,
                                child: Image.asset(
                                    'assets/images/icons/trash_can.png',
                                    color: Color(ColorConstants.getPeachDark())
                                ),
                              ),
                            ) : SizedBox(),
                            !pageState.shouldClear! ? Container(
                              margin: EdgeInsets.only(left: 300.0),
                              child: IconButton(
                                icon: const Icon(Icons.save),
                                tooltip: 'Save',
                                color: Color(ColorConstants.getPeachDark()),
                                onPressed: () {
                                  showSuccessAnimation();
                                  pageState.onSavePressed!();
                                },
                              ),
                            ) : SizedBox(),
                          ],
                        ),
                      ),
                      Container(
                        height: currentPageIndex == 1 ? 225.0 : 432.0,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller,
                          pageSnapping: true,
                          children: <Widget>[
                            SelectStartEndLocationsPage(),
                            const SelectExpenseDatePage(),
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
                              // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                              // disabledTextColor:
                              // Color(ColorConstants.primary_bg_grey),
                              // splashColor: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                onBackPressed(pageState);
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.pageViewIndex == 0 ? "Cancel" : "Back",
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
                              // Color(ColorConstants.primary_bg_grey),
                              // splashColor: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                onNextPressed(pageState);
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.pageViewIndex == 0 && pageState.selectedHomeLocationName!.isEmpty ? 'Skip' : currentPageIndex == pageCount
                                    ? "Save"
                                    : "Next",
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

  void onNextPressed(NewMileageExpensePageState pageState) {
    bool canProgress = false;
    if (currentPageIndex != pageCount) {
      switch (currentPageIndex) {
        case 0:
          if((pageState.endLocationName!.isNotEmpty && pageState.endLocationName != 'Select a location') && (pageState.profile!.hasDefaultHome() || pageState.startLocationName!.isNotEmpty)){
            canProgress = true;
          }else {
            if(pageState.endLocationName!.isEmpty || pageState.endLocationName == 'Select a location') {
              DandyToastUtil.showToast('End location is required', Color(ColorConstants.getPrimaryColor()));
            }
            if(!pageState.profile!.hasDefaultHome() && pageState.startLocationName!.isEmpty){
              DandyToastUtil.showToast('Start location is required', Color(ColorConstants.getPrimaryColor()));
            }
          }
          break;
        default:
          canProgress = true;
          break;
      }

      if (canProgress) {
        pageState.onNextPressed!();
        controller.animateToPage(currentPageIndex + 1,
            duration: Duration(milliseconds: 150), curve: Curves.ease);
        if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);
      }
    }
    if (currentPageIndex == pageCount) {
      if(pageState.expenseDate != null) {
        if(pageState.expenseCost! > 0.0){
          showSuccessAnimation();
          pageState.onSavePressed!();
        } else {
          DandyToastUtil.showToast('Cost must be greater than \$0.0', Color(ColorConstants.getPrimaryColor()));
        }
      } else {
        DandyToastUtil.showToast('Date of trip is required', Color(ColorConstants.getPrimaryColor()));
      }
    }
  }

  Future<void> _ackAlert(BuildContext context, NewMileageExpensePageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: Text('Are you sure?'),
          content: Text('This price package will be gone for good!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteMileageExpenseSelected!();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This price package will be gone for good!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteMileageExpenseSelected!();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
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
      pageState.onCancelPressed!();
      Navigator.of(context).pop();
    } else {
      pageState.onBackPressed!();
      controller.animateToPage(currentPageIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }
}
