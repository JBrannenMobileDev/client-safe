
import 'package:dandylight/utils/UUID.dart';
import 'package:flutter/widgets.dart';

class Question {
  static const String TYPE_MULTIPLE_CHOICE = 'Multiple choice';
  static const String TYPE_CONTACT_INFO = 'Contact info';
  static const String TYPE_SHORT_FORM_RESPONSE = 'Short response';
  static const String TYPE_LONG_FORM_RESPONSE = 'Long response';
  static const String TYPE_ADDRESS = 'Address';
  static const String TYPE_RATING = 'Rating';
  static const String TYPE_DATE = 'Date';
  static const String TYPE_NUMBER = 'Number';
  static const String TYPE_YES_NO = 'Yes/No';
  static const String TYPE_CHECK_BOXES = 'Checkboxes';

  String id = Uuid().generateV4();
  String type;
  String question;
  String imageUrl;
  bool showImage;
  bool isRequired;
  bool isAnswered;

  //MultipleChoice
  List<dynamic> choicesMultipleChoice;
  String answerMultipleChoice;
  bool includeOtherMultipleChoice;

  //CheckBoxes
  List<dynamic> choicesCheckBoxes;
  List<dynamic> answersCheckBoxes;
  bool includeOtherCheckBoxes;

  //Contact info
  String firstName;
  String lastName;
  String phone;
  String email;
  String instagramName;
  bool includeFirstName;
  bool includeLastName;
  bool includePhone;
  bool includeEmail;
  bool includeInstagramName;

  //Address
  String address;
  String addressLine2;
  String cityTown;
  String stateRegionProvince;
  String zipPostCode;
  String country;

  //Short form
  String shortAnswer;
  String shortHint;

  //Long form
  String longAnswer;
  String longHint;

  //Rating
  String ratingDescription;
  int numOfStars;
  int ratingAnswer;

  //Date
  DateTime selectedDate;
  int month;
  int day;
  int year;

  //Number
  int number;

  //Yes/No
  bool yesSelected;


  Question({
    this.id,
    this.type,
    this.question,
    this.imageUrl,
    this.showImage,
    this.isRequired,
    this.isAnswered,

    this.choicesMultipleChoice,
    this.answerMultipleChoice,
    this.includeOtherMultipleChoice,

    this.choicesCheckBoxes,
    this.answersCheckBoxes,
    this.includeOtherCheckBoxes,

    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.instagramName,
    this.includeFirstName,
    this.includeLastName,
    this.includePhone,
    this.includeEmail,
    this.includeInstagramName,

    this.address,
    this.addressLine2,
    this.cityTown,
    this.stateRegionProvince,
    this.zipPostCode,
    this.country,

    this.shortAnswer,
    this.shortHint,

    this.longAnswer,
    this.longHint,

    this.ratingDescription,
    this.numOfStars,
    this.ratingAnswer,

    this.selectedDate,
    this.month,
    this.day,
    this.year,

    this.number,

    this.yesSelected,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id ?? Uuid().generateV4(),
      'type' : type,
      'question' : question,
      'imageUrl' : imageUrl,
      'showImage' : showImage ?? false,
      'isRequired' : isRequired,
      'isAnswered' : isAnswered,

      'choicesMultipleChoice' : choicesMultipleChoice,
      'answerMultipleChoice' : answerMultipleChoice,
      'includeOtherMultipleChoice' : includeOtherMultipleChoice,

      'choicesCheckBoxes' : choicesCheckBoxes,
      'answersCheckBoxes' : answersCheckBoxes,
      'includeOtherCheckBoxes' : includeOtherCheckBoxes,

      'firstName' : firstName,
      'lastName' : lastName,
      'phone' : phone,
      'email' : email,
      'instagramName' : instagramName,
      'includeFirstName' : includeFirstName,
      'includeLastName' : includeLastName,
      'includePhone' : includePhone,
      'includeEmail' : includeEmail,
      'includeInstagramName' : includeInstagramName,

      'address' : address,
      'addressLine2' : addressLine2,
      'cityTown' : cityTown,
      'stateRegionProvince' : stateRegionProvince,
      'zipPostCode' : zipPostCode,
      'country' : country,

      'shortAnswer' : shortAnswer,
      'shortHint' : shortHint,

      'longAnswer' : longAnswer,
      'longHint' : longHint,

      'ratingDescription' : ratingDescription,
      'numOfStars' : numOfStars,
      'ratingAnswer' : ratingAnswer,

      'selectedDate' : selectedDate,
      'month' : month,
      'day' : day,
      'year' : year,

      'number' : number,

      'yesSelected' : yesSelected,
    };
  }

  static Question fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? Uuid().generateV4(),
      type: map['type'],
      question: map['question'],
      imageUrl: map['imageUrl'],
      showImage: map['showImage'] ?? false,
      isRequired: map['isRequired'],
      isAnswered: map['isAnswered'],

      choicesMultipleChoice: map['choicesMultipleChoice'],
      answerMultipleChoice: map['answerMultipleChoice'],
      includeOtherMultipleChoice: map['includeOtherMultipleChoice'],

      choicesCheckBoxes: map['choicesCheckBoxes'],
      answersCheckBoxes: map['answersCheckBoxes'],
      includeOtherCheckBoxes: map['includeOtherCheckBoxes'],

      firstName: map['firstName'],
      lastName: map['lastName'],
      phone: map['phone'],
      email: map['email'],
      instagramName: map['instagramName'],
      includeFirstName: map['includeFirstName'],
      includeLastName: map['includeLastName'],
      includePhone: map['includePhone'],
      includeEmail: map['includeEmail'],
      includeInstagramName: map['includeInstagramName'],

      address: map['address'],
      addressLine2: map['addressLine2'],
      cityTown: map['cityTown'],
      stateRegionProvince: map['stateRegionProvince'],
      zipPostCode: map['zipPostCode'],
      country: map['country'],

      shortAnswer: map['shortAnswer'],
      shortHint: map['shortHint'],

      longAnswer: map['longAnswer'],
      longHint: map['longHint'],

      ratingDescription: map['ratingDescription'],
      numOfStars: map['numOfStars'],
      ratingAnswer: map['ratingAnswer'],

      selectedDate: map['selectedDate'],
      day: map['day'],
      month: map['month'],
      year: map['year'],

      number: map['number'],

      yesSelected: map['yesSelected'],
    );
  }

  Widget getSettingsWidgetMobile() {
    return const SizedBox();
  }

  Widget getAnswerWidget() {
    return const SizedBox();
  }
}