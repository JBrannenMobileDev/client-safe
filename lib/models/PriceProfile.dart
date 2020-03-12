class PriceProfile{
  int id;
  String profileName;
  String rateType;
  double flatRate;
  double hourlyRate;
  double itemRate;
  int itemQuantity;
  int hourlyQuantity;
  String icon;

  PriceProfile({
    this.id,
    this.profileName,
    this.rateType,
    this.flatRate,
    this.hourlyRate,
    this.itemRate,
    this.itemQuantity,
    this.hourlyQuantity,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'profileName': profileName,
      'rateType' : rateType,
      'flatRate' : flatRate,
      'hourlyRate' : hourlyRate,
      'itemRate' : itemRate,
      'itemQuantity' : itemQuantity,
      'hourlyQuantity' : hourlyQuantity,
      'icon' : icon,
    };
  }

  static PriceProfile fromMap(Map<String, dynamic> map) {
    return PriceProfile(
      id: map['id'],
      profileName: map['profileName'],
      rateType: map['rateType'],
      flatRate: map['flatRate'],
      hourlyRate: map['hourlyRate'],
      itemRate: map['itemRate'],
      itemQuantity: map['itemQuantity'],
      hourlyQuantity: map['hourlyQuantity'],
      icon: map['icon'],
    );
  }
}