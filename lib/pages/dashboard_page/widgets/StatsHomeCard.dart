import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/widgets.dart';

class StatsHomeCard extends StatelessWidget{

  StatsHomeCard({
    this.cardTitle,
    this.pageState});

  final String cardTitle;
  final DashboardPageState pageState;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 0.0),
            height: 400.0,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 24.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cardTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Blackjack',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0.0, bottom: 16.0, left: 26.0, right: 26.0),
                  height: 64.0,
                  child: Text(
                    "This feature will be available in future updates of DandyLight.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}