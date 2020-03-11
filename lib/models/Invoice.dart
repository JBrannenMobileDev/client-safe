import 'package:client_safe/models/PriceProfile.dart';

class Invoice {
  static const String RATE_TYPE_FLAT_RATE = "Flat rate";
  static const String RATE_TYPE_HOURLY = "Hourly";
  static const String RATE_TYPE_QUANTITY = "Quantity";
  static const String DISCOUNT_TYPE_FIXED_AMOUNT = "Fixed amount";
  static const String DISCOUNT_TYPE_PERCENTAGE = "Percentage";

  int id;
  int clientId;
  int invoiceId;
  String clientName;
  DateTime createdDate;
  DateTime sentDate;
  bool depositPaid;
  bool totalPaid;
  PriceProfile priceProfile;
  double discount;
  double total;
  String unitType;
  double rate;
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
    this.discount,
    this.total,
    this.unitType,
    this.rate,
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
      'discount': discount,
      'total': total,
      'unitType': unitType,
      'rate' : rate,
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
      discount: map['discount'],
      total: map['total'],
      unitType: map['unitType'],
      rate: map['rate'],
      quantity: map['quantity'],
      amountDueBeforeSession: map['amountDueBeforeSession'],
      amountDueAfterSession: map['amountDueAfterSession'],
      dueBeforeDate: map['dueBeforeDate'],
      dueAfterDate: map['dueAfterDate'],
    );
  }
}