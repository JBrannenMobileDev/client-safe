import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/InvoiceCollection.dart';
import 'package:dandylight/data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';

class InvoiceDao extends Equatable{

  static Future insertOrUpdate(Invoice invoice) async {
    bool alreadyExists = invoice.documentId.isNotEmpty;
    if(alreadyExists){
      update(invoice);
    }else{
      InvoiceCollection().replaceInvoice(invoice);
      NextInvoiceNumber nextInvoiceNumber = await NextInvoiceNumberDao.getNext();
      if(nextInvoiceNumber == null) {
        nextInvoiceNumber = NextInvoiceNumber(highestInvoiceNumber: 1001);
      }
      nextInvoiceNumber.highestInvoiceNumber = (nextInvoiceNumber.highestInvoiceNumber + 1);
      NextInvoiceNumberDao.update(nextInvoiceNumber);
    }
  }

  static void update(Invoice invoice) {
    InvoiceCollection().updateInvoice(invoice);
  }

  static void deleteById(String documentId) {
    InvoiceCollection().deleteInvoice(documentId);
  }

  static void deleteByInvoice(Invoice invoice) {
    deleteById(invoice.documentId);
  }

  static Future<List<Invoice>> getAllSortedByDueDate() async {
    return await InvoiceCollection().getAllInvoicesSortedByDate(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  //TODO used to be invoice number ex: 1001
  //TODO now it is documentId needs to be fixed.
  static Future<Invoice> getInvoiceById(String documentId) async{
    return await InvoiceCollection().getInvoice(documentId);
  }

  static Future<Invoice> getInvoiceByInvoiceNumber(int invoiceNumber) async {
    return await InvoiceCollection().getInvoiceByInvoiceNumber(invoiceNumber);
  }
}