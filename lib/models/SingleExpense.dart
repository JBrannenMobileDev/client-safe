import 'package:dandylight/models/Charge.dart';

class SingleExpense {
  int id;
  String documentId;
  String expenseName;
  Charge charge;


  SingleExpense({
    this.id,
    this.documentId,
    this.expenseName,
    this.charge
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'expenseName': expenseName,
      'charge' : charge.toMap(),
    };
  }

  static SingleExpense fromMap(Map<String, dynamic> map) {
    return SingleExpense(
      id: map['id'],
      expenseName: map['expenseName'],
      charge: Charge.fromMap(map['charge']),
    );
  }
}