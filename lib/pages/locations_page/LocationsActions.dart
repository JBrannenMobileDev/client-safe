import 'dart:io';

import 'package:dandylight/models/Location.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';

class FetchLocationsAction{
  final LocationsPageState pageState;
  FetchLocationsAction(this.pageState);
}

class SetLocationsAction{
  final LocationsPageState pageState;
  final List<Location> locations;
  final List<File> imageFiles;
  SetLocationsAction(this.pageState, this.locations, this.imageFiles);
}

class DrivingDirectionsSelected{
  final LocationsPageState pageState;
  final Location location;
  DrivingDirectionsSelected(this.pageState, this.location);
}

class ShareLocationSelected{
  final LocationsPageState pageState;
  final Location location;
  ShareLocationSelected(this.pageState, this.location);
}

