
import 'dart:io';

import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/locations_page/LocationsActions.dart';
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class LocationsPageState{

  final List<Location> locations;
  final bool shouldClear;
  final Function(Location) onLocationSelected;
  final Function(Location) onDrivingDirectionsSelected;
  final Function(Location) onShareLocationSelected;
  final Function() clearNewLocationState;
  final List<File> locationImages;


  LocationsPageState({
    @required this.locations,
    @required this.shouldClear,
    @required this.onLocationSelected,
    @required this.onDrivingDirectionsSelected,
    @required this.onShareLocationSelected,
    @required this.clearNewLocationState,
    @required this.locationImages,
  });

  LocationsPageState copyWith({
    List<Location> locations,
    bool shouldClear,
    Function(int) onLocationSelected,
    Function(Location) onDrivingDirectionsSelected,
    Function(Location) onShareLocationSelected,
    Function() clearNewLocationState,
    List<File> locationImages,
  }){
    return LocationsPageState(
      locations: locations?? this.locations,
      shouldClear: shouldClear?? this.shouldClear,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
      onDrivingDirectionsSelected: onDrivingDirectionsSelected?? this.onDrivingDirectionsSelected,
      onShareLocationSelected: onShareLocationSelected?? this.onShareLocationSelected,
      clearNewLocationState: clearNewLocationState ?? this.clearNewLocationState,
      locationImages: locationImages ?? this.locationImages,
    );
  }

  factory LocationsPageState.initial() => LocationsPageState(
    locations: [],
    shouldClear: true,
    onLocationSelected: null,
    onDrivingDirectionsSelected: null,
    onShareLocationSelected: null,
    clearNewLocationState: null,
    locationImages: [],
  );

  factory LocationsPageState.fromStore(Store<AppState> store) {
    return LocationsPageState(
      locations: store.state.locationsPageState.locations,
      shouldClear: store.state.locationsPageState.shouldClear,
      locationImages: store.state.locationsPageState.locationImages,
      onLocationSelected: (location) => store.dispatch(LoadExistingLocationData(store.state.newLocationPageState, location)),
      onDrivingDirectionsSelected: (location) => store.dispatch(DrivingDirectionsSelected(store.state.locationsPageState, location)),
      onShareLocationSelected: (location) => store.dispatch(ShareLocationSelected(store.state.locationsPageState, location)),
      clearNewLocationState: () => store.dispatch(ClearStateAction(store.state.newLocationPageState)),
    );
  }

  @override
  int get hashCode =>
      locations.hashCode ^
      shouldClear.hashCode ^
      onLocationSelected.hashCode ^
      onDrivingDirectionsSelected.hashCode ^
      clearNewLocationState.hashCode ^
      locationImages.hashCode ^
      onShareLocationSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocationsPageState &&
              locations == other.locations &&
              clearNewLocationState == other.clearNewLocationState &&
              shouldClear == other.shouldClear &&
              onLocationSelected == other.onLocationSelected &&
              onDrivingDirectionsSelected == other.onDrivingDirectionsSelected &&
              locationImages == other.locationImages &&
              onShareLocationSelected == other.onShareLocationSelected;
}