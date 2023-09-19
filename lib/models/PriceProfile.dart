import 'package:dandylight/models/Invoice.dart';

class PriceProfile{
  int id;
  String documentId;
  String profileName;
  String rateType;
  double flatRate;
  double hourlyRate;
  double itemRate;
  double deposit;
  String icon;
  bool includeSalesTax;
  double salesTaxPercent;

  PriceProfile({
    this.id,
    this.documentId,
    this.profileName,
    this.rateType,
    this.flatRate,
    this.hourlyRate,
    this.itemRate,
    this.icon,
    this.deposit,
    this.includeSalesTax,
    this.salesTaxPercent,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentId' : documentId,
      'profileName': profileName,
      'rateType' : rateType,
      'flatRate' : flatRate,
      'hourlyRate' : hourlyRate,
      'itemRate' : itemRate,
      'icon' : icon,
      'deposit' : deposit,
      'includeSalesTax' : includeSalesTax,
      'salesTaxPercent' : salesTaxPercent,
    };
  }

  static PriceProfile fromMap(Map<String, dynamic> map) {
    return PriceProfile(
      documentId: map['documentId'],
      profileName: map['profileName'],
      rateType: map['rateType'],
      flatRate: (map['flatRate'])?.toDouble(),
      hourlyRate: (map['hourlyRate'])?.toDouble(),
      itemRate: (map['itemRate'])?.toDouble(),
      icon: map['icon'],
      deposit: (map['deposit'])?.toDouble(),
      includeSalesTax: map['includeSalesTax'] != null ? map['includeSalesTax'] : false,
      salesTaxPercent: map['salesTaxPercent'].toDouble() != null ? (map['salesTaxPercent']).toDouble() : 0.0,
    );
  }

  static String getRate(PriceProfile priceProfile) {
    String rateString = '';
    switch(priceProfile.rateType){
      case Invoice.RATE_TYPE_FLAT_RATE:
        rateString = '\$' + priceProfile.flatRate.toInt().toString();
        break;
      case Invoice.RATE_TYPE_HOURLY:
        rateString = '\$' + priceProfile.hourlyRate.toInt().toString() + '/hr';
        break;
      case Invoice.RATE_TYPE_QUANTITY:
        rateString = '\$' + priceProfile.itemRate.toInt().toString() + '/item';
        break;
    }
    return rateString;
  }
}