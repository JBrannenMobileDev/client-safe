import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class SingleExpenseCollection {
  Future<void> createSingleExpense(SingleExpense expense) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('singleExpenses')
        .document(expense.documentId)
        .setData(expense.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteSingleExpense(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('singleExpenses')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<SingleExpense> getSingleExpense(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('singleExpenses')
        .document(documentId)
        .get()
        .then((expenseSnapshot) {
          SingleExpense expense = SingleExpense.fromMap(expenseSnapshot.data);
          expense.documentId = expenseSnapshot.documentID;
          return expense;
        });
  }

  Future<List<SingleExpense>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('singleExpenses')
        .getDocuments()
        .then((singleExpenses) => _buildSingleExpensesList(singleExpenses));
  }



  Future<void> updateSingleExpense(SingleExpense expense) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('singleExpenses')
          .document(expense.documentId)
          .updateData(expense.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<SingleExpense> _buildSingleExpensesList(QuerySnapshot jobs) {
    List<SingleExpense> expensesList = List();
    for(DocumentSnapshot expenseSnapshot in jobs.documents){
      SingleExpense expense = SingleExpense.fromMap(expenseSnapshot.data);
      expense.documentId = expenseSnapshot.documentID;
      expensesList.add(expense);
    }
    return expensesList;
  }
}