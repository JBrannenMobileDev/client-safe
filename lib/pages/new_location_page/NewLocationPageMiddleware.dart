import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/LocationDao.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class NewLocationPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchLocationsAction){
      fetchLocations(store, next);
    }
    if(action is SaveLocationAction){
      _saveLocation(store, action, next);
    }
    if(action is DeleteLocation){
      _deleteLocation(store, action, next);
    }
    if(action is ClearStateAction){
      _clearState(store, action, next);
    }
  }

  void fetchLocations(Store<AppState> store, NextDispatcher next) async{
    LocationDao locationDao = LocationDao();
    List<Location> locations = await locationDao.getAllSortedMostFrequent();
    next(SetLocationsAction(store.state.newLocationPageState, locations));
  }

  void _saveLocation(Store<AppState> store, SaveLocationAction action, NextDispatcher next) async{
    LocationDao locationDao = LocationDao();
    Location location = Location(
      locationName: action.pageState.locationName,
      latitude: action.pageState.newLocationLatitude,
      longitude: action.pageState.newLocationLongitude,
    );
    await locationDao.insertOrUpdate(location);
    store.dispatch(FetchLocationsAction(store.state.newLocationPageState));
  }

  void _deleteLocation(Store<AppState> store, action, NextDispatcher next) async{
    LocationDao locationDao = LocationDao();
    await locationDao.delete(action.location);
    store.dispatch(FetchLocationsAction(store.state.newLocationPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  Future _clearState(store, action, next) async {
    Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    store.dispatch(SetLatLongAction(store.state.newLocationPageState, position.latitude, position.longitude));
  }
}