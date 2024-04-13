import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/widgets.dart';

class EventDandyLight{
  DateTime? selectedDate;
  DateTime? selectedTime;
  DateTime? start;
  DateTime? end;
  bool? isPersonalEvent;
  String? eventTitle;
  AssetImage? icon;
  String? nextStageText;
  String? jobDocumentId;


  EventDandyLight({
    this.selectedDate, this.selectedTime, this.start, this.end, this.isPersonalEvent,
    this.eventTitle, this.icon, this.nextStageText, this.jobDocumentId
  });

  static EventDandyLight fromJob(Job job) {
    return EventDandyLight(
      selectedDate: job.selectedDate,
      selectedTime: job.selectedTime,
      isPersonalEvent: false,
      eventTitle: job.jobTitle,
      icon: job.stage!.getNextStageImage(),
      nextStageText: 'Stage: ' + JobStage.getStageText(job.stage!),
      jobDocumentId: job.documentId,
    );
  }

  static EventDandyLight fromDeviceEvent(Event event) {
    return EventDandyLight(
      selectedDate: event.start,
      selectedTime: event.start,
      start: event.start,
      end: event.end,
      isPersonalEvent: true,
      eventTitle: event.title,
      icon: AssetImage('assets/images/icons/calendar_bold_white.png'),
      nextStageText: '',
      jobDocumentId: '',
    );
  }
}