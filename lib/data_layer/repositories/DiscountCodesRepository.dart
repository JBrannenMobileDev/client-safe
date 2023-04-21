import 'dart:async';

import 'package:dandylight/data_layer/local_db/daos/DiscountCodesDao.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/currentWeather/CurrentWeatherResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/ForecastFiveDayResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/hourlyForecast/HourWeather.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../api_clients/AccuWeatherClient.dart';

class DiscountCodesRepository {

  Future saveGeneratedCode(String type, String code) async {
    1 check if discount exists
    2 if yes add new code to it. make sure its not a duplicate
    3 if not create it and add first discount
    4 save discount
    return await DiscountCodesDao.in
  }

  Future<bool> doesCodeAlreadyExist(String code, String type) {

  }

  Future assignUserToCode(String code, String uid) async {
    return await weatherApiClient.fetchHourly12Weather(lat, lon);
  }
}