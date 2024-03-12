class Day {
  int? icon;
  String? iconPhrase;
  bool? hasPrecipitation;
  int? precipitationProbability;
  int? cloudCover;

  Day({this.icon, this.iconPhrase, this.hasPrecipitation, this.precipitationProbability, this.cloudCover});

  Day.fromJson(Map<String, dynamic> json) {
    icon = json['Icon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    precipitationProbability = json['PrecipitationProbability'];
    cloudCover = json['CloudCover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Icon'] = this.icon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    data['PrecipitationProbability'] = this.precipitationProbability;
    data['CloudCover'] = this.cloudCover;
    return data;
  }
}