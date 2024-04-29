
import 'package:dandylight/utils/UUID.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/DeviceType.dart';

class Question {
  static const String TYPE_CONTACT_INFO = 'Contact info';
  static const String TYPE_SHORT_FORM_RESPONSE = 'Short response';
  static const String TYPE_LONG_FORM_RESPONSE = 'Long response';
  static const String TYPE_ADDRESS = 'Address';
  static const String TYPE_RATING = 'Rating';
  static const String TYPE_DATE = 'Date';
  static const String TYPE_NUMBER = 'Number';
  static const String TYPE_YES_NO = 'Yes/No';
  static const String TYPE_CHECK_BOXES = 'Checkboxes';

  static List<String> allTypes() {
    return [
      TYPE_SHORT_FORM_RESPONSE,
      TYPE_LONG_FORM_RESPONSE,
      TYPE_CONTACT_INFO,
      TYPE_CHECK_BOXES,
      TYPE_NUMBER,
      TYPE_YES_NO,
      TYPE_RATING,
      TYPE_DATE,
      TYPE_ADDRESS,
    ];
  }

  String? id;
  String? type;
  String? question;
  String? webImageUrl;
  String? mobileImageUrl;
  bool? showImage;
  bool? isRequired;
  XFile? webImage;
  XFile? mobileImage;

  //CheckBoxes
  List<dynamic>? choicesCheckBoxes;
  List<dynamic>? answersCheckBoxes;
  bool? includeOtherCheckBoxes;
  bool? multipleSelection;

  //Contact info
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? instagramName;
  bool? includeFirstName;
  bool? includeLastName;
  bool? includePhone;
  bool? includeEmail;
  bool? includeInstagramName;

  //Address
  String? address;
  String? addressLine2;
  String? cityTown;
  String? stateRegionProvince;
  String? zipPostCode;
  String? country;
  bool? addressRequired;
  bool? cityTownRequired;
  bool? stateRegionProvinceRequired;
  bool? zipPostCodeRequired;
  bool? countryRequired;

  //Short form
  String? shortAnswer;
  String? shortHint;

  //Long form
  String? longAnswer;
  String? longHint;

  //Rating
  String? ratingDescription;
  int? numOfStars;
  int? ratingAnswer;

  //Date
  DateTime? selectedDate;
  int? month;
  int? day;
  int? year;

  //Number
  int? number;

  //Yes/No
  bool yesSelected;


  Question({
    this.id,
    this.type = TYPE_SHORT_FORM_RESPONSE,
    this.question,
    this.webImageUrl,
    this.mobileImageUrl,
    this.showImage = true,
    this.isRequired = true,
    this.mobileImage,
    this.webImage,

    this.multipleSelection = true,
    this.choicesCheckBoxes,
    this.answersCheckBoxes,
    this.includeOtherCheckBoxes = false,

    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.instagramName,
    this.includeFirstName = true,
    this.includeLastName = true,
    this.includePhone = true,
    this.includeEmail = true,
    this.includeInstagramName = true,

    this.address,
    this.addressLine2,
    this.cityTown,
    this.stateRegionProvince,
    this.zipPostCode,
    this.country,
    this.addressRequired = true,
    this.cityTownRequired = true,
    this.stateRegionProvinceRequired = true,
    this.zipPostCodeRequired = true,
    this.countryRequired = true,

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

    this.yesSelected = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id ?? Uuid().generateV4(),
      'type' : type,
      'question' : question,
      'webImageUrl' : webImageUrl,
      'mobileImageUrl' : mobileImageUrl,
      'showImage' : showImage ?? false,
      'isRequired' : isRequired,

      'multipleSelection' : multipleSelection,
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
      'addressRequired' : addressRequired,
      'cityTownRequired' : cityTownRequired,
      'stateRegionProvinceRequired' : stateRegionProvinceRequired,
      'zipPostCodeRequired' : zipPostCodeRequired,
      'countryRequired' : countryRequired,

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
      webImageUrl: map['webImageUrl'],
      mobileImageUrl: map['mobileImageUrl'],
      showImage: map['showImage'] ?? false,
      isRequired: map['isRequired'],

      multipleSelection: map['multipleSelection'],
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
      addressRequired: map['addressRequired'],
      cityTownRequired: map['cityTownRequired'],
      stateRegionProvinceRequired: map['stateRegionProvinceRequired'],
      zipPostCodeRequired: map['zipPostCodeRequired'],
      countryRequired: map['countryRequired'],

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

      yesSelected: map['yesSelected'] ?? true,
    );
  }

  Widget getSettingsWidgetMobile() {
    return const SizedBox();
  }

  bool hasImage() {
    return (showImage ?? false) && ((mobileImageUrl != null && mobileImageUrl!.isNotEmpty) && (webImageUrl != null && webImageUrl!.isNotEmpty));
  }

  bool isAnswered() {
    bool isAnswered = false;
    switch(type) {
      case TYPE_SHORT_FORM_RESPONSE:
        isAnswered = shortAnswer != null && shortAnswer!.isNotEmpty;
        break;
      case TYPE_LONG_FORM_RESPONSE:
        isAnswered = longAnswer != null && longAnswer!.isNotEmpty;
        break;
      case TYPE_CONTACT_INFO:
        isAnswered = isContactItemAnswered(firstName, includeFirstName)
          && isContactItemAnswered(lastName, includeLastName)
          && isContactItemAnswered(phone, includePhone)
          && isContactItemAnswered(email, includeEmail)
          && isContactItemAnswered(instagramName, includeInstagramName);
        break;
      case TYPE_NUMBER:
        isAnswered = number != null;
        break;
      case TYPE_YES_NO:
        isAnswered = true;
        break;
      case TYPE_CHECK_BOXES:
        isAnswered = answersCheckBoxes?.isNotEmpty ?? false;
        break;
      case TYPE_RATING:
        isAnswered = (ratingAnswer ?? 0) > 0;
        break;
    }
    return isAnswered;
  }

  bool isContactItemAnswered(String? answer, bool? isIncluded) {
    if(isIncluded ?? false) {
      return answer != null && answer.isNotEmpty;
    } else {
      return true;
    }
  }

  bool hasItemChecked(String? item) {
    if(item != null) {
      return answersCheckBoxes?.contains(item) ?? false;
    } else {
      return false;
    }
  }
}