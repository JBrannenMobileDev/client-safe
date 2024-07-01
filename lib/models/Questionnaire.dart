
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'Question.dart';
part 'Questionnaire.g.dart';
/// Questionnaires can be saved in 3 different places in this app.
/// 1. QuestionnaireDao - In our local database. These are just the templates. They
///    will not be connected to any jobs or have any answers
/// 2. In the Proposal object in a Job object. These will be specific for that
///    job and can potentially contain answers.
/// 3. In the user Profile object. These are questionnaires that were sent directly
///    without connecting them to a job/user. These may also include answers.

@JsonSerializable(explicitToJson: true)
class Questionnaire {

  int? id;
  String? documentId;
  String? jobDocumentId;
  String? title;
  String? clientName;
  String? message;
  List<Question>? questions;
  bool? isComplete;
  bool? isReviewed;
  bool? isTemplate;
  DateTime? dateCompleted;
  DateTime? dateCreated;

  static Questionnaire from(Questionnaire old) {
    return Questionnaire(
      id: old.id,
      documentId: old.documentId,
      jobDocumentId: old.jobDocumentId,
      title: old.title,
      message: old.message,
      clientName: old.clientName,
      questions: old.questions,
      isComplete: old.isComplete,
      isReviewed: old.isReviewed,
      dateCompleted: old.dateCompleted,
      dateCreated: old.dateCreated,
      isTemplate: old.isTemplate,
    );
  }

  factory Questionnaire.fromJson(Map<String, dynamic> json) => _$QuestionnaireFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionnaireToJson(this);

  bool isInProgress() {
    bool result = false;
    for(Question q in questions ?? []) {
      if(q.type != Question.TYPE_YES_NO && q.isAnswered()) result = true;
    }
    return result;
  }

  String getMainImageUrl() {
    return questions!.isNotEmpty ? questions!.first.webImageUrl! : '';
  }

  bool hasImage() {
    for(Question question in questions!) {
      if(question.showImage! && question.mobileImageUrl != null && question.mobileImageUrl!.isNotEmpty) return true;
    }
    return false;
  }

  String getDisplayImageUrl() {
    for(Question question in questions!) {
      if(question.showImage! && question.mobileImageUrl != null && question.mobileImageUrl!.isNotEmpty) return question.mobileImageUrl!;
    }
    return '';
  }

  String getLengthInMinutes() {
    double result = 0;
    if(questions == null) {
      return '';
    }
    for(Question question in questions!) {
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
          if(question.includeFirstName!) result = result + 0.15;
          if(question.includeLastName!) result = result + 0.15;
          if(question.includeEmail!) result = result + 0.15;
          if(question.includePhone!) result = result + 0.15;
          if(question.includeInstagramName!) result = result + 0.25;
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
          if(question.choicesCheckBoxes != null) {
            if(question.choicesCheckBoxes!.length <= 10) {
              result = result + 0.35;
            } else {
              result = result + 0.60;
            }
          }
          break;
      }
    }
    var formatter = NumberFormat('##0');
    if(result < 1) result = 1;
    var resultLow = formatter.format(result);
    var resultHigh = formatter.format(result + (questions!.length > 12 ? 5 : 3));
    return '$resultLow-$resultHigh';
  }

  Questionnaire({
    this.id,
    this.documentId,
    this.title,
    this.message,
    this.questions,
    this.isComplete,
    this.dateCompleted,
    this.jobDocumentId,
    this.isReviewed,
    this.dateCreated,
    this.isTemplate,
    this.clientName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'jobDocumentId' : jobDocumentId,
      'title' : title,
      'message' : message,
      'clientName' : clientName,
      'questions' : convertQuestionsToMap(questions!),
      'isComplete' : isComplete,
      'dateCompleted' : dateCompleted?.toString() ?? "",
      'dateCreated' : dateCreated?.toString() ?? "",
      'isReviewed' : isReviewed,
      'isTemplate' : isTemplate,
    };
  }

  static Questionnaire fromMap(Map<String, dynamic> map) {
    return Questionnaire(
      id: map['id'],
      documentId: map['documentId'],
      jobDocumentId: map['jobDocumentId'],
      title: map['title'],
      message: map['message'],
      clientName: map['clientName'],
      questions: convertMapsToQuestions(map['questions']),
      isComplete: map['isComplete'] ?? false,
      isReviewed: map['isReviewed'] ?? false,
      isTemplate: map['isTemplate'] ?? true,
      dateCompleted: map['dateCompleted'] != "" && map['dateCompleted'] != null ? DateTime.parse(map['dateCompleted']) : null,
      dateCreated: map['dateCreated'] != "" && map['dateCreated'] != null ? DateTime.parse(map['dateCreated']) : null,
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
      listOfQuestions.add(Question.fromMap(map as Map<String,dynamic>));
    }
    return listOfQuestions;
  }
}