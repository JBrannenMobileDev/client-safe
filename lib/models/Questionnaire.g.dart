// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Questionnaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Questionnaire _$QuestionnaireFromJson(Map<String, dynamic> json) =>
    Questionnaire(
      id: (json['id'] as num?)?.toInt(),
      documentId: json['documentId'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      isComplete: json['isComplete'] as bool?,
      dateCompleted: json['dateCompleted'] == null
          ? null
          : DateTime.parse(json['dateCompleted'] as String),
      jobDocumentId: json['jobDocumentId'] as String?,
      isReviewed: json['isReviewed'] as bool?,
      dateCreated: json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String),
      isTemplate: json['isTemplate'] as bool?,
      clientName: json['clientName'] as String?,
    );

Map<String, dynamic> _$QuestionnaireToJson(Questionnaire instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'jobDocumentId': instance.jobDocumentId,
      'title': instance.title,
      'clientName': instance.clientName,
      'message': instance.message,
      'questions': instance.questions?.map((e) => e.toJson()).toList(),
      'isComplete': instance.isComplete,
      'isReviewed': instance.isReviewed,
      'isTemplate': instance.isTemplate,
      'dateCompleted': instance.dateCompleted?.toIso8601String(),
      'dateCreated': instance.dateCreated?.toIso8601String(),
    };
