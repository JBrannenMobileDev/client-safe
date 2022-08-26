import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';

class JobType {
  int id;
  String documentId;
  String title;
  int flatRate;
  DateTime createdDate;
  List<JobStage> stages;
  List<ReminderDandyLight> reminders;

  JobType({
    this.id,
    this.documentId,
    this.title,
    this.flatRate,
    this.createdDate,
    this.stages,
    this.reminders,
  });

  JobType copyWith({
    int id,
    String documentId,
    String title,
    int flatRate,
    DateTime createdDate,
    List<JobStage> stages,
    List<ReminderDandyLight> reminders,
  }){
    return JobType(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      flatRate: flatRate ?? this.flatRate,
      createdDate: createdDate ?? this.createdDate,
      stages: stages ?? this.stages,
      reminders: reminders ?? this.reminders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'title' : title,
      'createdDate' : createdDate?.toString() ?? "",
      'flatRate' : flatRate,
      'stages' : convertStagesToMap(stages),
      'reminders' : convertRemindersToMap(reminders),
    };
  }

  static JobType fromMap(Map<String, dynamic> map) {
    return JobType(
      documentId: map['documentId'],
      title: map['title'],
      createdDate: map['createdDate'],
      flatRate: map['flatRate'],
      stages: convertMapsToJobStages(map['stages']),
      reminders: convertMapsToReminders(map['reminders']),
    );
  }

  List<Map<String, dynamic>> convertStagesToMap(List<JobStage> Stages){
    List<Map<String, dynamic>> listOfMaps = [];
    for(JobStage jobStage in stages){
      listOfMaps.add(jobStage.toMap());
    }
    return listOfMaps;
  }

  static List<JobStage> convertMapsToJobStages(List listOfMaps){
    List<JobStage> listOfJobStages = [];
    for(Map map in listOfMaps){
      listOfJobStages.add(JobStage.fromMap(map));
    }
    return listOfJobStages;
  }

  List<Map<String, dynamic>> convertRemindersToMap(List<ReminderDandyLight> reminders){
    List<Map<String, dynamic>> listOfMaps = [];
    for(ReminderDandyLight reminder in reminders){
      listOfMaps.add(reminder.toMap());
    }
    return listOfMaps;
  }

  static List<ReminderDandyLight> convertMapsToReminders(List reminders){
    List<ReminderDandyLight> listOfReminders = [];
    for(Map map in reminders){
      listOfReminders.add(ReminderDandyLight.fromMap(map));
    }
    return listOfReminders;
  }
}