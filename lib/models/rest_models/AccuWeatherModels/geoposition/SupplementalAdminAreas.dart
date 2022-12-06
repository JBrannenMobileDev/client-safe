class SupplementalAdminAreas {
  int level;
  String localizedName;
  String englishName;

  SupplementalAdminAreas({this.level, this.localizedName, this.englishName});

  SupplementalAdminAreas.fromJson(Map<String, dynamic> json) {
    level = json['Level'];
    localizedName = json['LocalizedName'];
    englishName = json['EnglishName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Level'] = this.level;
    data['LocalizedName'] = this.localizedName;
    data['EnglishName'] = this.englishName;
    return data;
  }
}