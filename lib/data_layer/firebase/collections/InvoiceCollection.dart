import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/utils/UidUtil.dart';

class InvoiceCollection {
  Future<void> createInvoice(Invoice invoice) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .document(invoice.documentId)
        .setData(invoice.toMap());
  }

  Future<void> deleteInvoice(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('invoices')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getInvoiceStream() {
    return Firestore.instance
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .snapshots();
  }

  Future<Invoice> getInvoice(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .document(documentId)
        .get()
        .then((invoice) => Invoice.fromMap(invoice.data));
  }

  Future<List<Invoice>> getAllInvoicesSortedByDate(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .getDocuments()
        .then((invoices) => _buildInvoicesList(invoices));
  }

  Future<void> replaceInvoice(Invoice invoice) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .document(invoice.documentId)
        .setData(invoice.toMap());
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
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
      Invoice result = Invoice.fromMap(invoiceDocument.data);
      result.documentId = invoiceDocument.documentID;
      invoiceList.add(result);
    }
    invoiceList.sort((invoiceA, invoiceB) => invoiceA.dueDate.compareTo(invoiceB.dueDate));
    return invoiceList;
  }

  Future<Invoice> getInvoiceByInvoiceNumber(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('invoices')
        .where('documentId', isEqualTo: documentId)
        .snapshots()
        .first
        .then((snapshot) {
          Invoice result = Invoice.fromMap(snapshot.documents.elementAt(0).data);
          result.documentId = snapshot.documents.elementAt(0).documentID;
          return result;
        });
  }
}