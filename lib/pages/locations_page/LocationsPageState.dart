
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
  final bool isLoadingImages;
  final Function(Location) onLocationSelected;
  final Function(Location) onDeleteLocationSelected;
  final Function(Location) onDrivingDirectionsSelected;
  final Function(Location) onShareLocationSelected;
  final Function() clearNewLocationState;
  final List<File> locationImages;


  LocationsPageState({
    @required this.locations,
    @required this.shouldClear,
    @required this.onLocationSelected,
    @required this.onDeleteLocationSelected,
    @required this.onDrivingDirectionsSelected,
    @required this.onShareLocationSelected,
    @required this.clearNewLocationState,
    @required this.locationImages,
    @required this.isLoadingImages,
  });

  LocationsPageState copyWith({
    List<Location> locations,
    bool shouldClear,
    Function(int) onLocationSelected,
    Function(PriceProfile) onDeleteLocationSelected,
    Function(Location) onDrivingDirectionsSelected,
    Function(Location) onShareLocationSelected,
    Function() clearNewLocationState,
    List<File> locationImages,
    bool isLoadingImages,
  }){
    return LocationsPageState(
      locations: locations?? this.locations,
      shouldClear: shouldClear?? this.shouldClear,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
      onDeleteLocationSelected: onDeleteLocationSelected?? this.onDeleteLocationSelected,
      onDrivingDirectionsSelected: onDrivingDirectionsSelected?? this.onDrivingDirectionsSelected,
      onShareLocationSelected: onShareLocationSelected?? this.onShareLocationSelected,
      clearNewLocationState: clearNewLocationState ?? this.clearNewLocationState,
      locationImages: locationImages ?? this.locationImages,
      isLoadingImages: isLoadingImages ?? this.isLoadingImages,
    );
  }

  factory LocationsPageState.initial() => LocationsPageState(
    locations: [],
    shouldClear: true,
    onLocationSelected: null,
    onDeleteLocationSelected: null,
    onDrivingDirectionsSelected: null,
    onShareLocationSelected: null,
    clearNewLocationState: null,
    isLoadingImages: true,
    locationImages: [],
  );

  factory LocationsPageState.fromStore(Store<AppState> store) {
    return LocationsPageState(
      locations: store.state.locationsPageState.locations,
      shouldClear: store.state.locationsPageState.shouldClear,
      locationImages: store.state.locationsPageState.locationImages,
      isLoadingImages: store.state.locationsPageState.isLoadingImages,
      onLocationSelected: (location) => store.dispatch(LoadExistingLocationData(store.state.newLocationPageState, location)),
      onDeleteLocationSelected: (location) => store.dispatch(DeleteLocationAction(store.state.locationsPageState, location)),
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
      onDeleteLocationSelected.hashCode ^
      onDrivingDirectionsSelected.hashCode ^
      clearNewLocationState.hashCode ^
      locationImages.hashCode ^
      isLoadingImages.hashCode ^
      onShareLocationSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocationsPageState &&
              locations == other.locations &&
              clearNewLocationState == other.clearNewLocationState &&
              shouldClear == other.shouldClear &&
              onLocationSelected == other.onLocationSelected &&
              onDeleteLocationSelected == other.onDeleteLocationSelected &&
              onDrivingDirectionsSelected == other.onDrivingDirectionsSelected &&
              locationImages == other.locationImages &&
              isLoadingImages == other.isLoadingImages &&
              onShareLocationSelected == other.onShareLocationSelected;
}