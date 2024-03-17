import 'dart:io';

import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/ForecastFiveDayResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/hourlyForecast/HourlyResponse.dart';
import 'package:dandylight/models/rest_models/Forecast7Days.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/rest_models/AccuWeatherModels/hourlyForecast/HourWeather.dart';


class FilterSelectorChangedAction{
  final SunsetWeatherPageState pageState;
  final int filterIndex;
  FilterSelectorChangedAction(this.pageState, this.filterIndex);
}

class LoadInitialLocationAndDateComingFromNewJobAction{
  final SunsetWeatherPageState? pageState;
  final LocationDandy? location;
  final DateTime? date;
  LoadInitialLocationAndDateComingFromNewJobAction(this.pageState, this.location, this.date);
}

class SetLastKnowPosition{
  final SunsetWeatherPageState pageState;
  SetLastKnowPosition(this.pageState);
}

class SetComingFromNewJobAction{
  final SunsetWeatherPageState pageState;
  final bool isComingFromNewJob;
  SetComingFromNewJobAction(this.pageState, this.isComingFromNewJob);
}

class SetLocationNameAction{
  final SunsetWeatherPageState pageState;
  final String locationName;
  SetLocationNameAction(this.pageState, this.locationName);
}

class SetSunsetTimeAction{
  final SunsetWeatherPageState pageState;
  final DateTime nauticalTwilightStart;
  final DateTime civilTwilightStart;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime civilTwilightEnd;
  final DateTime nauticalTwilightEnd;
  SetSunsetTimeAction(
      this.pageState,
      this.nauticalTwilightStart,
      this.civilTwilightStart,
      this.sunrise,
      this.sunset,
      this.civilTwilightEnd,
      this.nauticalTwilightEnd);
}

class FetchDataForSelectedDateAction{
  final SunsetWeatherPageState pageState;
  final DateTime selectedDate;
  FetchDataForSelectedDateAction(this.pageState, this.selectedDate);
}

class SetSelectedDateAction{
  final SunsetWeatherPageState pageState;
  final DateTime selectedDate;
  SetSelectedDateAction(this.pageState, this.selectedDate);
}

class SetForecastAction{
  final SunsetWeatherPageState pageState;
  final ForecastFiveDayResponse forecast5days;
  final List<LocationDandy> locations;
  SetForecastAction(this.pageState, this.forecast5days, this.locations);
}

class SetHourlyForecastAction{
  final SunsetWeatherPageState pageState;
  final List<HourWeather> hours;
  SetHourlyForecastAction(this.pageState, this.hours);
}

class SetSelectedLocationAction{
  final SunsetWeatherPageState pageState;
  final LocationDandy selectedLocation;
  SetSelectedLocationAction(this.pageState, this.selectedLocation);
}

class SetSunsetWeatherDocumentPathAction{
  final SunsetWeatherPageState pageState;
  final String path;
  SetSunsetWeatherDocumentPathAction(this.pageState, this.path);
}

class OnLocationSavedAction{
  final SunsetWeatherPageState pageState;
  OnLocationSavedAction(this.pageState);
}

class SetCurrentMapLatLngAction{
  final SunsetWeatherPageState pageState;
  final LatLng currentLatLng;
  SetCurrentMapLatLngAction(this.pageState, this.currentLatLng);
}

class SaveCurrentMapLatLngAction{
  final SunsetWeatherPageState pageState;
  SaveCurrentMapLatLngAction(this.pageState);
}

class SetInitialMapLatLng{
  final SunsetWeatherPageState pageState;
  final double lat;
  final double lng;
  SetInitialMapLatLng(this.pageState, this.lat, this.lng);
}

class FetchGoogleLocationsAction{
  final SunsetWeatherPageState pageState;
  final String input;
  FetchGoogleLocationsAction(this.pageState, this.input);
}

class LoadLocationImageFilesAction{
  final SunsetWeatherPageState pageState;
  LoadLocationImageFilesAction(this.pageState);
}

class SetLocationImageFilesAction {
  final SunsetWeatherPageState pageState;
  final List<File> imageFiles;
  SetLocationImageFilesAction(this.pageState, this.imageFiles);
}

class SetLocationResultsAction{
  final SunsetWeatherPageState pageState;
  final List<PlacesLocation> locations;
  SetLocationResultsAction(this.pageState, this.locations);
}

class FetchSearchLocationDetails{
  final SunsetWeatherPageState pageState;
  final PlacesLocation selectedSearchLocation;
  FetchSearchLocationDetails(this.pageState, this.selectedSearchLocation);
}

class SetSelectedSearchLocation{
  final SunsetWeatherPageState pageState;
  final LocationDandy selectedSearchLocation;
  SetSelectedSearchLocation(this.pageState, this.selectedSearchLocation);
}

class SetSearchTextAction{
  final SunsetWeatherPageState pageState;
  final String input;
  SetSearchTextAction(this.pageState, this.input);
}

class ClearPageStateAction{
  final SunsetWeatherPageState pageState;
  ClearPageStateAction(this.pageState);
}

class SetLocationsAction{
  final SunsetWeatherPageState pageState;
  final List<LocationDandy> locations;
  SetLocationsAction(this.pageState, this.locations);
}