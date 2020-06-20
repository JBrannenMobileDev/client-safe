import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/InvoiceItem.dart';
import 'package:dandylight/pages/IncomeAndExpenses/MileageExpenseItem.dart';
import 'package:dandylight/pages/IncomeAndExpenses/PaidInvoiceItem.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RecurringExpenseItem.dart';
import 'package:dandylight/pages/IncomeAndExpenses/SingleExpenseItem.dart';
import 'package:dandylight/pages/clients_page/ClientsPageActions.dart';
import 'package:dandylight/pages/clients_page/ClientsPageState.dart';
import 'package:dandylight/pages/clients_page/widgets/ClientListWidget.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sider_bar/sider_bar.dart';

class AllExpensesPage extends StatefulWidget {
  static const String FILTER_TYPE_MILEAGE_EXPENSES = "Mileage";
  static const String FILTER_TYPE_SINGLE_EXPENSES = "Single";
  static const String FILTER_TYPE_RECURRING_EXPENSES = "Recurring";

  @override
  State<StatefulWidget> createState() {
    return _AllExpensesPageState();
  }
}

class _AllExpensesPageState extends State<AllExpensesPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ScrollController _controller = ScrollController();
  Map<int, Widget> filterNames;
  int selectorIndex = 0;

  @override
  Widget build(BuildContext context) {
    filterNames = <int, Widget>{
      0: Text(
        AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES,
        style: TextStyle(
          fontFamily: 'simple',
          fontSize: 20.0,
          fontWeight: selectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),
      ),
      1: Text(AllExpensesPage.FILTER_TYPE_SINGLE_EXPENSES,
        style: TextStyle(
          fontFamily: 'simple',
          fontSize: 20.0,
          fontWeight: selectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      2: Text(AllExpensesPage.FILTER_TYPE_RECURRING_EXPENSES,
        style: TextStyle(
          fontFamily: 'simple',
          fontSize: 20.0,
          fontWeight: selectorIndex == 2 ? FontWeight.w800 : FontWeight.w600,
          color: Color(selectorIndex == 2
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };
    return StoreConnector<AppState, IncomeAndExpensesPageState>(
        onInit: (store) {
          selectorIndex = store.state.incomeAndExpensesPageState.allExpensesFilterType == AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES ? 0 : store.state.incomeAndExpensesPageState.allExpensesFilterType == AllExpensesPage.FILTER_TYPE_SINGLE_EXPENSES ? 1 : 2;
          filterNames = <int, Widget>{
            0: Text(
              AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES,
              style: TextStyle(
                fontFamily: 'simple',
                fontSize: 20.0,
                fontWeight: selectorIndex == 0 ? FontWeight.w800 : FontWeight.w600,
                color: Color(selectorIndex == 0
                    ? ColorConstants.getPrimaryWhite()
                    : ColorConstants.getPrimaryBlack()),
              ),
            ),
            1: Text(AllExpensesPage.FILTER_TYPE_SINGLE_EXPENSES,
              style: TextStyle(
                fontFamily: 'simple',
                fontSize: 20.0,
                fontWeight: selectorIndex == 1 ? FontWeight.w800 : FontWeight.w600,
                color: Color(selectorIndex == 1
                    ? ColorConstants.getPrimaryWhite()
                    : ColorConstants.getPrimaryBlack()),
              ),),
            2: Text(AllExpensesPage.FILTER_TYPE_RECURRING_EXPENSES,
              style: TextStyle(
                fontFamily: 'simple',
                fontSize: 20.0,
                fontWeight: selectorIndex == 2 ? FontWeight.w800 : FontWeight.w600,
                color: Color(selectorIndex == 2
                    ? ColorConstants.getPrimaryWhite()
                    : ColorConstants.getPrimaryBlack()),
              ),),
          };
          store.dispatch(FetchClientData(store.state.clientsPageState));
        },
        converter: (store) => IncomeAndExpensesPageState.fromStore(store),
        builder: (BuildContext context, IncomeAndExpensesPageState pageState) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        brightness: Brightness.light,
                        backgroundColor: Colors.white,
                        pinned: true,
                        centerTitle: true,
                        title: Text(
                            'All Expenses (' + pageState.selectedYear.toString() + ')',
                            style: TextStyle(
                              fontFamily: 'simple',
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(ColorConstants.primary_black),
                            ),
                        ),
                        actions: <Widget>[

                        ],
                        bottom: PreferredSize(
                          child: Container(
                            width: 300.0,
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                              thumbColor: Color(ColorConstants.getPrimaryColor()),
                              children: filterNames,
                              onValueChanged: (int filterTypeIndex) {
                                setState(() {
                                  selectorIndex = filterTypeIndex;
                                });
                                pageState.onAllExpensesFilterChanged(filterTypeIndex == 0 ? AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES : filterTypeIndex == 1 ? AllExpensesPage.FILTER_TYPE_SINGLE_EXPENSES : AllExpensesPage.FILTER_TYPE_RECURRING_EXPENSES);
                              },
                              groupValue: selectorIndex,
                            ),
                          ),
                          preferredSize: Size.fromHeight(44.0),
                        ),
                      ),
                      SliverList(
                        delegate: new SliverChildListDelegate(
                          <Widget>[
                            ListView.builder(
                              reverse: false,
                              padding: new EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 64.0),
                              shrinkWrap: true,
                              controller: _controller,
                              physics: ClampingScrollPhysics(),
                              key: _listKey,
                              itemCount: selectorIndex == 0 ? pageState.mileageExpensesForSelectedYear.length : selectorIndex == 1 ? pageState.singleExpensesForSelectedYear.length : pageState.recurringExpensesForSelectedYear.length,
                              itemBuilder: _buildItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
          ),
        ),
      );
  }
}

Widget _buildItem(BuildContext context, int index) {
  return StoreConnector<AppState, IncomeAndExpensesPageState>(
    converter: (store) => IncomeAndExpensesPageState.fromStore(store),
    builder: (BuildContext context, IncomeAndExpensesPageState pageState) =>
        pageState.allExpensesFilterType ==
                AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES
            ? MileageExpenseItem(pageState: pageState, mileageExpense: pageState.mileageExpensesForSelectedYear.elementAt(index))
            : pageState.allExpensesFilterType ==
                    AllExpensesPage.FILTER_TYPE_SINGLE_EXPENSES
                ? SingleExpenseItem(
                    pageState: pageState,
                    singleExpense: pageState.singleExpensesForSelectedYear
                        .elementAt(index),
                  )
                : RecurringExpenseItem(pageState: pageState, recurringExpense: pageState.recurringExpensesForSelectedYear.elementAt(index)),
  );
}
