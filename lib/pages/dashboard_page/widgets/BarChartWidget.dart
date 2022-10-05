import 'dart:async';
import 'dart:math';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'LineChartMonthData.dart';


class BarChartWidget extends StatefulWidget {
  BarChartWidget({Key key, this.monthsData}) : super(key: key);
  final List<LineChartMonthData> monthsData;

  @override
  State<StatefulWidget> createState() => BarChartState();
}

class BarChartState extends State<BarChartWidget> {
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    bool noData = true;
    for(LineChartMonthData data in widget.monthsData) {
      if(data.income > 1) {
        noData = false;
      }
    }
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  noData ? Container(
                    margin: EdgeInsets.only(top: 24.0, bottom: 18.0),
                    height: 72.0,
                    width: 72.0,
                    child: Image.asset(
                      'assets/images/icons/bar_chart_icon.png',
                      color: Color(ColorConstants.getPeachDark()).withOpacity(0.5),
                    ),
                  ) : SizedBox(),
                  noData ? Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    height: 65.0,
                    child: Text(
                      'No income data available. Receive payment to see income stats.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ) : SizedBox(),
                  Container(
                    margin: EdgeInsets.only(top: 0.0),
                    height: noData ? 50.0 : 175.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: !noData ? BarChart(
                        mainBarData(),
                        swapAnimationDuration: animDuration,
                      ) : SizedBox(),
                    ),
                  ),
                ],
              ),
            )
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      int y, {
        bool isTouched = false,
        Color barColor = const Color(0xffE6CE97),
        Color touchedBarColor = const Color(0xff557571),
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y.toDouble() + 1 : y.toDouble(),
          color: isTouched ? touchedBarColor : barColor,
          width: width,
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(6, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex);
      default:
        return throw Error();
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Color(ColorConstants.getBlueDark()),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = widget.monthsData.elementAt(group.x.toInt()).name;
                  break;
                case 1:
                  weekDay = widget.monthsData.elementAt(group.x.toInt()).name;
                  break;
                case 2:
                  weekDay = widget.monthsData.elementAt(group.x.toInt()).name;
                  break;
                case 3:
                  weekDay = widget.monthsData.elementAt(group.x.toInt()).name;
                  break;
                case 4:
                  weekDay = widget.monthsData.elementAt(group.x.toInt()).name;
                  break;
                case 5:
                  weekDay = widget.monthsData.elementAt(group.x.toInt()).name;
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0).format((rod.toY - 1) == 1 ? 0 : (rod.toY - 1)),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 20.0,
      fontFamily: 'simple',
      fontWeight: FontWeight.w400,
      color: Color(ColorConstants.primary_black),
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Apr', style: style);
        break;
      case 1:
        text = const Text('May', style: style);
        break;
      case 2:
        text = const Text('Jun', style: style);
        break;
      case 3:
        text = const Text('Jul', style: style);
        break;
      case 4:
        text = const Text('Aug', style: style);
        break;
      case 5:
        text = const Text('Sep', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
  }
}