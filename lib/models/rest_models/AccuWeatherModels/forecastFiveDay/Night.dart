class Night {
  int icon;
  String iconPhrase;
  bool hasPrecipitation;
  String precipitationType;
  String precipitationIntensity;
  int precipitationProbability;
  int cloudCover;

  Night(
      {this.icon,
        this.iconPhrase,
        this.hasPrecipitation,
        this.precipitationType,
        this.precipitationIntensity,
        this.precipitationProbability,
        this.cloudCover,
      });

  Night.fromJson(Map<String, dynamic> json) {
    icon = json['Icon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    precipitationType = json['PrecipitationType'];
    precipitationIntensity = json['PrecipitationIntensity'];
    precipitationProbability = json['PrecipitationProbability'];
    cloudCover = json['CloudCover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Icon'] = this.icon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    data['PrecipitationType'] = this.precipitationType;
    data['PrecipitationIntensity'] = this.precipitationIntensity;
    data['PrecipitationProbability'] = this.precipitationProbability;
    data['CloudCover'] = this.cloudCover;
    return data;
  }
}