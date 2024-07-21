import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/PieChartWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/TextFormatterUtil.dart';
import '../../../widgets/TextDandyLight.dart';

class JobTypeBreakdownPieChart extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  JobTypeBreakdownPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
          converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
          builder: (BuildContext context, DashboardPageState pageState) => Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Session Type Breakdown - ${DateTime.now().year}',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryGreyDark()),
                  ),
                ),
                pageState.sessionTypeBreakdownData!.isNotEmpty ? PieChartWidget(chartType: PieChartWidget.JOB_TYPE_BREAKDOWN,) :
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 25, bottom: 25),
                        height: 100,
                        child: Image.asset('assets/images/icons/pie_chart.png', color: Color(ColorConstants.getPeachLight()),),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 36, right: 36),
                        height: 74,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'No data available. Receive payment to see stats.',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ],
                  ),
                pageState.sessionTypeBreakdownData!.isNotEmpty ? ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  shrinkWrap: true,
                  controller: null,
                  physics: const ClampingScrollPhysics(),
                  key: _listKey,
                  itemCount: pageState.sessionTypePieChartRowData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 48.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 18.0,
                                width: 18.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    color: Color(pageState.sessionTypePieChartRowData!.elementAt(index).color!)
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.SMALL_TEXT,
                                  text: '${pageState.sessionTypePieChartRowData!.elementAt(index).sessionType} - ${pageState.sessionTypePieChartRowData!.elementAt(index).count}',
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: TextFormatterUtil.formatSimpleCurrency(pageState.sessionTypePieChartRowData!.elementAt(index).totalIncomeForType!),
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ) : const SizedBox(),
              ],
            ),
          ),
      );
  }