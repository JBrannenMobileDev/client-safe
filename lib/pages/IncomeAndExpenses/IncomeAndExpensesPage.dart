import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/AllInvoicesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeGraphCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/MileageExpensesCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/PaidInvoiceCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/RecurringExpensesCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/SingleExpenseCard.dart';
import 'package:client_safe/pages/IncomeAndExpenses/UnpaidInvoicesCard.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/Shadows.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    tabs = <int, Widget>{
      0: Text(IncomeAndExpensesPage.FILTER_TYPE_INCOME, style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'simple',
        fontWeight: FontWeight.w800,
        color: Color(selectedIndex == 0 ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite()),
      ),),
      1: Text(IncomeAndExpensesPage.FILTER_TYPE_EXPENSES, style: TextStyle(
        fontSize: 20.0,
        fontFamily: 'simple',
        fontWeight: FontWeight.w800,
        color: Color(selectedIndex == 1 ? ColorConstants.getPrimaryBlack() : ColorConstants.getPrimaryWhite()),
      ),),
    };
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
      onInit: (appState) {
        appState.dispatch(LoadAllInvoicesAction(appState.state.incomeAndExpensesPageState));
        appState.dispatch(LoadAllJobsAction(appState.state.incomeAndExpensesPageState));
        appState.dispatch(FetchSingleExpenses(appState.state.incomeAndExpensesPageState));
        appState.dispatch(FetchRecurringExpenses(appState.state.incomeAndExpensesPageState));
        appState.dispatch(FetchMileageExpenses(appState.state.incomeAndExpensesPageState));
      },
        converter: (store) => IncomeAndExpensesPageState.fromStore(store),
        builder: (BuildContext context, IncomeAndExpensesPageState pageState) => Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(selectedIndex == 0 ? ColorConstants.getBlueLight() : ColorConstants.getPeachLight()),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(selectedIndex == 0 ? ColorConstants.getBlueLight() : ColorConstants.getPeachLight()),
                      image: DecorationImage(
                        image: AssetImage(selectedIndex == 0 ? ImageUtil.JOB_DETAILS_BG : ImageUtil.EXPENSES_BG),
                        repeat: ImageRepeat.repeat,
                        fit: BoxFit.contain,
                      ),
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
                        expandedHeight: 315.0,
                        centerTitle: true,
                        title: Center(
                          child: Text(
                            'Income & Expenses',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                        actions: <Widget>[

                        ],
                        flexibleSpace: new FlexibleSpaceBar(
                          background: Column(

                            children: <Widget>[
                              SafeArea(
                                child: PreferredSize(
                                  child: Container(
                                    width: 300.0,
                                    margin: EdgeInsets.only(top: 56.0),
                                    child: CupertinoSlidingSegmentedControl<int>(
                                      thumbColor: Color(ColorConstants.getPrimaryWhite()),
                                      backgroundColor: Colors.transparent,
                                      children: tabs,
                                      onValueChanged: (int filterTypeIndex) {
                                        setState(() {
                                          selectedIndex = filterTypeIndex;
                                        });
                                        pageState.onFilterChanged(filterTypeIndex == 0 ? IncomeAndExpensesPage.FILTER_TYPE_INCOME : IncomeAndExpensesPage.FILTER_TYPE_EXPENSES);
                                      },
                                      groupValue: selectedIndex,
                                    ),
                                  ),
                                  preferredSize: Size.fromHeight(44.0),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 56.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: selectedIndex == 1 ? 8.0 : 0.0),
                                      width: 96.0,
                                      height: 96.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(48.0),
                                        color: Color(ColorConstants.getPrimaryWhite()),
                                      ),
                                      child: Image(
                                        height: 64.0,
                                        width: 64.0,
                                        image: AssetImage(selectedIndex == 0 ? "assets/images/job_progress/payment_requested.png" : "assets/images/icons/expenses_icon_peach.png"),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(

                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                selectedIndex == 0 ? 'Income' : 'Expenses',
                                                style: TextStyle(
                                                  fontFamily: 'simple',
                                                  fontSize: 26.0,
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(ColorConstants.getPrimaryWhite()),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 8.0, top: 2.0),
                                              padding: EdgeInsets.only(bottom: 2.0),
                                              alignment: Alignment.center,
                                              height: 32.0,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16.0),
                                                border: Border.all(
                                                    width: 2,
                                                  color: Color(ColorConstants.getPrimaryWhite())
                                                ),
                                              ),
                                              child: FlatButton(
                                                onPressed: () {
                                                  DatePicker.showDatePicker(
                                                    context,
                                                    dateFormat:'yyyy',
                                                    onConfirm: (dateTime, intList) {
                                                      pageState.onYearChanged(dateTime.year);
                                                    }
                                                  );
                                                },
                                                child: Text(
                                                  pageState.selectedYear.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'simple',
                                                    fontSize: 26.0,
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(ColorConstants.getPrimaryWhite()),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            selectedIndex == 0 ? NumberFormat.simpleCurrency(decimalDigits: 0).format(pageState.totalTips.round() + pageState.incomeForSelectedYear.round())
                                            : NumberFormat.simpleCurrency(decimalDigits: 0).format(pageState.expensesForSelectedYear.round()),
                                            style: TextStyle(
                                              fontFamily: 'simple',
                                              fontSize: 52.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(ColorConstants.getPrimaryWhite()),
                                            ),
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
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            selectedIndex == 0 ? IncomeGraphCard(pageState: pageState) : MileageExpensesCard(pageState: pageState),
                            selectedIndex == 0 ? UnpaidInvoicesCard(pageState: pageState) : SingleExpenseCard(pageState: pageState),
                            selectedIndex == 0 ? PaidInvoiceCard(pageState: pageState) : RecurringExpensesCard(pageState: pageState),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                floatingActionButton: SpeedDial(
                  // both default to 16
                  marginRight: 18,
                  marginBottom: 20,
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
                  backgroundColor: Color(ColorConstants.getPrimaryColor()),
                  foregroundColor: Colors.black,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  children: selectedIndex == 0 ? [
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 124.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Text(
                          'New invoice',
                          style: TextStyle(
                            fontFamily: 'simple',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showNewInvoiceDialog(context, null);
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getPeachLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 64.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Text(
                          'Tip',
                          style: TextStyle(
                            fontFamily: 'simple',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showAddTipDialog(context);
                      },
                    ),
                  ] : [
                    SpeedDialChild(
                        child: Icon(Icons.add),
                        backgroundColor: Color(ColorConstants.getPeachDark()),
                        labelWidget: Container(
                          alignment: Alignment.center,
                          height: 42.0,
                          width: 184.0,
                          decoration: BoxDecoration(
                            boxShadow: ElevationToShadow[4],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          child: Text(
                            'Recurring Expense',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ),
                        onTap: () {
                          UserOptionsUtil.showNewRecurringExpenseDialog(context);
                        }
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getBlueLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 156.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Text(
                          'Single Expense',
                          style: TextStyle(
                            fontFamily: 'simple',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      onTap: () {
                        UserOptionsUtil.showNewSingleExpenseDialog(context);
                      },
                    ),
                    SpeedDialChild(
                      child: Icon(Icons.add),
                      backgroundColor: Color(ColorConstants.getPeachLight()),
                      labelWidget: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        width: 172.0,
                        decoration: BoxDecoration(
                          boxShadow: ElevationToShadow[4],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21.0),
                        ),
                        child: Text(
                          'Mileage Expense',
                          style: TextStyle(
                            fontFamily: 'simple',
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
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
