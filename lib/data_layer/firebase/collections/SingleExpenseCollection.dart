import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class SingleExpenseCollection {
  Future<void> createSingleExpense(SingleExpense expense) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('singleExpenses')
        .doc(expense.documentId)
        .set(expense.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteSingleExpense(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('singleExpenses')
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
        .collection('singleExpenses')
        .snapshots();
  }

  Future<SingleExpense> getSingleExpense(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('singleExpenses')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
          SingleExpense expense = SingleExpense.fromMap(expenseSnapshot.data());
          expense.documentId = expenseSnapshot.id;
          return expense;
        });
  }

  Future<List<SingleExpense>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('singleExpenses')
        .get()
        .then((singleExpenses) => _buildSingleExpensesList(singleExpenses));
  }



  Future<void> updateSingleExpense(SingleExpense expense) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('singleExpenses')
          .doc(expense.documentId)
          .update(expense.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<SingleExpense> _buildSingleExpensesList(QuerySnapshot jobs) {
    List<SingleExpense> expensesList = List();
    for(DocumentSnapshot expenseSnapshot in jobs.docs){
      SingleExpense expense = SingleExpense.fromMap(expenseSnapshot.data());
      expense.documentId = expenseSnapshot.id;
      expensesList.add(expense);
    }
    return expensesList;
  }
}