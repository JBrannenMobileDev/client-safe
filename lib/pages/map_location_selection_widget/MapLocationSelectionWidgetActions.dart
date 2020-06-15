import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PlacesLocation.dart';
import 'package:client_safe/pages/map_location_selection_widget/MapLocationSelectionWidgetState.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FetchGoogleLocationsAction{
  final MapLocationSelectionWidgetState pageState;
  final String input;
  FetchGoogleLocationsAction(this.pageState, this.input);
}

class SetLocationResultsAction{
  final MapLocationSelectionWidgetState pageState;
  final List<PlacesLocation> locations;
  SetLocationResultsAction(this.pageState, this.locations);
}

class FetchSearchLocationDetails{
  final MapLocationSelectionWidgetState pageState;
  final PlacesLocation selectedSearchLocation;
  FetchSearchLocationDetails(this.pageState, this.selectedSearchLocation);
}

class SetSelectedSearchLocation{
  final MapLocationSelectionWidgetState pageState;
  final Location selectedSearchLocation;
  SetSelectedSearchLocation(this.pageState, this.selectedSearchLocation);
}

class SetSearchTextAction{
  final MapLocationSelectionWidgetState pageState;
  final String input;
  SetSearchTextAction(this.pageState, this.input);
}

class SetCurrentMapLatLngAction{
  final MapLocationSelectionWidgetState pageState;
  final LatLng currentLatLng;
  SetCurrentMapLatLngAction(this.pageState, this.currentLatLng);
}

class SaveCurrentMapLatLngAction{
  final MapLocationSelectionWidgetState pageState;
  SaveCurrentMapLatLngAction(this.pageState);
}

class SetLastKnowPosition{
  final MapLocationSelectionWidgetState pageState;
  SetLastKnowPosition(this.pageState);
}

class SetInitialMapLatLng{
  final MapLocationSelectionWidgetState pageState;
  final double lat;
  final double lng;
  SetInitialMapLatLng(this.pageState, this.lat, this.lng);
}

class SetLocationNameAction{
  final MapLocationSelectionWidgetState pageState;
  final String selectedLocationName;
  SetLocationNameAction(this.pageState, this.selectedLocationName);
}

class ClearState{
  final MapLocationSelectionWidgetState pageState;
  ClearState(this.pageState);
}

class ClearSearchTextAction{
  final MapLocationSelectionWidgetState pageState;
  ClearSearchTextAction(this.pageState);
}





