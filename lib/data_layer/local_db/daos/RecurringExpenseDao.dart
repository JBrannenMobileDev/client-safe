import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/RecurringExpenseCollection.dart';
import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class RecurringExpenseDao extends Equatable{
  static const String RECURRING_EXPENSE_STORE_NAME = 'recurringExpense';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _recurringExpenseStore = intMapStoreFactory.store(RECURRING_EXPENSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(RecurringExpense recurringExpense) async {
    await _recurringExpenseStore.add(await _db, recurringExpense.toMap());
    await RecurringExpenseCollection().createRecurringExpense(recurringExpense);
  }

  static Future insertOrUpdate(RecurringExpense recurringExpense) async {
    List<RecurringExpense> recurringExpenseList = await getAll();
    bool alreadyExists = false;
    for(RecurringExpense expense in recurringExpenseList){
      if(expense.id == recurringExpense.id){
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
    final finder = Finder(filter: Filter.byKey(recurringExpense.id));
    await _recurringExpenseStore.update(
      await _db,
      recurringExpense.toMap(),
      finder: finder,
    );
    await RecurringExpenseCollection().updateRecurringExpense(recurringExpense);
  }

  static Future delete(int id, String documentId) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _recurringExpenseStore.delete(
      await _db,
      finder: finder,
    );
    await RecurringExpenseCollection().deleteRecurringExpense(documentId);
  }

  static Future<List<RecurringExpense>> getAll() async {
    final recordSnapshots = await _recurringExpenseStore.find(await _db);
    //uncomment to delete all Single expense records.
//    for(RecordSnapshot snapshot in recordSnapshots) {
//      delete(snapshot.key);
//    }

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final recurringExpense = RecurringExpense.fromMap(snapshot.value);
      recurringExpense.id = snapshot.key;
      return recurringExpense;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}