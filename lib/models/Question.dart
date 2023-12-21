
class Question {

  int id;
  String question;
  String imageUrl;

  Question({
    this.id,
    this.question,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'question' : question,
      'imageUrl' : imageUrl,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      question: map['question'],
      imageUrl: map['imageUrl'],
    );
  }
}