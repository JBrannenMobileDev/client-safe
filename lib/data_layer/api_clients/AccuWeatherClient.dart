import 'dart:convert';

import 'package:dandylight/credentials.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/currentWeather/CurrentWeatherResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/ForecastFiveDayResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/geoposition/GeopositionResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/hourlyForecast/HourWeather.dart';
import 'package:dandylight/models/rest_models/CurrentWeather.dart';
import 'package:dandylight/models/rest_models/Forecast7Days.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../models/rest_models/AccuWeatherModels/hourlyForecast/HourlyResponse.dart';

class AccuWeatherClient {
  final _baseUrl = 'https://dataservice.accuweather.com';
  final _api_key = 'fkAMxFLUAK3WLGQlRr3a1O9fiQeJ93os';

  final http.Client httpClient;
  AccuWeatherClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<CurrentWeatherResponse> fetchCurrentWeather(double lat, double lon) async {
    String location_key = (await _fetchLocationKey(lat.toString(), lon.toString())).key;
    final url = '$_baseUrl/currentconditions/v1/$location_key?apikey=$_api_key&language=en-us&details=false';
    final response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return CurrentWeatherResponse.fromJson(json);
  }

  Future<List<HourWeather>> fetchHourly12Weather(double lat, double lon) async {
    String location_key = (await _fetchLocationKey(lat.toString(), lon.toString())).key;
    final url = '$_baseUrl/forecasts/v1/hourly/12hour/$location_key?apikey=$_api_key';
    final response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return List<HourWeather>.from(json.map((x) => HourWeather.fromJson(x)));
  }

  Future<ForecastFiveDayResponse> fetch5DayWeatherForecast(double lat, double lon) async {
    String location_key = (await _fetchLocationKey(lat.toString(), lon.toString())).key;
    final url = '$_baseUrl/forecasts/v1/daily/5day/$location_key?apikey=$_api_key&language=en-us&details=true&metric=false';
    final response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes : ' + response.statusCode.toString());
    }

    final json = jsonDecode(response.body);
    return ForecastFiveDayResponse.fromJson(json);
  }

  Future<GeoPositionResponse> _fetchLocationKey(String lat, String lon) async {
    final url = '$_baseUrl/locations/v1/cities/geoposition/search?apikey=$_api_key&q=$lat%2C$lon&language=en-us&details=false&toplevel=false';
    final response = await this.httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return GeoPositionResponse.fromJson(json);
  }
}