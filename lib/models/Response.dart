import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';

class Response{
  static const String GROUP_TITLE_PRE_BOOKING = 'Pre Booking';
  static const String GROUP_TITLE_PRE_PHOTOSHOOT = 'Pre Photoshoot';
  static const String GROUP_TITLE_POST_PHOTOSHOOT = 'Post Photoshoot';

  int id;
  String documentId;
  String title;
  String message;
  String parentGroup;
  String buttonName;

  Response({
    this.id,
    this.title,
    this.message,
    this.parentGroup,
    this.documentId,
    this.buttonName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'documentId' : documentId,
      'title' : title,
      'message' : message,
      'parentGroup' : parentGroup,
      'buttonName' : buttonName,
    };
  }

  static Response fromMap(Map<String, dynamic> map) {
    return Response(
      id: map['id'],
      documentId: map['documentId'],
      title: map['title'],
      message: map['message'],
      parentGroup: map['parentGroup'],
      buttonName: map['buttonName'],
    );
  }
}