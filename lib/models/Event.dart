import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';

class Event{
  DateTime selectedDate;
  DateTime selectedTime;
  bool isPersonalEvent;
  String eventTitle;
  AssetImage icon;
  String nextStageText;
  int jobId;


  Event({
    this.selectedDate, this.selectedTime, this.isPersonalEvent,
    this.eventTitle, this.icon, this.nextStageText, this.jobId
  });

  static Event fromJob(Job job) {
    return Event(
      selectedDate: job.selectedDate,
      selectedTime: job.selectedTime,
      isPersonalEvent: false,
      eventTitle: job.jobTitle,
      icon: job.stage.getNextStageImage(),
      nextStageText: 'Next: ' + JobStage.getNextStageNameStatic(JobStage.getStageValue(job.stage.stage)),
      jobId: job.id,
    );
  }
}