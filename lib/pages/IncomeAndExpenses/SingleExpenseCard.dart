import 'package:client_safe/pages/IncomeAndExpenses/AllExpensesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/IncomeAndExpenses/SingleExpenseItem.dart';
import 'package:client_safe/pages/common_widgets/DandyLightTextWidget.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/LeadItem.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class SingleExpenseCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  SingleExpenseCard({
    this.pageState});

  final IncomeAndExpensesPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getContainerHeight(pageState.singleExpensesForSelectedYear.length, pageState),
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Single Expenses (' + pageState.selectedYear.toString() + ')',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      pageState.singleExpensesForSelectedYear != null && pageState.singleExpensesForSelectedYear.length > 3 ? FlatButton(
                        onPressed: () {
                          pageState.onViewAllExpensesSelected(1);
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => AllExpensesPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            pageState.isSingleExpensesMinimized ? 'View all(' + pageState.singleExpensesForSelectedYear.length.toString() + ')' : 'Hide',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConstants.primary_black),
                            ),
                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                ),
                pageState.singleExpensesForSelectedYear.length > 0 ? Container(
                  alignment: Alignment.center,
                  child: DandyLightTextWidget(
                    amount: pageState.singleExpensesForSelectedYearTotal,
                    textSize: 48.0,
                    textColor: Color(ColorConstants.getPeachDark()),
                    fontWeight: FontWeight.w600,
                    isCurrency: true,
                    decimalPlaces: 2,
                  ),
                ) : SizedBox(),
                pageState.singleExpensesForSelectedYear.length > 0 ? ListView.builder(
                  padding: EdgeInsets.only(top:0.0, bottom: 16.0),
                    reverse: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    key: _listKey,
                    itemCount: _getItemCount(pageState),
                    itemBuilder: _buildItem,
                  ) : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 16.0, right: 16.0),
                  height: 64.0,
                  child: Text(
                    'You have zero single expenses.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w400,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
    ),
    );
  }

  int _getItemCount(IncomeAndExpensesPageState pageState) {
    if(pageState.isSingleExpensesMinimized && pageState.singleExpensesForSelectedYear.length > 3) {
      return 3;
    } else {
      return pageState.singleExpensesForSelectedYear.length;
    }
  }

  double getContainerHeight(int length, IncomeAndExpensesPageState pageState) {
    if(length == 0) {
      return 178.0;
    }else if(length == 1) {
      return 222.0;
    }else if(length == 2) {
      return 306.0;
    }else if(length == 3) {
      return 370.0;
    }else {
      return pageState.isSingleExpensesMinimized ? 390.0 : ((74*length) + 172).toDouble();
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return SingleExpenseItem(singleExpense: pageState.singleExpensesForSelectedYear.elementAt(index), pageState: pageState);
  }
}