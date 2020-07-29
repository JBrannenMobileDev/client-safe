class Reminder {
  int id;
  String documentId;
  String description;
  String when;
  int amount;

  Reminder({
    this.id,
    this.documentId,
    this.description,
    this.when,
    this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'description': description,
      'when' : when,
      'amount' : amount,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map) {
    return Reminder(
      documentId: map['documentId'],
      description: map['description'],
      when: map['when'],
      amount: map['amount'],
    );
  }
}