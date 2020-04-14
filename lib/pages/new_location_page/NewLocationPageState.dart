import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class NewLocationPageState{
  final int id;
  final bool shouldClear;
  final String locationName;
  final String newLocationAddress;
  final int pageViewIndex;
  final double newLocationLatitude;
  final double newLocationLongitude;
  final String imagePath;
  final List<Location> locations;
  final Function(LatLng) onLocationChanged;
  final Function() onSaveLocationSelected;
  final Function() onDeleteSelected;
  final Function() onCanceledSelected;
  final Function(String) onLocationNameChanged;
  final Function() onNextPressed;
  final Function() onBackPressed;

  NewLocationPageState({
    @required this.id,
    @required this.shouldClear,
    @required this.locationName,
    @required this.pageViewIndex,
    @required this.newLocationAddress,
    @required this.newLocationLatitude,
    @required this.newLocationLongitude,
    @required this.imagePath,
    @required this.locations,
    @required this.onLocationChanged,
    @required this.onSaveLocationSelected,
    @required this.onDeleteSelected,
    @required this.onCanceledSelected,
    @required this.onLocationNameChanged,
    @required this.onNextPressed,
    @required this.onBackPressed,
  });

  NewLocationPageState copyWith({
    int id,
    bool shouldClear,
    String locationName,
    int pageViewIndex,
    String newLocationAddress,
    double newLocationLatitude,
    double newLocationLongitude,
    String imagePath,
    List<Location> locations,
    Function(int) onLocationChanged,
    Function() onDeleteLocationSelected,
    Function(Location) onSaveLocationSelected,
    Function() onDeleteSelected,
    Function() onCanceledSelected,
    Function(String) onLocationNameChanged,
    Function() onNextPressed,
    Function() onBackPressed,
  }){
    return NewLocationPageState(
      id: id?? this.id,
      shouldClear: shouldClear?? this.shouldClear,
      locationName: locationName?? this.locationName,
      pageViewIndex: pageViewIndex ?? this.pageViewIndex,
      newLocationAddress: newLocationAddress?? this.newLocationAddress,
      newLocationLatitude: newLocationLatitude?? this.newLocationLatitude,
      newLocationLongitude: newLocationLongitude?? this.newLocationLongitude,
      imagePath: imagePath?? this.imagePath,
      locations: locations?? this.locations,
      onLocationChanged: onLocationChanged?? this.onLocationChanged,
      onSaveLocationSelected: onSaveLocationSelected?? this.onSaveLocationSelected,
      onCanceledSelected: onCanceledSelected?? this.onCanceledSelected,
      onDeleteSelected: onDeleteSelected?? this.onDeleteSelected,
      onLocationNameChanged: onLocationNameChanged?? this.onLocationNameChanged,
      onNextPressed: onNextPressed ?? this.onNextPressed,
      onBackPressed: onBackPressed ?? this.onBackPressed,
    );
  }

  factory NewLocationPageState.initial() => NewLocationPageState(
    id: null,
    shouldClear: true,
    locationName: "",
    pageViewIndex: 0,
    newLocationAddress: "",
    newLocationLatitude: 0.0,
    newLocationLongitude: 0.0,
    imagePath: '',
    locations: List(),
    onLocationChanged: null,
    onSaveLocationSelected: null,
    onCanceledSelected: null,
    onDeleteSelected: null,
    onLocationNameChanged: null,
    onNextPressed: null,
    onBackPressed: null,
  );

  factory NewLocationPageState.fromStore(Store<AppState> store) {
    return NewLocationPageState(
      id: store.state.newLocationPageState.id,
      shouldClear: store.state.newLocationPageState.shouldClear,
      locationName: store.state.newLocationPageState.locationName,
      newLocationAddress: store.state.newLocationPageState.newLocationAddress,
      newLocationLatitude: store.state.newLocationPageState.newLocationLatitude,
      newLocationLongitude: store.state.newLocationPageState.newLocationLongitude,
      imagePath: store.state.newLocationPageState.imagePath,
      locations: store.state.newLocationPageState.locations,
      pageViewIndex: store.state.newLocationPageState.pageViewIndex,
      onLocationChanged: (latLng) => store.dispatch(UpdateLocation(store.state.newLocationPageState, latLng)),
      onSaveLocationSelected: () => store.dispatch(SaveLocationAction(store.state.newLocationPageState)),
      onCanceledSelected: () => store.dispatch(ClearStateAction(store.state.newLocationPageState)),
      onDeleteSelected: () => store.dispatch(DeleteLocation(store.state.newLocationPageState)),
      onLocationNameChanged: (name) => store.dispatch(UpdateLocationName(store.state.newLocationPageState, name)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newLocationPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newLocationPageState)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      shouldClear.hashCode ^
      locationName.hashCode ^
      pageViewIndex.hashCode ^
      newLocationAddress.hashCode ^
      newLocationLatitude.hashCode ^
      newLocationLongitude.hashCode ^
      imagePath.hashCode ^
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
              id == other.id &&
              shouldClear == other.shouldClear &&
              locationName == other.locationName &&
              pageViewIndex == other.pageViewIndex &&
              newLocationAddress == other.newLocationAddress &&
              newLocationLatitude == other.newLocationLatitude &&
              newLocationLongitude == other.newLocationLongitude &&
              imagePath == other.imagePath &&
              locations == other.locations &&
              onLocationChanged == other.onLocationChanged &&
              onSaveLocationSelected == other.onSaveLocationSelected &&
              onCanceledSelected == other.onCanceledSelected &&
              onDeleteSelected == other.onDeleteSelected &&
              onLocationNameChanged == other.onLocationNameChanged;
}