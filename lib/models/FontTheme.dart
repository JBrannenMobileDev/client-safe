
class FontTheme {
  static const String SANS_SERIF = 'sans_serif';

  int id;
  String iconFont;
  String titleFont;
  String bodyFont;

  FontTheme({
    this.id,
    this.iconFont,
    this.titleFont,
    this.bodyFont,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'iconFont' : iconFont,
      'titleFont' : titleFont,
      'bodyFont' : bodyFont,
    };
  }

  static FontTheme fromMap(Map<String, dynamic> map) {
    return FontTheme(
      id: map['id'],
      iconFont: map['iconFont'],
      titleFont: map['titleFont'],
      bodyFont: map['bodyFont'],
    );
  }
}