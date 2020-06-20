import 'package:dandylight/models/Invoice.dart';

class PriceProfile{
  int id;
  String profileName;
  String rateType;
  double flatRate;
  double hourlyRate;
  double itemRate;
  String icon;

  PriceProfile({
    this.id,
    this.profileName,
    this.rateType,
    this.flatRate,
    this.hourlyRate,
    this.itemRate,
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
      icon: map['icon'],
    );
  }
}