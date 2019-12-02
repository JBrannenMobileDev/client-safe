import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class NewLocationPageState{

  final bool shouldClear;
  final String locationName;
  final String newLocationAddress;
  final double newLocationLatitude;
  final double newLocationLongitude;
  final List<Location> locations;
  final Function(LatLng) onLocationChanged;
  final Function() onSaveLocationSelected;
  final Function() onDeleteSelected;
  final Function() onCanceledSelected;
  final Function(String) onLocationNameChanged;

  NewLocationPageState({
    @required this.shouldClear,
    @required this.locationName,
    @required this.newLocationAddress,
    @required this.newLocationLatitude,
    @required this.newLocationLongitude,
    @required this.locations,
    @required this.onLocationChanged,
    @required this.onSaveLocationSelected,
    @required this.onDeleteSelected,
    @required this.onCanceledSelected,
    @required this.onLocationNameChanged,
  });

  NewLocationPageState copyWith({
    bool shouldClear,
    String locationName,
    String newLocationAddress,
    double newLocationLatitude,
    double newLocationLongitude,
    List<Location> locations,
    Function(int) onLocationChanged,
    Function() onDeleteLocationSelected,
    Function() onDeleteSelected,
    Function() onCanceledSelected,
    Function(String) onLocationNameChanged,
  }){
    return NewLocationPageState(
      shouldClear: shouldClear?? this.shouldClear,
      locationName: locationName?? this.locationName,
      newLocationAddress: newLocationAddress?? this.newLocationAddress,
      newLocationLatitude: newLocationLatitude?? this.newLocationLatitude,
      newLocationLongitude: newLocationLongitude?? this.newLocationLongitude,
      locations: locations?? this.locations,
      onLocationChanged: onLocationChanged?? this.onLocationChanged,
      onSaveLocationSelected: onDeleteLocationSelected?? this.onSaveLocationSelected,
      onCanceledSelected: onCanceledSelected?? this.onCanceledSelected,
      onDeleteSelected: onDeleteSelected?? this.onDeleteSelected,
      onLocationNameChanged: onLocationNameChanged?? this.onLocationNameChanged,
    );
  }

  factory NewLocationPageState.initial() => NewLocationPageState(
    shouldClear: true,
    locationName: "",
    newLocationAddress: "",
    newLocationLatitude: 0.0,
    newLocationLongitude: 0.0,
    locations: List(),
    onLocationChanged: null,
    onSaveLocationSelected: null,
    onCanceledSelected: null,
    onDeleteSelected: null,
    onLocationNameChanged: null,
  );

  factory NewLocationPageState.fromStore(Store<AppState> store) {
    return NewLocationPageState(
      shouldClear: store.state.newLocationPageState.shouldClear,
      locationName: store.state.newLocationPageState.locationName,
      newLocationAddress: store.state.newLocationPageState.newLocationAddress,
      newLocationLatitude: store.state.newLocationPageState.newLocationLatitude,
      newLocationLongitude: store.state.newLocationPageState.newLocationLongitude,
      locations: store.state.newLocationPageState.locations,
      onLocationChanged: (latLng) => store.dispatch(UpdateLocation(store.state.newLocationPageState, latLng)),
      onSaveLocationSelected: () => store.dispatch(SaveLocationAction(store.state.newLocationPageState)),
      onCanceledSelected: () => store.dispatch(ClearStateAction(store.state.newLocationPageState)),
      onDeleteSelected: () => store.dispatch(DeleteLocation(store.state.newLocationPageState)),
      onLocationNameChanged: (name) => store.dispatch(UpdateLocationName(store.state.newLocationPageState, name)),
    );
  }

  @override
  int get hashCode =>
      shouldClear.hashCode ^
      locationName.hashCode ^
      newLocationAddress.hashCode ^
      newLocationLatitude.hashCode ^
      newLocationLongitude.hashCode ^
      locations.hashCode ^
      onLocationChanged.hashCode ^
      onSaveLocationSelected.hashCode ^
      onCanceledSelected.hashCode ^
      onDeleteSelected.hashCode ^
      onLocationNameChanged.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewLocationPageState &&
              shouldClear == other.shouldClear &&
              locationName == other.locationName &&
              newLocationAddress == other.newLocationAddress &&
              newLocationLatitude == other.newLocationLatitude &&
              newLocationLongitude == other.newLocationLongitude &&
              locations == other.locations &&
              onLocationChanged == other.onLocationChanged &&
              onSaveLocationSelected == other.onSaveLocationSelected &&
              onCanceledSelected == other.onCanceledSelected &&
              onDeleteSelected == other.onDeleteSelected &&
              onLocationNameChanged == other.onLocationNameChanged;
}