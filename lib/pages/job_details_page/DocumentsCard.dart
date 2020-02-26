import 'package:client_safe/pages/common_widgets/ClientSafeButton.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class DocumentsCard extends StatelessWidget {
  DocumentsCard({this.pageState});

  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
      padding: EdgeInsets.only(top: 26.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
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
                Container(
                      margin: EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 0.0),
                      child: Text(
                        'Documents',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Blackjack',
                          fontWeight: FontWeight.w800,
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
