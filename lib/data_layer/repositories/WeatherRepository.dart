import 'dart:async';

import 'package:dandylight/data_layer/api_clients/WeatherApiClient.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/currentWeather/CurrentWeatherResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/ForecastFiveDayResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/hourlyForecast/HourlyWeatherResponse.dart';
import 'package:dandylight/models/rest_models/CurrentWeather.dart';
import 'package:dandylight/models/rest_models/Forecast7Days.dart';
import 'package:meta/meta.dart';

import '../api_clients/AccuWeatherClient.dart';

class WeatherRepository {
  final AccuWeatherClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient}) : assert(weatherApiClient != null);

  Future<CurrentWeatherResponse> fetchCurrentWeather(double lat, double lon) async {
    return await weatherApiClient.fetchCurrentWeather(lat, lon);
  }

  Future<HourlyWeatherResponse> fetchHourly12Weather(double lat, double lon) async {
    return await weatherApiClient.fetchHourly12Weather(lat, lon);
  }

  Future<ForecastFiveDayResponse> fetch5DayForecast(double lat, double lon) async {
    return await weatherApiClient.fetch5DayWeatherForecast(lat, lon);
  }
}