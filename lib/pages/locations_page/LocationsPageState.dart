import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/locations_page/LocationsActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class LocationsPageState{

  final List<Location> locations;
  final Function(Location) onLocationSelected;
  final Function(Location) onDeleteLocationSelected;
  final Function(String, Location) saveImagePath;
  final Function(Location) onDrivingDirectionsSelected;
  final Function(Location) onShareLocationSelected;

  LocationsPageState({
    @required this.locations,
    @required this.onLocationSelected,
    @required this.onDeleteLocationSelected,
    @required this.saveImagePath,
    @required this.onDrivingDirectionsSelected,
    @required this.onShareLocationSelected,
  });

  LocationsPageState copyWith({
    List<Location> locations,
    Function(int) onLocationSelected,
    Function(PriceProfile) onDeleteLocationSelected,
    Function(String) saveImagePath,
    Function(Location) onDrivingDirectionsSelected,
    Function(Location) onShareLocationSelected,
  }){
    return LocationsPageState(
      locations: locations?? this.locations,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
      onDeleteLocationSelected: onDeleteLocationSelected?? this.onDeleteLocationSelected,
      saveImagePath: saveImagePath?? this.saveImagePath,
      onDrivingDirectionsSelected: onDrivingDirectionsSelected?? this.onDrivingDirectionsSelected,
      onShareLocationSelected: onShareLocationSelected?? this.onShareLocationSelected,
    );
  }

  factory LocationsPageState.initial() => LocationsPageState(
    locations: List(),
    onLocationSelected: null,
    onDeleteLocationSelected: null,
    saveImagePath: null,
    onDrivingDirectionsSelected: null,
    onShareLocationSelected: null,
  );

  factory LocationsPageState.fromStore(Store<AppState> store) {
    return LocationsPageState(
      locations: store.state.locationsPageState.locations,
      onLocationSelected: null,
      onDeleteLocationSelected: (location) => store.dispatch(DeleteLocationAction(store.state.locationsPageState, location)),
      saveImagePath: (imagePath, location) => store.dispatch(SaveImagePathAction(store.state.locationsPageState, imagePath, location)),
      onDrivingDirectionsSelected: (location) => store.dispatch(DrivingDirectionsSelected(store.state.locationsPageState, location)),
      onShareLocationSelected: (location) => store.dispatch(ShareLocationSelected(store.state.locationsPageState, location)),
    );
  }

  @override
  int get hashCode =>
      locations.hashCode ^
      onLocationSelected.hashCode ^
      onDeleteLocationSelected.hashCode ^
      saveImagePath.hashCode ^
      onDrivingDirectionsSelected.hashCode ^
      onShareLocationSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocationsPageState &&
              locations == other.locations &&
              onLocationSelected == other.onLocationSelected &&
              onDeleteLocationSelected == other.onDeleteLocationSelected &&
              saveImagePath == other.saveImagePath &&
              onDrivingDirectionsSelected == other.onDrivingDirectionsSelected &&
              onShareLocationSelected == other.onShareLocationSelected;
}