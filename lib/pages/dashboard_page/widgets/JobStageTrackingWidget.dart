import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/jobs_page/widgets/JobStageAssetImage.dart';
import 'package:flutter/widgets.dart';

class JobStageTrackingWidget extends StatelessWidget{
  final List<String> completedStages;
  final String currentStage;

  JobStageTrackingWidget(this.currentStage, this.completedStages);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(64.0, 8.0, 0.0, 24.0),
        height: 38.0,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              JobStateAssetImage(Job.JOB_STAGE_INQUIRY,
                  0 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_INQUIRY) ? true : false,
                  Job.JOB_STAGE_INQUIRY == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_FOLLOW_UP,
                  1 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_FOLLOW_UP) ? true : false,
                  Job.JOB_STAGE_FOLLOW_UP == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_SEND_PROPOSAL,
                  2 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_SEND_PROPOSAL) ? true : false,
                  Job.JOB_STAGE_SEND_PROPOSAL == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_SIGN_PROPOSAL,
                  3 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_SIGN_PROPOSAL) ? true : false,
                  Job.JOB_STAGE_SIGN_PROPOSAL == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_PLANNING,
                  4 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_PLANNING) ? true : false,
                  Job.JOB_STAGE_PLANNING == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_EDITING,
                  5 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_EDITING) ? true : false,
                  Job.JOB_STAGE_EDITING == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_SEND_GALLERY,
                  6 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_SEND_GALLERY) ? true : false,
                  Job.JOB_STAGE_SEND_GALLERY == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_COLLECT_PAYMENT,
                  7 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_COLLECT_PAYMENT) ? true : false,
                  Job.JOB_STAGE_COLLECT_PAYMENT == currentStage ? true : false),
              JobStateAssetImage(Job.JOB_STAGE_GET_FEEDBACK,
                  8 <= Job.getJobStagePosition(currentStage) ? true : false,
                  completedStages.contains(Job.JOB_STAGE_GET_FEEDBACK) ? true : false,
                  Job.JOB_STAGE_GET_FEEDBACK == currentStage ? true : false),
            ],
          ),
        ),
    );
  }
}