import 'package:dandylight/models/rest_models/Hour.dart';
import 'package:dandylight/models/rest_models/OneDayForecast.dart';
import 'package:dandylight/models/rest_models/OneHourForecast.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import '../../models/rest_models/ForecastDay.dart';

final sunsetWeatherPageReducer = combineReducers<SunsetWeatherPageState>([
  TypedReducer<SunsetWeatherPageState, FilterSelectorChangedAction>(_updateSelectorIndex),
  TypedReducer<SunsetWeatherPageState, SetLocationNameAction>(_setLocationName),
  TypedReducer<SunsetWeatherPageState, SetSunsetTimeAction>(_setSunsetTimes),
  TypedReducer<SunsetWeatherPageState, SetSelectedDateAction>(_setSelectedDate),
  TypedReducer<SunsetWeatherPageState, SetForecastAction>(_setForecast),
  TypedReducer<SunsetWeatherPageState, SetSelectedLocationAction>(_setSelectedLocation),
  TypedReducer<SunsetWeatherPageState, SetSunsetWeatherDocumentPathAction>(_setDocumentPath),
  TypedReducer<SunsetWeatherPageState, SetCurrentMapLatLngAction>(_setCurrentMapLatLng),
  TypedReducer<SunsetWeatherPageState, SetInitialMapLatLng>(_setInitMapLatLng),
  TypedReducer<SunsetWeatherPageState, SetLocationResultsAction>(_setLocationResults),
  TypedReducer<SunsetWeatherPageState, SetSelectedSearchLocation>(_setSelectedSearchLocation),
  TypedReducer<SunsetWeatherPageState, SetSearchTextAction>(_setSearchText),
  TypedReducer<SunsetWeatherPageState, SetLocationsAction>(_setLocations),
  TypedReducer<SunsetWeatherPageState, SetLocationImageFilesAction>(_setLocationImages),
]);

SunsetWeatherPageState _setLocationImages(SunsetWeatherPageState previousState, SetLocationImageFilesAction action){
  return previousState.copyWith(
    locationImages: action.imageFiles,
  );
}

SunsetWeatherPageState _setLocations(SunsetWeatherPageState previousState, SetLocationsAction action){
  return previousState.copyWith(
    locations: action.locations,
  );
}

SunsetWeatherPageState _setSearchText(SunsetWeatherPageState previousState, SetSearchTextAction action){
  return previousState.copyWith(
    searchText: action.input,
  );
}

SunsetWeatherPageState _setSelectedSearchLocation(SunsetWeatherPageState previousState, SetSelectedSearchLocation action){
  return previousState.copyWith(
    selectedSearchLocation: action.selectedSearchLocation,
    locationResults: List(),
  );
}

SunsetWeatherPageState _setLocationResults(SunsetWeatherPageState previousState, SetLocationResultsAction action){
  return previousState.copyWith(
    locationResults: action.locations,
  );
}

SunsetWeatherPageState _setInitMapLatLng(SunsetWeatherPageState previousState, SetInitialMapLatLng action){
  return previousState.copyWith(
    lat: action.lat,
    lng: action.lng,
    selectedDate: DateTime.now(),
  );
}

SunsetWeatherPageState _setCurrentMapLatLng(SunsetWeatherPageState previousState, SetCurrentMapLatLngAction action){
  return previousState.copyWith(
    currentMapLatLng: action.currentLatLng,
  );
}

SunsetWeatherPageState _setSelectedLocation(SunsetWeatherPageState previousState, SetSelectedLocationAction action){
  return previousState.copyWith(
    selectedLocation: action.selectedLocation,
  );
}

SunsetWeatherPageState _setDocumentPath(SunsetWeatherPageState previousState, SetSunsetWeatherDocumentPathAction action){
  return previousState.copyWith(
    documentPath: action.path,
  );
}

SunsetWeatherPageState _setForecast(SunsetWeatherPageState previousState, SetForecastAction action){
  Forecastday matchingDay;
  for(Forecastday forecastDay in action.forecast7days.forecast.forecastday){
    if(DateFormat('yyyy-MM-dd').format(previousState.selectedDate) == forecastDay.date) {
      matchingDay = forecastDay;
      break;
    }
  }

  return matchingDay != null ? previousState.copyWith(
    showFartherThan7DaysError: false,
    weatherDescription: getWeatherDescription(matchingDay.hour),
    tempHigh: matchingDay.day.maxtempF.toInt().toString(),
    tempLow: matchingDay.day.mintempF.toInt().toString(),
    chanceOfRain: getAvgChanceOfRain(matchingDay.hour),
    cloudCoverage: getAvgCloudCoverage(matchingDay.hour),
    weatherIcon: _getMostAccurateWeatherCode(matchingDay.hour),
    isWeatherDataLoading: false,
    hoursForecast: matchingDay.hour,
    locations: action.locations,
  ) : previousState.copyWith(
    showFartherThan7DaysError: true,
  );
}

String getWeatherDescription(List<Hour> hourly) {
  int containsSunny = 0;
  int containsRainy = 0;
  int containsSnowy = 0;
  int containsPartlyCloudy = 0;
  int containsCloudy = 0;
  int containsHail = 0;
  int containsLightning = 0;
  for(Hour oneHour in hourly){
    switch(oneHour.condition.code){
      case 1000:
        containsSunny = containsSunny + 1;
        break;
      case 1003:
        containsPartlyCloudy = containsPartlyCloudy + 1;
        break;
      case 1006:
      case 1135:
      case 1147:
      case 1009:
      case 1030:
        containsCloudy = containsCloudy + 1;
        break;
      case 1063:
      case 1150:
      case 1153:
      case 1180:
      case 1183:
      case 1087:
      case 1273:
      case 1276:
      case 1279:
      case 1282:
      case 1186:
      case 1189:
      case 1192:
      case 1195:
      case 1201:
      case 1240:
      case 1243:
      case 1246:
        containsRainy = containsRainy + 1;
        break;
      case 1066:
      case 1072:
      case 1114:
      case 1117:
      case 1210:
      case 1213:
      case 1216:
      case 1219:
      case 1222:
      case 1225:
      case 1255:
      case 1258:
        containsSnowy = containsSnowy + 1;
        break;
      case 1069:
      case 1168:
      case 1171:
      case 1198:
      case 1204:
      case 1207:
      case 1237:
      case 1249:
      case 1252:
      case 1261:
      case 1264:
        containsHail = containsHail + 1;
        break;
      case 1087:
      case 1273:
      case 1276:
      case 1279:
      case 1282:
        containsLightning = containsLightning + 1;
        break;
    }
  }
  if(containsLightning > 0){
    return 'Chance of Thunderstroms';
  } else if(containsSnowy > 0){
    return 'Chance of Snow';
  } else if(containsHail > 0){
    return 'Chance of Hail';
  } else if(containsRainy > 0){
    return 'Chance of Rain';
  } else {
    if(containsSunny > containsPartlyCloudy && containsSunny > containsCloudy) {
      return 'Sunny';
    } else {
      if(containsPartlyCloudy > containsCloudy) {
        return 'Partly Cloudy';
      } else {
        return 'Cloudy';
      }
    }
  }
}

String getAvgCloudCoverage(List<Hour> hourly) {
  int totalCloudCover = 0;
  for(Hour oneHour in hourly){
    totalCloudCover = totalCloudCover + oneHour.cloud;
  }
  return (totalCloudCover~/24).toInt().toString();
}

String getAvgChanceOfRain(List<Hour> hourly) {
  int totalChanceOfRain = 0;
  for(Hour oneHour in hourly){
    totalChanceOfRain = totalChanceOfRain + oneHour.chanceOfRain;
  }
  return (totalChanceOfRain~/24).toInt().toString();
}

AssetImage _getMostAccurateWeatherCode(List<Hour> hourly) {
  int containsSunny = 0;
  int containsRainy = 0;
  int containsSnowy = 0;
  int containsPartlyCloudy = 0;
  int containsCloudy = 0;
  int containsHail = 0;
  int containsLightning = 0;
  for(Hour oneHour in hourly){
    switch(oneHour.condition.code){
      case 1000:
        containsSunny = containsSunny + 1;
        break;
      case 1003:
        containsPartlyCloudy = containsPartlyCloudy + 1;
        break;
      case 1006:
      case 1135:
      case 1147:
      case 1009:
      case 1030:
        containsCloudy = containsCloudy + 1;
        break;
      case 1063:
      case 1150:
      case 1153:
      case 1180:
      case 1183:
      case 1087:
      case 1273:
      case 1276:
      case 1279:
      case 1282:
      case 1186:
      case 1189:
      case 1192:
      case 1195:
      case 1201:
      case 1240:
      case 1243:
      case 1246:
        containsRainy = containsRainy + 1;
        break;
      case 1066:
      case 1072:
      case 1114:
      case 1117:
      case 1210:
      case 1213:
      case 1216:
      case 1219:
      case 1222:
      case 1225:
      case 1255:
      case 1258:
        containsSnowy = containsSnowy + 1;
        break;
      case 1069:
      case 1168:
      case 1171:
      case 1198:
      case 1204:
      case 1207:
      case 1237:
      case 1249:
      case 1252:
      case 1261:
      case 1264:
        containsHail = containsHail + 1;
        break;
      case 1087:
      case 1273:
      case 1276:
      case 1279:
      case 1282:
        containsLightning = containsLightning + 1;
        break;
    }
  }

  AssetImage imageToReturn = AssetImage('assets/images/icons/sunny_icon_gold.png');
  int highestCount = 0;

  if(containsLightning > containsSnowy) {
    imageToReturn = AssetImage('assets/images/icons/lightning_rain_icon.png');
    highestCount = containsLightning;
  } else {
    imageToReturn = AssetImage('assets/images/icons/snowing_icon.png');
    highestCount = containsSnowy;
  }

  if(containsHail > highestCount){
    imageToReturn = AssetImage('assets/images/icons/hail_icon.png');
    highestCount = containsHail;
  }

  if(containsRainy > highestCount){
    imageToReturn = AssetImage('assets/images/icons/rainy_icon.png');
    highestCount = containsRainy;
  }

  if(containsCloudy > highestCount){
    imageToReturn = AssetImage('assets/images/icons/cloudy_icon.png');
    highestCount = containsCloudy;
  }

  if(containsPartlyCloudy > highestCount){
    imageToReturn = AssetImage('assets/images/icons/partly_cloudy_icon.png');
    highestCount = containsPartlyCloudy;
  }

  if(containsSunny > highestCount){
    imageToReturn = AssetImage('assets/images/icons/sunny_icon_gold.png');
    highestCount = containsSunny;
  }

  return imageToReturn;
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
    isSunsetDataLoading: true,
    isWeatherDataLoading: true,
    locationName: action.locationName,
    selectedLocation: previousState.selectedLocation,
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

