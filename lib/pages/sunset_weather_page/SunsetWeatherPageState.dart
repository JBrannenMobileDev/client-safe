import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/rest_models/OneHourForecast.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';

class SunsetWeatherPageState {
  final int selectedFilterIndex;
  final Function(int) onSelectorChanged;
  final String locationName;
  final Function() onFetchCurrentLocation;
  final String morningBlueHour;
  final String sunrise;
  final String morningGoldenHour;
  final String eveningGoldenHour;
  final String sunset;
  final DateTime sunsetTimestamp;
  final String eveningBlueHour;
  final String weatherDescription;
  final String chanceOfRain;
  final String cloudCoverage;
  final AssetImage weatherIcon;
  final DateTime selectedDate;
  final String tempHigh;
  final String tempLow;
  final Function(DateTime) onDateSelected;
  final bool showFartherThan7DaysError;
  final bool isWeatherDataLoading;
  final bool isSunsetDataLoading;
  final List<OneHourForecast> hoursForecast;
  final int pageViewIndex;
  final Function() onNextPressed;
  final Function() onSaveLocationSelected;
  final Function() onCanceledSelected;
  final Function() onBackPressed;
  final List<Location> locations;
  final Location selectedLocation;
  final Function(Location) onLocationSelected;
  final Function() onLocationSaved;
  final String documentPath;
  final LatLng currentMapLatLng;
  final Function(LatLng) onMapLocationChanged;
  final Function() onMapLocationSaved;
  final double lat;
  final double lng;

  SunsetWeatherPageState({
    @required this.selectedFilterIndex,
    @required this.onSelectorChanged,
    @required this.locationName,
    @required this.onFetchCurrentLocation,
    @required this.morningBlueHour,
    @required this.sunrise,
    @required this.morningGoldenHour,
    @required this.eveningGoldenHour,
    @required this.sunset,
    @required this.eveningBlueHour,
    @required this.weatherDescription,
    @required this.chanceOfRain,
    @required this.cloudCoverage,
    @required this.weatherIcon,
    @required this.selectedDate,
    @required this.tempHigh,
    @required this.tempLow,
    @required this.onDateSelected,
    @required this.sunsetTimestamp,
    @required this.showFartherThan7DaysError,
    @required this.isSunsetDataLoading,
    @required this.isWeatherDataLoading,
    @required this.hoursForecast,
    @required this.pageViewIndex,
    @required this.onNextPressed,
    @required this.onSaveLocationSelected,
    @required this.onCanceledSelected,
    @required this.onBackPressed,
    @required this.locations,
    @required this.selectedLocation,
    @required this.onLocationSelected,
    @required this.documentPath,
    @required this.onLocationSaved,
    @required this.onMapLocationChanged,
    @required this.currentMapLatLng,
    @required this.onMapLocationSaved,
    @required this.lat,
    @required this.lng,
  });

  SunsetWeatherPageState copyWith({
    int selectedFilterIndex,
    Function(int) onSelectorChanged,
    String locationName,
    Function() onFetchCurrentLocation,
    String morningBlueHour,
    String sunrise,
    String morningGoldenHour,
    String eveningGoldenHour,
    String sunset,
    String eveningBlueHour,
    String weatherDescription,
    String chanceOfRain,
    String cloudCoverage,
    AssetImage weatherIcon,
    DateTime selectedDate,
    String tempHigh,
    String tempLow,
    Function(DateTime) onDateSelected,
    DateTime sunsetTimestamp,
    bool showFartherThan7DaysError,
    bool isWeatherDataLoading,
    bool isSunsetDataLoading,
    List<OneHourForecast> hoursForecast,
    int pageViewIndex,
    Function() onNextPressed,
    Function() onSaveLocationSelected,
    Function() onCanceledSelected,
    Function() onBackPressed,
    List<Location> locations,
    Location selectedLocation,
    Function(Location) onLocationSelected,
    String documentPath,
    Function() onLocationSaved,
    LatLng currentMapLatLng,
    Function(LatLng) onMapLocationChanged,
    Function() onMapLocationSaved,
    double lat,
    double lng,
  }){
    return SunsetWeatherPageState(
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      onSelectorChanged: onSelectorChanged ?? this.onSelectorChanged,
      locationName: locationName ?? this.locationName,
      onFetchCurrentLocation: onFetchCurrentLocation ?? this.onFetchCurrentLocation,
      morningBlueHour: morningBlueHour ?? this.morningBlueHour,
      sunrise: sunrise ?? this.sunrise,
      morningGoldenHour: morningGoldenHour ?? this.morningGoldenHour,
      eveningGoldenHour:  eveningGoldenHour ?? this.eveningGoldenHour,
      sunset:  sunset ?? this.sunset,
      eveningBlueHour: eveningBlueHour ?? this.eveningBlueHour,
      weatherDescription: weatherDescription ?? this.weatherDescription,
      chanceOfRain: chanceOfRain ?? this.chanceOfRain,
      cloudCoverage: cloudCoverage ?? this.cloudCoverage,
      weatherIcon: weatherIcon ?? this.weatherIcon,
      selectedDate: selectedDate ?? this.selectedDate,
      tempHigh: tempHigh ?? this.tempHigh,
      tempLow: tempLow ?? this.tempLow,
      onDateSelected: onDateSelected ?? this.onDateSelected,
      sunsetTimestamp: sunsetTimestamp ?? this.sunsetTimestamp,
      showFartherThan7DaysError: showFartherThan7DaysError ?? this.showFartherThan7DaysError,
      isSunsetDataLoading: isSunsetDataLoading ?? this.isSunsetDataLoading,
      isWeatherDataLoading: isWeatherDataLoading ?? this.isWeatherDataLoading,
      hoursForecast: hoursForecast ?? this.hoursForecast,
      pageViewIndex: pageViewIndex ?? this.pageViewIndex,
      onNextPressed: onNextPressed ?? this.onNextPressed,
      onSaveLocationSelected: onSaveLocationSelected ?? this.onSaveLocationSelected,
      onCanceledSelected: onCanceledSelected ?? this.onCanceledSelected,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      onLocationSelected: onLocationSelected ?? this.onLocationSelected,
      documentPath: documentPath ?? this.documentPath,
      onLocationSaved: onLocationSaved ?? this.onLocationSaved,
      currentMapLatLng: currentMapLatLng ?? this.currentMapLatLng,
      onMapLocationChanged: onMapLocationChanged ?? this.onMapLocationChanged,
      onMapLocationSaved: onMapLocationSaved ?? this.onMapLocationSaved,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  factory SunsetWeatherPageState.initial() => SunsetWeatherPageState(
    selectedFilterIndex: 0,
    onSelectorChanged: null,
    locationName: 'Location',
    onFetchCurrentLocation: null,
    morningBlueHour: '',
    sunrise: '',
    morningGoldenHour: '',
    eveningGoldenHour:  '',
    sunset:  '',
    eveningBlueHour: '',
    weatherDescription: '',
    chanceOfRain: '0',
    cloudCoverage: '0',
    weatherIcon: null,
    selectedDate: DateTime.now(),
    tempHigh: '0',
    tempLow: '0',
    onDateSelected: null,
    sunsetTimestamp: null,
    showFartherThan7DaysError: false,
    isWeatherDataLoading: true,
    isSunsetDataLoading: true,
    hoursForecast: List(),
    pageViewIndex: 0,
    onNextPressed: null,
    onSaveLocationSelected: null,
    onCanceledSelected: null,
    onBackPressed: null,
    locations: null,
    selectedLocation: null,
    onLocationSelected: null,
    documentPath: '',
    onLocationSaved: null,
    currentMapLatLng: null,
    onMapLocationChanged: null,
    onMapLocationSaved: null,
    lat: 0.0,
    lng: 0.0,
  );

  factory SunsetWeatherPageState.fromStore(Store<AppState> store) {
    return SunsetWeatherPageState(
      selectedFilterIndex: store.state.sunsetWeatherPageState.selectedFilterIndex,
      locationName: store.state.sunsetWeatherPageState.locationName,
      morningBlueHour: store.state.sunsetWeatherPageState.morningBlueHour,
      sunrise: store.state.sunsetWeatherPageState.sunrise,
      morningGoldenHour: store.state.sunsetWeatherPageState.morningGoldenHour,
      eveningGoldenHour: store.state.sunsetWeatherPageState.eveningGoldenHour,
      sunset: store.state.sunsetWeatherPageState.sunset,
      eveningBlueHour: store.state.sunsetWeatherPageState.eveningBlueHour,
      weatherDescription: store.state.sunsetWeatherPageState.weatherDescription,
      chanceOfRain: store.state.sunsetWeatherPageState.chanceOfRain,
      cloudCoverage: store.state.sunsetWeatherPageState.cloudCoverage,
      weatherIcon: store.state.sunsetWeatherPageState.weatherIcon,
      selectedDate: store.state.sunsetWeatherPageState.selectedDate,
      tempHigh: store.state.sunsetWeatherPageState.tempHigh,
      tempLow: store.state.sunsetWeatherPageState.tempLow,
      sunsetTimestamp: store.state.sunsetWeatherPageState.sunsetTimestamp,
      isWeatherDataLoading: store.state.sunsetWeatherPageState.isWeatherDataLoading,
      isSunsetDataLoading: store.state.sunsetWeatherPageState.isSunsetDataLoading,
      showFartherThan7DaysError: store.state.sunsetWeatherPageState.showFartherThan7DaysError,
      hoursForecast: store.state.sunsetWeatherPageState.hoursForecast,
      pageViewIndex: store.state.sunsetWeatherPageState.pageViewIndex,
      onNextPressed: store.state.sunsetWeatherPageState.onNextPressed,
      onSaveLocationSelected: store.state.sunsetWeatherPageState.onSaveLocationSelected,
      onCanceledSelected: store.state.sunsetWeatherPageState.onCanceledSelected,
      onBackPressed: store.state.sunsetWeatherPageState.onBackPressed,
      locations: store.state.sunsetWeatherPageState.locations,
      selectedLocation: store.state.sunsetWeatherPageState.selectedLocation,
      documentPath: store.state.sunsetWeatherPageState.documentPath,
      currentMapLatLng: store.state.sunsetWeatherPageState.currentMapLatLng,
      lat: store.state.sunsetWeatherPageState.lat,
      lng: store.state.sunsetWeatherPageState.lng,
      onSelectorChanged: (index) => store.dispatch(FilterSelectorChangedAction(store.state.sunsetWeatherPageState, index)),
      onFetchCurrentLocation: () => store.dispatch(SetLastKnowPosition(store.state.sunsetWeatherPageState)),
      onDateSelected: (newDate) => store.dispatch(FetchDataForSelectedDateAction(store.state.sunsetWeatherPageState, newDate)),
      onLocationSelected: (selectedLocation) => store.dispatch(SetSelectedLocationAction(store.state.sunsetWeatherPageState, selectedLocation)),
      onLocationSaved: () => store.dispatch(OnLocationSavedAction(store.state.sunsetWeatherPageState)),
      onMapLocationChanged: (newLatLng) => store.dispatch(SetCurrentMapLatLngAction(store.state.sunsetWeatherPageState, newLatLng)),
      onMapLocationSaved: () => store.dispatch(SaveCurrentMapLatLngAction(store.state.sunsetWeatherPageState)),
    );
  }

  @override
  int get hashCode =>
    selectedFilterIndex.hashCode ^
    locationName.hashCode ^
    onFetchCurrentLocation.hashCode ^
    morningBlueHour.hashCode ^
    sunrise.hashCode ^
    morningGoldenHour.hashCode ^
    eveningGoldenHour.hashCode ^
    sunset.hashCode ^
    eveningBlueHour.hashCode ^
    weatherDescription.hashCode ^
    chanceOfRain.hashCode ^
    cloudCoverage.hashCode ^
    weatherIcon.hashCode ^
    selectedDate.hashCode ^
    tempHigh.hashCode ^
    tempLow.hashCode ^
    sunsetTimestamp.hashCode ^
    showFartherThan7DaysError.hashCode ^
    isWeatherDataLoading.hashCode ^
    isSunsetDataLoading.hashCode ^
    hoursForecast.hashCode ^
    pageViewIndex.hashCode ^
    onNextPressed.hashCode ^
    onSaveLocationSelected.hashCode ^
    onCanceledSelected.hashCode ^
    onBackPressed.hashCode ^
    locations.hashCode ^
    selectedLocation.hashCode ^
    documentPath.hashCode ^
    currentMapLatLng.hashCode ^
    onMapLocationChanged.hashCode ^
    onMapLocationSaved.hashCode ^
    lat.hashCode ^
    lng.hashCode ^
    onSelectorChanged.hashCode
   ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SunsetWeatherPageState &&
          pageViewIndex == other.pageViewIndex &&
          onNextPressed == other.onNextPressed &&
          onSaveLocationSelected == other.onSaveLocationSelected &&
          onCanceledSelected == other.onCanceledSelected &&
          onBackPressed == other.onBackPressed &&
          selectedFilterIndex == other.selectedFilterIndex &&
          locationName == other.locationName &&
          onFetchCurrentLocation == other.onFetchCurrentLocation &&
          morningBlueHour == other.morningBlueHour &&
          sunrise == other.sunrise &&
          morningGoldenHour == other.morningGoldenHour &&
          eveningGoldenHour == other.eveningGoldenHour &&
          sunset == other.sunset &&
          tempHigh == other.tempHigh &&
          tempLow == other.tempLow &&
          eveningBlueHour == other.eveningBlueHour &&
          weatherDescription == other.weatherDescription &&
          chanceOfRain == other.chanceOfRain &&
          cloudCoverage == other.cloudCoverage &&
          weatherIcon == other.weatherIcon &&
          selectedDate == other.selectedDate &&
          sunsetTimestamp == other.sunsetTimestamp &&
          showFartherThan7DaysError == other.showFartherThan7DaysError &&
          isWeatherDataLoading == other.isWeatherDataLoading &&
          isSunsetDataLoading == other.isSunsetDataLoading &&
          hoursForecast == other.hoursForecast &&
          locations == other.locations &&
          lat == other.lat &&
          lng == other.lng &&
          selectedLocation == other.selectedLocation &&
          documentPath == other.documentPath &&
          currentMapLatLng == other.currentMapLatLng &&
          onMapLocationSaved == other.onMapLocationSaved &&
          onMapLocationChanged == other.onMapLocationChanged &&
          onSelectorChanged == other.onSelectorChanged;
}
