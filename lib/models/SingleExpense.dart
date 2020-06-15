import 'package:client_safe/models/Charge.dart';

class SingleExpense {
  int id;
  String expenseName;
  Charge charge;


  SingleExpense({
    this.id,
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