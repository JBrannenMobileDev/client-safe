import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/models/PriceProfile.dart';

class Invoice {
  static const String RATE_TYPE_FLAT_RATE = "Flat rate";
  static const String RATE_TYPE_HOURLY = "Hourly";
  static const String RATE_TYPE_QUANTITY = "Quantity"; // needs to be removed
  static const String DISCOUNT_TYPE_FIXED_AMOUNT = "Fixed amount";
  static const String DISCOUNT_TYPE_PERCENTAGE = "Percentage";

  int? id;
  String? documentId;
  String? clientDocumentId;
  int? invoiceId;
  String? jobDocumentId;
  String? clientName;
  String? jobName;
  DateTime? createdDate;
  DateTime? sentDate;
  DateTime? dueDate;
  DateTime? depositDueDate;
  bool? depositPaid;
  bool? invoicePaid;
  PriceProfile? priceProfile;
  double? discount;
  double? subtotal;
  double? total;
  double? unpaidAmount;
  double? balancePaidAmount;
  double? depositAmount;
  double? salesTaxAmount;
  double? salesTaxRate;
  List<LineItem>? lineItems;

  Invoice({
    this.id,
    this.documentId,
    this.clientDocumentId,
    this.invoiceId,
    this.jobDocumentId,
    this.clientName,
    this.jobName,
    this.createdDate,
    this.sentDate,
    this.depositPaid,
    this.invoicePaid,
    this.priceProfile,
    this.discount,
    this.total,
    this.unpaidAmount,
    this.lineItems,
    this.dueDate,
    this.depositAmount,
    this.salesTaxAmount,
    this.salesTaxRate,
    this.depositDueDate,
    this.subtotal,
    this.balancePaidAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'clientDocumentId': clientDocumentId,
      'invoiceId': invoiceId,
      'clientName': clientName,
      'jobName' :jobName,
      'jobDocumentId' : jobDocumentId,
      'createdDate': createdDate?.millisecondsSinceEpoch ?? null,
      'sentDate': sentDate?.millisecondsSinceEpoch ?? null,
      'dueDate' : dueDate?.millisecondsSinceEpoch ?? null,
      'depositPaid': depositPaid,
      'invoicePaid': invoicePaid,
      'priceProfile': priceProfile!.toMap(),
      'discount': discount,
      'total': total,
      'subtotal' : subtotal,
      'balancePaidAmount' : balancePaidAmount,
      'unpaidAmount' : unpaidAmount,
      'lineItems' : convertLineItemsToMaps(lineItems),
      'depositAmount' : depositAmount,
      'salesTaxAmount' : salesTaxAmount,
      'salesTaxRate' : salesTaxRate,
      'depositDueDate' : depositDueDate?.millisecondsSinceEpoch ?? null,
    };
  }

  static Invoice fromMap(Map<String, dynamic> map) {
    return Invoice(
      documentId: map['documentId'],
      clientDocumentId: map['clientDocumentId'],
      invoiceId: map['invoiceId'],
      clientName: map['clientName'],
      jobName: map['jobName'],
      jobDocumentId: map['jobDocumentId'],
      depositDueDate: map['depositDueDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['depositDueDate']) : null,
      createdDate: map['createdDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['createdDate']) : null,
      sentDate: map['sentDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['sentDate']) : null,
      dueDate: map['dueDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) : map['createdDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['createdDate']) : null,
      depositPaid: map['depositPaid'],
      invoicePaid: map['invoicePaid'],
      priceProfile: PriceProfile.fromMap(map['priceProfile']),
      discount: map['discount']?.toDouble(),
      total: map['total']?.toDouble(),
      subtotal: map['subtotal']?.toDouble(),
      balancePaidAmount: map['balancePaidAmount']?.toDouble(),
      unpaidAmount: map['unpaidAmount']?.toDouble(),
      lineItems: convertMapsToLineItems(map['lineItems']),
      depositAmount: map['depositAmount']?.toDouble(),
      salesTaxAmount: map['salesTaxAmount']?.toDouble(),
      salesTaxRate: map['salesTaxRate']?.toDouble(),
    );
  }

  List<Map<String, dynamic>> convertLineItemsToMaps(List<LineItem>? lineItems){
    List<Map<String, dynamic>> listOfMaps = [];
    for(LineItem lineItem in lineItems!){
      listOfMaps.add(lineItem.toMap());
    }
    return listOfMaps;
  }

  static List<LineItem> convertMapsToLineItems(List listOfMaps){
    List<LineItem> listOfLineItems = [];
    for(Map map in listOfMaps){
      listOfLineItems.add(LineItem.fromMap(map as Map<String, dynamic>));
    }
    return listOfLineItems;
  }

  bool isOverdue() {
    DateTime now = DateTime.now();
    if(dueDate != null && now.isAfter(dueDate!) && invoicePaid!) return true;
    return false;
  }

  double calculateUnpaidAmount() {
    if(!invoicePaid!) {
      double result = subtotal! - discount!;
      double tax = result * (salesTaxRate!/100);
      result = result + tax;
      if(depositPaid!) {
        result = result - depositAmount!;
      }
      return result;
    }
    return 0;
  }
}