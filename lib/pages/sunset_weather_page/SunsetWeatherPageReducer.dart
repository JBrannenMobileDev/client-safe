import 'package:client_safe/models/rest_models/OneDayForecast.dart';
import 'package:client_safe/models/rest_models/OneHourForecast.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

final sunsetWeatherPageReducer = combineReducers<SunsetWeatherPageState>([
  TypedReducer<SunsetWeatherPageState, FilterSelectorChangedAction>(_updateSelectorIndex),
  TypedReducer<SunsetWeatherPageState, SetLocationNameAction>(_setLocationName),
  TypedReducer<SunsetWeatherPageState, SetSunsetTimeAction>(_setSunsetTimes),
  TypedReducer<SunsetWeatherPageState, SetSelectedDateAction>(_setSelectedDate),
  TypedReducer<SunsetWeatherPageState, SetForecastAction>(_setForecast),
]);

SunsetWeatherPageState _setForecast(SunsetWeatherPageState previousState, SetForecastAction action){
  Map<dynamic, dynamic> forecastDays = action.forecast7days.forecast;
  List<String> dayStringDates = forecastDays.keys.toList();
  OneDayForecast oneDayForecast;
  for(String dayDate in dayStringDates){
    if(DateFormat('yyyy-MM-dd').format(previousState.selectedDate) == dayDate) {
      oneDayForecast = OneDayForecast.fromMap(forecastDays.remove(dayDate));
      break;
    }
  }

  return oneDayForecast != null ? previousState.copyWith(
    showFartherThan7DaysError: false,
    weatherDescription: getWeatherDescription(oneDayForecast.hourly),
    tempHigh: oneDayForecast.maxtemp.toString(),
    tempLow: oneDayForecast.mintemp.toString(),
    chanceOfRain: getAvgChanceOfRain(oneDayForecast.hourly),
    cloudCoverage: getAvgCloudCoverage(oneDayForecast.hourly),
    weatherIcon: _getMostAccurateWeatherCode(oneDayForecast.hourly),
    isWeatherDataLoading: false,
  ) : previousState.copyWith(
    showFartherThan7DaysError: true,
  );
}

String getWeatherDescription(List<OneHourForecast> hourly) {

  return 'Sunny';
}

String getAvgCloudCoverage(List<OneHourForecast> hourly) {

  return '35';
}

String getAvgChanceOfRain(List<OneHourForecast> hourly) {

  return '15';
}

AssetImage _getMostAccurateWeatherCode(List<OneHourForecast> hourly) {
  int containsSunny = 0;
  int containsRainy = 0;
  int containsSnowy = 0;
  int containsPartlyCloudy = 0;
  int containsCloudy = 0;
  int containsHail = 0;
  int containsLightning = 0;
  for(OneHourForecast oneHour in hourly){
    switch(oneHour.weather_code){
      case 113:
        containsSunny = containsSunny + 1;
        break;
      case 116:
        containsPartlyCloudy = containsPartlyCloudy + 1;
        break;
      case 119:
      case 248:
      case 260:
      case 122:
      case 143:
        containsCloudy = containsCloudy + 1;
      break;
      case 176:
      case 263:
      case 266:
      case 293:
      case 296:
      case 299:
      case 302:
      case 305:
      case 308:
        containsRainy = containsRainy + 1;
        break;
      case 179:
      case 185:
      case 227:
      case 230:
        containsSnowy = containsSnowy + 1;
        break;
      case 182:
      case 281:
      case 284:
      case 311:
        containsHail = containsHail + 1;
        break;
      case 200:
        containsLightning = containsLightning + 1;
        break;
    }
  }
  if(containsLightning > 0){
    return AssetImage('assets/images/icons/lightning_rain_icon.png');
  } else if(containsSnowy > 0){
    return AssetImage('assets/images/icons/snowing_icon.png');
  } else if(containsHail > 0){
    return AssetImage('assets/images/icons/hail_icon.png');
  } else if(containsRainy > 0){
    return AssetImage('assets/images/icons/rainy_icon.png');
  } else {
    if(containsSunny > containsPartlyCloudy && containsSunny > containsCloudy) {
      return AssetImage('assets/images/icons/sunny_icon_gold.png');
    } else {
      if(containsPartlyCloudy > containsCloudy) {
        return AssetImage('assets/images/icons/partly_cloudy_icon.png');
      } else {
        return AssetImage('assets/images/icons/cloudy_icon.png');
      }
    }
  }
}

SunsetWeatherPageState _setSelectedDate(SunsetWeatherPageState previousState, SetSelectedDateAction action){
  return previousState.copyWith(
    selectedDate: action.selectedDate,
    isSunsetDataLoading: true,
    isWeatherDataLoading: true,
  );
}

SunsetWeatherPageState _updateSelectorIndex(SunsetWeatherPageState previousState, FilterSelectorChangedAction action){
  return previousState.copyWith(
    selectedFilterIndex: action.filterIndex,
  );
}

SunsetWeatherPageState _setLocationName(SunsetWeatherPageState previousState, SetLocationNameAction action){
  return previousState.copyWith(
    locationName: action.locationName,
  );
}

SunsetWeatherPageState _setSunsetTimes(SunsetWeatherPageState previousState, SetSunsetTimeAction action){
  int degrees6 = _calculate6DegreesOfTime(action.sunset, action.civilTwilightEnd);
  int degrees4 = (degrees6 * 0.6666).toInt();
  return previousState.copyWith(
    morningBlueHour: _getMorningBlueHour(degrees6, degrees4, action.sunrise),
    sunrise: DateFormat('h:mm a').format(action.sunrise),
    morningGoldenHour: _getMorningGoldenHour(degrees6, degrees4, action.sunrise),
    eveningGoldenHour: _getEveningGoldenHour(degrees6, degrees4, action.sunset),
    sunset: DateFormat('h:mm a').format(action.sunset),
    sunsetTimestamp: action.sunset,
    eveningBlueHour: _getEveningBlueHour(degrees6, degrees4, action.sunset),
    isSunsetDataLoading: false,
  );
}

String _getMorningGoldenHour(int degrees6, int degrees4, DateTime sunrise) {
  String startTime = '';
  String endTime = '';
  int startTimeMilli = sunrise.millisecondsSinceEpoch - degrees4;
  int endTimeMilli = sunrise.millisecondsSinceEpoch + degrees6;
  startTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(startTimeMilli));
  endTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(endTimeMilli));
  return startTime + ' - ' + endTime;
}

String _getEveningGoldenHour(int degrees6, int degrees4, DateTime sunset) {
  String startTime = '';
  String endTime = '';
  int startTimeMilli = sunset.millisecondsSinceEpoch - degrees6;
  int endTimeMilli = sunset.millisecondsSinceEpoch + degrees4;
  startTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(startTimeMilli));
  endTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(endTimeMilli));
  return startTime + ' - ' + endTime;
}

String _getEveningBlueHour(int degrees6, int degrees4, DateTime sunset) {
  String startTime = '';
  String endTime = '';
  int startTimeMilli = sunset.millisecondsSinceEpoch + degrees4;
  int endTimeMilli = sunset.millisecondsSinceEpoch + degrees6;
  startTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(startTimeMilli));
  endTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(endTimeMilli));
  return startTime + ' - ' + endTime;
}

String _getMorningBlueHour(int degrees6, int degrees4, DateTime sunrise) {
  String startTime = '';
  String endTime = '';
  int startTimeMilli = sunrise.millisecondsSinceEpoch - degrees6;
  int endTimeMilli = sunrise.millisecondsSinceEpoch - degrees4;
  startTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(startTimeMilli));
  endTime = DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(endTimeMilli));
  return startTime + ' - ' + endTime;
}

int _calculate6DegreesOfTime(DateTime sunset, DateTime civilTwilightEnd) {
  return civilTwilightEnd.millisecondsSinceEpoch - sunset.millisecondsSinceEpoch;
}

AssetImage getWeatherIcon(DateTime sunsetTime, int weatherCode){
  AssetImage icon = AssetImage('assets/images/icons/sunny_icon_gold.png');
  switch(weatherCode){
    case 113:
      if(DateTime.now().millisecondsSinceEpoch > sunsetTime.millisecondsSinceEpoch){
        icon = AssetImage('assets/images/icons/night_icon.png');
      }else{
        icon = AssetImage('assets/images/icons/sunny_icon_gold.png');
      }
      break;
    case 116:
      icon = AssetImage('assets/images/icons/partly_cloudy_icon.png');
      break;
    case 119:
    case 248:
    case 260:
      icon = AssetImage('assets/images/icons/cloudy_icon.png');
      break;
    case 122:
    case 143:
      icon = AssetImage('assets/images/icons/very_cloudy_icon.png');
      break;
    case 176:
    case 263:
    case 266:
    case 293:
    case 296:
      icon = AssetImage('assets/images/icons/sunny_rainy_icon.png');
      break;
    case 179:
    case 185:
    case 227:
    case 230:
      icon = AssetImage('assets/images/icons/snowing_icon.png');
      break;
    case 182:
    case 281:
    case 284:
    case 311:
      icon = AssetImage('assets/images/icons/hail_icon.png');
      break;
    case 200:
      icon = AssetImage('assets/images/icons/lightning_rain_icon.png');
      break;
    case 299:
    case 302:
    case 305:
    case 308:
      icon = AssetImage('assets/images/icons/rainy_icon.png');
      break;
  }
  return icon;
}