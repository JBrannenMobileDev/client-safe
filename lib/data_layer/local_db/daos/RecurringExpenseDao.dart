import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/RecurringExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class RecurringExpenseDao extends Equatable{
  static const String RECURRING_EXPENSE_STORE_NAME = 'recurringExpense';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _recurringExpenseStore = intMapStoreFactory.store(RECURRING_EXPENSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(RecurringExpense recurringExpense) async {
    recurringExpense.documentId = Uuid().v1();
    recurringExpense.id = await _recurringExpenseStore.add(await _db, recurringExpense.toMap());
    await RecurringExpenseCollection().createRecurringExpense(recurringExpense);
    _updateLastChangedTime();
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.recurringExpensesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertLocalOnly(RecurringExpense recurringExpense) async {
    await _recurringExpenseStore.add(await _db, recurringExpense.toMap());
  }

  static Future insertOrUpdate(RecurringExpense recurringExpense) async {
    List<RecurringExpense> recurringExpenseList = await getAll();
    bool alreadyExists = false;
    for(RecurringExpense expense in recurringExpenseList){
      if(expense.documentId == recurringExpense.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(recurringExpense);
    }else{
      await insert(recurringExpense);
    }
  }

  static Future update(RecurringExpense recurringExpense) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', recurringExpense.documentId));
    await _recurringExpenseStore.update(
      await _db,
      recurringExpense.toMap(),
      finder: finder,
    );
    await RecurringExpenseCollection().updateRecurringExpense(recurringExpense);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(RecurringExpense recurringExpense) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.equals('documentId', recurringExpense.documentId));
    await _recurringExpenseStore.update(
      await _db,
      recurringExpense.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    await _recurringExpenseStore.delete(
      await _db,
      finder: finder,
    );
    await RecurringExpenseCollection().deleteRecurringExpense(documentId);
    _updateLastChangedTime();
  }

  static Future<List<RecurringExpense>> getAll() async {
    final recordSnapshots = await _recurringExpenseStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final recurringExpense = RecurringExpense.fromMap(snapshot.value);
      recurringExpense.id = snapshot.key;
      return recurringExpense;
    }).toList();
  }

  static Future<RecurringExpense> getRecurringExpenseById(String documentId) async{
    final finder = Finder(filter: Filter.equals('documentId', documentId));
    final recordSnapshots = await _recurringExpenseStore.find(await _db, finder: finder);
    return recordSnapshots.map((snapshot) {
      final expense = RecurringExpense.fromMap(snapshot.value);
      expense.id = snapshot.key;
      return expense;
    }).toList().elementAt(0);
  }

  static Future<Stream<List<RecordSnapshot>>> getRecurringExpenseStream() async {
    var query = _recurringExpenseStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getRecurringExpensesStreamFromFireStore() {
    return RecurringExpenseCollection().getExpensesStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<RecurringExpense> allLocalRecurringExpenses = await getAll();
    List<RecurringExpense> allFireStoreRecurringExpenses = await RecurringExpenseCollection().getAll(UidUtil().getUid());

    if(allLocalRecurringExpenses != null && allLocalRecurringExpenses.length > 0) {
      if(allFireStoreRecurringExpenses != null && allFireStoreRecurringExpenses.length > 0) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalRecurringExpenses, allFireStoreRecurringExpenses);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalRecurringExpenses(allLocalRecurringExpenses);
      }
    } else {
      if(allFireStoreRecurringExpenses != null && allFireStoreRecurringExpenses.length > 0){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreRecurringExpensesToLocal(allFireStoreRecurringExpenses);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalRecurringExpenses(List<RecurringExpense> allLocalRecurringExpenses) async {
    for(RecurringExpense expense in allLocalRecurringExpenses) {
      final finder = Finder(filter: Filter.equals('documentId', expense.documentId));
      await _recurringExpenseStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreRecurringExpensesToLocal(List<RecurringExpense> allFireStoreRecurringExpenses) async {
    for (RecurringExpense clientToSave in allFireStoreRecurringExpenses) {
      await _recurringExpenseStore.add(await _db, clientToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<RecurringExpense> allLocalRecurringExpenses, List<RecurringExpense> allFireStoreRecurringExpenses) async {
    for(RecurringExpense localRecurringExpense in allLocalRecurringExpenses) {
      //should only be 1 matching
      List<RecurringExpense> matchingFireStoreRecurringExpenses = allFireStoreRecurringExpenses.where((fireStoreRecurringExpense) => localRecurringExpense.documentId == fireStoreRecurringExpense.documentId).toList();
      if(matchingFireStoreRecurringExpenses !=  null && matchingFireStoreRecurringExpenses.length > 0) {
        RecurringExpense fireStoreRecurringExpense = matchingFireStoreRecurringExpenses.elementAt(0);
        final finder = Finder(filter: Filter.equals('documentId', fireStoreRecurringExpense.documentId));
        await _recurringExpenseStore.update(
          await _db,
          fireStoreRecurringExpense.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = Finder(filter: Filter.equals('documentId', localRecurringExpense.documentId));
        await _recurringExpenseStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(RecurringExpense fireStoreRecurringExpense in allFireStoreRecurringExpenses) {
      List<RecurringExpense> matchingLocalRecurringExpenses = allLocalRecurringExpenses.where((localRecurringExpense) => localRecurringExpense.documentId == fireStoreRecurringExpense.documentId).toList();
      if(matchingLocalRecurringExpenses != null && matchingLocalRecurringExpenses.length > 0) {
        //do nothing. RecurringExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreRecurringExpense.id = null;
        await _recurringExpenseStore.add(await _db, fireStoreRecurringExpense.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}