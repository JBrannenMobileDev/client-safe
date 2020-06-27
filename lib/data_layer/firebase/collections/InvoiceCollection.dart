import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/utils/UidUtil.dart';

class InvoiceCollection {
  Future<void> createInvoice(Invoice invoice) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .add(invoice.toMap());
  }

  void deleteInvoice(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('invoices')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Invoice> getInvoice(String documentId) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .document(documentId)
        .get()
        .then((invoice) => Invoice.fromMap(invoice.data, invoice.documentID));
  }

  Future<List<Invoice>> getAllInvoicesSortedByDate(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .getDocuments()
        .then((invoices) => _buildInvoicesList(invoices));
  }

  void replaceInvoice(Invoice invoice) {
    final databaseReference = Firestore.instance;
    databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .document(invoice.documentId)
        .setData(invoice.toMap());
  }

  void updateInvoice(Invoice invoice) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('invoices')
          .document(invoice.documentId)
          .updateData(invoice.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Invoice> _buildInvoicesList(QuerySnapshot invoices) {
    List<Invoice> invoiceList = List();
    for(DocumentSnapshot invoiceDocument in invoices.documents){
      invoiceList.add(Invoice.fromMap(invoiceDocument.data, invoiceDocument.documentID));
    }
    invoiceList.sort((invoiceA, invoiceB) => invoiceA.dueDate.compareTo(invoiceB.dueDate));
    return invoiceList;
  }

  Future<Invoice> getInvoiceByInvoiceNumber(int invoiceNumber) {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .where('invoiceNumber', isEqualTo: invoiceNumber)
        .snapshots()
        .first
        .then((snapshot) => Invoice.fromMap(snapshot.documents.elementAt(0).data, snapshot.documents.elementAt(0).documentID));
  }
}