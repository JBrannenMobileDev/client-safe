import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/TextDandyLight.dart';
import 'BarChartWidget.dart';

class MonthlyProfitLineChart extends StatelessWidget{
  const MonthlyProfitLineChart({Key? key, this.pageState}) : super(key: key);

  final DashboardPageState? pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Monthly Net Profit',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryGreyDark()),
                  ),
                ),
                BarChartWidget(monthsData: pageState!.lineChartMonthData),
              ],
            ),
    );
  }
}