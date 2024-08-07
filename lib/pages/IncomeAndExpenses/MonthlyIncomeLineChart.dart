import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';
import '../dashboard_page/widgets/BarChartWidget.dart';

class MonthlyIncomeLineChart extends StatelessWidget{
  MonthlyIncomeLineChart({this.pageState});

  final IncomeAndExpensesPageState? pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
    child: Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Monthly Income',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                BarChartWidget(monthsData: pageState!.lineChartMonthData),
              ],
            ),
    ),
    );
  }
}