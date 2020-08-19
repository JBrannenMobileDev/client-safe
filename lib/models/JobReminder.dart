import 'package:dandylight/models/Reminder.dart';

class JobReminder {
  int id;
  String documentId;
  Reminder reminder;
  DateTime exactDateAndTime;

  JobReminder({
    this.id,
    this.documentId,
    this.reminder,
    this.exactDateAndTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'reminder': reminder.toMap(),
      'exactDateAndTime' : exactDateAndTime?.millisecondsSinceEpoch ?? null,
    };
  }

  static JobReminder fromMap(Map<String, dynamic> map) {
    return JobReminder(
      documentId: map['documentId'],
      reminder: Reminder.fromMap(map['priceProfile']),
      exactDateAndTime: map['exactDateAndTime'] != null? DateTime.fromMillisecondsSinceEpoch(map['exactDateAndTime']) : null,
    );
  }
}