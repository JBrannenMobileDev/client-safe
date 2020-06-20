import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/models/rest_models/CurrentWeather.dart';
import 'package:dandylight/models/rest_models/Forecast7Days.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'SunsetWeatherPageState.dart';
import 'SunsetWeatherPageState.dart';
import 'SunsetWeatherPageState.dart';
import 'SunsetWeatherPageState.dart';
import 'SunsetWeatherPageState.dart';
import 'SunsetWeatherPageState.dart';

class FilterSelectorChangedAction{
  final SunsetWeatherPageState pageState;
  final int filterIndex;
  FilterSelectorChangedAction(this.pageState, this.filterIndex);
}

class SetLastKnowPosition{
  final SunsetWeatherPageState pageState;
  SetLastKnowPosition(this.pageState);
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
  final Forecast7Days forecast7days;
  final List<Location> locations;
  SetForecastAction(this.pageState, this.forecast7days, this.locations);
}

class SetSelectedLocationAction{
  final SunsetWeatherPageState pageState;
  final Location selectedLocation;
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
  final Location selectedSearchLocation;
  SetSelectedSearchLocation(this.pageState, this.selectedSearchLocation);
}

class SetSearchTextAction{
  final SunsetWeatherPageState pageState;
  final String input;
  SetSearchTextAction(this.pageState, this.input);
}