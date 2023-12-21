
import 'Question.dart';

class Questionnaire {

  int id;
  String documentId;
  String title;
  List<Question> questions;
  bool isComplete;
  DateTime dateCompleted;

  String getMainImageUrl() {
    return questions.isNotEmpty ? questions.first.imageUrl : '';
  }

  Questionnaire({
    this.id,
    this.documentId,
    this.title,
    this.questions,
    this.isComplete,
    this.dateCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'title' : title,
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