class Reminder {
  int id;
  String documentId;
  Reminder reminder;
  DateTime exactDateAndTime;

  Reminder({
    this.id,
    this.documentId,
    this.reminder,
    this.exactDateAndTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'reminder': reminder,
      'exactDateAndTime' : exactDateAndTime,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      documentId: map['documentId'],
      reminder: map['description'], //TODO update to map to reminder object
      exactDateAndTime: map['exactDateAndTime'], //TODO map to milliseconds
    );
  }
}