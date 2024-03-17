import 'dart:io';

import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';

class FetchLocationsAction{
  final LocationsPageState? pageState;
  FetchLocationsAction(this.pageState);
}

class SetLocationsAction{
  final LocationsPageState? pageState;
  final List<LocationDandy>? locations;
  SetLocationsAction(this.pageState, this.locations);
}

class DrivingDirectionsSelected{
  final LocationsPageState? pageState;
  final LocationDandy? location;
  DrivingDirectionsSelected(this.pageState, this.location);
}

class ShareLocationSelected{
  final LocationsPageState? pageState;
  final LocationDandy? location;
  ShareLocationSelected(this.pageState, this.location);
}

