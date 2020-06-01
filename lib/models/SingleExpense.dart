class SingleExpense {
  int id;
  String expenseName;
  double cost;
  DateTime chargeDate;


  SingleExpense({
    this.id,
    this.expenseName,
    this.cost,
    this.chargeDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'expenseName': expenseName,
      'cost' : cost,
      'chargeDate' : chargeDate?.millisecondsSinceEpoch ?? null,
    };
  }

  static SingleExpense fromMap(Map<String, dynamic> map) {
    return SingleExpense(
      id: map['id'],
      expenseName: map['expenseName'],
      cost: map['cost'],
      chargeDate: map['chargeDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['chargeDate']) : null,
    );
  }
}