import 'package:dandylight/models/rest_models/AccuWeatherModels/hourlyForecast/HourWeather.dart';

class HourlyResponse {
  List<HourWeather>? hours;

  HourlyResponse({this.hours});

  HourlyResponse.fromJson(Map<String, dynamic> json) {
    if (json['hours'] != null) {
      hours = [];
      json['hours'].forEach((v) {
        hours!.add(new HourWeather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hours != null) {
      data['hours'] = this.hours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}