import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class ReminderCollection {
  Future<void> createReminder(ReminderDandyLight reminder) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
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
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
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
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('reminders')
        .snapshots();
  }

  Future<ReminderDandyLight> getReminder(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('reminders')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
          ReminderDandyLight reminder = ReminderDandyLight.fromMap(expenseSnapshot.data() as Map<String, dynamic>);
          reminder.documentId = expenseSnapshot.id;
          return reminder;
        });
  }

  Future<List<ReminderDandyLight>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('reminders')
        .get()
        .then((reminders) => _buildRemindersList(reminders));
  }



  Future<void> updateReminder(ReminderDandyLight reminder) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('reminders')
          .doc(reminder.documentId)
          .update(reminder.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<ReminderDandyLight> _buildRemindersList(QuerySnapshot reminders) {
    List<ReminderDandyLight> remindersList = [];
    for(DocumentSnapshot reminderSnapshot in reminders.docs){
      ReminderDandyLight reminder = ReminderDandyLight.fromMap(reminderSnapshot.data() as Map<String, dynamic>);
      reminder.documentId = reminderSnapshot.id;
      remindersList.add(reminder);
    }
    return remindersList;
  }
}