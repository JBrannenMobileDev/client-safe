
import 'package:client_safe/pages/IncomeAndExpenses/UnpaidInvoiceItem.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class IncomeGraphCard extends StatelessWidget {
  IncomeGraphCard({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(

        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40.0),
            height: 100.0,
            color: Color(ColorConstants.getPrimaryBackgroundGrey()),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Income Insights",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Blackjack',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      Text(
                        "2020",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      )
                    ],
                  ),
                ),
                0 > 0 ? Container(
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 16.0),
                    reverse: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
//                    key: _listKey,
//                    itemCount: jobs.length,
                    itemBuilder: _buildItem,
                  ),
                ) : Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 26.0, left: 26.0, right: 26.0),
                  height: 56.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
//    return UnpaidInvoiceItem(job: jobs.elementAt(index), pageState: pageState);
    return SizedBox();
  }
}