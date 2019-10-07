class ImportantDate{
  static const String TYPE_ANNIVERSARY = "Anniversary";
  static const String TYPE_GRADUATION = "Graduation";
  static const String TYPE_PREGNANCY_DUE_DATE = "Pregnancy Due Date";
  static const String TYPE_BIRTHDAY = "Birthday";

  final DateTime date;
  final String type;
  final int chipIndex;

  ImportantDate(this.date, this.type, this.chipIndex);
}