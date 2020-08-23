import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

class JobReminderCollection {
  Future<void> createReminder(JobReminder reminder) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobReminders')
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
          .collection('jobReminders')
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
        .collection('jobReminders')
        .snapshots();
  }

  Future<JobReminder> getReminder(String documentId) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobReminders')
        .document(documentId)
        .get()
        .then((expenseSnapshot) {
          JobReminder reminder = JobReminder.fromMap(expenseSnapshot.data);
          reminder.documentId = expenseSnapshot.documentID;
          return reminder;
        });
  }

  Future<List<JobReminder>> getAll(String uid) async {
    final databaseReference = Firestore.instance;
    return await databaseReference
        .collection('users')
        .document(UidUtil().getUid())
        .collection('jobReminders')
        .getDocuments()
        .then((reminders) => _buildRemindersList(reminders));
  }



  Future<void> updateReminder(JobReminder reminder) async {
    try {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection('users')
          .document(UidUtil().getUid())
          .collection('jobReminders')
          .document(reminder.documentId)
          .updateData(reminder.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<JobReminder> _buildRemindersList(QuerySnapshot reminders) {
    List<JobReminder> remindersList = List();
    for(DocumentSnapshot reminderSnapshot in reminders.documents){
      JobReminder reminder = JobReminder.fromMap(reminderSnapshot.data);
      reminder.documentId = reminderSnapshot.documentID;
      remindersList.add(reminder);
    }
    return remindersList;
  }
}