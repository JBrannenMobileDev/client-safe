import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/SessionType.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../utils/EnvironmentUtil.dart';

class SessionTypesCollection {
  Future<void> createSessionType(SessionType sessionType) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('sessionTypes')
        .doc(sessionType.documentId)
        .set(sessionType.toMap()).catchError((error) {
          print(error);
        });
  }

  Future<void> deleteSessionType(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('sessionTypes')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getSessionTypesStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('sessionTypes')
        .snapshots();
  }

  Future<SessionType> getSessionType(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('sessionTypes')
        .doc(documentId)
        .get()
        .then((expenseSnapshot) {
          SessionType sessionType = SessionType.fromMap(expenseSnapshot.data() as Map<String, dynamic>);
          sessionType.documentId = expenseSnapshot.id;
          return sessionType;
        });
  }

  Future<List<SessionType>?> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('sessionTypes')
        .get()
        .then((sessionTypes) => _buildSessionTypesList(sessionTypes));
  }



  Future<void> updateSessionType(SessionType sessionType) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('sessionTypes')
          .doc(sessionType.documentId)
          .update(sessionType.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<SessionType> _buildSessionTypesList(QuerySnapshot sessionTypes) {
    List<SessionType> sessionTypesList = [];
    for(DocumentSnapshot sessionTypesSnapshot in sessionTypes.docs){
      SessionType sessionType = SessionType.fromMap(sessionTypesSnapshot.data() as Map<String, dynamic>);
      sessionType.documentId = sessionTypesSnapshot.id;
      sessionTypesList.add(sessionType);
    }
    return sessionTypesList;
  }
}