import 'package:dandylight/models/Reminder.dart';

class JobReminder {
  int id;
  String documentId;
  String jobDocumentId;
  Reminder reminder;
  DateTime exactDateAndTime;

  JobReminder({
    this.id,
    this.documentId,
    this.jobDocumentId,
    this.reminder,
    this.exactDateAndTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'jobDocumentId' : jobDocumentId,
      'reminder': reminder.toMap(),
      'exactDateAndTime' : exactDateAndTime?.millisecondsSinceEpoch ?? null,
    };
  }

  static JobReminder fromMap(Map<String, dynamic> map) {
    return JobReminder(
      documentId: map['documentId'],
      jobDocumentId: map['jobDocumentId'],
      reminder: Reminder.fromMap(map['priceProfile']),
      exactDateAndTime: map['exactDateAndTime'] != null? DateTime.fromMillisecondsSinceEpoch(map['exactDateAndTime']) : null,
    );
  }
}