import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';


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

