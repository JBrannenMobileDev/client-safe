
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/BaseHomeCardInProgress.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StageStatsItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/JobUtil.dart';

class StageStatsHomeCard extends StatelessWidget {
  StageStatsHomeCard({this.pageState});
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      decoration: new BoxDecoration(
          color: Color(ColorConstants.getPrimaryWhite()),
          borderRadius: new BorderRadius.all(Radius.circular(24.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Text(
              'Active Stages',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 22.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.primary_black),
              ),
            ),
          ),
          pageState.allUserStages.length > 0 ? ListView.builder(
            padding: EdgeInsets.only(bottom: 16.0),
            reverse: false,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            key: _listKey,
            itemCount: pageState.allUserStages.length,
            itemBuilder: _buildItem,
          ) : Container(
            padding: EdgeInsets.only(left:  32.0, right: 32.0, top: 16.0),
            height: 100.0,
            child: Text(
              'No Active jobs.  Start a new job to see your progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.primary_black),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StageStatsItem(jobs: JobUtil.getJobsForStage(pageState.activeJobs, pageState.allUserStages.elementAt(index)), pageState: pageState, stage: pageState.allUserStages.elementAt(index));
  }
}
