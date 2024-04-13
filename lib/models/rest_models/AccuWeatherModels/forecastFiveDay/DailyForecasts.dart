

import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/Day.dart';

import 'Night.dart';
import 'Temperature.dart';

class DailyForecasts {
  String? date;
  int? epochDate;
  Temperature? temperature;
  Day? day;
  Night? night;
  List<String>? sources;
  String? mobileLink;
  String? link;

  DailyForecasts(
      {this.date,
        this.epochDate,
        this.temperature,
        this.day,
        this.night,
        this.sources,
        this.mobileLink,
        this.link});

  DailyForecasts.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    epochDate = json['EpochDate'];
    temperature = json['Temperature'] != null
        ? new Temperature.fromJson(json['Temperature'])
        : null;
    day = json['Day'] != null ? new Day.fromJson(json['Day']) : null;
    night = json['Night'] != null ? new Night.fromJson(json['Night']) : null;
    sources = json['Sources'].cast<String>();
    mobileLink = json['MobileLink'];
    link = json['Link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['EpochDate'] = this.epochDate;
    if (this.temperature != null) {
      data['Temperature'] = this.temperature!.toJson();
    }
    if (this.day != null) {
      data['Day'] = this.day!.toJson();
    }
    if (this.night != null) {
      data['Night'] = this.night!.toJson();
    }
    data['Sources'] = this.sources;
    data['MobileLink'] = this.mobileLink;
    data['Link'] = this.link;
    return data;
  }
}