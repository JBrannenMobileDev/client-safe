import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/RecurringExpenseCollection.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';

class RecurringExpenseDao extends Equatable{

  static void insert(RecurringExpense recurringExpense) {
    RecurringExpenseCollection().createRecurringExpense(recurringExpense);
  }

  static Future insertOrUpdate(RecurringExpense recurringExpense) async {
    bool alreadyExists = recurringExpense.documentId.isNotEmpty;

    if(alreadyExists){
      update(recurringExpense);
    }else{
      insert(recurringExpense);
    }
  }

  static void update(RecurringExpense recurringExpense) {
    RecurringExpenseCollection().updateRecurringExpense(recurringExpense);
  }

  static void delete(String documentId) {
    RecurringExpenseCollection().deleteRecurringExpense(documentId);
  }

  static Future<List<RecurringExpense>> getAll() async {
    return await RecurringExpenseCollection().getAll(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}