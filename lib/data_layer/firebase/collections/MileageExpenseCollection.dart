import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class MileageExpenseCollection {
  Future<void> createMileageExpense(MileageExpense expense) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('mileageExpenses')
        .document(expense.documentId)
        .setData(expense.toMap());
  }

  Future<void> deleteMileageExpense(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
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
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('mileageExpenses')
        .document(documentId)
        .get()
        .then((expenseSnapshot) {
          MileageExpense expense = MileageExpense.fromMap(expenseSnapshot.data);
          expense.documentId = expenseSnapshot.documentID;
          return expense;
        });
  }

  Future<List<MileageExpense>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('mileageExpenses')
        .getDocuments()
        .then((mileageExpenses) => _buildMileageExpensesList(mileageExpenses));
  }



  Future<void> updateMileageExpense(MileageExpense expense) async{
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
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
      MileageExpense expense = MileageExpense.fromMap(expenseSnapshot.data);
      expense.documentId = expenseSnapshot.documentID;
      expensesList.add(expense);
    }
    return expensesList;
  }
}