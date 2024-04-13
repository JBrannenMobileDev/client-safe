import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class InvoiceCollection {
  Future<void> createInvoice(Invoice invoice) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('invoices')
        .doc(invoice.documentId)
        .set(invoice.toMap());
  }

  Future<void> deleteInvoice(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('invoices')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getInvoiceStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('invoices')
        .snapshots();
  }

  Future<Invoice> getInvoice(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('invoices')
        .doc(documentId)
        .get()
        .then((invoice) => Invoice.fromMap(invoice.data() as Map<String, dynamic>));
  }

  Future<List<Invoice>?> getAllInvoicesSortedByDate(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('invoices')
        .get()
        .then((invoices) => _buildInvoicesList(invoices));
  }

  Future<void> replaceInvoice(Invoice invoice) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('invoices')
        .doc(invoice.documentId)
        .set(invoice.toMap());
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('invoices')
          .doc(invoice.documentId)
          .update(invoice.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Invoice> _buildInvoicesList(QuerySnapshot invoices) {
    List<Invoice> invoiceList = [];
    for(DocumentSnapshot invoiceDocument in invoices.docs){
      Invoice result = Invoice.fromMap(invoiceDocument.data() as Map<String, dynamic>);
      result.documentId = invoiceDocument.id;
      invoiceList.add(result);
    }
    return invoiceList;
  }

  Future<Invoice> getInvoiceByInvoiceNumber(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('invoices')
        .where('documentId', isEqualTo: documentId)
        .snapshots()
        .first
        .then((snapshot) {
          Invoice result = Invoice.fromMap(snapshot.docs.elementAt(0).data());
          result.documentId = snapshot.docs.elementAt(0).id;
          return result;
        });
  }
}