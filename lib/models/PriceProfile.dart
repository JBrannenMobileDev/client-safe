class PriceProfile{
  int id;
  String profileName;
  String rateType;
  double rate;
  int quantity;
  String icon;

  PriceProfile({
    this.id,
    this.profileName,
    this.rateType,
    this.rate,
    this.quantity,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'profileName': profileName,
      'rateType' : rateType,
      'rate' : rate,
      'icon' : icon,
    };
  }

  static PriceProfile fromMap(Map<String, dynamic> map) {
    return PriceProfile(
      id: map['id'],
      profileName: map['profileName'],
      rateType: map['rateType'],
      rate: map['rate'],
      quantity: map['quantity'],
      icon: map['icon'],
    );
  }
}