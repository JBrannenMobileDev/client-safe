import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/MileageExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';
import 'package:uuid/uuid.dart';

class MileageExpenseDao extends Equatable{
  static const String MILEAGE_EXPENSE_STORE_NAME = 'mileageExpense';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _mileageExpenseStore = intMapStoreFactory.store(MILEAGE_EXPENSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(MileageExpense mileageExpense) async {
    mileageExpense.documentId = Uuid().v1();
    mileageExpense.id = await _mileageExpenseStore.add(await _db, mileageExpense.toMap());
    await MileageExpenseCollection().createMileageExpense(mileageExpense);
  }

  static Future insertOrUpdate(MileageExpense mileageExpense) async {
    List<MileageExpense> mileageExpenseList = await getAll();
    bool alreadyExists = false;
    for(MileageExpense expense in mileageExpenseList){
      if(expense.id == mileageExpense.id){
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
    final finder = Finder(filter: Filter.byKey(mileageExpense.id));
    await _mileageExpenseStore.update(
      await _db,
      mileageExpense.toMap(),
      finder: finder,
    );
    await MileageExpenseCollection().updateMileageExpense(mileageExpense);
  }

  static Future delete(int id, String documentId) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _mileageExpenseStore.delete(
      await _db,
      finder: finder,
    );
    await MileageExpenseCollection().deleteMileageExpense(documentId);
  }

  static Future<List<MileageExpense>> getAll() async {
    final recordSnapshots = await _mileageExpenseStore.find(await _db);

    //uncomment to delete all mileage expense records.
//    for(RecordSnapshot snapshot in recordSnapshots) {
//      delete(snapshot.key, MileageExpense.fromMap(snapshot.value).documentId);
//    }
    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final mileageExpense = MileageExpense.fromMap(snapshot.value);
      mileageExpense.id = snapshot.key;
      return mileageExpense;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}