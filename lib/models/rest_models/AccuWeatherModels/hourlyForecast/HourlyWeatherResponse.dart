import 'package:dandylight/models/rest_models/AccuWeatherModels/hourlyForecast/Temperature.dart';

class HourlyWeatherResponse {
  String dateTime;
  int epochDateTime;
  int weatherIcon;
  String iconPhrase;
  bool hasPrecipitation;
  bool isDaylight;
  Temperature temperature;
  int precipitationProbability;
  String mobileLink;
  String link;

  HourlyWeatherResponse(
      {this.dateTime,
        this.epochDateTime,
        this.weatherIcon,
        this.iconPhrase,
        this.hasPrecipitation,
        this.isDaylight,
        this.temperature,
        this.precipitationProbability,
        this.mobileLink,
        this.link});

  HourlyWeatherResponse.fromJson(Map<String, dynamic> json) {
    dateTime = json['DateTime'];
    epochDateTime = json['EpochDateTime'];
    weatherIcon = json['WeatherIcon'];
    iconPhrase = json['IconPhrase'];
    hasPrecipitation = json['HasPrecipitation'];
    isDaylight = json['IsDaylight'];
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    precipitationProbability = json['PrecipitationProbability'];
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DateTime'] = this.dateTime;
    data['EpochDateTime'] = this.epochDateTime;
    data['WeatherIcon'] = this.weatherIcon;
    data['IconPhrase'] = this.iconPhrase;
    data['HasPrecipitation'] = this.hasPrecipitation;
    data['IsDaylight'] = this.isDaylight;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature.toJson();
    }
    data['PrecipitationProbability'] = this.precipitationProbability;
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}