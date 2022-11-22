
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/UnpaidInvoiceItem.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../utils/TextFormatterUtil.dart';

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
            padding: EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - (28),
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: new BorderRadius.all(Radius.circular(24.0))),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'This Month',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 42.0),
                        child: Text(
                          TextFormatterUtil.formatSimpleCurrency(pageState.thisMonthIncome),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 32.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width / 2) - (28),
                  height: 120.0,
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: new BorderRadius.all(Radius.circular(24.0))),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Last Month',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 42.0),
                        child: Text(
                          TextFormatterUtil.formatSimpleCurrency(pageState.lastMonthIncome),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 32.0,
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 2) - (28),
                height: 120.0,
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.all(Radius.circular(24.0))),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'This Month Last Year',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 42.0),
                      child: Text(
                        TextFormatterUtil.formatSimpleCurrency(pageState.thisMonthLastYearIncome),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width / 2) - (28),
                height: 120.0,
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.all(Radius.circular(24.0))),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Last Month Last Year',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 42.0),
                      child: Text(
                        TextFormatterUtil.formatSimpleCurrency(pageState.lastMonthLastYearIncome),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 32.0,
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
          )
        ],
      ),
    );
  }
}
