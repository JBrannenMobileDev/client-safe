import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/data_layer/firebase/collections/MileageExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:uuid/uuid.dart';

class MileageExpenseDao extends Equatable{
  static const String MILEAGE_EXPENSE_STORE_NAME = 'mileageExpense';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _mileageExpenseStore = sembast.intMapStoreFactory.store(MILEAGE_EXPENSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<sembast.Database> get _db async => await SembastDb.instance.database;

  static Future<MileageExpense> insert(MileageExpense mileageExpense) async {
    mileageExpense.documentId = Uuid().v1();
    mileageExpense.id = await _mileageExpenseStore.add(await _db, mileageExpense.toMap());
    await MileageExpenseCollection().createMileageExpense(mileageExpense);
    _updateLastChangedTime();
    return mileageExpense;
  }

  static Future<void> _updateLastChangedTime() async {
    Profile profile = (await ProfileDao.getAll())!.elementAt(0);
    profile.mileageExpensesLastChangeDate = DateTime.now();
    ProfileDao.update(profile);
  }

  static Future insertLocalOnly(MileageExpense mileageExpense) async {
    await _mileageExpenseStore.add(await _db, mileageExpense.toMap());
  }

  static Future insertOrUpdate(MileageExpense mileageExpense) async {
    List<MileageExpense> mileageExpenseList = await getAll();
    bool alreadyExists = false;
    for(MileageExpense expense in mileageExpenseList){
      if(expense.documentId == mileageExpense.documentId){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(mileageExpense);
    }else{
      await insert(mileageExpense);
    }
  }

  static Future update(MileageExpense mileageExpense) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', mileageExpense.documentId));
    await _mileageExpenseStore.update(
      await _db,
      mileageExpense.toMap(),
      finder: finder,
    ).catchError((error) {
      print(error);
    });
    await MileageExpenseCollection().updateMileageExpense(mileageExpense);
    _updateLastChangedTime();
  }

  static Future updateLocalOnly(MileageExpense mileageExpense) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', mileageExpense));
    await _mileageExpenseStore.update(
      await _db,
      mileageExpense.toMap(),
      finder: finder,
    );
  }

  static Future delete(String documentId) async {
    final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
    await _mileageExpenseStore.delete(
      await _db,
      finder: finder,
    );
    await MileageExpenseCollection().deleteMileageExpense(documentId);
    _updateLastChangedTime();
  }

  static Future<List<MileageExpense>> getAll() async {
    final recordSnapshots = await _mileageExpenseStore.find(await _db);
    return recordSnapshots.map((snapshot) {
      final mileageExpense = MileageExpense.fromMap(snapshot.value);
      mileageExpense.id = snapshot.key;
      return mileageExpense;
    }).toList();
  }

  static Future<MileageExpense?> getMileageExpenseById(String documentId) async{
    if((await getAll()).isNotEmpty) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', documentId));
      final recordSnapshots = await _mileageExpenseStore.find(await _db, finder: finder);
      List<MileageExpense> trips = recordSnapshots.map((snapshot) {
        final expense = MileageExpense.fromMap(snapshot.value);
        expense.id = snapshot.key;
        return expense;
      }).toList();
      if(trips.isNotEmpty) {
        return trips.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<MileageExpense?> getMileageExpenseByJobId(String jobDocumentId) async{
    if((await getAll()).isNotEmpty) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('jobDocumentId', jobDocumentId));
      final recordSnapshots = await _mileageExpenseStore.find(await _db, finder: finder);
      List<MileageExpense> trips = recordSnapshots.map((snapshot) {
        final expense = MileageExpense.fromMap(snapshot.value);
        expense.id = snapshot.key;
        return expense;
      }).toList();
      if(trips.isNotEmpty) {
        return trips.elementAt(0);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Stream<List<sembast.RecordSnapshot>>> getMileageExpenseStream() async {
    var query = _mileageExpenseStore.query();
    return query.onSnapshots(await _db);
  }

  static Stream<QuerySnapshot> getMileageExpensesStreamFromFireStore() {
    return MileageExpenseCollection().getExpensesStream();
  }

  static Future<void> syncAllFromFireStore() async {
    List<MileageExpense> allLocalMileageExpenses = await getAll();
    List<MileageExpense> allFireStoreMileageExpenses = await MileageExpenseCollection().getAll(UidUtil().getUid());

    if(allLocalMileageExpenses.isNotEmpty) {
      if(allFireStoreMileageExpenses.isNotEmpty) {
        //both local and fireStore have clients
        //fireStore is source of truth for this sync.
        await _syncFireStoreToLocal(allLocalMileageExpenses, allFireStoreMileageExpenses);
      } else {
        //all clients have been deleted in the cloud. Delete all local clients also.
        _deleteAllLocalMileageExpenses(allLocalMileageExpenses);
      }
    } else {
      if(allFireStoreMileageExpenses.isNotEmpty){
        //no local clients but there are fireStore clients.
        await _copyAllFireStoreMileageExpensesToLocal(allFireStoreMileageExpenses);
      } else {
        //no clients in either database. nothing to sync.
      }
    }
  }

  static Future<void> _deleteAllLocalMileageExpenses(List<MileageExpense> allLocalMileageExpenses) async {
    for(MileageExpense expense in allLocalMileageExpenses) {
      final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', expense.documentId));
      await _mileageExpenseStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  static Future<void> _copyAllFireStoreMileageExpensesToLocal(List<MileageExpense> allFireStoreMileageExpenses) async {
    for (MileageExpense clientToSave in allFireStoreMileageExpenses) {
      await _mileageExpenseStore.add(await _db, clientToSave.toMap());
    }
  }

  static Future<void> _syncFireStoreToLocal(List<MileageExpense> allLocalMileageExpenses, List<MileageExpense> allFireStoreMileageExpenses) async {
    for(MileageExpense localMileageExpense in allLocalMileageExpenses) {
      //should only be 1 matching
      List<MileageExpense> matchingFireStoreMileageExpenses = allFireStoreMileageExpenses.where((fireStoreMileageExpense) => localMileageExpense.documentId == fireStoreMileageExpense.documentId).toList();
      if(matchingFireStoreMileageExpenses.isNotEmpty) {
        MileageExpense fireStoreMileageExpense = matchingFireStoreMileageExpenses.elementAt(0);
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', fireStoreMileageExpense.documentId));
        await _mileageExpenseStore.update(
          await _db,
          fireStoreMileageExpense.toMap(),
          finder: finder,
        );
      } else {
        //client does nto exist on cloud. so delete from local.
        final finder = sembast.Finder(filter: sembast.Filter.equals('documentId', localMileageExpense.documentId));
        await _mileageExpenseStore.delete(
          await _db,
          finder: finder,
        );
      }
    }

    for(MileageExpense fireStoreMileageExpense in allFireStoreMileageExpenses) {
      List<MileageExpense> matchingLocalMileageExpenses = allLocalMileageExpenses.where((localMileageExpense) => localMileageExpense.documentId == fireStoreMileageExpense.documentId).toList();
      if(matchingLocalMileageExpenses.isNotEmpty) {
        //do nothing. MileageExpense already synced.
      } else {
        //add to local. does not exist in local and has not been synced yet.
        fireStoreMileageExpense.id = null;
        await _mileageExpenseStore.add(await _db, fireStoreMileageExpense.toMap());
      }
    }
  }

  @override
  // TODO: implement props
  List<Object> get props => [];

  static void deleteAllLocal() async {
    List<MileageExpense> expenses = await getAll();
    _deleteAllLocalMileageExpenses(expenses);
  }
}