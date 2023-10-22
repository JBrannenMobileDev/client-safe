
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/UnpaidInvoiceItem.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../utils/TextFormatterUtil.dart';
import '../../widgets/TextDandyLight.dart';

class IncomeInsights extends StatelessWidget {
  IncomeInsights({this.pageState});

  final IncomeAndExpensesPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 128.0),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - (21),
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: new BorderRadius.all(Radius.circular(12.0))),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'This Month',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 42.0),
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: TextFormatterUtil.formatSimpleCurrency(pageState.thisMonthIncome),
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - (21),
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: new BorderRadius.all(Radius.circular(12.0))),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'Last Month',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 42.0),
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: TextFormatterUtil.formatSimpleCurrency(pageState.lastMonthIncome),
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 2) - (21),
                height: 120.0,
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.all(Radius.circular(12.0))),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'This Month \nLast Year',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 54.0),
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                        text: TextFormatterUtil.formatSimpleCurrency(pageState.thisMonthLastYearIncome),
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width / 2) - (21),
                height: 120.0,
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.all(Radius.circular(12.0))),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Last Month \nLast Year',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 54.0),
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                        text: TextFormatterUtil.formatSimpleCurrency(pageState.lastMonthLastYearIncome),
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
