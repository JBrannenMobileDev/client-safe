import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/models/PriceProfile.dart';

class Invoice {
  static const String RATE_TYPE_FLAT_RATE = "Flat rate";
  static const String RATE_TYPE_HOURLY = "Hourly";
  static const String RATE_TYPE_QUANTITY = "Quantity"; // needs to be removed
  static const String DISCOUNT_TYPE_FIXED_AMOUNT = "Fixed amount";
  static const String DISCOUNT_TYPE_PERCENTAGE = "Percentage";

  int id;
  String documentId;
  String clientDocumentId;
  int invoiceId;
  String jobDocumentId;
  String clientName;
  String jobName;
  DateTime createdDate;
  DateTime sentDate;
  DateTime dueDate;
  bool depositPaid;
  bool invoicePaid;
  PriceProfile priceProfile;
  double discount;
  double total;
  double unpaidAmount;
  double depositAmount;
  List<LineItem> lineItems;

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
      'priceProfile': priceProfile.toMap(),
      'discount': discount,
      'total': total,
      'unpaidAmount' : unpaidAmount,
      'lineItems' : convertLineItemsToMaps(lineItems),
      'depositAmount' : depositAmount,
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
      createdDate: map['createdDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['createdDate']) : null,
      sentDate: map['sentDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['sentDate']) : null,
      dueDate: map['dueDate'] != null? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) : null,
      depositPaid: map['depositPaid'],
      invoicePaid: map['invoicePaid'],
      priceProfile: PriceProfile.fromMap(map['priceProfile']),
      discount: map['discount'],
      total: map['total'],
      unpaidAmount: map['unpaidAmount'],
      lineItems: convertMapsToLineItems(map['lineItems']),
      depositAmount: map['depositAmount'],
    );
  }

  List<Map<String, dynamic>> convertLineItemsToMaps(List<LineItem> lineItems){
    List<Map<String, dynamic>> listOfMaps = List();
    for(LineItem lineItem in lineItems){
      listOfMaps.add(lineItem.toMap());
    }
    return listOfMaps;
  }

  static List<LineItem> convertMapsToLineItems(List listOfMaps){
    List<LineItem> listOfLineItems = List();
    for(Map map in listOfMaps){
      listOfLineItems.add(LineItem.fromMap(map));
    }
    return listOfLineItems;
  }

  bool isOverdue() {
    DateTime now = DateTime.now();
    if(dueDate != null && now.isAfter(dueDate)) return true;
    return false;
  }
}