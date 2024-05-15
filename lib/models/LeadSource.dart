import 'package:flutter/widgets.dart';

class LeadSource{
  static const String TYPE_INSTAGRAM = "Instagram";
  static const String TYPE_FACEBOOK = "Facebook";
  static const String TYPE_TIKTOK = "TikTok";
  static const String TYPE_YOUTUBE = "YouTube";
  static const String TYPE_TWITTER = "Twitter";
  static const String TYPE_WORD_OF_MOUTH = "Word of mouth";
  static const String TYPE_WEB_SEARCH = "Web search";
  static const String TYPE_APP_STORE = "App store";
  static const String TYPE_EMAIL = "Email";
  static const String TYPE_OTHER = "Other";
  static const String TYPE_REDDIT = "Reddit";
  static const String TYPE_SKIP = "Skip";
  static const String TYPE_DANDYLIGHT_BLOG = "Dandylight Blog";
  static const String TYPE_PINTEREST = "Pinterest";

  final DateTime? date;
  final String? type;
  final int? chipIndex;

  LeadSource({
    @required this.date,
    @required this.type,
    @required this.chipIndex
  });

  Map<String, dynamic> toMap() {
    return {
      'date' : date!.millisecondsSinceEpoch,
      'type' : type,
      'chipIndex' : chipIndex
    };
  }

  static LeadSource fromMap(Map<String, dynamic> map) {
    return LeadSource(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      type: map['type'],
      chipIndex: map['chipIndex'],
    );
  }
}