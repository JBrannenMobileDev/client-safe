
class ColorTheme {
  int? id;
  String? themeName;
  String? bannerColor;
  String? iconColor;
  String? iconTextColor;
  String? buttonColor;
  String? buttonTextColor;

  ColorTheme({
    this.id,
    this.themeName,
    this.bannerColor,
    this.iconColor,
    this.buttonColor,
    this.buttonTextColor,
    this.iconTextColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'themeName' : themeName,
      'bannerColor' : bannerColor,
      'iconColor' : iconColor,
      'buttonColor' : buttonColor,
      'buttonTextColor' : buttonTextColor,
      'iconTextColor' : iconTextColor,
    };
  }

  static ColorTheme fromMap(Map<String, dynamic> map) {
    return ColorTheme(
      id: map['id'],
      themeName: map['themeName'],
      bannerColor: map['bannerColor'],
      iconColor: map['iconColor'],
      iconTextColor: map['iconTextColor'],
      buttonColor: map['buttonColor'],
      buttonTextColor: map['buttonTextColor'],
    );
  }
}