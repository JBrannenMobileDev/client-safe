import 'dart:async';

import 'package:dandylight/data_layer/firebase/collections/MileageExpenseCollection.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:equatable/equatable.dart';

class MileageExpenseDao extends Equatable{

  static void insert(MileageExpense mileageExpense) {
    MileageExpenseCollection().createMileageExpense(mileageExpense);
  }

  static Future insertOrUpdate(MileageExpense mileageExpense) async {
    bool alreadyExists = mileageExpense.documentId.isNotEmpty;

    if(alreadyExists){
      update(mileageExpense);
    }else{
      insert(mileageExpense);
    }
  }

  static void update(MileageExpense mileageExpense) {
    MileageExpenseCollection().updateMileageExpense(mileageExpense);
  }

  static void delete(String documentId) {
    MileageExpenseCollection().deleteMileageExpense(documentId);
  }

  static Future<List<MileageExpense>> getAll() async {
    return await MileageExpenseCollection().getAll(UidUtil().getUid());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}