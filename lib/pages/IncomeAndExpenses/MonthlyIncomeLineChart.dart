import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../dashboard_page/widgets/BarChartWidget.dart';

class MonthlyIncomeLineChart extends StatelessWidget{
  MonthlyIncomeLineChart({this.pageState});

  final IncomeAndExpensesPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
    child:Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 275.0,
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'Monthly Income',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                BarChartWidget(monthsData: pageState.lineChartMonthData),
              ],
            ),
          ),
        ],
    ),
    );
  }
}