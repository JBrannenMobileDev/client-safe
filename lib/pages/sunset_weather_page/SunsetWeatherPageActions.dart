import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/rest_models/CurrentWeather.dart';
import 'package:client_safe/models/rest_models/Forecast7Days.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';

class FilterSelectorChangedAction{
  final SunsetWeatherPageState pageState;
  final int filterIndex;
  FilterSelectorChangedAction(this.pageState, this.filterIndex);
}

class SetLastKnowPosition{
  final SunsetWeatherPageState pageState;
  final bool comingFromInit;
  SetLastKnowPosition(this.pageState, this.comingFromInit);
}

class SetLocationNameAction{
  final SunsetWeatherPageState pageState;
  final String locationName;
  final bool comingFromInit;
  SetLocationNameAction(this.pageState, this.locationName, this.comingFromInit);
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