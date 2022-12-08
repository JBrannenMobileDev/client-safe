import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/DailyForecasts.dart';
import 'package:dandylight/models/rest_models/Hour.dart';
import 'package:dandylight/models/rest_models/OneDayForecast.dart';
import 'package:dandylight/models/rest_models/OneHourForecast.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

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
  TypedReducer<SunsetWeatherPageState, SetComingFromNewJobAction>(_setComingFromNewJob),
  TypedReducer<SunsetWeatherPageState, ClearPageStateAction>(_clearPageState),
  TypedReducer<SunsetWeatherPageState, SetHourlyForecastAction>(_setHourlyForecast),
]);

SunsetWeatherPageState _clearPageState(SunsetWeatherPageState previousState, ClearPageStateAction action){
  return SunsetWeatherPageState.initial();
}

SunsetWeatherPageState _setComingFromNewJob(SunsetWeatherPageState previousState, SetComingFromNewJobAction action){
  return previousState.copyWith(
    comingFromNewJob: action.isComingFromNewJob,
  );
}

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

SunsetWeatherPageState _setHourlyForecast(SunsetWeatherPageState previousState, SetHourlyForecastAction action) {
  return previousState.copyWith(
    hoursForecast: action.hours,
  );
}

SunsetWeatherPageState _setForecast(SunsetWeatherPageState previousState, SetForecastAction action){
  DailyForecasts matchingDay;
  for(DailyForecasts forecastDay in action.forecast5days.dailyForecasts){
    if(DateFormat('yyyy-MM-dd').format(previousState.selectedDate) == DateFormat('yyyy-MM-dd').format(DateTime.parse(forecastDay.date))) {
      matchingDay = forecastDay;
      break;
    }
  }

  bool isNight = DateTime.parse(matchingDay.date).hour > 17;

  return matchingDay != null ? previousState.copyWith(
    showFartherThan7DaysError: false,
    weatherDescription: isNight ? matchingDay.night.iconPhrase : matchingDay.day.iconPhrase,
    tempHigh: matchingDay.temperature.maximum.value.toInt().toString(),
    tempLow: matchingDay.temperature.minimum.value.toInt().toString(),
    chanceOfRain: isNight ? matchingDay.night.precipitationProbability.toString() : matchingDay.day.precipitationProbability.toString(),
    cloudCoverage: isNight ? matchingDay.night.cloudCover.toString() : matchingDay.day.cloudCover.toString(),
    weatherIcon: _getWeatherIcon(isNight ? matchingDay.night.icon : matchingDay.day.icon),
    isWeatherDataLoading: false,
    locations: action.locations,
  ) : previousState.copyWith(
    showFartherThan7DaysError: true,
  );
}

String _getWeatherIcon(int iconId) {
  String imageToReturn = 'assets/images/icons/sunny_icon_gold.png';
  switch(iconId) {
    case 1:
    case 2:
    case 30:
      imageToReturn = 'assets/images/icons/sunny_icon_gold.png';
      break;
    case 3:
    case 4:
    case 5:
      imageToReturn = 'assets/images/icons/partly_cloudy_icon.png';
      break;
    case 6:
    case 7:
    case 8:
    case 31:
      imageToReturn = 'assets/images/icons/cloudy_icon.png';
      break;
    case 11:
      imageToReturn = 'assets/images/icons/fog.png';
      break;
    case 12:
    case 13:
    case 14:
    case 18:
    case 29:
      imageToReturn = 'assets/images/icons/rainy_icon.png';
      break;
    case 15:
    case 16:
    case 17:
    case 41:
    case 42:
      imageToReturn = 'assets/images/icons/lightning_rain_icon.png';
      break;
    case 19:
    case 20:
    case 21:
    case 22:
    case 23:
    case 24:
    case 43:
    case 44:
      imageToReturn = 'assets/images/icons/snowing_icon.png';
      break;
    case 25:
    case 26:
      imageToReturn = 'assets/images/icons/hail_icon.png';
      break;
    case 32:
      imageToReturn = 'assets/images/icons/windy.png';
      break;
    case 33:
    case 34:
      imageToReturn = 'assets/images/icons/clear_night.png';
      break;
    case 35:
    case 36:
    case 37:
    case 38:
      imageToReturn = 'assets/images/icons/partly_cloudy_night.png';
      break;
    case 39:
    case 40:
      imageToReturn = 'assets/images/icons/rainy_night.png';
      break;
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

