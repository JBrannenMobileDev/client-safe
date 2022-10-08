import '../pages/new_reminder_page/WhenSelectionWidget.dart';

class ReminderDandyLight {
  int id;
  String documentId;
  String description;
  String when;
  String daysWeeksMonths;
  int amount;
  DateTime time;

  Future<DateTime> getTriggerTime(Future<DateTime> jobDateFuture) async {
    DateTime jobDate = await jobDateFuture;
    if(jobDate == null) return null;
    DateTime triggerDateTime;
    switch(when) {
      case WhenSelectionWidget.ON:
        triggerDateTime = DateTime(jobDate.year, jobDate.month, jobDate.day, time.hour, time.minute);
        break;
      case WhenSelectionWidget.BEFORE:
        triggerDateTime = DateTime(jobDate.year, jobDate.month, jobDate.day, time.hour, time.minute);
        switch(daysWeeksMonths) {
          case WhenSelectionWidget.DAYS:
            triggerDateTime = triggerDateTime.subtract(Duration(days: amount));
            break;
          case WhenSelectionWidget.MONTHS:
            triggerDateTime = DateTime(triggerDateTime.year, triggerDateTime.month - amount, triggerDateTime.day, triggerDateTime.hour, triggerDateTime.minute);
            break;
          case WhenSelectionWidget.WEEKS:
            triggerDateTime = triggerDateTime.subtract(Duration(days: (amount*7)));
            break;
        }
        break;
      case WhenSelectionWidget.AFTER:
        triggerDateTime = DateTime(jobDate.year, jobDate.month, jobDate.day, time.hour, time.minute);
        switch(daysWeeksMonths) {
          case WhenSelectionWidget.DAYS:
            triggerDateTime = triggerDateTime.add(Duration(days: amount));
            break;
          case WhenSelectionWidget.MONTHS:
            triggerDateTime = DateTime(triggerDateTime.year, triggerDateTime.month + amount, triggerDateTime.day, triggerDateTime.hour, triggerDateTime.minute);
            break;
          case WhenSelectionWidget.WEEKS:
            triggerDateTime = triggerDateTime.add(Duration(days: (amount*7)));
            break;
        }
        break;
    }
    return triggerDateTime;
  }

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