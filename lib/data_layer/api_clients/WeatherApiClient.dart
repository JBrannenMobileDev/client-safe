import 'dart:convert';

import 'package:dandylight/credentials.dart';
import 'package:dandylight/models/rest_models/CurrentWeather.dart';
import 'package:dandylight/models/rest_models/Forecast7Days.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class WeatherApiClient {
  final _baseUrl = 'https://api.weatherstack.com';

  final http.Client httpClient;
  WeatherApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CurrentWeather> fetchCurrentWeather(double lat, double lon) async {
    final url = '$_baseUrl/current?access_key=' + WEATHER_ACCESS_KEY +  '&query=' + lat.toString() + ',' + lon.toString() + '&units=f';
    final response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return CurrentWeather.fromJson(json);
  }

  Future<Forecast7Days> fetch7DayWeatherForecast(double lat, double lon) async {
    final url = '$_baseUrl/forecast?access_key='
        + WEATHER_ACCESS_KEY
        + '&query='
        + lat.toString()
        + ',' + lon.toString()
        + '&units=f'
        + '&forecast_days=7'
        + '&hourly=1'
        + '&interval=1';
    final response = await this.httpClient.get(Uri.parse(url));

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