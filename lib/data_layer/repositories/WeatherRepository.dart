import 'dart:async';

import 'package:client_safe/data_layer/api_clients/WeatherApiClient.dart';
import 'package:client_safe/models/rest_models/CurrentWeather.dart';
import 'package:client_safe/models/rest_models/Forecast7Days.dart';
import 'package:meta/meta.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient}) : assert(weatherApiClient != null);

  Future<CurrentWeather> fetchCurrentWeather(double lat, double lon) async {
    return await weatherApiClient.fetchCurrentWeather(lat, lon);
  }

  Future<Forecast7Days> fetch7DayForecast(double lat, double lon) async {
    return await weatherApiClient.fetch7DayWeatherForecast(lat, lon);
  }
}