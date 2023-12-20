import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/TextDandyLight.dart';

class StageStatsItem extends StatelessWidget{
  final List<Job> jobs;
  final JobStage stage;
  final DashboardPageState pageState;
  const StageStatsItem({Key key, this.jobs, this.stage, this.pageState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(right: 18.0, left: 16.0),
                  height: 28.0,
                  width: 28.0,
                  child: ImageUtil.getJobStageImageFromStage(stage, true),
                ),
                TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: JobStage.getStageText(stage),
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
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: jobs.length.toString(),
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
    );
  }
}