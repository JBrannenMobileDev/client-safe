import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class SingleExpenseCollection {
  void createSingleExpense(SingleExpense expense) {
    final databaseReference = Firestore.instance;
    databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('singleExpenses')
        .add(expense.toMap());
  }

  void deleteSingleExpense(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
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
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('singleExpenses')
        .document(documentId)
        .get()
        .then((snapshot) => SingleExpense.fromMap(snapshot.data, snapshot.documentID));
  }

  Future<List<SingleExpense>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('singleExpenses')
        .getDocuments()
        .then((singleExpenses) => _buildSingleExpensesList(singleExpenses));
  }



  void updateSingleExpense(SingleExpense expense) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
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
      expensesList.add(SingleExpense.fromMap(expenseSnapshot.data, expenseSnapshot.documentID));
    }
    return expensesList;
  }
}