import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';

class FetchLocationsAction{
  final LocationsPageState pageState;
  FetchLocationsAction(this.pageState);
}

class SetLocationsAction{
  final LocationsPageState pageState;
  final List<Location> locations;
  SetLocationsAction(this.pageState, this.locations);
}

class DeleteLocationAction{
  final LocationsPageState pageState;
  final Location location;
  DeleteLocationAction(this.pageState, this.location);
}

class SaveImagePathAction{
  final LocationsPageState pageState;
  final String imagePath;
  SaveImagePathAction(this.pageState, this.imagePath);
}

