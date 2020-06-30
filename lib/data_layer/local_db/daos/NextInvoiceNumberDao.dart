import 'dart:async';

import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class NextInvoiceNumberDao extends Equatable{
  static const String NEXT_INVOICE_NUMBER_STORE_NAME = 'nextInvoiceNumber';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _nextInvoiceNumberStore = intMapStoreFactory.store(NEXT_INVOICE_NUMBER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(NextInvoiceNumber next) async {
    await _nextInvoiceNumberStore.add(await _db, next.toMap());
  }

  static Future insertOrUpdate(NextInvoiceNumber next) async {
    List<NextInvoiceNumber> nextList = await getAllSorted();
    bool alreadyExists = false;
    for(NextInvoiceNumber singleNext in nextList){
      if(singleNext.id == next.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(next);
    }else{
      await insert(next);
    }
  }

  static Future update(NextInvoiceNumber next) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(next.id));
    await _nextInvoiceNumberStore.update(
      await _db,
      next.toMap(),
      finder: finder,
    );
  }

  static Future delete(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _nextInvoiceNumberStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<NextInvoiceNumber>> getAllSorted() async {

    final recordSnapshots = await _nextInvoiceNumberStore.find(await _db);

    return recordSnapshots.map((snapshot) {
      final next = NextInvoiceNumber.fromMap(snapshot.value);
      next.id = snapshot.key;
      return next;
    }).toList();
  }

  static Future<int> nextNumber() async {
    List<NextInvoiceNumber> allNextNumbers = await getAllSorted();
    if(allNextNumbers.length == 0) return 1000;
    int nextNumber = allNextNumbers.elementAt(0).highestInvoiceNumber++;
    return nextNumber;
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}