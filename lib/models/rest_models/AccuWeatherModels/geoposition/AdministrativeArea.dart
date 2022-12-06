class AdministrativeArea {
  String iD;
  String localizedName;
  String englishName;
  int level;
  String localizedType;
  String englishType;
  String countryID;

  AdministrativeArea(
      {this.iD,
        this.localizedName,
        this.englishName,
        this.level,
        this.localizedType,
        this.englishType,
        this.countryID});

  AdministrativeArea.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    localizedName = json['LocalizedName'];
    englishName = json['EnglishName'];
    level = json['Level'];
    localizedType = json['LocalizedType'];
    englishType = json['EnglishType'];
    countryID = json['CountryID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['LocalizedName'] = this.localizedName;
    data['EnglishName'] = this.englishName;
    data['Level'] = this.level;
    data['LocalizedType'] = this.localizedType;
    data['EnglishType'] = this.englishType;
    data['CountryID'] = this.countryID;
    return data;
  }
}