import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/SingleExpenseCollection.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';

class SingleExpenseDao extends Equatable{
  static void insert(SingleExpense singleExpense) {
    SingleExpenseCollection().createSingleExpense(singleExpense);
  }

  static Future insertOrUpdate(SingleExpense singleExpense) async {
    bool alreadyExists = singleExpense.documentId.isNotEmpty;

    if(alreadyExists){
      update(singleExpense);
    }else{
      insert(singleExpense);
    }
  }

  static void update(SingleExpense singleExpense) {
    SingleExpenseCollection().updateSingleExpense(singleExpense);
  }

  static void delete(String documentId) {
    SingleExpenseCollection().deleteSingleExpense(documentId);
  }

  static Future<List<SingleExpense>> getAll() async {
    return await SingleExpenseCollection().getAll(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}