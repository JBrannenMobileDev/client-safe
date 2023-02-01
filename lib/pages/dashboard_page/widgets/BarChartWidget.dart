import 'dart:async';
import 'dart:math';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widgets/TextDandyLight.dart';
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
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'No income data available. Receive payment to see income stats.',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.primary_black),
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
        bool isNegative = false,
        Color barColor = const Color(0xffE6CE97),
        Color barColorNegative = const Color(ColorConstants.peach_dark),
        Color touchedBarColor = const Color(0xff557571),
        double width = 22,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y.toDouble() + 1 : y.toDouble(),
          color: isNegative ? barColorNegative : isTouched ? touchedBarColor : barColor,
          width: width,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(6, (i) {
    switch (i) {
      case 0:
        return makeGroupData(0, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex, isNegative: widget.monthsData.elementAt(i).income < 0);
      case 1:
        return makeGroupData(1, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex, isNegative: widget.monthsData.elementAt(i).income < 0);
      case 2:
        return makeGroupData(2, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex, isNegative: widget.monthsData.elementAt(i).income < 0);
      case 3:
        return makeGroupData(3, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex, isNegative: widget.monthsData.elementAt(i).income < 0);
      case 4:
        return makeGroupData(4, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex, isNegative: widget.monthsData.elementAt(i).income < 0);
      case 5:
        return makeGroupData(5, widget.monthsData.elementAt(i).income, isTouched: i == touchedIndex, isNegative: widget.monthsData.elementAt(i).income < 0);
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
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0).format((rod.toY - 1) == 1 ? 0 : (rod.toY - 1)),
                    style: TextStyle(
                      fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                      fontFamily: TextDandyLight.getFontFamily(),
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
    Widget text;
    switch (value.toInt()) {
      case 0:
        DateTime currentMonth = DateTime.now();
        DateTime resultMonth = DateTime(currentMonth.year, currentMonth.month - 5, currentMonth.day);
        String monthShort = _getMonthStringShort(resultMonth.month);
        text = TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: monthShort);
        break;
      case 1:
        DateTime currentMonth = DateTime.now();
        DateTime resultMonth = DateTime(currentMonth.year, currentMonth.month - 4, currentMonth.day);
        String monthShort = _getMonthStringShort(resultMonth.month);
        text = TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: monthShort);
        break;
      case 2:
        DateTime currentMonth = DateTime.now();
        DateTime resultMonth = DateTime(currentMonth.year, currentMonth.month - 3, currentMonth.day);
        String monthShort = _getMonthStringShort(resultMonth.month);
        text = TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: monthShort);
        break;
      case 3:
        DateTime currentMonth = DateTime.now();
        DateTime resultMonth = DateTime(currentMonth.year, currentMonth.month - 2, currentMonth.day);
        String monthShort = _getMonthStringShort(resultMonth.month);
        text = TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: monthShort);
        break;
      case 4:
        DateTime currentMonth = DateTime.now();
        DateTime resultMonth = DateTime(currentMonth.year, currentMonth.month - 1, currentMonth.day);
        String monthShort = _getMonthStringShort(resultMonth.month);
        text = TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: monthShort);
        break;
      case 5:
        DateTime currentMonth = DateTime.now();
        String monthShort = _getMonthStringShort(currentMonth.month);
        text = TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: monthShort);
        break;
      default:
        text = TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: '');
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

  String _getMonthStringShort(int month) {
    switch(month) {
      case 1:
        return 'Jan';
        break;
      case 2:
        return 'Feb';
        break;
      case 3:
        return 'Mar';
        break;
      case 4:
        return 'Apr';
        break;
      case 5:
        return 'May';
        break;
      case 6:
        return 'Jun';
        break;
      case 7:
        return 'Jul';
        break;
      case 8:
        return 'Aug';
        break;
      case 9:
        return 'Sep';
        break;
      case 10:
        return 'Oct';
        break;
      case 11:
        return 'Nov';
        break;
      case 12:
        return 'Dec';
        break;
    }
    return '';
  }
}