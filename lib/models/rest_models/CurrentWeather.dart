import 'package:dandylight/models/rest_models/Current.dart';
import 'package:dandylight/models/rest_models/Location.dart';
import 'package:dandylight/models/rest_models/Request.dart';

class CurrentWeather {
  final Request request;
  final Location location;
  final Current current;

  const CurrentWeather({this.request, this.location, this.current});

  static CurrentWeather fromJson(dynamic json) {
    return CurrentWeather(
      request: Request.fromJson(json['request']),
      location: Location.fromJson(json['location']),
      current: Current.fromJson(json['current']),
    );
  }
}
