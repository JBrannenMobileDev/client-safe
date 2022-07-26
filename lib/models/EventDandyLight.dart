import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';

class EventDandyLight{
  DateTime selectedDate;
  DateTime selectedTime;
  bool isPersonalEvent;
  String eventTitle;
  AssetImage icon;
  String nextStageText;
  String jobDocumentId;


  EventDandyLight({
    this.selectedDate, this.selectedTime, this.isPersonalEvent,
    this.eventTitle, this.icon, this.nextStageText, this.jobDocumentId
  });

  static EventDandyLight fromJob(Job job) {
    return EventDandyLight(
      selectedDate: job.selectedDate,
      selectedTime: job.selectedTime,
      isPersonalEvent: false,
      eventTitle: job.jobTitle,
      icon: job.stage.getNextStageImage(),
      nextStageText: 'Next: ' + JobStage.getNextStageNameStatic(JobStage.getStageValue(job.stage.stage)),
      jobDocumentId: job.documentId,
    );
  }
}