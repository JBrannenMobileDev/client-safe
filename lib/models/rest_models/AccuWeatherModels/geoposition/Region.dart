class Region {
  String iD;
  String localizedName;
  String englishName;

  Region({this.iD, this.localizedName, this.englishName});

  Region.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    localizedName = json['LocalizedName'];
    englishName = json['EnglishName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['LocalizedName'] = this.localizedName;
    data['EnglishName'] = this.englishName;
    return data;
  }
}