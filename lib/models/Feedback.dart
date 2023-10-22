
class Feedback {

  int id;
  String selectedFilter;
  double rate;
  double percentage;

  Feedback({
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

  static Feedback fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'],
      selectedFilter: map['selectedFilter'],
      rate: map['rate']?.toDouble(),
      percentage: map['percentage']?.toDouble(),
    );
  }
}