import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class RecurringExpenseCollection {
  void createRecurringExpense(RecurringExpense expense) {
    final databaseReference = Firestore.instance;
    databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('recurringExpenses')
        .add(expense.toMap());
  }

  void deleteRecurringExpense(String documentId) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('recurringExpenses')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<RecurringExpense> getRecurringExpense(String documentId) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('recurringExpenses')
        .document(documentId)
        .get()
        .then((snapshot) => RecurringExpense.fromMap(snapshot.data, snapshot.documentID));
  }

  Future<List<RecurringExpense>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('recurringExpenses')
        .getDocuments()
        .then((recurringExpenses) => _buildRecurringExpensesList(recurringExpenses));
  }



  void updateRecurringExpense(RecurringExpense expense) {
    try {
      final databaseReference = Firestore.instance;
      databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('recurringExpenses')
          .document(expense.documentId)
          .updateData(expense.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<RecurringExpense> _buildRecurringExpensesList(QuerySnapshot jobs) {
    List<RecurringExpense> expensesList = List();
    for(DocumentSnapshot expenseSnapshot in jobs.documents){
      expensesList.add(RecurringExpense.fromMap(expenseSnapshot.data, expenseSnapshot.documentID));
    }
    return expensesList;
  }
}