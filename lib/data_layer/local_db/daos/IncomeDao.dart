import 'dart:async';

import 'package:client_safe/data_layer/local_db/SembastDb.dart';
import 'package:client_safe/models/Income.dart';
import 'package:equatable/equatable.dart';
import 'package:sembast/sembast.dart';

class IncomeDao extends Equatable{
  static const String INCOME_STORE_NAME = 'income';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Client objects converted to Map
  static final _incomeStore = intMapStoreFactory.store(INCOME_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  static Future<Database> get _db async => await SembastDb.instance.database;

  static Future insert(Income income) async {
    await _incomeStore.add(await _db, income.toMap());
  }

  static Future insertOrUpdate(Income income) async {
    List<Income> incomeList = await getAllSortedByYear();
    bool alreadyExists = false;
    for(Income singleIncome in incomeList){
      if(singleIncome.id == income.id){
        alreadyExists = true;
      }
    }
    if(alreadyExists){
      await update(income);
    }else{
      await insert(income);
    }
  }

  static Future update(Income income) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(income.id));
    await _incomeStore.update(
      await _db,
      income.toMap(),
      finder: finder,
    );
  }

  static Future delete(int id) async {
    final finder = Finder(filter: Filter.byKey(id));
    await _incomeStore.delete(
      await _db,
      finder: finder,
    );
  }

  static Future<List<Income>> getAllSortedByYear() async {
    final finder = Finder(sortOrders: [
      SortOrder('year'),
    ]);

    final recordSnapshots = await _incomeStore.find(await _db, finder: finder);

    return recordSnapshots.map((snapshot) {
      final income = Income.fromMap(snapshot.value);
      income.id = snapshot.key;
      return income;
    }).toList();
  }
}