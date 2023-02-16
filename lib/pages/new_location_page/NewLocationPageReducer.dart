import 'dart:io';

import 'package:dandylight/pages/new_location_page/NewLocationActions.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:redux/redux.dart';

final locationReducer = combineReducers<NewLocationPageState>([
  TypedReducer<NewLocationPageState, SetLocationsAction>(_setLocations),
  TypedReducer<NewLocationPageState, SetLatLongAction>(_setLatLong),
  TypedReducer<NewLocationPageState, ClearStateAction>(_clearState),
  TypedReducer<NewLocationPageState, UpdateLocation>(_updateLocation),
  TypedReducer<NewLocationPageState, UpdateLocationName>(_updateLocationName),
  TypedReducer<NewLocationPageState, LoadExistingLocationData>(_loadLocationData),
  TypedReducer<NewLocationPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewLocationPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewLocationPageState, SaveImagePathNewAction>(_setImagePath),
  TypedReducer<NewLocationPageState, SetLocationResultsAction>(_setLocationResults),
  TypedReducer<NewLocationPageState, SetSelectedSearchLocation>(_setSelectedSearchLocation),
  TypedReducer<NewLocationPageState, SetSearchTextAction>(_setSearchText),
  TypedReducer<NewLocationPageState, SetCurrentMapLatLngAction>(_setCurrentMapLatLng),
]);

NewLocationPageState _setCurrentMapLatLng(NewLocationPageState previousState, SetCurrentMapLatLngAction action){
  return previousState.copyWith(
    currentMapLatLng: action.currentLatLng,
  );
}

NewLocationPageState _setSearchText(NewLocationPageState previousState, SetSearchTextAction action){
  return previousState.copyWith(
    searchText: action.input,
  );
}

NewLocationPageState _setSelectedSearchLocation(NewLocationPageState previousState, SetSelectedSearchLocation action){
  return previousState.copyWith(
    selectedSearchLocation: action.selectedSearchLocation,
    newLocationLatitude: action.selectedSearchLocation.latitude,
    newLocationLongitude: action.selectedSearchLocation.longitude,
    locationsResults: [],
  );
}

NewLocationPageState _setLocationResults(NewLocationPageState previousState, SetLocationResultsAction action){
  return previousState.copyWith(
    locationsResults: action.locations,
  );
}

NewLocationPageState _setImagePath(NewLocationPageState previousState, SaveImagePathNewAction action) {
  return previousState.copyWith(
    imagePath: action.imagePath,
  );
}

NewLocationPageState _incrementPageViewIndex(NewLocationPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewLocationPageState _decrementPageViewIndex(NewLocationPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewLocationPageState _updatePageView(NewLocationPageState previousState, IncrementPageViewIndex action){
  return previousState.copyWith(
    pageViewIndex: (previousState.pageViewIndex + 1),
  );
}

NewLocationPageState _setLocations(NewLocationPageState previousState, SetLocationsAction action){
  return previousState.copyWith(
    locations: action.locations,
    pageViewIndex: 0,
  );
}

NewLocationPageState _setLatLong(NewLocationPageState previousState, SetLatLongAction action){
  return previousState.copyWith(
    newLocationLatitude: action.lat,
    newLocationLongitude: action.long,
  );
}

NewLocationPageState _clearState(NewLocationPageState previousState, ClearStateAction action) {
  NewLocationPageState newState = NewLocationPageState.initial();
  return newState.copyWith(
    newLocationLatitude: 0,
    newLocationLongitude: 0,
    pageViewIndex: 0,
  );
}

NewLocationPageState _updateLocation(NewLocationPageState previousState, UpdateLocation action) {
  return previousState.copyWith(
    newLocationLatitude: action.latLng.latitude,
    newLocationLongitude: action.latLng.longitude,
    locationUpdate: true,
    pageViewIndex: 2,
  );
}

NewLocationPageState _updateLocationName(NewLocationPageState previousState, UpdateLocationName action) {
  return previousState.copyWith(
    locationName: action.locationName,
  );
}

NewLocationPageState _loadLocationData(NewLocationPageState previousState, LoadExistingLocationData action){
  return previousState.copyWith(
    id: action.location.id,
    documentId: action.location.documentId,
    shouldClear: false,
    locationName: action.location.locationName,
    newLocationLatitude: action.location.latitude,
    newLocationLongitude: action.location.longitude,
    pageViewIndex: 0,
  );
}
