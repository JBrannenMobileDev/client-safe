import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class MileageExpenseCollection {
  void createMileageExpense(MileageExpense expense) {
    final databaseReference = Firestore.instance;
    databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('mileageExpenses')
        .add(expense.toMap());
  }

  void deleteMileageExpense(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('mileageExpenses')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<MileageExpense> getMileageExpense(String documentId) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('mileageExpenses')
        .document(documentId)
        .get()
        .then((snapshot) => MileageExpense.fromMap(snapshot.data, snapshot.documentID));
  }

  Future<List<MileageExpense>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('mileageExpenses')
        .getDocuments()
        .then((mileageExpenses) => _buildMileageExpensesList(mileageExpenses));
  }



  void updateMileageExpense(MileageExpense expense) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('mileageExpenses')
          .document(expense.documentId)
          .updateData(expense.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<MileageExpense> _buildMileageExpensesList(QuerySnapshot jobs) {
    List<MileageExpense> expensesList = List();
    for(DocumentSnapshot expenseSnapshot in jobs.documents){
      expensesList.add(MileageExpense.fromMap(expenseSnapshot.data, expenseSnapshot.documentID));
    }
    return expensesList;
  }
}