import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetActions.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';

@immutable
class MapLocationSelectionWidgetState {
  final Function(String)? onSearchInputChanged;
  final Function(String)? onThrottleGetLocations;
  final String? searchText;
  final double? lat;
  final double? lng;
  final LocationDandy? selectedSearchLocation;
  final List<PlacesLocation>? locationResults;
  final Function(PlacesLocation)? onSearchLocationSelected;
  final Function(LatLng)? onMapLocationChanged;
  final Function()? onClearSearchTextSelected;

  MapLocationSelectionWidgetState({
    @required this.lat,
    @required this.lng,
    @required this.onSearchInputChanged,
    @required this.searchText,
    @required this.locationResults,
    @required this.onSearchLocationSelected,
    @required this.onThrottleGetLocations,
    @required this.onMapLocationChanged,
    @required this.selectedSearchLocation,
    @required this.onClearSearchTextSelected,
  });

  MapLocationSelectionWidgetState copyWith({
    Function(LatLng)? onMapLocationChanged,
    double? lat,
    double? lng,
    Function(String)? onSearchInputChanged,
    String? searchText,
    List<PlacesLocation>? locationResults,
    Function(PlacesLocation)? onSearchLocationSelected,
    Function(String)? onThrottleGetLocations,
    List<PlacesLocation>? locationsResults,
    LocationDandy? selectedSearchLocation,
    Function()? onClearSearchTextSelected,
  }){
    return MapLocationSelectionWidgetState(
      onMapLocationChanged: onMapLocationChanged ?? this.onMapLocationChanged,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      onSearchInputChanged: onSearchInputChanged ?? this.onSearchInputChanged,
      searchText: searchText ?? this.searchText,
      locationResults: locationResults ?? this.locationResults,
      onSearchLocationSelected: onSearchLocationSelected ?? this.onSearchLocationSelected,
      onThrottleGetLocations: onThrottleGetLocations ?? this.onThrottleGetLocations,
      selectedSearchLocation: selectedSearchLocation ?? this.selectedSearchLocation,
      onClearSearchTextSelected: onClearSearchTextSelected ?? this.onClearSearchTextSelected,
    );
  }

  factory MapLocationSelectionWidgetState.initial() => MapLocationSelectionWidgetState(
        onMapLocationChanged: null,
        lat: 0.0,
        lng: 0.0,
        onSearchInputChanged: null,
        searchText: '',
        locationResults: [],
        onSearchLocationSelected: null,
        onThrottleGetLocations: null,
        selectedSearchLocation: null,
        onClearSearchTextSelected: null,
      );

  factory MapLocationSelectionWidgetState.fromStore(Store<AppState> store) {
    return MapLocationSelectionWidgetState(
      lat: store.state.mapLocationSelectionWidgetState!.lat,
      lng: store.state.mapLocationSelectionWidgetState!.lng,
      searchText: store.state.mapLocationSelectionWidgetState!.searchText,
      locationResults: store.state.mapLocationSelectionWidgetState!.locationResults,
      selectedSearchLocation: store.state.mapLocationSelectionWidgetState!.selectedSearchLocation,
      onMapLocationChanged: (newLatLng) => store.dispatch(SetCurrentMapLatLngAction(store.state.mapLocationSelectionWidgetState, newLatLng)),
      onSearchInputChanged: (input) => store.dispatch(SetSearchTextAction(store.state.mapLocationSelectionWidgetState, input)),
      onSearchLocationSelected: (searchLocation) {
        store.dispatch(FetchSearchLocationDetails(store.state.mapLocationSelectionWidgetState, searchLocation));
        store.dispatch(SetSearchTextAction(store.state.mapLocationSelectionWidgetState, searchLocation.name));
      },
      onThrottleGetLocations: (input) => store.dispatch(FetchGoogleLocationsAction(store.state.mapLocationSelectionWidgetState, input)),
      onClearSearchTextSelected: () => store.dispatch(ClearSearchTextAction(store.state.mapLocationSelectionWidgetState)),
    );
  }

  @override
  int get hashCode =>
      onSearchInputChanged.hashCode ^
      locationResults.hashCode ^
      onMapLocationChanged.hashCode ^
      lat.hashCode ^
      onClearSearchTextSelected.hashCode ^
      lng.hashCode ^
      selectedSearchLocation.hashCode ^
      onSearchLocationSelected.hashCode ^
      searchText.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapLocationSelectionWidgetState &&
          locationResults == other.locationResults &&
          onSearchLocationSelected == other.onSearchLocationSelected &&
          onSearchInputChanged == other.onSearchInputChanged &&
          searchText == other.searchText &&
          selectedSearchLocation == other.selectedSearchLocation &&
          lat == other.lat &&
          onClearSearchTextSelected == other.onClearSearchTextSelected &&
          lng == other.lng &&
          onMapLocationChanged == other.onMapLocationChanged;
}
