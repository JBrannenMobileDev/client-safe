import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';
import 'package:device_calendar/device_calendar.dart' as deviceEvent;


class Event{
  DateTime selectedDate;
  DateTime selectedTime;
  bool isPersonalEvent;
  String eventTitle;
  AssetImage icon;
  String nextStageText;


  Event({
    this.selectedDate, this.selectedTime, this.isPersonalEvent,
    this.eventTitle, this.icon, this.nextStageText
  });

  static Event fromJob(Job job) {
    return Event(
      selectedDate: job.selectedDate,
      selectedTime: job.selectedTime,
      isPersonalEvent: false,
      eventTitle: job.jobTitle,
      icon: job.stage.getNextStageImage(),
      nextStageText: 'Next: ' + JobStage.getNextStageNameStatic(JobStage.getStageValue(job.stage.stage)),
    );
  }

  static Event fromDeviceEvent(deviceEvent.Event deviceEvent) {
    return Event(
      selectedTime: deviceEvent.start,
      selectedDate: deviceEvent.start,
      isPersonalEvent: true,
      eventTitle: deviceEvent.title,
      icon: ImageUtil.getDeviceEventAssetImage(),
    );
  }
}