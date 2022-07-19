import 'package:dandylight/models/Reminder.dart';

class JobReminder {
  int id;
  String documentId;
  String jobDocumentId;
  Reminder reminder;

  JobReminder({
    this.id,
    this.documentId,
    this.jobDocumentId,
    this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'jobDocumentId' : jobDocumentId,
      'reminder': reminder.toMap(),
    };
  }

  static JobReminder fromMap(Map<String, dynamic> map) {
    return JobReminder(
      documentId: map['documentId'],
      jobDocumentId: map['jobDocumentId'],
      reminder: Reminder.fromMap(map['reminder']),
    );
  }
}