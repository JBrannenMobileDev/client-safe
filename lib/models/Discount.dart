
class Discount {

  int id;
  String selectedFilter;
  double rate;
  double percentage;

  Discount({
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

  static Discount fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'],
      selectedFilter: map['selectedFilter'],
      rate: map['rate'],
      percentage: map['percentage'],
    );
  }
}