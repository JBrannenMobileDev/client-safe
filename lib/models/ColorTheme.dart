
class ColorTheme {
  int id;
  String bannerColor;
  String iconColor;
  String buttonColor;
  String buttonTextColor;

  ColorTheme({
    this.id,
    this.bannerColor,
    this.iconColor,
    this.buttonColor,
    this.buttonTextColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'bannerColor' : bannerColor,
      'iconColor' : iconColor,
      'buttonColor' : buttonColor,
      'buttonTextColor' : buttonTextColor,
    };
  }

  static ColorTheme fromMap(Map<String, dynamic> map) {
    return ColorTheme(
      id: map['id'],
      bannerColor: map['bannerColor'],
      iconColor: map['iconColor'],
      buttonColor: map['buttonColor'],
      buttonTextColor: map['buttonTextColor'],
    );
  }
}