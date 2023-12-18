
class Report {
  static const String TYPE_INCOME_EXPENSE = 'Income & Expense Reports';
  static const String TYPE_MILEAGE = 'Mileage Reports';

  int year;
  String type;
  List<String> header;
  List<List<String>> rows;

  Report({
    this.year,
    this.header,
    this.rows,
    this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'year' : year,
      'header' : header,
      'rows' : rows,
      'type' : type,
    };
  }

  static Report fromMap(Map<String, dynamic> map) {
    return Report(
      year: map['year'],
      header: map['header'],
      rows: map['rows'],
      type: map['type'],
    );
  }

  double getTotalIncome() {
    double totalIncome = 0;
    List<List<String>> copyOfRows = List.from(rows);
    copyOfRows.removeLast();

    for(var row in copyOfRows) {
      if(row[2].isNotEmpty) {
        totalIncome = totalIncome + (double.tryParse(row[2].replaceAll(',', '')) ?? 0.0);
      }
    }

    return totalIncome;
  }

  double getTotalExpenses() {
    double totalExpenses = 0;
    List<List<String>> copyOfRows = List.from(rows);
    copyOfRows.removeLast();

    for(var row in copyOfRows) {
      if(row[3].isNotEmpty) {
        totalExpenses = totalExpenses + (double.tryParse(row[3].replaceAll(',', '')) ?? 0.0);
      }
    }

    return totalExpenses;
  }
}