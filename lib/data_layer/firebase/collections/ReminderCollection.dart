import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class ReminderCollection {
  Future<void> createReminder(Reminder reminder) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('reminders')
        .document(reminder.documentId)
        .setData(reminder.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteReminder(String documentId) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('reminders')
          .document(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getReminderStream() {
    return Firestore.instance
        .collection('users')
        .document(UidUtil().getUid())
        .collection('reminders')
        .snapshots();
  }

  Future<Reminder> getReminder(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('reminders')
        .document(documentId)
        .get()
        .then((expenseSnapshot) {
          Reminder reminder = Reminder.fromMap(expenseSnapshot.data);
          reminder.documentId = expenseSnapshot.documentID;
          return reminder;
        });
  }

  Future<List<Reminder>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('reminders')
        .getDocuments()
        .then((reminders) => _buildRemindersList(reminders));
  }



  Future<void> updateReminder(Reminder reminder) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('reminders')
          .document(reminder.documentId)
          .updateData(reminder.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Reminder> _buildRemindersList(QuerySnapshot reminders) {
    List<Reminder> remindersList = List();
    for(DocumentSnapshot reminderSnapshot in reminders.documents){
      Reminder reminder = Reminder.fromMap(reminderSnapshot.data);
      reminder.documentId = reminderSnapshot.documentID;
      remindersList.add(reminder);
    }
    return remindersList;
  }
}