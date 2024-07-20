import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';

class SessionType {
  int? id;
  String? documentId;
  String title;
  double totalCost;
  int durationMinutes;
  int durationHours;
  DateTime createdDate;
  List<JobStage> stages;
  List<ReminderDandyLight> reminders;
  double deposit;
  double salesTaxPercent;

  double getTotalPlusTax() {
    double taxAmount = salesTaxPercent > 0 ? (totalCost * (salesTaxPercent/100)) : 0.0;
    return totalCost + taxAmount;
  }

  SessionType({
    this.id,
    this.documentId,
    required this.title,
    required this.totalCost,
    required this.createdDate,
    required this.stages,
    required this.reminders,
    required this.deposit,
    required this.salesTaxPercent,
    required this.durationMinutes,
    required this.durationHours,
  });

  SessionType copyWith({
    int? id,
    String? documentId,
    required String title,
    required double totalCost,
    required DateTime createdDate,
    required List<JobStage> stages,
    required List<ReminderDandyLight> reminders,
    required double deposit,
    required bool includeSalesTax,
    required double salesTaxPercent,
    required int durationMinutes,
    required int durationHours,
}){
    return SessionType(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      title: title,
      totalCost: totalCost,
      createdDate: createdDate,
      stages: stages,
      reminders: reminders,
      deposit: deposit,
      salesTaxPercent: salesTaxPercent,
      durationMinutes: durationMinutes,
      durationHours: durationHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'title' : title,
      'createdDate' : createdDate.toString(),
      'totalCost' : totalCost,
      'stages' : convertStagesToMap(stages),
      'reminders' : convertRemindersToMap(reminders),
      'deposit' : deposit,
      'salesTaxPercent' : salesTaxPercent,
      'durationMinutes' : durationMinutes,
      'durationHours' : durationHours,
    };
  }

  static SessionType fromMap(Map<String, dynamic> map) {
    return SessionType(
      documentId: map['documentId'],
      title: map['title'],
      createdDate: DateTime.parse(map['createdDate']),
      totalCost: map['totalCost'],
      stages: convertMapsToJobStages(map['stages']),
      reminders: convertMapsToReminders(map['reminders']),
      deposit: map['deposit'],
      salesTaxPercent: map['salesTaxPercent'],
      durationHours: map['durationHours'],
      durationMinutes: map['durationMinutes'],
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
      listOfJobStages.add(JobStage.fromMap(map as Map<String, dynamic>));
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
      listOfReminders.add(ReminderDandyLight.fromMap(map as Map<String, dynamic>));
    }
    return listOfReminders;
  }
}