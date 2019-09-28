import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/dashboard_page/widgets/JobStageTrackingWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class JobListItem extends StatelessWidget{
  final Job job;
  JobListItem({this.job});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 18.0, top: 4.0),
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageUtil.getRandomJobIcon(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        job.jobTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Text(
                      job.clientName + " • " + job.getJobType(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w400,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    Text(
                      DateFormat("EEEE, LLLL dd").format(job.dateTime),
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
          JobStageTrackingWidget(Job.JOB_STAGE_SIGN_PROPOSAL, [Job.JOB_STAGE_INQUIRY, Job.JOB_STAGE_FOLLOW_UP, Job.JOB_STAGE_SEND_PROPOSAL]),
        ],
      ),
    );
  }
}