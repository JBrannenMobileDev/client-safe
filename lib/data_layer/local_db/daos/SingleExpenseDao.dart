import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/SingleExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

class SingleExpenseDao extends Equatable{
  static const String SINGLE_EXPENSE_STORE_NAME = 'singleExpense';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _singleExpenseStore = sembast.intMapStoreFactory.store(SINGLE_EXPENSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future insert(SingleExpense singleExpense) async {
    singleExpense.documentId = Uuid().v1();
    singleExpense.id = await _singleExpenseStore.add(await _db, singleExpense.toMap());
    await SingleExpenseCollection().createSingleExpense(singleExpense);
    _updateLastChangedTime();
  }

  static Future insertLocalOnly(SingleExpense singleExpense) async {
    await _singleExpenseStore.add(await _db, singleExpense.toMap());
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.singleExpensesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertOrUpdate(SingleExpense singleExpense) async {
    List<SingleExpense> singleExpenseList = await getAll();
    bool alreadyExists = false;
    for(SingleExpense expense in singleExpenseList){
      if(expense.documentId == singleExpense.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(singleExpense);
    }else{
      await insert(singleExpense);
    }
  }

  static Future update(SingleExpense singleExpense) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', singleExpense.documentId));
    await _singleExpenseStore.update(
      await _db,
      singleExpense.toMap(),
      finder: finder,
    );
    await SingleExpenseCollection().updateSingleExpense(singleExpense);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(SingleExpense singleExpense) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', singleExpense.documentId));
    await _singleExpenseStore.update(
      await _db,
      singleExpense.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _singleExpenseStore.delete(
      await _db,
      finder: finder,
    );
    await SingleExpenseCollection().deleteSingleExpense(documentId);
    _updateLastChangedTime();
  }

  static Future<List<SingleExpense>> getAll() async {
    final recordSnapshots = await _singleExpenseStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final singleExpense = SingleExpense.fromMap(snapshot.value);
      singleExpense.id = snapshot.key;
      return singleExpense;
    }).toList();
  }

  static Future<SingleExpense> getSingleExpenseById(String documentId) async{
    if((await getAll()).length > 0) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
      final recordSnapshots = await _singleExpenseStore.find(await _db, finder: finder);
      return recordSnapshots.map((snapshot) {
        final expense = SingleExpense.fromMap(snapshot.value);
        expense.id = snapshot.key;
        return expense;
      }).toList().elementAt(0);
    } else {
      return null;
    }
  }

  static Future<Stream<List<sembast.RecordSnapshot>>> getSingleExpenseStream() async {
    var query = _singleExpenseStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getSingleExpensesStreamFromFireStore() {
    return SingleExpenseCollection().getExpensesStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<SingleExpense> allLocalSingleExpenses = await getAll();
    List<SingleExpense> allFireStoreSingleExpenses = await SingleExpenseCollection().getAll(UidUtil().getUid());

    if(allLocalSingleExpenses != null && allLocalSingleExpenses.length > 0) {
      if(allFireStoreSingleExpenses != null && allFireStoreSingleExpenses.length > 0) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalSingleExpenses, allFireStoreSingleExpenses);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalSingleExpenses(allLocalSingleExpenses);
      }
    } else {
      if(allFireStoreSingleExpenses != null && allFireStoreSingleExpenses.length > 0){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreSingleExpensesToLocal(allFireStoreSingleExpenses);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalSingleExpenses(List<SingleExpense> allLocalSingleExpenses) async {
    for(SingleExpense expense in allLocalSingleExpenses) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', expense.documentId));
      await _singleExpenseStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreSingleExpensesToLocal(List<SingleExpense> allFireStoreSingleExpenses) async {
    for (SingleExpense singleToSave in allFireStoreSingleExpenses) {
      await _singleExpenseStore.add(await _db, singleToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<SingleExpense> allLocalSingleExpenses, List<SingleExpense> allFireStoreSingleExpenses) async {
    for(SingleExpense localSingleExpense in allLocalSingleExpenses) {
      //should only be 1 matching
      List<SingleExpense> matchingFireStoreSingleExpenses = allFireStoreSingleExpenses.where((fireStoreSingleExpense) => localSingleExpense.documentId == fireStoreSingleExpense.documentId).toList();
      if(matchingFireStoreSingleExpenses !=  null && matchingFireStoreSingleExpenses.length > 0) {
        SingleExpense fireStoreSingleExpense = matchingFireStoreSingleExpenses.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreSingleExpense.documentId));
        await _singleExpenseStore.update(
          await _db,
          fireStoreSingleExpense.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localSingleExpense.documentId));
        await _singleExpenseStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(SingleExpense fireStoreSingleExpense in allFireStoreSingleExpenses) {
      List<SingleExpense> matchingLocalSingleExpenses = allLocalSingleExpenses.where((localSingleExpense) => localSingleExpense.documentId == fireStoreSingleExpense.documentId).toList();
      if(matchingLocalSingleExpenses != null && matchingLocalSingleExpenses.length > 0) {
        //do nothing. SingleExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreSingleExpense.id = null;
        await _singleExpenseStore.add(await _db, fireStoreSingleExpense.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<SingleExpense> expenses = await getAll();
    _deleteAllLocalSingleExpenses(expenses);
  }
}