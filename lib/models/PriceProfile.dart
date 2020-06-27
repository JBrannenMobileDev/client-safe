
class PriceProfile{
  String documentId;
  String profileName;
  String rateType;
  double flatRate;
  double hourlyRate;
  double itemRate;
  String icon;

  PriceProfile({
    this.documentId,
    this.profileName,
    this.rateType,
    this.flatRate,
    this.hourlyRate,
    this.itemRate,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'profileName': profileName,
      'rateType' : rateType,
      'flatRate' : flatRate,
      'hourlyRate' : hourlyRate,
      'itemRate' : itemRate,
      'icon' : icon,
    };
  }

  static PriceProfile fromMap(Map<String, dynamic> map, String documentId) {
    return PriceProfile(
      documentId: documentId,
      profileName: map['profileName'],
      rateType: map['rateType'],
      flatRate: map['flatRate'],
      hourlyRate: map['hourlyRate'],
      itemRate: map['itemRate'],
      icon: map['icon'],
    );
  }
}