import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPage.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class LeadItem extends StatelessWidget{
  final Job job;
  LeadItem({this.job});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => NavigationUtil.onClientTapped(context),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
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
                      child: Text(
                        job.clientName,
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
                      'Next: ' + JobStage.getNextStageNameStatic(JobStage.getStageValue(job.stage.stage)),
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
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 8.0),
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