import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobListItem.dart';
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
            padding: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
            height: 400.0,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 10.0),
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(26.0, 26.0, 26.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cardTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16.0, bottom: 8.0, left: 64.0, right: 64.0),
                  height: 64.0,
                  child: Text(
                    "This feature will be available in future updates of Client Safe.",
                    textAlign: TextAlign.center,
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