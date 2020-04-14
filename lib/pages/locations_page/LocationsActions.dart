import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';

class FetchLocationsAction{
  final LocationsPageState pageState;
  FetchLocationsAction(this.pageState);
}

class SetLocationsAction{
  final LocationsPageState pageState;
  final List<Location> locations;
  final String path;
  SetLocationsAction(this.pageState, this.locations, this.path);
}

class DeleteLocationAction{
  final LocationsPageState pageState;
  final Location location;
  DeleteLocationAction(this.pageState, this.location);
}

class SaveImagePathAction{
  final LocationsPageState pageState;
  final String imagePath;
  final Location location;
  SaveImagePathAction(this.pageState, this.imagePath, this.location);
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

