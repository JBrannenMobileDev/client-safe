import 'package:dandylight/pages/IncomeAndExpenses/AllExpensesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RecurringExpenseItem.dart';
import 'package:dandylight/pages/common_widgets/dandylightTextWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/styles/Styles.dart';


class RecurringExpensesCard extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  RecurringExpensesCard({
    this.pageState});

  final IncomeAndExpensesPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 64.0),
      height: getContainerHeight(pageState.recurringExpensesForSelectedYear.length, pageState),
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
                        'Recurring Expenses (' + pageState.selectedYear.toString() + ')',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      pageState.recurringExpensesForSelectedYear != null && pageState.recurringExpensesForSelectedYear.length > 3 ? TextButton(
                        style: Styles.getButtonStyle(),
                        onPressed: () {
                          pageState.onViewAllExpensesSelected(2);
                          Navigator.of(context).push(
                            new MaterialPageRoute(builder: (context) => AllExpensesPage()),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'View all(' + pageState.recurringExpensesForSelectedYear.length.toString() + ')',
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
                pageState.recurringExpensesForSelectedYear.length > 0 ? Container(
                  alignment: Alignment.center,
                  child: DandyLightTextWidget(
                      amount: pageState.recurringExpensesForSelectedYearTotal,
                      textSize: 48.0,
                      textColor: Color(ColorConstants.getPeachDark()),
                      fontWeight: FontWeight.w600,
                      isCurrency: true,
                      decimalPlaces: 2,
                    ),
                ) : SizedBox(),
                pageState.recurringExpensesForSelectedYear.length > 0 ? ListView.builder(
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
                    'You have zero recurring expenses.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
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
    );
  }

  int _getItemCount(IncomeAndExpensesPageState pageState) {
    if( pageState.recurringExpensesForSelectedYear.length > 3) {
      return 3;
    } else {
      return pageState.recurringExpensesForSelectedYear.length;
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
      return 390.0;
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return RecurringExpenseItem(recurringExpense: pageState.recurringExpensesForSelectedYear.elementAt(index), pageState: pageState);
  }
}