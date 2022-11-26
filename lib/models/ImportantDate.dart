import 'package:flutter/widgets.dart';

class ImportantDate{
  static const String TYPE_ANNIVERSARY = "Anniversary";
  static const String TYPE_GRADUATION = "Graduation";
  static const String TYPE_PREGNANCY_DUE_DATE = "Pregnancy Due Date";
  static const String TYPE_BIRTHDAY = "Birthday";
  static const String TYPE_ENGAGEMENT = "Wedding Engagement";
  static const String TYPE_WEDDING = "Wedding";


  final DateTime date;
  final String type;
  final int chipIndex;

  ImportantDate({
    @required this.date,
    @required this.type,
    @required this.chipIndex
  });

  Map<String, dynamic> toMap() {
    return {
      'date' : date.millisecondsSinceEpoch,
      'type' : type,
      'chipIndex' : chipIndex
    };
  }

  static ImportantDate fromMap(Map<String, dynamic> map) {
    return ImportantDate(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      type: map['type'],
      chipIndex: map['chipIndex'],
    );
  }
}