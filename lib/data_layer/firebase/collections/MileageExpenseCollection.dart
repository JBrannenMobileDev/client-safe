import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class MileageExpenseCollection {
  Future<void> createMileageExpense(MileageExpense expense) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('mileageExpenses')
        .doc(expense.documentId)
        .set(expense.toMap());
  }

  Future<void> deleteMileageExpense(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('mileageExpenses')
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
        .collection('mileageExpense')
        .snapshots();
  }

  Future<MileageExpense> getMileageExpense(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('mileageExpenses')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
          MileageExpense expense = MileageExpense.fromMap(expenseSnapshot.data());
          expense.documentId = expenseSnapshot.id;
          return expense;
        });
  }

  Future<List<MileageExpense>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('mileageExpenses')
        .get()
        .then((mileageExpenses) => _buildMileageExpensesList(mileageExpenses));
  }



  Future<void> updateMileageExpense(MileageExpense expense) async{
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('mileageExpenses')
          .doc(expense.documentId)
          .update(expense.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<MileageExpense> _buildMileageExpensesList(QuerySnapshot jobs) {
    List<MileageExpense> expensesList = [];
    for(DocumentSnapshot expenseSnapshot in jobs.docs){
      MileageExpense expense = MileageExpense.fromMap(expenseSnapshot.data());
      expense.documentId = expenseSnapshot.id;
      expensesList.add(expense);
    }
    return expensesList;
  }
}