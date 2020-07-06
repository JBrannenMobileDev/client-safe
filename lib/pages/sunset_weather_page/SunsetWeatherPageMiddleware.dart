import 'dart:io';

import 'package:dandylight/data_layer/api_clients/GoogleApiClient.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/models/rest_models/Forecast7Days.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/api_clients/WeatherApiClient.dart';
import 'package:dandylight/data_layer/repositories/WeatherRepository.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:sunrise_sunset/sunrise_sunset.dart';

class SunsetWeatherPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SetLastKnowPosition){
      setLocationData(store, next, action);
    }
    if(action is FetchDataForSelectedDateAction){
      fetchForSelectedDate(store, next, action);
    }
    if(action is OnLocationSavedAction){
      updateWeatherAndSunsetData(store, next, action);
    }
    if(action is SaveCurrentMapLatLngAction){
      updateWeatherWithCurrentLatLng(store, next, action);
    }
    if(action is FetchGoogleLocationsAction){
      fetchLocations(store, next, action);
    }
    if(action is FetchSearchLocationDetails){
      fetchLocationDetails(store, next, action);
    }
  }

  void fetchLocationDetails(Store<AppState> store, NextDispatcher next, FetchSearchLocationDetails action) async {
    Location selectedSearchLocation = await GoogleApiClient(httpClient: http.Client()).getLocationDetails(action.selectedSearchLocation.place_id, action.selectedSearchLocation.description);
    store.dispatch(SetSelectedSearchLocation(store.state.sunsetWeatherPageState, selectedSearchLocation));
  }

  void fetchLocations(Store<AppState> store, NextDispatcher next, FetchGoogleLocationsAction action) async {
    List<PlacesLocation> locations = await GoogleApiClient(httpClient: http.Client()).getLocationResults(action.input);
    store.dispatch(SetLocationResultsAction(store.state.sunsetWeatherPageState, locations));
  }

  void updateWeatherWithCurrentLatLng(Store<AppState> store, NextDispatcher next, SaveCurrentMapLatLngAction action) async {
    LatLng latLng = store.state.sunsetWeatherPageState.currentMapLatLng;
    if(latLng != null) {

      List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));

      final response = await SunriseSunset.getResults(date: DateTime.now(), latitude: latLng.latitude, longitude: latLng.longitude);
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
      Forecast7Days forecast7days = await WeatherRepository(weatherApiClient: WeatherApiClient(httpClient: http.Client())).fetch7DayForecast(latLng.latitude, latLng.longitude);
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast7days, await LocationDao.getAllSortedMostFrequent()));
    }
  }

  void updateWeatherAndSunsetData(Store<AppState> store, NextDispatcher next, OnLocationSavedAction action) async {
    Location selectedLocation = store.state.sunsetWeatherPageState.selectedLocation;
    if(selectedLocation != null) {
      store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, selectedLocation.locationName));

      final response = await SunriseSunset.getResults(date: DateTime.now(), latitude: selectedLocation.latitude, longitude: selectedLocation.longitude);
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
      Forecast7Days forecast7days = await WeatherRepository(weatherApiClient: WeatherApiClient(httpClient: http.Client())).fetch7DayForecast(selectedLocation.latitude, selectedLocation.longitude);
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast7days, await LocationDao.getAllSortedMostFrequent()));
    }
  }

  void setLocationData(Store<AppState> store, NextDispatcher next, SetLastKnowPosition action) async {
    Position positionLastKnown = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    if(positionLastKnown != null) {
      store.dispatch(SetInitialMapLatLng(store.state.sunsetWeatherPageState, positionLastKnown.latitude, positionLastKnown.longitude));
      List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(positionLastKnown.latitude, positionLastKnown.longitude);

      store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));

      (await LocationDao.getLocationsStream()).listen((locationSnapshots) {
        List<Location> locations = List();
        for(RecordSnapshot locationSnapshot in locationSnapshots) {
          locations.add(Location.fromMap(locationSnapshot.value));
        }
        store.dispatch(SetLocationsAction(store.state.sunsetWeatherPageState, locations));
      });

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
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast7days, await LocationDao.getAllSortedMostFrequent()));

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = appDocDir.path;
      store.dispatch(SetSunsetWeatherDocumentPathAction(store.state.sunsetWeatherPageState, path));
    }
  }

  void fetchForSelectedDate(Store<AppState> store, NextDispatcher next, FetchDataForSelectedDateAction action) async{
    Position positionLastKnown = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    if(positionLastKnown != null) {

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
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast7days, await LocationDao.getAllSortedMostFrequent()));
    }
  }
}