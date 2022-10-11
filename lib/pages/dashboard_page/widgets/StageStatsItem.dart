import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../utils/styles/Styles.dart';

class StageStatsItem extends StatelessWidget{
  final List<Job> jobs;
  final JobStage stage;
  final DashboardPageState pageState;
  StageStatsItem({this.jobs, this.stage, this.pageState});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationUtil.onStageStatsSelected(context, pageState, stage.stage, stage);
      },
      child: Container(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 18.0, left: 16.0),
                  height: 28.0,
                  width: 28.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ImageUtil.getJobStageImageFromStage(stage),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  JobStage.getStageText(stage),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Text(
                    jobs.length.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8.0),
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
    );
  }
}