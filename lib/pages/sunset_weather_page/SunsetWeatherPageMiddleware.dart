import 'dart:io';

import 'package:client_safe/models/rest_models/Forecast7Days.dart';
import 'package:http/http.dart' as http;
import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/api_clients/WeatherApiClient.dart';
import 'package:client_safe/data_layer/repositories/WeatherRepository.dart';
import 'package:client_safe/models/rest_models/CurrentWeather.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

class SunsetWeatherPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SetLastKnowPosition){
      setLocationData(store, next, action);
    }
    if(action is FetchDataForSelectedDateAction){
      fetch(store, next, action);
    }
  }

  void setLocationData(Store<AppState> store, NextDispatcher next, SetLastKnowPosition action) async {
    Position positionLastKnown = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    if(positionLastKnown != null) {
      List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(positionLastKnown.latitude, positionLastKnown.longitude);
      store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));

      final response = await SunriseSunset.getResults(date: DateTime.now(), latitude: positionLastKnown.latitude, longitude: positionLastKnown.longitude);
      store.dispatch(
          SetSunsetTimeAction(
            store.state.sunsetWeatherPageState,
            response.data.nauticalTwilightBegin.toLocal(),
            response.data.civilTwilightBegin.toLocal(),
            response.data.sunrise.toLocal(),
            response.data.sunset.toLocal(),
            response.data.civilTwilightEnd.toLocal(),
            response.data.nauticalTwilightEnd.toLocal(),
          )
      );

      Forecast7Days forecast7days = await WeatherRepository(weatherApiClient: WeatherApiClient(httpClient: http.Client())).fetch7DayForecast(positionLastKnown.latitude, positionLastKnown.longitude);
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast7days));
    }
  }

  void fetch(Store<AppState> store, NextDispatcher next, FetchDataForSelectedDateAction action) async{
    Position positionLastKnown = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    if(positionLastKnown != null) {
      List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(positionLastKnown.latitude, positionLastKnown.longitude);
      store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));

      store.dispatch(SetSelectedDateAction(store.state.sunsetWeatherPageState, action.selectedDate));

      final response = await SunriseSunset.getResults(date: action.selectedDate, latitude: positionLastKnown.latitude, longitude: positionLastKnown.longitude);
      store.dispatch(
          SetSunsetTimeAction(
            store.state.sunsetWeatherPageState,
            response.data.nauticalTwilightBegin.toLocal(),
            response.data.civilTwilightBegin.toLocal(),
            response.data.sunrise.toLocal(),
            response.data.sunset.toLocal(),
            response.data.civilTwilightEnd.toLocal(),
            response.data.nauticalTwilightEnd.toLocal(),
          )
      );

      Forecast7Days forecast7days = await WeatherRepository(weatherApiClient: WeatherApiClient(httpClient: http.Client())).fetch7DayForecast(positionLastKnown.latitude, positionLastKnown.longitude);
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast7days));
    }
  }
}