import 'package:dandylight/models/rest_models/AccuWeatherModels/currentWeather/Temperature.dart';

class CurrentWeatherResponse {
  String localObservationDateTime;
  int epochTime;
  String weatherText;
  int weatherIcon;
  bool hasPrecipitation;
  Null precipitationType;
  bool isDayTime;
  Temperature temperature;
  String mobileLink;
  String link;

  CurrentWeatherResponse(
      {this.localObservationDateTime,
        this.epochTime,
        this.weatherText,
        this.weatherIcon,
        this.hasPrecipitation,
        this.precipitationType,
        this.isDayTime,
        this.temperature,
        this.mobileLink,
        this.link});

  CurrentWeatherResponse.fromJson(Map<String, dynamic> json) {
    localObservationDateTime = json['LocalObservationDateTime'];
    epochTime = json['EpochTime'];
    weatherText = json['WeatherText'];
    weatherIcon = json['WeatherIcon'];
    hasPrecipitation = json['HasPrecipitation'];
    precipitationType = json['PrecipitationType'];
    isDayTime = json['IsDayTime'];
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LocalObservationDateTime'] = this.localObservationDateTime;
    data['EpochTime'] = this.epochTime;
    data['WeatherText'] = this.weatherText;
    data['WeatherIcon'] = this.weatherIcon;
    data['HasPrecipitation'] = this.hasPrecipitation;
    data['PrecipitationType'] = this.precipitationType;
    data['IsDayTime'] = this.isDayTime;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}