import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:flutter/widgets.dart';

import 'Response.dart';

class ResponsesListItem{
  static const String RESPONSE = 'response';
  static const String GROUP_TITLE = 'group_title';
  static const String ADD_ANOTHER_BUTTON = 'add_another_button';
  static const String NO_SAVED_RESPONSES = 'no_saved_responses';

  String itemType;
  String title;
  String groupName;
  Response response;

  ResponsesListItem({
    this.itemType,
    this.title,
    this.response,
    this.groupName,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemType' : itemType,
      'title' : title,
      'response' : response?.toMap() ?? null,
      'groupName' : groupName,
    };
  }

  static ResponsesListItem fromMap(Map<String, dynamic> map) {
    return ResponsesListItem(
      itemType: map['itemType'],
      title: map['title'],
      groupName: map['groupName'],
      response: map['response'] != null ? Response.fromMap(map['response']) : null,
    );
  }
}