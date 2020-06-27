import 'package:dandylight/models/Charge.dart';

class SingleExpense {
  String documentId;
  String expenseName;
  Charge charge;


  SingleExpense({
    this.documentId,
    this.expenseName,
    this.charge
  });

  Map<String, dynamic> toMap() {
    return {
      'expenseName': expenseName,
      'charge' : charge.toMap(),
    };
  }

  static SingleExpense fromMap(Map<String, dynamic> map, String documentId) {
    return SingleExpense(
      documentId: documentId,
      expenseName: map['expenseName'],
      charge: Charge.fromMap(map['charge']),
    );
  }
}