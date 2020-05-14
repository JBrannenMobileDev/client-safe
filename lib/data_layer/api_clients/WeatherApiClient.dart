import 'dart:convert';

import 'package:client_safe/models/rest_models/CurrentWeather.dart';
import 'package:client_safe/models/rest_models/Forecast7Days.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class WeatherApiClient {
  final _baseUrl = 'https://api.weatherstack.com';
  static const ACCESS_KEY = 'f3c6d1a829e88a92eca5de0a23f305fc';
  final http.Client httpClient;
  WeatherApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CurrentWeather> fetchCurrentWeather(double lat, double lon) async {
    final url = '$_baseUrl/current?access_key=' + ACCESS_KEY +  '&query=' + lat.toString() + ',' + lon.toString() + '&units=f';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return CurrentWeather.fromJson(json);
  }

  Future<Forecast7Days> fetch7DayWeatherForecast(double lat, double lon) async {
    final url = '$_baseUrl/forecast?access_key='
        + ACCESS_KEY
        + '&query='
        + lat.toString()
        + ',' + lon.toString()
        + '&units=f'
        + '&forecast_days=7'
        + '&hourly=1'
        + '&interval=1';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return Forecast7Days.fromJson(json);
  }

  Future<CurrentWeather> fetch14DayWeatherForecast(double lat, double lon) async {
    return CurrentWeather();
  }
}