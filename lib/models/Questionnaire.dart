
class Questionnaire {

  int id;
  String selectedFilter;
  double rate;
  double percentage;

  Questionnaire({
    this.id,
    this.selectedFilter,
    this.rate,
    this.percentage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'selectedFilter' : selectedFilter,
      'rate' : rate,
      'percentage' : percentage,
    };
  }

  static Questionnaire fromMap(Map<String, dynamic> map) {
    return Questionnaire(
      id: map['id'],
      selectedFilter: map['selectedFilter'],
      rate: map['rate'],
      percentage: map['percentage'],
    );
  }
}