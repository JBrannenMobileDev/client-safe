import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/NextInvoiceNumber.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class InvoiceDao extends Equatable{
  static const String INVOICE_STORE_NAME = 'invoice';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _invoiceStore = intMapStoreFactory.store(INVOICE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(Invoice invoice) async {
    await _invoiceStore.add(await _db, invoice.toMap());
  }

  static Future insertOrUpdate(Invoice invoice) async {
    List<Invoice> invoices = await getAllSortedByDueDate();
    bool alreadyExists = false;
    for(Invoice singleInvoice in invoices){
      if(singleInvoice.id == invoice.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(invoice);
    }else{
      await insert(invoice);
      List<NextInvoiceNumber> nextInvoiceNumbers = await NextInvoiceNumberDao.getAllSorted();
      NextInvoiceNumber nextInvoiceNumber = nextInvoiceNumbers.elementAt(0);
      nextInvoiceNumber.highestInvoiceNumber = nextInvoiceNumber.highestInvoiceNumber++;
      await NextInvoiceNumberDao.update(nextInvoiceNumber);
    }
  }

  static Future update(Invoice invoice) async {
    final finder = Finder(filter: Filter.byKey(invoice.id));
    await _invoiceStore.update(
      await _db,
      invoice.toMap(),
      finder: finder,
    );
  }

  static Future delete(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _invoiceStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<Invoice>> getAllSortedByDueDate() async {
    final finder = Finder(sortOrders: [
      SortOrder('year'),
    ]);

    final recordSnapshots = await _invoiceStore.find(await _db, finder: finder);

    return recordSnapshots.map((snapshot) {
      final invoice = Invoice.fromMap(snapshot.value);
      invoice.id = snapshot.key;
      return invoice;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}