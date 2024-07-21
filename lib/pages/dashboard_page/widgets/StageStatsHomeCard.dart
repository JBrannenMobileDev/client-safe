
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
  StageStatsHomeCard({Key? key, this.pageState}) : super(key: key);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final DashboardPageState? pageState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      decoration: BoxDecoration(
          color: Color(ColorConstants.getPrimaryGreyLight()).withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(12.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Active Job Stages',
              textAlign: TextAlign.start,
              color: Color(ColorConstants.getPrimaryGreyDark()),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              NavigationUtil.onStageStatsSelected(context, pageState!, 'Active Jobs', null, true);
            },
            child: SizedBox(
              height: 42.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        margin: const EdgeInsets.only(right: 18.0, left: 16.0),
                        height: 24.0,
                        width: 24.0,
                        child: Image.asset('assets/images/icons/job_type.png', color: Color(ColorConstants.getPrimaryGreyDark())),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'All active jobs',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: pageState?.activeJobs?.length.toString() ?? '0',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          pageState!.allUserStages!.isNotEmpty ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 16.0),
            reverse: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            key: _listKey,
            itemCount: pageState!.allUserStages!.length,
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
    JobStage stage = pageState!.allUserStages!.elementAt(index);
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          NavigationUtil.onStageStatsSelected(context, pageState!, JobStage.getStageText(stage), stage, false);
          EventSender().sendEvent(eventName: EventNames.NAV_TO_ACTIVE_STAGE, properties: {EventNames.ACTIVE_STAGE_PARAM_NAME : JobStage.getStageText(stage)});
        },
        child: StageStatsItem(jobs: JobUtil.getJobsForStage(
            pageState!.activeJobs!, pageState!.allUserStages!.elementAt(index)),
            pageState: pageState!,
            stage: pageState!.allUserStages!.elementAt(index))
    );
  }
}
