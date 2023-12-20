import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/PieChartWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';

class LeadSourcesPieChart extends StatelessWidget{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  LeadSourcesPieChart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
          converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
          builder: (BuildContext context, DashboardPageState pageState) => Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 124.0),
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Lead Sources - ${DateTime.now().year}',
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                pageState.leadSourcesData.isNotEmpty ? PieChartWidget(chartType: PieChartWidget.LEAD_SOURCES,) :
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
                        text: 'No data available. Add new contacts to see stats.',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
                pageState.leadSourcesData.isNotEmpty ? Container(
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Sources',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Conversion Rate',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ],
                  ),
                ) : const SizedBox(),
                pageState.leadSourcesData.isNotEmpty ? ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  shrinkWrap: true,
                  controller: null,
                  physics: const ClampingScrollPhysics(),
                  key: _listKey,
                  itemCount: pageState.leadSourcePieChartRowData.length,
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
                                    color: Color(pageState.leadSourcePieChartRowData.elementAt(index).color)
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 8.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: '${pageState.leadSourcePieChartRowData.elementAt(index).sourceName} - ${pageState.leadSourcePieChartRowData.elementAt(index).count}',
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: '${pageState.leadSourcePieChartRowData.elementAt(index).conversionRate}%',
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