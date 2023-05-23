import 'dart:io';

import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class NewLocationPageState{
  final int id;
  final String documentId;
  final bool shouldClear;
  final bool locationUpdated;
  final String documentFilePath;
  final String locationName;
  final String newLocationAddress;
  final int pageViewIndex;
  final double newLocationLatitude;
  final double newLocationLongitude;
  final String imagePath;
  final LatLng selectedLatLng;
  final List<Location> locations;
  final Function(LatLng) onLocationChanged;
  final Function() onSaveLocationSelected;
  final Function() onDeleteSelected;
  final Function() onCanceledSelected;
  final Function(String) onLocationNameChanged;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(String) saveImagePath;
  final String searchText;
  final Location selectedSearchLocation;
  final List<PlacesLocation> locationsResults;
  final Function(LatLng) onMapLocationChanged;
  final Function() onMapLocationSaved;
  final Function(String) onThrottleGetLocations;
  final Function(String) onSearchInputChanged;
  final Function(PlacesLocation) onSearchLocationSelected;
  final LatLng currentMapLatLng;

  NewLocationPageState({
    @required this.id,
    @required this.documentId,
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
    @required this.documentFilePath,
    @required this.saveImagePath,
    @required this.locationUpdated,
    @required this.searchText,
    @required this.selectedSearchLocation,
    @required this.locationsResults,
    @required this.onMapLocationChanged,
    @required this.onThrottleGetLocations,
    @required this.onSearchInputChanged,
    @required this.onSearchLocationSelected,
    @required this.currentMapLatLng,
    @required this.onMapLocationSaved,
    @required this.selectedLatLng,
  });

  NewLocationPageState copyWith({
    int id,
    String documentId,
    bool shouldClear,
    bool locationUpdate,
    String locationName,
    int pageViewIndex,
    String newLocationAddress,
    double newLocationLatitude,
    double newLocationLongitude,
    String imagePath,
    String documentFilePath,
    List<Location> locations,
    LatLng selectedLatLng,
    Function(int) onLocationChanged,
    Function() onDeleteLocationSelected,
    Function(Location) onSaveLocationSelected,
    Function() onDeleteSelected,
    Function() onCanceledSelected,
    Function(String) onLocationNameChanged,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(String) saveImagePath,
    String searchText,
    Location selectedSearchLocation,
    List<PlacesLocation> locationsResults,
    Function(LatLng) onMapLocationChanged,
    Function() onMapLocationSaved,
    Function(String) onThrottleGetLocations,
    Function(String) onSearchInputChanged,
    Function(PlacesLocation) onSearchLocationSelected,
    LatLng currentMapLatLng,
  }){
    return NewLocationPageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
      shouldClear: shouldClear?? this.shouldClear,
      locationName: locationName?? this.locationName,
      pageViewIndex: pageViewIndex ?? this.pageViewIndex,
      newLocationAddress: newLocationAddress?? this.newLocationAddress,
      newLocationLatitude: newLocationLatitude?? this.newLocationLatitude,
      newLocationLongitude: newLocationLongitude?? this.newLocationLongitude,
      imagePath: imagePath?? this.imagePath,
      locations: locations?? this.locations,
      documentFilePath: documentFilePath ?? this.documentFilePath,
      onLocationChanged: onLocationChanged?? this.onLocationChanged,
      onSaveLocationSelected: onSaveLocationSelected?? this.onSaveLocationSelected,
      onCanceledSelected: onCanceledSelected?? this.onCanceledSelected,
      onDeleteSelected: onDeleteSelected?? this.onDeleteSelected,
      onLocationNameChanged: onLocationNameChanged?? this.onLocationNameChanged,
      onNextPressed: onNextPressed ?? this.onNextPressed,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      saveImagePath: saveImagePath ?? this.saveImagePath,
      locationUpdated: locationUpdate ?? this.locationUpdated,
      searchText: searchText ?? this.searchText,
      selectedSearchLocation: selectedSearchLocation ?? this.selectedSearchLocation,
      locationsResults: locationsResults ?? this.locationsResults,
      onMapLocationSaved: onMapLocationSaved ?? this.onMapLocationSaved,
      onThrottleGetLocations: onThrottleGetLocations ?? this.onThrottleGetLocations,
      onSearchInputChanged: onSearchInputChanged ?? this.onSearchInputChanged,
      onSearchLocationSelected: onSearchLocationSelected ?? this.onSearchLocationSelected,
      currentMapLatLng: currentMapLatLng ?? this.currentMapLatLng,
      onMapLocationChanged: onMapLocationChanged ?? this.onMapLocationChanged,
      selectedLatLng: selectedLatLng ?? this.selectedLatLng,
    );
  }

  factory NewLocationPageState.initial() => NewLocationPageState(
    id: null,
    documentId: '',
    shouldClear: true,
    locationName: "",
    pageViewIndex: 0,
    newLocationAddress: "",
    newLocationLatitude: 0.0,
    newLocationLongitude: 0.0,
    imagePath: '',
    documentFilePath: '',
    locations: List(),
    onLocationChanged: null,
    onSaveLocationSelected: null,
    onCanceledSelected: null,
    onDeleteSelected: null,
    onLocationNameChanged: null,
    onNextPressed: null,
    onBackPressed: null,
    saveImagePath: null,
    locationUpdated: false,
    searchText: '',
    selectedSearchLocation: null,
    locationsResults: List(),
    onMapLocationSaved: null,
    onMapLocationChanged: null,
    onThrottleGetLocations: null,
    onSearchInputChanged: null,
    onSearchLocationSelected: null,
    currentMapLatLng: null,
    selectedLatLng: null,
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
      documentFilePath: store.state.newLocationPageState.documentFilePath,
      locationUpdated: store.state.newLocationPageState.locationUpdated,
      searchText: store.state.newLocationPageState.searchText,
      selectedSearchLocation: store.state.newLocationPageState.selectedSearchLocation,
      locationsResults: store.state.newLocationPageState.locationsResults,
      currentMapLatLng: store.state.newLocationPageState.currentMapLatLng,
      documentId: store.state.newLocationPageState.documentId,
      selectedLatLng: store.state.newLocationPageState.selectedLatLng,
      onLocationChanged: (latLng) => store.dispatch(UpdateLocation(store.state.newLocationPageState, latLng)),
      onSaveLocationSelected: () => store.dispatch(SaveLocationAction(store.state.newLocationPageState)),
      onCanceledSelected: () => store.dispatch(ClearStateAction(store.state.newLocationPageState)),
      onDeleteSelected: () => store.dispatch(DeleteLocation(store.state.newLocationPageState)),
      onLocationNameChanged: (name) => store.dispatch(UpdateLocationName(store.state.newLocationPageState, name)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newLocationPageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newLocationPageState)),
      saveImagePath: (imagePath) => store.dispatch(SaveImagePathNewAction(store.state.newLocationPageState, imagePath)),
      onMapLocationChanged: (newLatLng) => store.dispatch(SetCurrentMapLatLngAction(store.state.newLocationPageState, newLatLng)),
      onMapLocationSaved: () => store.dispatch(SetNewLocationLocation(store.state.newLocationPageState)),
      onSearchInputChanged: (input) => store.dispatch(SetSearchTextAction(store.state.newLocationPageState, input)),
      onSearchLocationSelected: (searchLocation) {
        store.dispatch(FetchSearchLocationDetails(store.state.newLocationPageState, searchLocation));
        store.dispatch(SetSearchTextAction(store.state.newLocationPageState, searchLocation.name));
      },
      onThrottleGetLocations: (input) => store.dispatch(FetchGoogleLocationsAction(store.state.newLocationPageState, input)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      searchText.hashCode ^
      selectedSearchLocation.hashCode ^
      locationsResults.hashCode ^
      currentMapLatLng.hashCode ^
      onMapLocationSaved.hashCode ^
      onSearchInputChanged.hashCode ^
      onSearchLocationSelected.hashCode ^
      onThrottleGetLocations.hashCode ^
      documentId.hashCode ^
      shouldClear.hashCode ^
      locationName.hashCode ^
      pageViewIndex.hashCode ^
      selectedLatLng.hashCode ^
      newLocationAddress.hashCode ^
      newLocationLatitude.hashCode ^
      newLocationLongitude.hashCode ^
      saveImagePath.hashCode ^
      imagePath.hashCode ^
      locations.hashCode ^
      onLocationChanged.hashCode ^
      onSaveLocationSelected.hashCode ^
      onCanceledSelected.hashCode ^
      onDeleteSelected.hashCode ^
      documentFilePath.hashCode ^
      locationUpdated.hashCode ^
      onLocationNameChanged.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NewLocationPageState &&
              id == other.id &&
              documentId == other.documentId &&
              searchText == other.searchText &&
              selectedSearchLocation == other.selectedSearchLocation &&
              locationsResults == other.locationsResults &&
              onMapLocationSaved == other.onMapLocationSaved &&
              onSearchInputChanged == other.onSearchInputChanged &&
              onSearchLocationSelected == other.onSearchLocationSelected &&
              onThrottleGetLocations == other.onThrottleGetLocations &&
              saveImagePath == other.saveImagePath &&
              currentMapLatLng == other.currentMapLatLng &&
              shouldClear == other.shouldClear &&
              selectedLatLng == other.selectedLatLng &&
              locationName == other.locationName &&
              pageViewIndex == other.pageViewIndex &&
              newLocationAddress == other.newLocationAddress &&
              newLocationLatitude == other.newLocationLatitude &&
              newLocationLongitude == other.newLocationLongitude &&
              imagePath == other.imagePath &&
              locations == other.locations &&
              documentFilePath == other.documentFilePath &&
              onLocationChanged == other.onLocationChanged &&
              onSaveLocationSelected == other.onSaveLocationSelected &&
              onCanceledSelected == other.onCanceledSelected &&
              onDeleteSelected == other.onDeleteSelected &&
              locationUpdated == other.locationUpdated &&
              onLocationNameChanged == other.onLocationNameChanged;
}