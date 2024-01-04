import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeInsights.dart';
import 'package:dandylight/pages/IncomeAndExpenses/MileageExpensesCard.dart';
import 'package:dandylight/pages/IncomeAndExpenses/PageExplainationBottomSheet.dart';
import 'package:dandylight/pages/IncomeAndExpenses/PaidInvoiceCard.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RecurringExpensesCard.dart';
import 'package:dandylight/pages/IncomeAndExpenses/SingleExpenseCard.dart';
import 'package:dandylight/pages/IncomeAndExpenses/UnpaidInvoicesCard.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../utils/DeviceType.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'MonthlyIncomeLineChart.dart';

class IncomeAndExpensesPage extends StatefulWidget {
  static const String FILTER_TYPE_INCOME = "Income";
  static const String FILTER_TYPE_EXPENSES = "Expenses";

  @override
  State<StatefulWidget> createState() {
    return _IncomeAndExpensesPageState();
  }
}

class _IncomeAndExpensesPageState extends State<IncomeAndExpensesPage> {
  ScrollController scrollController;
  bool dialVisible = true;
  int selectedIndex = 0;
  Map<int, Widget> tabs;
  bool isFabExpanded = false;

  void _showInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return PageExplainationBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    tabs = <int, Widget>{
      0: TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: IncomeAndExpensesPage.FILTER_TYPE_INCOME,
          color: Color(selectedIndex == 0 ? ColorConstants.getPrimaryBlack() : ColorConstants.getPeachDark()),
        ),
      1: TextDandyLight(
          type: TextDandyLight.MEDIUM_TEXT,
          text: IncomeAndExpensesPage.FILTER_TYPE_EXPENSES,
          color: Color(selectedIndex == 1 ? ColorConstants.getPrimaryBlack() : ColorConstants.getBlueDark()),
      ),
    };
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
      onInit: (appState) {
        appState.dispatch(LoadAllInvoicesAction(appState.state.incomeAndExpensesPageState));
        appState.dispatch(LoadAllJobsAction(appState.state.incomeAndExpensesPageState));
        appState.dispatch(FetchSingleExpenses(appState.state.incomeAndExpensesPageState));
        appState.dispatch(FetchRecurringExpenses(appState.state.incomeAndExpensesPageState));
        appState.dispatch(FetchMileageExpenses(appState.state.incomeAndExpensesPageState));
        appState.dispatch(UpdateSelectedYearAction(appState.state.incomeAndExpensesPageState, DateTime.now().year));
        if(appState.state.dashboardPageState.profile != null && !appState.state.dashboardPageState.profile.hasSeenIncomeInfo) {
          Future.delayed(const Duration(seconds: 1), () {
            _showInfoSheet(context);
          });
        }
      },
        converter: (store) => IncomeAndExpensesPageState.fromStore(store),
        builder: (BuildContext context, IncomeAndExpensesPageState pageState) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(selectedIndex == 0 ? ColorConstants.getBlueLight() : ColorConstants.getPeachMedium()),
                    ),
                  ),
                  CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        iconTheme: IconThemeData(
                          color: Color(ColorConstants.getPrimaryWhite()), //change your color here
                        ),
                        brightness: Brightness.light,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        pinned: false,
                        floating: false,
                        forceElevated: false,
                        expandedHeight: 275.0,
                        centerTitle: true,
                        title: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          text: 'Income & Expenses',
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {
                              NavigationUtil.onIncomeAndExpenseSettingsSelected(context);
                              EventSender().sendEvent(eventName: EventNames.NAV_TO_SETTINGS_INCOME_EXPENSE);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 16.0),
                              height: 32.0,
                              width: 32.0,
                              child: Image.asset(
                                  'assets/images/icons/settings.png',
                                  color: Color(ColorConstants.getPrimaryWhite())
                              ),
                            ),
                          )
                        ],
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(

                            children: <Widget>[
                              SafeArea(
                                child: PreferredSize(
                                  preferredSize: const Size.fromHeight(44.0),
                                  child: Container(
                                    width: 300.0,
                                    margin: const EdgeInsets.only(top: 56.0),
                                    child: CupertinoSlidingSegmentedControl<int>(
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      backgroundColor: Colors.transparent,
                                      children: tabs,
                                      onValueChanged: (int filterTypeIndex) {
                                        setState(() {
                                          selectedIndex = filterTypeIndex;
                                        });
                                        pageState.onFilterChanged(filterTypeIndex == 0 ? IncomeAndExpensesPage.FILTER_TYPE_INCOME : IncomeAndExpensesPage.FILTER_TYPE_EXPENSES);
                                        if(filterTypeIndex == 0) EventSender().sendEvent(eventName: EventNames.NAV_TO_INCOME);
                                        if(filterTypeIndex == 1) EventSender().sendEvent(eventName: EventNames.NAV_TO_EXPENSES);
                                      },
                                      groupValue: selectedIndex,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 42.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: TextDandyLight(
                                                type: TextDandyLight.LARGE_TEXT,
                                                text: selectedIndex == 0 ? 'Income' : 'Expenses',
                                                color: Color(ColorConstants.getPrimaryWhite()),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 8.0, top: 2.0),
                                              padding: const EdgeInsets.only(bottom: 2.0),
                                              alignment: Alignment.center,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16.0),
                                                border: Border.all(
                                                    width: 2,
                                                  color: Color(ColorConstants.getPrimaryWhite())
                                                ),
                                              ),
                                              child: TextButton(
                                                style: Styles.getButtonStyle(),
                                                onPressed: () {
                                                  DatePicker.showDatePicker(
                                                    context,
                                                    dateFormat:'yyyy',
                                                    onConfirm: (dateTime, intList) {
                                                      pageState.onYearChanged(dateTime.year);
                                                    },
                                                      pickerTheme: DateTimePickerTheme(
                                                        cancelTextStyle: TextStyle(
                                                            color: Color(ColorConstants.getPrimaryBlack())
                                                        ),
                                                        confirmTextStyle: TextStyle(
                                                            color: Color(ColorConstants.getPrimaryBlack())
                                                        ),
                                                      )
                                                  );
                                                },
                                                child: TextDandyLight(
                                                  type: TextDandyLight.LARGE_TEXT,
                                                  text: pageState.selectedYear.toString(),
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 0.0),
                                          child: TextDandyLight(
                                            type: TextDandyLight.INCOME_EXPENSE_TOTAL,
                                                amount: selectedIndex == 0 ? pageState.totalTips + pageState.incomeForSelectedYear : pageState.expensesForSelectedYear,
                                                color: Color(ColorConstants.getPrimaryWhite()),
                                                isCurrency: true,
                                                decimalPlaces: 0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: DeviceType.getDeviceType() == Type.Tablet ? const EdgeInsets.only(left: 150, right: 150) : const EdgeInsets.only(left: 0, right: 0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            <Widget>[
                              selectedIndex == 0 ? UnpaidInvoicesCard(pageState: pageState) : MileageExpensesCard(pageState: pageState),
                              selectedIndex == 0 ? PaidInvoiceCard(pageState: pageState) : SingleExpenseCard(pageState: pageState),
                              selectedIndex == 0 ? Padding(
                                padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: 'Income Insights',
                                  textAlign: TextAlign.center,
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ) : const SizedBox(),
                              selectedIndex == 0 ? MonthlyIncomeLineChart(pageState: pageState) : const SizedBox(),
                              selectedIndex == 0 ? IncomeInsights(pageState: pageState) : RecurringExpensesCard(pageState: pageState),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                floatingActionButton: SpeedDial(
                  // both default to 16
                  childMargin: const EdgeInsets.only(right: 18.0, bottom: 20.0),
                  child: getFabIcon(),
                  visible: dialVisible,
                  // If true user is forced to close dial manually
                  // by tapping main button and overlay is not rendered.
                  closeManually: false,
                  curve: Curves.bounceIn,
                  overlayColor: Colors.black,
                  overlayOpacity: 0.5,
                  onOpen: () {
                    setState(() {
                      isFabExpanded = true;
                    });
                  },
                  onClose: () {
                    setState(() {
                      isFabExpanded = false;
                    });
                  },
                  tooltip: 'Speed Dial',
                  heroTag: 'speed-dial-hero-tag',
                  backgroundColor: selectedIndex == 0 ? Color(ColorConstants.getPeachDark()) : Color(ColorConstants.getPeachDark()),
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  shape: const CircleBorder(),
                  children: selectedIndex == 0 ? [
                    SpeedDialChild(
                      child: const Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 124.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'New invoice',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      onTap: () {
                        if(pageState.profile.showRequestPaymentLinksDialog) {
                          UserOptionsUtil.showPaymentLinksRequestDialog(context);
                          pageState.setPaymentRequestAsSeen();
                        } else {
                          UserOptionsUtil.showNewInvoiceDialog(context, null, true);
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 64.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Tip',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showAddTipDialog(context);
                      },
                    ),
                  ] : [
                    SpeedDialChild(
                        child: const Icon(Icons.add),
                        backgroundColor: Color(ColorConstants.getPeachLight()),
                        labelWidget: Container(
                          alignment: Alignment.center,
                          height: 42.0,
                          width: 184.0,
                          decoration: BoxDecoration(
                            boxShadow: ElevationToShadow[4],
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Recurring Expense',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        onTap: () {
                          UserOptionsUtil.showNewRecurringExpenseDialog(context);
                        }
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getPeachLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 156.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Single Expense',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showNewSingleExpenseDialog(context);
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getPeachLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 172.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Mileage Trip',
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showNewMileageExpenseSelected(context);
                      },
                    ),
                  ],
                ),
            ),
          ],
        ),
      );
  }

  getFabIcon() {
    if(isFabExpanded){
      return Icon(Icons.close, color: Color(ColorConstants.getPrimaryWhite()));
    }else{
      return Icon(Icons.add, color: Color(ColorConstants.getPrimaryWhite()));
    }
  }
}
