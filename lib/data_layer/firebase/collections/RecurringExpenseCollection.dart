import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class RecurringExpenseCollection {
  Future<void> createRecurringExpense(RecurringExpense expense) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('recurringExpenses')
        .document(expense.documentId)
        .setData(expense.toMap());
  }

  Future<void> deleteRecurringExpense(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('recurringExpenses')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getExpensesStream() {
    return Firestore.instance
        .collection('users')
        .document(UidUtil().getUid())
        .collection('recurringExpenses')
        .snapshots();
  }

  Future<RecurringExpense> getRecurringExpense(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('recurringExpenses')
        .document(documentId)
        .get()
        .then((expenseSnapshot) {
            RecurringExpense expense = RecurringExpense.fromMap(expenseSnapshot.data);
            expense.documentId = expenseSnapshot.documentID;
            return expense;
        });
  }

  Future<List<RecurringExpense>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('recurringExpenses')
        .getDocuments()
        .then((recurringExpenses) => _buildRecurringExpensesList(recurringExpenses));
  }



  Future<void> updateRecurringExpense(RecurringExpense expense) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
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
      RecurringExpense expense = RecurringExpense.fromMap(expenseSnapshot.data);
      expense.documentId = expenseSnapshot.documentID;
      expensesList.add(expense);
    }
    return expensesList;
  }
}