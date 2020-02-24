import 'package:client_safe/pages/common_widgets/ClientSafeButton.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RemindersCard extends StatelessWidget {
  RemindersCard({this.pageState});

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 40.0),
              height: 130.0,
              color: Color(ColorConstants.getPrimaryBackgroundGrey())),
          Container(
            width: double.maxFinite,
            height: 175.0,
            margin: EdgeInsets.fromLTRB(26.0, 0.0, 26.0, 0.0),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(8.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 0.0),
                      child: Text(
                        'Reminders',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Blackjack',
                          fontWeight: FontWeight.w800,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 0.0),
                      child: Text(
                        "View all",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
