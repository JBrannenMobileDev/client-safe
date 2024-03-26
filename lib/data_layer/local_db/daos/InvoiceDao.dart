import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/InvoiceCollection.dart';
import 'package:dandylight/data_layer/firebase/collections/NextInvoiceNumberCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

import 'ProfileDao.dart';

class InvoiceDao extends Equatable{
  static const String INVOICE_STORE_NAME = 'invoice';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _invoiceStore = sembast.intMapStoreFactory.store(INVOICE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future insert(Invoice invoice, Job jobToUpdate) async {
    invoice.documentId = Uuid().v1();
    int savedInvoiceId = await _invoiceStore.add(await _db, invoice.toMap());
    invoice.id = savedInvoiceId;
    jobToUpdate.invoice = invoice;
    await JobDao.update(jobToUpdate);
    await InvoiceCollection().createInvoice(invoice);
    _updateLastChangedTime();
  }

  static Future insertLocalOnly(Invoice invoice) async {
    await _invoiceStore.add(await _db, invoice.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll())!.elementAt(0);
    profile.invoicesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(Invoice invoice, Job selectedJob) async {
    List<Invoice>? invoices = await getAllSortedByDueDate();
    bool alreadyExists = false;
    for(Invoice singleInvoice in invoices!){
      if(singleInvoice.documentId == invoice.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(invoice, selectedJob);
    }else{
      List<Invoice>? allInvoices = await getAllSortedByDueDate();
      List<Invoice> invoicesToDelete = [];
      for(Invoice invoiceItem in allInvoices!){
        if(invoiceItem.jobDocumentId == invoice.jobDocumentId) invoicesToDelete.add(invoiceItem);
      }

      for(Invoice invoiceToDelete in invoicesToDelete){
        await deleteByInvoice(invoiceToDelete);
      }

      await insert(invoice, selectedJob);
      List<NextInvoiceNumber> nextInvoiceNumbers = await NextInvoiceNumberDao.getAllSorted();
      if(nextInvoiceNumbers.isEmpty){
        nextInvoiceNumbers.add(NextInvoiceNumber(highestInvoiceNumber: 1000));
        await NextInvoiceNumberCollection().setStartingValue(1000);
      }
      NextInvoiceNumber nextInvoiceNumber = nextInvoiceNumbers.elementAt(0);
      nextInvoiceNumber.highestInvoiceNumber = (nextInvoiceNumber.highestInvoiceNumber! + 1);
      await NextInvoiceNumberDao.insertOrUpdate(nextInvoiceNumber);
    }
  }

  static Future update(Invoice? invoice, Job? jobToUpdate) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', invoice!.documentId));
    await _invoiceStore.update(
      await _db,
      invoice.toMap(),
      finder: finder,
    );
    jobToUpdate!.invoice = invoice;
    await JobDao.update(jobToUpdate);
    await InvoiceCollection().updateInvoice(invoice);
    _updateLastChangedTime();
  }

  static Future updateInvoiceOnly(Invoice? invoice) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', invoice!.documentId));
    await _invoiceStore.update(
      await _db,
      invoice.toMap(),
      finder: finder,
    );
    await InvoiceCollection().updateInvoice(invoice);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(Invoice invoice) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', invoice.documentId));
    await _invoiceStore.update(
      await _db,
      invoice.toMap(),
      finder: finder,
    );
    await InvoiceCollection().updateInvoice(invoice);
  }

  static Future deleteById(String? documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _invoiceStore.delete(
      await _db,
      finder: finder,
    );
    await InvoiceCollection().deleteInvoice(documentId!);
    List<Job>? jobs = await JobDao.getAllJobs();
    for(Job job in jobs!){
      if(job.invoice?.documentId == documentId){
        job.invoice = null;
        await JobDao.update(job);
      }
    }
    _updateLastChangedTime();
  }

  static Future deleteByInvoice(Invoice? invoice) async {
    await deleteById(invoice!.documentId);
  }

  static Future<List<Invoice>?> getAllSortedByDueDate() async {
    final finder = sembast.Finder(sortOrders: [
      sembast.SortOrder('year'),
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

  static Future<Invoice?> getInvoiceById(String documentId) async{
    if((await getAllSortedByDueDate())!.isNotEmpty) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
      final recordSnapshots = await _invoiceStore.find(await _db, finder: finder);
      // Making a List<Client> out of List<RecordSnapshot>
      List<Invoice> list = recordSnapshots.map((snapshot) {
        final invoice = Invoice.fromMap(snapshot.value);
        invoice.id = snapshot.key;
        return invoice;
      }).toList();
      if(list.isNotEmpty) {
        return list.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }

  }

  static Future<Stream<List<sembast.RecordSnapshot>>> getInvoiceStream() async {
    var query = _invoiceStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getInvoicesStreamFromFireStore() {
    return InvoiceCollection().getInvoiceStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<Invoice>? allLocalInvoices = await getAllSortedByDueDate();
    List<Invoice>? allFireStoreInvoices = await InvoiceCollection().getAllInvoicesSortedByDate(UidUtil().getUid());

    if(allLocalInvoices != null && allLocalInvoices.isNotEmpty) {
      if(allFireStoreInvoices != null && allFireStoreInvoices.isNotEmpty) {
        //both local and fireStore have Invoices
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalInvoices, allFireStoreInvoices);
      } else {
        //all Invoices have been deleted in the cloud. Delete all local Invoices also.
        _deleteAllLocalInvoices(allLocalInvoices);
      }
    } else {
      if(allFireStoreInvoices != null && allFireStoreInvoices.isNotEmpty){
        //no local Invoices but there are fireStore Invoices.
        await _copyAllFireStoreInvoicesToLocal(allFireStoreInvoices);
      } else {
        //no Invoices in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalInvoices(List<Invoice> allLocalInvoices) async {
    for(Invoice invoice in allLocalInvoices) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', invoice.documentId));
      await _invoiceStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreInvoicesToLocal(List<Invoice> allFireStoreInvoices) async {
    for (Invoice InvoiceToSave in allFireStoreInvoices) {
      await _invoiceStore.add(await _db, InvoiceToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<Invoice> allLocalInvoices, List<Invoice> allFireStoreInvoices) async {
    for(Invoice localInvoice in allLocalInvoices) {
      //should only be 1 matching
      List<Invoice> matchingFireStoreInvoices = allFireStoreInvoices.where((fireStoreInvoice) => localInvoice.documentId == fireStoreInvoice.documentId).toList();
      if(matchingFireStoreInvoices.isNotEmpty) {
        Invoice fireStoreInvoice = matchingFireStoreInvoices.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreInvoice.documentId));
        await _invoiceStore.update(
          await _db,
          fireStoreInvoice.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localInvoice.documentId));
        await _invoiceStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(Invoice fireStoreInvoice in allFireStoreInvoices) {
      List<Invoice> matchingLocalInvoices = allLocalInvoices.where((localInvoice) => localInvoice.documentId == fireStoreInvoice.documentId).toList();
      if(matchingLocalInvoices.isNotEmpty) {
        //do nothing. Invoice already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreInvoice.id = null;
        await _invoiceStore.add(await _db, fireStoreInvoice.toMap());
      }
    }
  }

  static void deleteAllLocal() async {
    List<Invoice>? invoices = await getAllSortedByDueDate();
    _deleteAllLocalInvoices(invoices!);
  }

  static void deleteAllRemote() async {
    List<Invoice>? invoices = await getAllSortedByDueDate();
    for(Invoice invoice in invoices!) {
      await deleteById(invoice.documentId);
    }
  }
}