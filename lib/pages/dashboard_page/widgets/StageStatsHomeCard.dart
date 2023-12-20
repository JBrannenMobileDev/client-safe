
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/dashboard_page/widgets/StageStatsItem.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/JobStage.dart';
import '../../../utils/JobUtil.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';

class StageStatsHomeCard extends StatelessWidget {
  StageStatsHomeCard({Key key, this.pageState}) : super(key: key);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
          color: Color(ColorConstants.getPrimaryWhite()),
          borderRadius: const BorderRadius.all(Radius.circular(12.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Active Stages',
              textAlign: TextAlign.start,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
          pageState.allUserStages.isNotEmpty ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 16.0),
            reverse: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            key: _listKey,
            itemCount: pageState.allUserStages.length,
            itemBuilder: _buildItem,
          ) : Container(
            padding: const EdgeInsets.only(left:  32.0, right: 32.0, top: 16.0),
            height: 100.0,
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'No Active jobs.  Start a new job to see your progress.',
              textAlign: TextAlign.center,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    JobStage stage = pageState.allUserStages.elementAt(index);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          NavigationUtil.onStageStatsSelected(context, pageState, JobStage.getStageText(stage), stage, false);
          EventSender().sendEvent(eventName: EventNames.NAV_TO_ACTIVE_STAGE, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.getStageText(stage)});
        },
        child: StageStatsItem(jobs: JobUtil.getJobsForStage(
            pageState.activeJobs, pageState.allUserStages.elementAt(index)),
            pageState: pageState,
            stage: pageState.allUserStages.elementAt(index))
    );
  }
}
