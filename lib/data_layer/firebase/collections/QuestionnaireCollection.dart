import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../models/Questionnaire.dart';
import '../../../utils/EnvironmentUtil.dart';

class QuestionnaireCollection {
  Future<void> create(Questionnaire questionnaire) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('questionnaires')
        .doc(questionnaire.documentId)
        .set(questionnaire.toMap());
  }

  Future<void> delete(String documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('questionnaires')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getStream() {
    return FirebaseFirestore.instance
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('questionnaires')
        .snapshots();
  }

  Future<Questionnaire> get(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('questionnaires')
        .doc(documentId)
        .get()
        .then((snapshot) {
          Questionnaire result = Questionnaire.fromMap(snapshot.data());
          result.documentId = snapshot.id;
          return result;
        });
  }

  Future<List<Questionnaire>> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('users')
        .doc(UidUtil().getUid())
        .collection('questionnaires')
        .get()
        .then((jobs) => _buildQuestionnairesList(jobs));
  }



  Future<void> update(Questionnaire questionnaire) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('users')
          .doc(UidUtil().getUid())
          .collection('questionnaires')
          .doc(questionnaire.documentId)
          .update(questionnaire.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Questionnaire> _buildQuestionnairesList(QuerySnapshot contracts) {
    List<Questionnaire> list = [];
    for(DocumentSnapshot snapshot in contracts.docs){
      Questionnaire result = Questionnaire.fromMap(snapshot.data());
      result.documentId = snapshot.id;
      list.add(result);
    }
    return list;
  }
}