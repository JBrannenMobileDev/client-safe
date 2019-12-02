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

  LocationsPageState({
    @required this.locations,
    @required this.onLocationSelected,
    @required this.onDeleteLocationSelected,
  });

  LocationsPageState copyWith({
    List<Location> locations,
    Function(int) onLocationSelected,
    Function(PriceProfile) onDeleteLocationSelected,
  }){
    return LocationsPageState(
      locations: locations?? this.locations,
      onLocationSelected: onLocationSelected?? this.onLocationSelected,
      onDeleteLocationSelected: onDeleteLocationSelected?? this.onDeleteLocationSelected,
    );
  }

  factory LocationsPageState.initial() => LocationsPageState(
    locations: List(),
    onLocationSelected: null,
    onDeleteLocationSelected: null,
  );

  factory LocationsPageState.fromStore(Store<AppState> store) {
    return LocationsPageState(
      locations: store.state.locationsPageState.locations,
      onLocationSelected: null,
      onDeleteLocationSelected: (location) => store.dispatch(DeleteLocationAction(store.state.locationsPageState, location)),
    );
  }

  @override
  int get hashCode =>
      locations.hashCode ^
      onLocationSelected.hashCode ^
      onDeleteLocationSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocationsPageState &&
              locations == other.locations &&
              onLocationSelected == other.onLocationSelected &&
              onDeleteLocationSelected == other.onDeleteLocationSelected;
}