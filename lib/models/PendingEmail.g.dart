// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PendingEmail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingEmail _$PendingEmailFromJson(Map<String, dynamic> json) => PendingEmail(
      id: (json['id'] as num?)?.toInt(),
      documentId: json['documentId'] as String?,
      sendDate: DateTime.parse(json['sendDate'] as String),
      emailType: json['type'] as String,
      toAddress: json['toAddress'] as String,
      uid: json['uid'] as String,
      photographerName: json['photographerName'] as String,
    );

Map<String, dynamic> _$PendingEmailToJson(PendingEmail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'sendDate': instance.sendDate.toIso8601String(),
      'type': instance.emailType,
      'toAddress': instance.toAddress,
      'photographerName': instance.photographerName,
      'uid': instance.uid,
    };
