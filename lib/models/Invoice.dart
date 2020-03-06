import 'package:client_safe/models/PriceProfile.dart';

class Invoice {
  int id;
  int clientId;
  int invoiceId;
  String clientName;
  DateTime createdDate;
  DateTime sentDate;
  bool depositPaid;
  bool totalPaid;
  PriceProfile priceProfile;
  double subtotal;
  double discount;
  double total;
  String unitType;
  int quantity;
  double amountDueBeforeSession;
  double amountDueAfterSession;
  DateTime dueBeforeDate;
  DateTime dueAfterDate;

  Invoice({
    this.id,
    this.clientId,
    this.invoiceId,
    this.clientName,
    this.createdDate,
    this.sentDate,
    this.depositPaid,
    this.totalPaid,
    this.priceProfile,
    this.subtotal,
    this.discount,
    this.total,
    this.unitType,
    this.quantity,
    this.amountDueBeforeSession,
    this.amountDueAfterSession,
    this.dueBeforeDate,
    this.dueAfterDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'clientId': clientId,
      'invoiceId': invoiceId,
      'clientName': clientName,
      'createdDate': createdDate,
      'sentDate': sentDate,
      'depositPaid': depositPaid,
      'totalPaid': totalPaid,
      'priceProfile': priceProfile,
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'unitType': unitType,
      'quantity': quantity,
      'amountDueBeforeSession': amountDueBeforeSession,
      'amountDueAfterSession': amountDueAfterSession,
      'dueBeforeDate': dueBeforeDate,
      'dueAfterDate': dueAfterDate,
    };
  }

  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      clientId: map['clientId'],
      invoiceId: map['invoiceId'],
      clientName: map['clientName'],
      createdDate: map['createdDate'],
      sentDate: map['sentDate'],
      depositPaid: map['depositPaid'],
      totalPaid: map['totalPaid'],
      priceProfile: map['priceProfile'],
      subtotal: map['subtotal'],
      discount: map['discount'],
      total: map['total'],
      unitType: map['unitType'],
      quantity: map['quantity'],
      amountDueBeforeSession: map['amountDueBeforeSession'],
      amountDueAfterSession: map['amountDueAfterSession'],
      dueBeforeDate: map['dueBeforeDate'],
      dueAfterDate: map['dueAfterDate'],
    );
  }
}