import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JobInProgressItem extends StatelessWidget{
  final Job job;
  final DashboardPageState pageState;
  JobInProgressItem({this.job, this.pageState});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () =>
      {
        pageState.onJobClicked(job),
        NavigationUtil.onClientTapped(context),
      },
      child: Padding(
      padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 18.0),
      child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 18.0, top: 4.0),
                  height: 38.0,
                  width: 38.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: job.stage.getStageImage(),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.0, top: 4.0),
                        child: Text(
                          job.jobTitle,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Text(
                        'Stage: ' + JobStage.getStageTextFromValue(JobStage.getStageValue(job.stage.stage)),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                      Text(
                        (job.selectedDate != null ? DateFormat('EEE, MMM d').format(job.selectedDate) : '') + ' · ' + (job.selectedTime != null ? DateFormat('h:mm a').format(job.selectedTime) : ''),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
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