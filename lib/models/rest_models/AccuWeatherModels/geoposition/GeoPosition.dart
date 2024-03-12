import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/Elevation.dart';

class GeoPosition {
  double? latitude;
  double? longitude;
  Elevation? elevation;

  GeoPosition({this.latitude, this.longitude, this.elevation});

  GeoPosition.fromJson(Map<String, dynamic> json) {
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    elevation = json['Elevation'] != null
        ? new Elevation.fromJson(json['Elevation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    if (this.elevation != null) {
      data['Elevation'] = this.elevation!.toJson();
    }
    return data;
  }
}