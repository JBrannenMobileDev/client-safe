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
  SetForecastAction(this.pageState, this.forecast7days);
}