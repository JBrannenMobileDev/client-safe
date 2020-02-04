import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/LocationDao.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/locations_page/LocationsActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:client_safe/utils/IntentLauncherUtil.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';
import 'package:share/share.dart';

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
//    Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
//    IntentLauncherUtil.launchDrivingDirections(
//        position.latitude.toString(),
//        position.longitude.toString(),
//        action.location.latitude.toString(),
//        action.location.longitude.toString());
  }

  void _shareDirections(Store<AppState> store, ShareLocationSelected action){
    Share.share('Here are the driving directions. \nLocation: ${action.location.locationName}\n\nhttps://www.google.com/maps/search/?api=1&query=${action.location.latitude},${action.location.longitude}');
  }

  void fetchProfiles(Store<AppState> store, NextDispatcher next) async{
    LocationDao locationDao = LocationDao();
    List<Location> locations = await locationDao.getAllSortedMostFrequent();
    next(SetLocationsAction(store.state.locationsPageState, locations));
  }

  void _deleteLocation(Store<AppState> store, action, NextDispatcher next) async{
    LocationDao locationDao = LocationDao();
    await locationDao.delete(action.location.id);
    store.dispatch(FetchLocationsAction(store.state.locationsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void _saveImagePath(Store<AppState> store, SaveImagePathAction action) async{
    LocationDao locationDao = LocationDao();
    action.location.imagePath = action.imagePath;
    await locationDao.insertOrUpdate(action.location);
    store.dispatch(FetchLocationsAction(store.state.locationsPageState));
  }
}