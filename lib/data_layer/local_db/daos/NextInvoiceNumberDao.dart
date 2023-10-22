import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/NextInvoiceNumberCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/NextInvoiceNumber.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;

import 'ProfileDao.dart';

class NextInvoiceNumberDao extends Equatable{
  static const String NEXT_INVOICE_NUMBER_STORE_NAME = 'nextInvoiceNumber';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _nextInvoiceNumberStore = sembast.intMapStoreFactory.store(NEXT_INVOICE_NUMBER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future insert(NextInvoiceNumber next) async {
    await _nextInvoiceNumberStore.add(await _db, next.toMap());
    await NextInvoiceNumberCollection().updateNextInvoiceNumber(next);
    _updateLastChangedTime();
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.nextInvoiceNumberLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertLocalOnly(NextInvoiceNumber next) async {
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

  static Stream<DocumentSnapshot> getStreamFromFireStore() {
    return NextInvoiceNumberCollection().getStream();
  }

  static Future update(NextInvoiceNumber next) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.byKey(next.id));
    await _nextInvoiceNumberStore.update(
      await _db,
      next.toMap(),
      finder: finder,
    );
    await NextInvoiceNumberCollection().updateNextInvoiceNumber(next);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(NextInvoiceNumber next) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.byKey(next.id));
    await _nextInvoiceNumberStore.update(
      await _db,
      next.toMap(),
      finder: finder,
    );
  }

  static Future<NextInvoiceNumber> getNextNumber() async{
    final recordSnapshots = await _nextInvoiceNumberStore.find(await _db);

    return recordSnapshots.map((snapshot) {
      final next = NextInvoiceNumber.fromMap(snapshot.value);
      next.id = snapshot.key;
      return next;
    }).toList().elementAt(0);
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
    if(allNextNumbers.length == 0 || allNextNumbers.elementAt(0).highestInvoiceNumber == null) return 1000;
    int nextNumber = allNextNumbers.elementAt(0).highestInvoiceNumber++;
    return nextNumber;
  }

  static syncAllFromFireStore() async {
    NextInvoiceNumber fireStoreCloud = await NextInvoiceNumberCollection().getNextInvoiceNumber(UidUtil().getUid());
    int local = await nextNumber();
    int fireStore = fireStoreCloud != null ? fireStoreCloud.highestInvoiceNumber : 0;
    if(local == fireStore) return;
    if(local > fireStore) {
      await NextInvoiceNumberCollection().updateNextInvoiceNumber(NextInvoiceNumber(highestInvoiceNumber: local));
    } else {
      fireStoreCloud.id = 1;
      await updateLocalOnly(fireStoreCloud);
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static Future<void> _deleteAllLocal(List<NextInvoiceNumber> all) async {
    for(NextInvoiceNumber expense in all) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('id', expense.id));
      await _nextInvoiceNumberStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static void deleteAllLocal() async {
    List<NextInvoiceNumber> numbers = await getAllSorted();
    _deleteAllLocal(numbers);
  }
}