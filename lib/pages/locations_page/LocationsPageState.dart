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
  final String documentFilePath;
  final Function(Location) onLocationSelected;
  final Function(Location) onDeleteLocationSelected;
  final Function(String, Location) saveImagePath;
  final Function(Location) onDrivingDirectionsSelected;
  final Function(Location) onShareLocationSelected;
  final Function() clearNewLocationState;

  LocationsPageState({
    @required this.locations,
    @required this.shouldClear,
    @required this.documentFilePath,
    @required this.onLocationSelected,
    @required this.onDeleteLocationSelected,
    @required this.saveImagePath,
    @required this.onDrivingDirectionsSelected,
    @required this.onShareLocationSelected,
    @required this.clearNewLocationState,
  });

  LocationsPageState copyWith({
    List<Location> locations,
    bool shouldClear,
    String documentFilePath,
    Function(int) onLocationSelected,
    Function(PriceProfile) onDeleteLocationSelected,
    Function(String) saveImagePath,
    Function(Location) onDrivingDirectionsSelected,
    Function(Location) onShareLocationSelected,
    Function() clearNewLocationState,
  }){
    return LocationsPageState(
      locations: locations?? this.locations,
      documentFilePath: documentFilePath ?? this.documentFilePath,
      shouldClear: shouldClear?? this.shouldClear,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
      onDeleteLocationSelected: onDeleteLocationSelected?? this.onDeleteLocationSelected,
      saveImagePath: saveImagePath?? this.saveImagePath,
      onDrivingDirectionsSelected: onDrivingDirectionsSelected?? this.onDrivingDirectionsSelected,
      onShareLocationSelected: onShareLocationSelected?? this.onShareLocationSelected,
      clearNewLocationState: clearNewLocationState ?? this.clearNewLocationState,
    );
  }

  factory LocationsPageState.initial() => LocationsPageState(
    locations: List(),
    shouldClear: true,
    documentFilePath: '',
    onLocationSelected: null,
    onDeleteLocationSelected: null,
    saveImagePath: null,
    onDrivingDirectionsSelected: null,
    onShareLocationSelected: null,
    clearNewLocationState: null,
  );

  factory LocationsPageState.fromStore(Store<AppState> store) {
    return LocationsPageState(
      locations: store.state.locationsPageState.locations,
      shouldClear: store.state.locationsPageState.shouldClear,
      documentFilePath: store.state.locationsPageState.documentFilePath,
      onLocationSelected: (location) => store.dispatch(LoadExistingLocationData(store.state.newLocationPageState, location)),
      onDeleteLocationSelected: (location) => store.dispatch(DeleteLocationAction(store.state.locationsPageState, location)),
      saveImagePath: (imagePath, location) => store.dispatch(SaveImagePathAction(store.state.locationsPageState, imagePath, location)),
      onDrivingDirectionsSelected: (location) => store.dispatch(DrivingDirectionsSelected(store.state.locationsPageState, location)),
      onShareLocationSelected: (location) => store.dispatch(ShareLocationSelected(store.state.locationsPageState, location)),
      clearNewLocationState: () => store.dispatch(ClearStateAction(store.state.newLocationPageState)),
    );
  }

  @override
  int get hashCode =>
      locations.hashCode ^
      shouldClear.hashCode ^
      documentFilePath.hashCode ^
      onLocationSelected.hashCode ^
      onDeleteLocationSelected.hashCode ^
      saveImagePath.hashCode ^
      onDrivingDirectionsSelected.hashCode ^
      clearNewLocationState.hashCode ^
      onShareLocationSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocationsPageState &&
              locations == other.locations &&
              clearNewLocationState == other.clearNewLocationState &&
              documentFilePath == other.documentFilePath &&
              shouldClear == other.shouldClear &&
              onLocationSelected == other.onLocationSelected &&
              onDeleteLocationSelected == other.onDeleteLocationSelected &&
              saveImagePath == other.saveImagePath &&
              onDrivingDirectionsSelected == other.onDrivingDirectionsSelected &&
              onShareLocationSelected == other.onShareLocationSelected;
}