// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as String?,
      type: json['type'] as String? ?? 'Short response',
      question: json['question'] as String?,
      webImageUrl: json['webImageUrl'] as String?,
      mobileImageUrl: json['mobileImageUrl'] as String?,
      showImage: json['showImage'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? true,
      multipleSelection: json['multipleSelection'] as bool? ?? true,
      choicesCheckBoxes: json['choicesCheckBoxes'] as List<dynamic>?,
      answersCheckBoxes: json['answersCheckBoxes'] as List<dynamic>?,
      includeOtherCheckBoxes: json['includeOtherCheckBoxes'] as bool? ?? false,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      instagramName: json['instagramName'] as String?,
      includeFirstName: json['includeFirstName'] as bool? ?? true,
      includeLastName: json['includeLastName'] as bool? ?? true,
      includePhone: json['includePhone'] as bool? ?? true,
      includeEmail: json['includeEmail'] as bool? ?? true,
      includeInstagramName: json['includeInstagramName'] as bool? ?? true,
      address: json['address'] as String?,
      addressLine2: json['addressLine2'] as String?,
      cityTown: json['cityTown'] as String?,
      stateRegionProvince: json['stateRegionProvince'] as String?,
      zipPostCode: json['zipPostCode'] as String?,
      country: json['country'] as String?,
      addressRequired: json['addressRequired'] as bool? ?? true,
      cityTownRequired: json['cityTownRequired'] as bool? ?? true,
      stateRegionProvinceRequired:
          json['stateRegionProvinceRequired'] as bool? ?? true,
      zipPostCodeRequired: json['zipPostCodeRequired'] as bool? ?? true,
      countryRequired: json['countryRequired'] as bool? ?? true,
      shortAnswer: json['shortAnswer'] as String?,
      shortHint: json['shortHint'] as String?,
      longAnswer: json['longAnswer'] as String?,
      longHint: json['longHint'] as String?,
      ratingDescription: json['ratingDescription'] as String?,
      numOfStars: (json['numOfStars'] as num?)?.toInt(),
      ratingAnswer: (json['ratingAnswer'] as num?)?.toInt(),
      selectedDate: json['selectedDate'] == null
          ? null
          : DateTime.parse(json['selectedDate'] as String),
      month: (json['month'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      number: (json['number'] as num?)?.toInt(),
      yesSelected: json['yesSelected'] as bool? ?? true,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'question': instance.question,
      'webImageUrl': instance.webImageUrl,
      'mobileImageUrl': instance.mobileImageUrl,
      'showImage': instance.showImage,
      'isRequired': instance.isRequired,
      'choicesCheckBoxes': instance.choicesCheckBoxes,
      'answersCheckBoxes': instance.answersCheckBoxes,
      'includeOtherCheckBoxes': instance.includeOtherCheckBoxes,
      'multipleSelection': instance.multipleSelection,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'instagramName': instance.instagramName,
      'includeFirstName': instance.includeFirstName,
      'includeLastName': instance.includeLastName,
      'includePhone': instance.includePhone,
      'includeEmail': instance.includeEmail,
      'includeInstagramName': instance.includeInstagramName,
      'address': instance.address,
      'addressLine2': instance.addressLine2,
      'cityTown': instance.cityTown,
      'stateRegionProvince': instance.stateRegionProvince,
      'zipPostCode': instance.zipPostCode,
      'country': instance.country,
      'addressRequired': instance.addressRequired,
      'cityTownRequired': instance.cityTownRequired,
      'stateRegionProvinceRequired': instance.stateRegionProvinceRequired,
      'zipPostCodeRequired': instance.zipPostCodeRequired,
      'countryRequired': instance.countryRequired,
      'shortAnswer': instance.shortAnswer,
      'shortHint': instance.shortHint,
      'longAnswer': instance.longAnswer,
      'longHint': instance.longHint,
      'ratingDescription': instance.ratingDescription,
      'numOfStars': instance.numOfStars,
      'ratingAnswer': instance.ratingAnswer,
      'selectedDate': instance.selectedDate?.toIso8601String(),
      'month': instance.month,
      'day': instance.day,
      'year': instance.year,
      'number': instance.number,
      'yesSelected': instance.yesSelected,
    };
