import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';

class JobReminder {
  static const int MILEAGE_EXPENSE = 100;
  static const String MILEAGE_EXPENSE_ID = 'mileage_expense';

  int id;
  String documentId;
  String jobDocumentId;
  String payload;
  DateTime triggerTime;//this is not persisted. It is only calculated when needed in NotificationHelper. Otherwise it will be null.
  ReminderDandyLight reminder;
  bool hasBeenSeen;

  JobReminder({
    this.id,
    this.documentId,
    this.jobDocumentId,
    this.reminder,
    this.hasBeenSeen,
    this.payload,
  });

  Future<DateTime> getJobDate() async {
    return (await JobDao.getJobById(jobDocumentId))?.selectedDate;
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'jobDocumentId' : jobDocumentId,
      'reminder': reminder.toMap(),
      'hasBeenSeen' : hasBeenSeen,
      'payload' : payload,
    };
  }

  static JobReminder fromMap(Map<String, dynamic> map) {
    return JobReminder(
      documentId: map['documentId'],
      jobDocumentId: map['jobDocumentId'],
      reminder: ReminderDandyLight.fromMap(map['reminder']),
      hasBeenSeen: map['hasBeenSeen'],
      payload: map['payload'],
    );
  }
}