
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
      color: Colors.transparent,
      child: Stack(

        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.only(top: 40.0),
            height: pageState.upcomingJobs.length > 0 ? pageState.upcomingJobs.length == 1 ? 124.0 : 189.0 : 64.0,
          ),
          BaseHomeCardInProgress(
            cardTitle: "Upcoming Jobs",
            pageState: pageState,
            jobs: pageState.isMinimized ? (pageState.upcomingJobs.length > 3? pageState.upcomingJobs.sublist(0, 3) : pageState.upcomingJobs)
            : pageState.upcomingJobs,
          ),
        ],
      ),
    );
  }
}
