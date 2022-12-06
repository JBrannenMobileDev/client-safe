import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/Imperial.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/Metric.dart';

class Elevation {
  Metric metric;
  Imperial imperial;

  Elevation({this.metric, this.imperial});

  Elevation.fromJson(Map<String, dynamic> json) {
    metric =
    json['Metric'] != null ? new Metric.fromJson(json['Metric']) : null;
    imperial =
    json['Imperial'] != null ? new Imperial.fromJson(json['Imperial']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metric != null) {
      data['Metric'] = this.metric.toJson();
    }
    if (this.imperial != null) {
      data['Imperial'] = this.imperial.toJson();
    }
    return data;
  }
}