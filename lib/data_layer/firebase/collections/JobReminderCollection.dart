import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class JobReminderCollection {
  Future<void> createReminder(JobReminder reminder) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobReminders')
        .doc(reminder.documentId)
        .set(reminder.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteReminder(String? documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('jobReminders')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getReminderStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobReminders')
        .snapshots();
  }

  Future<JobReminder> getReminder(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobReminders')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
          JobReminder reminder = JobReminder.fromMap(expenseSnapshot.data() as Map<String, dynamic>);
          reminder.documentId = expenseSnapshot.id;
          return reminder;
        });
  }

  Future<List<JobReminder>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('jobReminders')
        .get()
        .then((reminders) => _buildRemindersList(reminders));
  }



  Future<void> updateReminder(JobReminder reminder) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('jobReminders')
          .doc(reminder.documentId)
          .update(reminder.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<JobReminder> _buildRemindersList(QuerySnapshot reminders) {
    List<JobReminder> remindersList = [];
    for(DocumentSnapshot reminderSnapshot in reminders.docs){
      JobReminder reminder = JobReminder.fromMap(reminderSnapshot.data() as Map<String, dynamic>);
      reminder.documentId = reminderSnapshot.id;
      remindersList.add(reminder);
    }
    return remindersList;
  }
}