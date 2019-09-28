import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/jobs_page/widgets/JobStageAssetImage.dart';
import 'package:flutter/widgets.dart';

class JobStageTrackingWidget extends StatelessWidget {
  final List<String> completedStages;
  final String currentStage;

  JobStageTrackingWidget(this.currentStage, this.completedStages);

  @override
  Widget build(BuildContext context) {
    int currentStagePosition = Job.getJobStagePosition(currentStage);
    double offset = currentStagePosition > 2 ? currentStagePosition.toDouble() - 1.0 : 0.0;
    ScrollController _scrollController = new ScrollController(initialScrollOffset: offset*48);
    return Container(
      width: 240.0,
      margin: EdgeInsets.fromLTRB(50.0, 12.0, 24.0, 16.0),
      height: 38.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: <Widget>[
          JobStateAssetImage(
              Job.JOB_STAGE_INQUIRY,
              0 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_INQUIRY) ? true : false,
              Job.JOB_STAGE_INQUIRY == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_FOLLOW_UP,
              1 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_FOLLOW_UP) ? true : false,
              Job.JOB_STAGE_FOLLOW_UP == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_SEND_PROPOSAL,
              2 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_SEND_PROPOSAL)
                  ? true
                  : false,
              Job.JOB_STAGE_SEND_PROPOSAL == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_SIGN_PROPOSAL,
              3 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_SIGN_PROPOSAL)
                  ? true
                  : false,
              Job.JOB_STAGE_SIGN_PROPOSAL == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_PLANNING,
              4 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_PLANNING) ? true : false,
              Job.JOB_STAGE_PLANNING == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_EDITING,
              5 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_EDITING) ? true : false,
              Job.JOB_STAGE_EDITING == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_SEND_GALLERY,
              6 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_SEND_GALLERY)
                  ? true
                  : false,
              Job.JOB_STAGE_SEND_GALLERY == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_COLLECT_PAYMENT,
              7 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_COLLECT_PAYMENT)
                  ? true
                  : false,
              Job.JOB_STAGE_COLLECT_PAYMENT == currentStage ? true : false),
          JobStateAssetImage(
              Job.JOB_STAGE_GET_FEEDBACK,
              8 <= currentStagePosition ? true : false,
              completedStages.contains(Job.JOB_STAGE_GET_FEEDBACK)
                  ? true
                  : false,
              Job.JOB_STAGE_GET_FEEDBACK == currentStage ? true : false),
        ],
      ),
    );
  }
}
