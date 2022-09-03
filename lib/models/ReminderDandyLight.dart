class ReminderDandyLight {
  int id;
  String documentId;
  String description;
  String when;
  String daysWeeksMonths;
  int amount;
  DateTime time;


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderDandyLight &&
          runtimeType == other.runtimeType &&
          documentId == other.documentId &&
          description == other.description &&
          when == other.when &&
          daysWeeksMonths == other.daysWeeksMonths &&
          amount == other.amount &&
          time == other.time;

  @override
  int get hashCode =>
      documentId.hashCode ^
      description.hashCode ^
      when.hashCode ^
      daysWeeksMonths.hashCode ^
      amount.hashCode ^
      time.hashCode;

  ReminderDandyLight({
    this.id,
    this.documentId,
    this.description,
    this.when,
    this.daysWeeksMonths,
    this.amount,
    this.time
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'description': description,
      'when' : when,
      'daysWeeksMonths' : daysWeeksMonths,
      'amount' : amount,
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
      // createdDate: map['createdDate'] != "" ? DateTime.parse(map['createdDate']) : null,
      time: DateTime.parse(map['time'] != null ? map['time'] : DateTime.utc(1999).toString()),
    );
  }
}