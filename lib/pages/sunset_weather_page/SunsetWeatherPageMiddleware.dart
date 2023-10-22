import 'dart:io';

import 'package:dandylight/data_layer/api_clients/AccuWeatherClient.dart';
import 'package:dandylight/data_layer/api_clients/GoogleApiClient.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/ForecastFiveDayResponse.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/repositories/WeatherRepository.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../credentials.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../models/rest_models/AccuWeatherModels/hourlyForecast/HourWeather.dart';
import '../../utils/sunrise_sunset_library/sunrise_sunset.dart';

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
    if(action is LoadLocationImageFilesAction) {
      loadLocationImageFiles(store, next, action);
    }
    if(action is LoadInitialLocationAndDateComingFromNewJobAction) {
      fetchForAndLocationFromNewJob(store, next, action);
    }
  }

  void loadLocationImageFiles(Store<AppState> store, NextDispatcher next, LoadLocationImageFilesAction action) async {
    List<File> imageFiles = [];

    if(store.state.sunsetWeatherPageState.locations != null) {
      for(LocationDandy location in store.state.sunsetWeatherPageState.locations) {
        imageFiles.add(await FileStorage.getLocationImageFile(location));
      }

      store.dispatch(SetLocationImageFilesAction(store.state.sunsetWeatherPageState, imageFiles));
    }
  }

  void fetchLocationDetails(Store<AppState> store, NextDispatcher next, FetchSearchLocationDetails action) async {
    LocationDandy selectedSearchLocation = LocationDandy.LocationDandy(latitude: action.selectedSearchLocation.lat, longitude: action.selectedSearchLocation.lon);
    store.dispatch(SetSelectedSearchLocation(store.state.sunsetWeatherPageState, selectedSearchLocation));
  }

  void fetchLocations(Store<AppState> store, NextDispatcher next, FetchGoogleLocationsAction action) async {
    List<PlacesLocation> locations = await GoogleApiClient(httpClient: http.Client()).getLocationResults(action.input);
    store.dispatch(SetLocationResultsAction(store.state.sunsetWeatherPageState, locations));
  }

  void updateWeatherWithCurrentLatLng(Store<AppState> store, NextDispatcher next, SaveCurrentMapLatLngAction action) async {
    LatLng latLng = store.state.sunsetWeatherPageState.currentMapLatLng;
    if(latLng != null) {

      GeoData address = await getAddress(latLng.latitude, latLng.longitude);
      store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, address.address));

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
      ForecastFiveDayResponse forecast5days = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetch5DayForecast(latLng.latitude, latLng.longitude);
      DateTime now = DateTime.now();
      if(action.pageState.selectedDate.year == now.year && action.pageState.selectedDate.month == now.month && action.pageState.selectedDate.day == now.day) {
        List<HourWeather> hourlyForecast = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetchHourly12Weather(latLng.latitude, latLng.longitude);
        store.dispatch(SetHourlyForecastAction(store.state.sunsetWeatherPageState, hourlyForecast));
      }
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast5days, await LocationDao.getAllSortedMostFrequent()));
    }
  }

  void updateWeatherAndSunsetData(Store<AppState> store, NextDispatcher next, OnLocationSavedAction action) async {
    LocationDandy selectedLocation = store.state.sunsetWeatherPageState.selectedLocation;
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
      ForecastFiveDayResponse forecast5days = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetch5DayForecast(selectedLocation.latitude, selectedLocation.longitude);
      DateTime now = DateTime.now();
      if(action.pageState.selectedDate.year == now.year && action.pageState.selectedDate.month == now.month && action.pageState.selectedDate.day == now.day) {
        List<HourWeather> hourlyForecast = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetchHourly12Weather(selectedLocation.latitude, selectedLocation.longitude);
        store.dispatch(SetHourlyForecastAction(store.state.sunsetWeatherPageState, hourlyForecast));
      }
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast5days, await LocationDao.getAllSortedMostFrequent()));
    }
  }

  void setLocationData(Store<AppState> store, NextDispatcher next, SetLastKnowPosition action) async {
    if(!store.state.sunsetWeatherPageState.comingFromNewJob) {
      Position positionLastKnown = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(positionLastKnown != null) {
        store.dispatch(SetInitialMapLatLng(store.state.sunsetWeatherPageState, positionLastKnown.latitude, positionLastKnown.longitude));

        GeoData address = await getAddress(positionLastKnown.latitude, positionLastKnown.longitude);
        store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, address.address));

        (await LocationDao.getLocationsStream()).listen((locationSnapshots) {
          List<LocationDandy> locations = [];
          for(RecordSnapshot locationSnapshot in locationSnapshots) {
            locations.add(LocationDandy.fromMap(locationSnapshot.value));
          }
          store.dispatch(SetLocationsAction(store.state.sunsetWeatherPageState, locations));
        });

        ForecastFiveDayResponse forecast5days = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetch5DayForecast(positionLastKnown.latitude, positionLastKnown.longitude);
        DateTime now = DateTime.now();
        if(action.pageState.selectedDate.year == now.year && action.pageState.selectedDate.month == now.month && action.pageState.selectedDate.day == now.day) {
          List<HourWeather> hourlyForecast = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetchHourly12Weather(positionLastKnown.latitude, positionLastKnown.longitude);
          store.dispatch(SetHourlyForecastAction(store.state.sunsetWeatherPageState, hourlyForecast));
        }
        store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast5days, await LocationDao.getAllSortedMostFrequent()));

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
      }
    }
  }

  void fetchForSelectedDate(Store<AppState> store, NextDispatcher next, FetchDataForSelectedDateAction action) async{
    double lat = 0.0;
    double long = 0.0;
    if(store.state.sunsetWeatherPageState.selectedLocation == null) {
      Position positionLastKnown = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(positionLastKnown != null) {
        lat = positionLastKnown.latitude;
        long = positionLastKnown.longitude;
      }
    } else {
      lat = store.state.sunsetWeatherPageState.selectedLocation.latitude;
      long = store.state.sunsetWeatherPageState.selectedLocation.longitude;
    }

    if(lat != 0.0 && long != 0.0) {

      store.dispatch(SetSelectedDateAction(store.state.sunsetWeatherPageState, action.selectedDate));

      final response = await SunriseSunset.getResults(date: action.selectedDate, latitude: lat, longitude: long);
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

      ForecastFiveDayResponse forecast5days = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetch5DayForecast(lat, long);
      DateTime now = DateTime.now();
      if(action.selectedDate.year == now.year && action.selectedDate.month == now.month && action.selectedDate.day == now.day) {
        List<HourWeather> hourlyForecast = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetchHourly12Weather(lat, long);
        store.dispatch(SetHourlyForecastAction(store.state.sunsetWeatherPageState, hourlyForecast));
      } else {
        store.dispatch(SetHourlyForecastAction(store.state.sunsetWeatherPageState, []));
      }
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast5days, await LocationDao.getAllSortedMostFrequent()));
    }
  }

  void fetchForAndLocationFromNewJob(Store<AppState> store, NextDispatcher next, LoadInitialLocationAndDateComingFromNewJobAction action) async{
    double lat = 0.0;
    double long = 0.0;
    if(action.location == null) {
      Position positionLastKnown = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if(positionLastKnown != null) {
        lat = positionLastKnown.latitude;
        long = positionLastKnown.longitude;
      }
    } else {
      lat = action.location.latitude;
      long = action.location.longitude;
    }

    if(lat != 0.0 && long != 0.0) {

      DateTime selectedDate = action.date != null ? action.date : DateTime.now();

      store.dispatch(SetComingFromNewJobAction(store.state.sunsetWeatherPageState, true));
      store.dispatch(SetSelectedDateAction(store.state.sunsetWeatherPageState, selectedDate));
      store.dispatch(SetLocationNameAction(store.state.sunsetWeatherPageState, action.location.locationName));

      final response = await SunriseSunset.getResults(date: selectedDate, latitude: lat, longitude: long);
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

      ForecastFiveDayResponse forecast5days = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetch5DayForecast(lat, long);
      DateTime now = DateTime.now();
      if(action.date.year == now.year && action.date.month == now.month && action.date.day == now.day) {
        List<HourWeather> hourlyForecast = await WeatherRepository(weatherApiClient: AccuWeatherClient(httpClient: http.Client())).fetchHourly12Weather(lat, long);
        store.dispatch(SetHourlyForecastAction(store.state.sunsetWeatherPageState, hourlyForecast));
      }
      store.dispatch(SetForecastAction(store.state.sunsetWeatherPageState, forecast5days, await LocationDao.getAllSortedMostFrequent()));
    }
  }

  Future<GeoData> getAddress(double lat, double lng) async {
    return await Geocoder2.getDataFromCoordinates(
        latitude: lat,
        longitude: lng,
        googleMapApiKey: PLACES_API_KEY
    );
  }
}