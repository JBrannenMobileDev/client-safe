import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/pages/locations_page/LocationsActions.dart';
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart' as newLocation;
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:share_plus/share_plus.dart';

class LocationsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchLocationsAction){
      fetchProfiles(store, next);
    }
    if(action is DeleteLocationAction){
      _deleteLocation(store, action, next);
    }
    if(action is SaveImagePathAction){
      _saveImagePath(store, action);
    }
    if(action is DrivingDirectionsSelected){
      _launchDrivingDirections(store, action);
    }
    if(action is ShareLocationSelected){
      _shareDirections(store, action);
    }
  }

  void _launchDrivingDirections(Store<AppState> store, DrivingDirectionsSelected action)async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    IntentLauncherUtil.launchDrivingDirections(
        position.latitude.toString(),
        position.longitude.toString(),
        action.location.latitude.toString(),
        action.location.longitude.toString());
  }

  void _shareDirections(Store<AppState> store, ShareLocationSelected action){
    Share.share('Here are the driving directions. \nLocation: ${action.location.locationName}\n\nhttps://www.google.com/maps/search/?api=1&query=${action.location.latitude},${action.location.longitude}');
  }

  void fetchProfiles(Store<AppState> store, NextDispatcher next) async{
    List<Location> locations = await LocationDao.getAllSortedMostFrequent();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    next(SetLocationsAction(store.state.locationsPageState, locations, path));
    store.dispatch(newLocation.SetDocumentPathAction(store.state.newLocationPageState, path));

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) {
      List<Location> locations = List();
      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(Location.fromMap(locationSnapshot.value));
      }
      store.dispatch(SetLocationsAction(store.state.locationsPageState, locations, path));
    });
  }

  void _deleteLocation(Store<AppState> store, DeleteLocationAction action, NextDispatcher next) async{
    await LocationDao.delete(action.location.documentId);
    store.dispatch(FetchLocationsAction(store.state.locationsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void _saveImagePath(Store<AppState> store, SaveImagePathAction action) async{
    action.location.imagePath = action.imagePath;
    await LocationDao.insertOrUpdate(action.location);
    store.dispatch(FetchLocationsAction(store.state.locationsPageState));
  }
}