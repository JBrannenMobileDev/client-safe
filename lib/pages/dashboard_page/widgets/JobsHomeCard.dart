
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/dashboard_page/widgets/BaseHomeCardInProgress.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class JobsHomeCard extends StatelessWidget {
  JobsHomeCard({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(

        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40.0),
            height: 189.0,
            color: Color(ColorConstants.getPrimaryBackgroundGrey())
          ),
          BaseHomeCardInProgress(
            cardTitle: "Upcoming Jobs",
            pageState: pageState,
            jobs: pageState.currentJobs,
          ),
        ],
      ),
    );
  }
}
