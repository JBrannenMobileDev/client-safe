
class Branding{
  String logoUrl;
  String bannerUrl;
  String bannerColor;
  String logoColor;
  String titleTextColor;
  String logoTextColor;
  String backgroundColor;

  Branding({
    this.logoUrl,
    this.bannerUrl,
    this.bannerColor,
    this.logoColor,
    this.titleTextColor,
    this.logoTextColor,
    this.backgroundColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'logoUrl' : logoUrl,
      'bannerUrl' : bannerUrl,
      'bannerColor' : bannerColor,
      'logoColor' : logoColor,
      'titleTextColor' : titleTextColor,
      'logoTextColor' : logoTextColor,
      'backgroundColor' : backgroundColor,
    };
  }

  static Branding fromMap(Map<String, dynamic> map) {
    return Branding(
      logoUrl: map['logoUrl'],
      bannerUrl: map['bannerUrl'],
      bannerColor: map['bannerColor'],
      logoColor: map['logoColor'],
      titleTextColor: map['titleTextColor'],
      logoTextColor: map['logoTextColor'],
      backgroundColor: map['backgroundColor'],
    );
  }
}