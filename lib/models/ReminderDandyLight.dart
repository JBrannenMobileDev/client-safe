class ReminderDandyLight {
  int id;
  String documentId;
  String description;
  String when;
  String daysWeeksMonths;
  int amount;
  bool isDefault;
  DateTime time;

  ReminderDandyLight({
    this.id,
    this.documentId,
    this.description,
    this.when,
    this.daysWeeksMonths,
    this.amount,
    this.isDefault,
    this.time
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'description': description,
      'when' : when,
      'daysWeeksMonths' : daysWeeksMonths,
      'amount' : amount,
      'isDefault' : isDefault,
      'time' : time.toString(),
    };
  }

  static ReminderDandyLight fromMap(Map<String, dynamic> map) {
    return ReminderDandyLight(
      documentId: map['documentId'],
      description: map['description'],
      when: map['when'],
      daysWeeksMonths: map['daysWeeksMonths'],
      amount: map['amount'],
      isDefault: map['isDefault'],
      time: DateTime.parse((map['time'] != null ? map['time'] : DateTime.utc(1999).toString())),
    );
  }
}