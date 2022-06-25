import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class ReminderCollection {
  Future<void> createReminder(Reminder reminder) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('reminders')
        .doc(reminder.documentId)
        .set(reminder.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteReminder(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('reminders')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getReminderStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('reminders')
        .snapshots();
  }

  Future<Reminder> getReminder(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('reminders')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
          Reminder reminder = Reminder.fromMap(expenseSnapshot.data());
          reminder.documentId = expenseSnapshot.id;
          return reminder;
        });
  }

  Future<List<Reminder>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('reminders')
        .get()
        .then((reminders) => _buildRemindersList(reminders));
  }



  Future<void> updateReminder(Reminder reminder) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('reminders')
          .doc(reminder.documentId)
          .update(reminder.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Reminder> _buildRemindersList(QuerySnapshot reminders) {
    List<Reminder> remindersList = [];
    for(DocumentSnapshot reminderSnapshot in reminders.docs){
      Reminder reminder = Reminder.fromMap(reminderSnapshot.data());
      reminder.documentId = reminderSnapshot.id;
      remindersList.add(reminder);
    }
    return remindersList;
  }
}