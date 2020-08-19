class Reminder {
  int id;
  String documentId;
  String description;
  String when;
  String daysWeeksMonths;
  int amount;

  Reminder({
    this.id,
    this.documentId,
    this.description,
    this.when,
    this.daysWeeksMonths,
    this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'description': description,
      'when' : when,
      'daysWeeksMonths' : daysWeeksMonths,
      'amount' : amount,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      documentId: map['documentId'],
      description: map['description'],
      when: map['when'],
      daysWeeksMonths: map['daysWeeksMonths'],
      amount: map['amount'],
    );
  }
}