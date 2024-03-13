import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../DashboardPageState.dart';


class PieChartWidget extends StatefulWidget {
  static const String JOB_TYPE_BREAKDOWN = 'job_type_breakdown';
  static const String LEAD_SOURCES = 'lead_sources';

  const PieChartWidget({Key? key, this.chartType}) : super(key: key);
  final String? chartType;

  @override
  State<StatefulWidget> createState() => PieChartState(chartType!);
}

class PieChartState extends State<PieChartWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);

  final String chartType;
  List<PieChartSectionData> chartData = [];
  int touchedIndex = -1;

  PieChartState(this.chartType);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    onInit: (store) {
      switch(chartType) {
        case PieChartWidget.JOB_TYPE_BREAKDOWN:
          chartData = store.state.dashboardPageState!.jobTypeBreakdownData!;
          break;
        case PieChartWidget.LEAD_SOURCES:
          chartData = store.state.dashboardPageState!.leadSourcesData!;
          break;
      }
    },
      onDidChange: (previous, current) {
        switch(chartType) {
          case PieChartWidget.JOB_TYPE_BREAKDOWN:
            chartData = current.jobTypeBreakdownData!;
            break;
          case PieChartWidget.LEAD_SOURCES:
            chartData = current.leadSourcesData!;
            break;
        }
      },
  converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
  builder: (BuildContext context, DashboardPageState pageState) => Container(
      alignment: Alignment.topCenter,
      height: 224.0,
      margin: const EdgeInsets.only(top: 0.0),
      child: chartData != null && chartData.isNotEmpty ? PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sectionsSpace: 0.5,
          centerSpaceRadius: 50,
          sections: chartData,
        ),
      ) : const SizedBox(),
    )
  );
}