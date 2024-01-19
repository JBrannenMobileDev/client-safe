
import 'package:flutter/widgets.dart';

class Question {
  static const String TYPE_MULTIPLE_CHOICE = 'Multiple choice';
  static const String TYPE_CONTACT_INFO = 'Contact info';
  static const String TYPE_SHORT_FORM_RESPONSE = 'Short response';
  static const String TYPE_LONG_FORM_RESPONSE = 'Long response';

  int id;
  String type;
  String question;
  String imageUrl;
  bool showImage;
  bool isRequired;


  //MultipleChoice
  List<String> choices;
  List<String> answers;
  bool includeOther;

  //Contact info
  String firstName;
  String lastName;
  String phone;
  String email;
  String address;
  String instagramName;

  //Short form
  String shortAnswer;
  String shortHint;

  //Long form
  String longAnswer;
  String longHint;

  Question({
    this.id,
    this.type,
    this.question,
    this.imageUrl,
    this.showImage,
    this.isRequired,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'type' : type,
      'question' : question,
      'imageUrl' : imageUrl,
      'showImage' : showImage,
      'isRequired' : isRequired,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      type: map['type'],
      question: map['question'],
      imageUrl: map['imageUrl'],
      showImage: map['showImage'],
      isRequired: map['isRequired'],
    );
  }

  Widget getSettingsWidgetMobile() {
    return const SizedBox();
  }

  Widget getAnswerWidget() {
    return const SizedBox();
  }
}