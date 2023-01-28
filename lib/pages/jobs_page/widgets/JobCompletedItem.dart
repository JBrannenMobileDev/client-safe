import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/jobs_page/JobsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../utils/styles/Styles.dart';
import '../../../widgets/TextDandyLight.dart';

class JobCompletedItem extends StatelessWidget{
  final Job job;
  final JobsPageState pageState;
  JobCompletedItem({this.job, this.pageState});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Styles.getButtonStyle(),
      onPressed: () {
        pageState.onJobClicked(job);
        NavigationUtil.onJobTapped(context);
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 16.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 18.0, top: 0.0),
                  height: 42.0,
                  width: 42.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: job.stage.getNextStageImage(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: job.jobTitle,
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      text: NumberFormat.simpleCurrency(name: 'USD', decimalDigits: 0).format(job.getJobCost()),
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 24.0),
              child: Icon(
                Icons.chevron_right,
                color: Color(ColorConstants.getPrimaryBackgroundGrey()),
              ),
            )
          ],
        ),
      ),
    );
  }
}