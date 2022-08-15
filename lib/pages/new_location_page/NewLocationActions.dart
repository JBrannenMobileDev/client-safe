import 'dart:io';

import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'NewLocationPageState.dart';



class FetchLocationsAction{
  final NewLocationPageState pageState;
  FetchLocationsAction(this.pageState);
}

class LoadExistingLocationData{
  final NewLocationPageState pageState;
  final Location location;
  LoadExistingLocationData(this.pageState, this.location);
}

class SetLocationsAction{
  final NewLocationPageState pageState;
  final List<Location> locations;
  SetLocationsAction(this.pageState, this.locations);
}

class SaveLocationAction{
  final NewLocationPageState pageState;
  SaveLocationAction(this.pageState);
}

class SetLatLongAction{
  final NewLocationPageState pageState;
  final double lat;
  final double long;
  SetLatLongAction(this.pageState, this.lat, this.long);
}

class ClearStateAction{
  final NewLocationPageState pageState;
  ClearStateAction(this.pageState);
}

class UpdateLocation{
  final NewLocationPageState pageState;
  final LatLng latLng;
  UpdateLocation(this.pageState, this.latLng);
}

class DeleteLocation{
  final NewLocationPageState pageState;
  DeleteLocation(this.pageState);
}

class UpdateLocationName{
  final NewLocationPageState pageState;
  final String locationName;
  UpdateLocationName(this.pageState, this.locationName);
}

class InitializeLocationAction{
  final NewLocationPageState pageState;
  InitializeLocationAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewLocationPageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewLocationPageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class SaveImagePathNewAction{
  final NewLocationPageState pageState;
  final String imagePath;
  SaveImagePathNewAction(this.pageState, this.imagePath);
}

class FetchGoogleLocationsAction{
  final NewLocationPageState pageState;
  final String input;
  FetchGoogleLocationsAction(this.pageState, this.input);
}

class SetLocationResultsAction{
  final NewLocationPageState pageState;
  final List<PlacesLocation> locations;
  SetLocationResultsAction(this.pageState, this.locations);
}

class FetchSearchLocationDetails{
  final NewLocationPageState pageState;
  final PlacesLocation selectedSearchLocation;
  FetchSearchLocationDetails(this.pageState, this.selectedSearchLocation);
}

class SetSelectedSearchLocation{
  final NewLocationPageState pageState;
  final Location selectedSearchLocation;
  SetSelectedSearchLocation(this.pageState, this.selectedSearchLocation);
}

class SetSearchTextAction{
  final NewLocationPageState pageState;
  final String input;
  SetSearchTextAction(this.pageState, this.input);
}

class SetCurrentMapLatLngAction{
  final NewLocationPageState pageState;
  final LatLng currentLatLng;
  SetCurrentMapLatLngAction(this.pageState, this.currentLatLng);
}

class SetNewLocationLocation{
  final NewLocationPageState pageState;
  SetNewLocationLocation(this.pageState);
}

