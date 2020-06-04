import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class SingleExpenseDao extends Equatable{
  static const String SINGLE_EXPENSE_STORE_NAME = 'singleExpense';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _singleExpenseStore = intMapStoreFactory.store(SINGLE_EXPENSE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(SingleExpense singleExpense) async {
    await _singleExpenseStore.add(await _db, singleExpense.toMap());
  }

  static Future insertOrUpdate(SingleExpense singleExpense) async {
    List<SingleExpense> singleExpenseList = await getAll();
    bool alreadyExists = false;
    for(SingleExpense expense in singleExpenseList){
      if(expense.id == singleExpense.id){
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
    final finder = Finder(filter: Filter.byKey(singleExpense.id));
    await _singleExpenseStore.update(
      await _db,
      singleExpense.toMap(),
      finder: finder,
    );
  }

  static Future delete(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _singleExpenseStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<SingleExpense>> getAll() async {
    final recordSnapshots = await _singleExpenseStore.find(await _db);

    // Making a List<Client> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final singleExpense = SingleExpense.fromMap(snapshot.value);
      singleExpense.id = snapshot.key;
      return singleExpense;
    }).toList();
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}