import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';

class PosesCard extends StatelessWidget {

  const PosesCard({Key key, this.pageState}) : super(key: key);
  
  final JobDetailsPageState pageState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(pageState.job.poses.isNotEmpty) {
          NavigationUtil.onJobPosesSelected(context);
          EventSender().sendEvent(eventName: EventNames.NAV_TO_JOB_POSES_FROM_JOB_DETAILS);
        } else {
          NavigationUtil.onPosesSelected(context, pageState.job, true, false);
          EventSender().sendEvent(eventName: EventNames.NAV_TO_POSES_ADD_POSE_TO_JOB);
        }
      },
      child: Container(
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
          width: double.maxFinite,
          height: pageState.job.poses.isEmpty ? 216 : 184.0,
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: const BorderRadius.all(Radius.circular(12.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(26.0, 16.0, 26.0, 24.0),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Poses',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              pageState.job.poses.isNotEmpty ? Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    pageState.job.poses.isNotEmpty ? Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      alignment: Alignment.centerLeft,
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: '+${pageState.job.poses.length}',
                        color: Color(ColorConstants.getPeachDark()),
                        textAlign: TextAlign.center,
                      ),
                    ) : const SizedBox(),
                    pageState.job.poses.length >= 6 ? Container(
                      margin: const EdgeInsets.only(left: 194),
                      height: 66,
                      width: 66,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.job.poses.elementAt(5).imageUrl,
                      ),
                    ) : const SizedBox(),
                    pageState.job.poses.length >= 5 ? Container(
                      margin: const EdgeInsets.only(left: 168),
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                          color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.job.poses.elementAt(4).imageUrl,
                      ),
                    ) : const SizedBox(),
                    pageState.job.poses.length >= 4 ? Container(
                      margin: const EdgeInsets.only(left: 142),
                      height: 78,
                      width: 78,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                          color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.job.poses.elementAt(3).imageUrl,
                      ),
                    ) : const SizedBox(),
                    pageState.job.poses.length >= 3 ? Container(
                      margin: const EdgeInsets.only(left: 116),
                      height: 84,
                      width: 84,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                          color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.job.poses.elementAt(2).imageUrl,
                      ),
                    ) : const SizedBox(),
                    pageState.job.poses.length >= 2 ? Container(
                      margin: const EdgeInsets.only(left: 90),
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                          color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.job.poses.elementAt(1).imageUrl,
                      ),
                    ) : const SizedBox(),
                    pageState.job.poses.isNotEmpty ? Container(
                      margin: const EdgeInsets.only(left: 64),
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                          color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.job.poses.elementAt(0).imageUrl,
                      ),
                    ) : const SizedBox(),
                    Container(
                      height: 64,
                      margin: const EdgeInsets.only(right: 16),
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right,
                        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      ),
                    ),
                  ],
              ) : const SizedBox(),
              pageState.job.poses.isEmpty ? Container(
                margin: const EdgeInsets.only(top: 12, left: 24, right: 24),
                alignment: Alignment.center,
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Select the button below to add poses to this job.',
                  color: Color(ColorConstants.getPrimaryBlack()),
                  textAlign: TextAlign.center,
                ),
              ) : const SizedBox(),
              pageState.job.poses.isEmpty ? Container(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 32),
                    alignment: Alignment.center,
                    height: 48,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(ColorConstants.getBlueDark()),
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Select Poses',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
