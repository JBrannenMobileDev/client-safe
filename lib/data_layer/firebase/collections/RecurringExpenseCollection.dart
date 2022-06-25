import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class RecurringExpenseCollection {
  Future<void> createRecurringExpense(RecurringExpense expense) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('recurringExpenses')
        .doc(expense.documentId)
        .set(expense.toMap());
  }

  Future<void> deleteRecurringExpense(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('recurringExpenses')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getExpensesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('recurringExpenses')
        .snapshots();
  }

  Future<RecurringExpense> getRecurringExpense(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('recurringExpenses')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
            RecurringExpense expense = RecurringExpense.fromMap(expenseSnapshot.data());
            expense.documentId = expenseSnapshot.id;
            return expense;
        });
  }

  Future<List<RecurringExpense>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('recurringExpenses')
        .get()
        .then((recurringExpenses) => _buildRecurringExpensesList(recurringExpenses));
  }



  Future<void> updateRecurringExpense(RecurringExpense expense) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('recurringExpenses')
          .doc(expense.documentId)
          .update(expense.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<RecurringExpense> _buildRecurringExpensesList(QuerySnapshot jobs) {
    List<RecurringExpense> expensesList = [];
    for(DocumentSnapshot expenseSnapshot in jobs.docs){
      RecurringExpense expense = RecurringExpense.fromMap(expenseSnapshot.data());
      expense.documentId = expenseSnapshot.id;
      expensesList.add(expense);
    }
    return expensesList;
  }
}