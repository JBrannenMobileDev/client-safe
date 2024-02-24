
import 'Question.dart';

/// Questionnaires can be saved in 3 different places in this app.
/// 1. QuestionnaireDao - In our local database. These are just the templates. They
///    will not be connected to any jobs or have any answers
/// 2. In the Proposal object in a Job object. These will be specific for that
///    job and can potentially contain answers.
/// 3. In the user Profile object. These are questionnaires that were sent directly
///    without connecting them to a job/user. These may also include answers.
class Questionnaire {

  int id;
  String documentId;
  String title;
  String message;
  List<Question> questions;
  bool isComplete;
  DateTime dateCompleted;

  String getMainImageUrl() {
    return questions.isNotEmpty ? questions.first.webImageUrl : '';
  }

  double getLengthInMinutes() {
    double result = 0;
    for(Question question in questions) {
      switch(question.type) {
        case Question.TYPE_NUMBER:
          result = result + 0.25;
          break;
        case Question.TYPE_SHORT_FORM_RESPONSE:
          result = result + 0.35;
          break;
        case Question.TYPE_LONG_FORM_RESPONSE:
          result = result + 1;
          break;
        case Question.TYPE_CONTACT_INFO:
          if(question.includeFirstName) result = result + 0.15;
          if(question.includeLastName) result = result + 0.15;
          if(question.includeEmail) result = result + 0.15;
          if(question.includePhone) result = result + 0.15;
          if(question.includeInstagramName) result = result + 0.25;
          break;
        case Question.TYPE_ADDRESS:
          result = result + 0.35;
          break;
        case Question.TYPE_DATE:
          result = result + 0.25;
          break;
        case Question.TYPE_RATING:
          result = result + 0.15;
          break;
        case Question.TYPE_YES_NO:
          result = result + 0.10;
          break;
        case Question.TYPE_CHECK_BOXES:
          if(question.choicesCheckBoxes.length <= 10) {
            result = result + 0.35;
          } else {
            result = result + 0.60;
          }
          break;
      }
    }
    return result;
  }

  Questionnaire({
    this.id,
    this.documentId,
    this.title,
    this.message,
    this.questions,
    this.isComplete,
    this.dateCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'title' : title,
      'message' : message,
      'questions' : convertQuestionsToMap(questions),
      'isComplete' : isComplete,
      'dateCompleted' : dateCompleted?.toString() ?? "",
    };
  }

  static Questionnaire fromMap(Map<String, dynamic> map) {
    return Questionnaire(
      id: map['id'],
      documentId: map['documentId'],
      title: map['title'],
      message: map['message'],
      questions: convertMapsToQuestions(map['questions']) ?? [],
      isComplete: map['isComplete'] ?? false,
      dateCompleted: map['dateCompleted'] != "" && map['dateCompleted'] != null ? DateTime.parse(map['dateCompleted']) : null,
    );
  }

  List<Map<String, dynamic>> convertQuestionsToMap(List<Question> questions){
    List<Map<String, dynamic>> listOfMaps = [];
    for(Question question in questions){
      listOfMaps.add(question.toMap());
    }
    return listOfMaps;
  }

  static List<Question> convertMapsToQuestions(List listOfMaps){
    List<Question> listOfQuestions = [];
    for(Map map in listOfMaps){
      listOfQuestions.add(Question.fromMap(map));
    }
    return listOfQuestions;
  }
}