import 'DailyForecasts.dart';
import 'Headline.dart';

class ForecastFiveDayResponse {
  Headline? headline;
  List<DailyForecasts>? dailyForecasts;

  ForecastFiveDayResponse({this.headline, this.dailyForecasts});

  ForecastFiveDayResponse.fromJson(Map<String, dynamic> json) {
    headline = json['Headline'] != null
        ? new Headline.fromJson(json['Headline'])
        : null;
    if (json['DailyForecasts'] != null) {
      dailyForecasts = [];
      json['DailyForecasts'].forEach((v) {
        dailyForecasts!.add(new DailyForecasts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.headline != null) {
      data['Headline'] = this.headline!.toJson();
    }
    if (this.dailyForecasts != null) {
      data['DailyForecasts'] =
          this.dailyForecasts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}