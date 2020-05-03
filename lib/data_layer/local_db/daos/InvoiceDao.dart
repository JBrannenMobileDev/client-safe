import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
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
      List<Invoice> allInvoices = await getAllSortedByDueDate();
      List<Invoice> invoicesToDelete = List();
      for(Invoice invoiceItem in allInvoices){
        if(invoiceItem.jobId == invoice.jobId) invoicesToDelete.add(invoiceItem);
      }

      for(Invoice invoiceToDelete in invoicesToDelete){
        await deleteByInvoice(invoiceToDelete);
      }

      await insert(invoice);
      List<NextInvoiceNumber> nextInvoiceNumbers = await NextInvoiceNumberDao.getAllSorted();
      if(nextInvoiceNumbers.length == 0){
        nextInvoiceNumbers.add(NextInvoiceNumber(highestInvoiceNumber: 1000));
      }
      NextInvoiceNumber nextInvoiceNumber = nextInvoiceNumbers.elementAt(0);
      nextInvoiceNumber.highestInvoiceNumber = (nextInvoiceNumber.highestInvoiceNumber + 1);
      await NextInvoiceNumberDao.insertOrUpdate(nextInvoiceNumber);
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

  static Future deleteById(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _invoiceStore.delete(
      await _db,
      finder: finder,
    );
    List<Job> jobs = await JobDao.getAllJobs();
    for(Job job in jobs){
      if(job.invoice?.id == id){
        job.invoice = null;
        await JobDao.update(job);
      }
    }
  }

  static Future deleteByInvoice(Invoice invoice) async {
    await deleteById(invoice.id);
  }

  static Future<List<Invoice>> getAllSortedByDueDate() async {
    final finder = Finder(sortOrders: [
      SortOrder('year'),
    ]);

    final recordSnapshots = await _invoiceStore.find(await _db, finder: finder);

//    List<Invoice> allInvoices = recordSnapshots.map((snapshot) {
//      final invoice = Invoice.fromMap(snapshot.value);
//      invoice.id = snapshot.key;
//      return invoice;
//    }).toList();
//
//    for(Invoice invoice in allInvoices){
//      await delete(invoice.id);
//    }
//
//    return List();

    return recordSnapshots.map((snapshot) {
      final invoice = Invoice.fromMap(snapshot.value);
      invoice.id = snapshot.key;
      return invoice;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static Future<Invoice> getInvoiceById(int invoiceId) async{
    final finder = Finder(filter: Filter.equals('invoiceId', invoiceId));
    final recordSnapshots = await _invoiceStore.find(await _db, finder: finder);
    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final invoice = Invoice.fromMap(snapshot.value);
      invoice.id = snapshot.key;
      return invoice;
    }).toList().elementAt(0);
  }
}