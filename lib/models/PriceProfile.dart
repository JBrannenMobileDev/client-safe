class PriceProfile{
  int id;
  String profileName;
  int priceFives;
  int priceHundreds;
  int timeInMin;
  int timeInHours;
  int numOfEdits;
  String icon;

  PriceProfile({
    this.id,
    this.profileName,
    this.priceFives,
    this.priceHundreds,
    this.timeInMin,
    this.timeInHours,
    this.numOfEdits,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'profileName': profileName,
      'priceFives' : priceFives,
      'priceHundreds' : priceHundreds,
      'timeInMinutes' : timeInMin,
      'timeInHours' : timeInHours,
      'numOfEdits' : numOfEdits,
      'icon' : icon,
    };
  }

  static PriceProfile fromMap(Map<String, dynamic> map) {
    return PriceProfile(
      id: map['id'],
      profileName: map['profileName'],
      priceFives: map['priceFives'],
      priceHundreds: map['priceHundreds'],
      timeInMin: map['timeInMin'],
      timeInHours: map['timeInHours'],
      numOfEdits: map['numOfEdits'],
      icon: map['icon'],
    );
  }
}