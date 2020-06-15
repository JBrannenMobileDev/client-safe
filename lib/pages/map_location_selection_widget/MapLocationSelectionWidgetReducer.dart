import 'package:client_safe/pages/map_location_selection_widget/MapLocationSelectionWidgetActions.dart';
import 'package:client_safe/pages/map_location_selection_widget/MapLocationSelectionWidgetState.dart';
import 'package:redux/redux.dart';

final mapLocationSelectionWidgetReducer = combineReducers<MapLocationSelectionWidgetState>([
  TypedReducer<MapLocationSelectionWidgetState, SetInitialMapLatLng>(_setInitMapLatLng),
  TypedReducer<MapLocationSelectionWidgetState, SetCurrentMapLatLngAction>(_setCurrentMapLatLng),
  TypedReducer<MapLocationSelectionWidgetState, SetInitialMapLatLng>(_setInitMapLatLng),
  TypedReducer<MapLocationSelectionWidgetState, SetLocationResultsAction>(_setLocationResults),
  TypedReducer<MapLocationSelectionWidgetState, SetSelectedSearchLocation>(_setSelectedSearchLocation),
  TypedReducer<MapLocationSelectionWidgetState, SetSearchTextAction>(_setSearchText),
  TypedReducer<MapLocationSelectionWidgetState, ClearState>(_clearState),
  TypedReducer<MapLocationSelectionWidgetState, ClearSearchTextAction>(_clearSearchText),
]);

MapLocationSelectionWidgetState _clearSearchText(MapLocationSelectionWidgetState previousState, ClearSearchTextAction action){
  return previousState.copyWith(
    searchText: '',
      locationResults: List(),
  );
}

MapLocationSelectionWidgetState _clearState(MapLocationSelectionWidgetState previousState, ClearState action){
  return MapLocationSelectionWidgetState.initial();
}

MapLocationSelectionWidgetState _setSearchText(MapLocationSelectionWidgetState previousState, SetSearchTextAction action){
  return previousState.copyWith(
    searchText: action.input,
  );
}

MapLocationSelectionWidgetState _setSelectedSearchLocation(MapLocationSelectionWidgetState previousState, SetSelectedSearchLocation action){
  return previousState.copyWith(
    selectedSearchLocation: action.selectedSearchLocation,
    locationResults: List(),
  );
}

MapLocationSelectionWidgetState _setLocationResults(MapLocationSelectionWidgetState previousState, SetLocationResultsAction action){
  return previousState.copyWith(
    locationResults: action.locations,
  );
}

MapLocationSelectionWidgetState _setCurrentMapLatLng(MapLocationSelectionWidgetState previousState, SetCurrentMapLatLngAction action){
  return previousState.copyWith(
    lat: action.currentLatLng.latitude,
    lng: action.currentLatLng.longitude,
  );
}

MapLocationSelectionWidgetState _setInitMapLatLng(MapLocationSelectionWidgetState previousState, SetInitialMapLatLng action){
  return previousState.copyWith(
    lat: action.lat,
    lng: action.lng,
  );
}