import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';

class JobReminder {
  int id;
  String documentId;
  String jobDocumentId;
  DateTime triggerTime;//this is not persisted. It is only calculated when needed in NotificationHelper. Otherwise it will be null.
  ReminderDandyLight reminder;
  bool hasBeenSeen = false;

  JobReminder({
    this.id,
    this.documentId,
    this.jobDocumentId,
    this.reminder,
    this.hasBeenSeen,
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
    };
  }

  static JobReminder fromMap(Map<String, dynamic> map) {
    return JobReminder(
      documentId: map['documentId'],
      jobDocumentId: map['jobDocumentId'],
      reminder: ReminderDandyLight.fromMap(map['reminder']),
      hasBeenSeen: map['hasBeenSeen'],
    );
  }
}