import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/utils/UidUtil.dart';

import '../../../models/Contract.dart';
import '../../../models/Questionnaire.dart';
import '../../../utils/EnvironmentUtil.dart';

class QuestionnaireTemplateCollection {
  Future<void> createQuestionnaire(Questionnaire questionnaire) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('questionnaireTemplates')
        .doc(questionnaire.documentId)
        .set(questionnaire.toMap());
  }

  Future<void> deleteQuestionnaire(String? documentId) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('questionnaireTemplates')
          .doc(documentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Questionnaire> getQuestionnaire(String documentId) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('questionnaireTemplates')
        .doc(documentId)
        .get()
        .then((questionnaireSnapshot) {
          Questionnaire result = Questionnaire.fromMap(questionnaireSnapshot.data() as Map<String, dynamic>);
          result.documentId = questionnaireSnapshot.id;
          return result;
        });
  }

  Future<List<Questionnaire>?> getAll(String uid) async {
    final databaseReference = FirebaseFirestore.instance;
    return await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('questionnaireTemplates')
        .get()
        .then((jobs) => _buildQuestionnairesList(jobs));
  }



  Future<void> updateQuestionnaire(Questionnaire questionnaire) async {
    try {
      final databaseReference = FirebaseFirestore.instance;
      await databaseReference
          .collection('env')
          .doc(EnvironmentUtil().getCurrentEnvironment())
          .collection('questionnaireTemplates')
          .doc(questionnaire.documentId)
          .update(questionnaire.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Questionnaire> _buildQuestionnairesList(QuerySnapshot questionnaires) {
    List<Questionnaire> questionnairesList = [];
    for(DocumentSnapshot questionnaireSnapshot in questionnaires.docs){
      Questionnaire result = Questionnaire.fromMap(questionnaireSnapshot.data() as Map<String, dynamic>);
      result.documentId = questionnaireSnapshot.id;
      questionnairesList.add(result);
    }
    return questionnairesList;
  }
}