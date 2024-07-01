import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/PendingEmail.dart';
import '../../../utils/EnvironmentUtil.dart';

class PendingEmailCollection {
  Future<void> createPendingEmail(PendingEmail pendingEmail) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('pendingEmails')
        .doc(pendingEmail.documentId)
        .set(pendingEmail.toMap());
  }

  Future<void> delete(String? documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('pendingEmails')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<PendingEmail> getPendingEmail(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('pendingEmails')
        .doc(documentId)
        .get()
        .then((pendingEmailSnapshot) {
          PendingEmail result = PendingEmail.fromMap(pendingEmailSnapshot.data() as Map<String, dynamic>);
          result.documentId = pendingEmailSnapshot.id;
          return result;
        });
  }

  Future<List<PendingEmail>?> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('pendingEmails')
        .get()
        .then((jobs) => _buildPendingEmailsList(jobs));
  }



  Future<void> updatePendingEmail(PendingEmail pendingEmail) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('pendingEmails')
          .doc(pendingEmail.documentId)
          .update(pendingEmail.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<PendingEmail> _buildPendingEmailsList(QuerySnapshot pendingEmails) {
    List<PendingEmail> pendingEmailsList = [];
    for(DocumentSnapshot pendingEmailSnapshot in pendingEmails.docs){
      PendingEmail result = PendingEmail.fromMap(pendingEmailSnapshot.data() as Map<String, dynamic>);
      result.documentId = pendingEmailSnapshot.id;
      pendingEmailsList.add(result);
    }
    return pendingEmailsList;
  }
}