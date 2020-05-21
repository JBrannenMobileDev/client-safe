import 'dart:async';
import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/LocationDao.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageActions.dart' as jobs;
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/pages/locations_page/LocationsActions.dart' as locations;
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';

import 'NewLocationActions.dart';

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
    if(action is InitializeLocationAction){
      _initializeLocation(store, action, next);
    }
  }

  void fetchLocations(Store<AppState> store, NextDispatcher next) async{
    List<Location> locations = await LocationDao.getAllSortedMostFrequent();
    next(SetLocationsAction(store.state.newLocationPageState, locations));
  }

  void _saveLocation(Store<AppState> store, SaveLocationAction action, NextDispatcher next) async{
    Location location = Location();
    location.id = action.pageState.id;
    location.locationName = action.pageState.locationName;
    location.latitude = action.pageState.newLocationLatitude;
    location.longitude = action.pageState.newLocationLongitude;
    location.imagePath = action.pageState.imagePath;
    await LocationDao.insertOrUpdate(location);
    store.dispatch(ClearStateAction(store.state.newLocationPageState));
    store.dispatch(locations.FetchLocationsAction(store.state.locationsPageState));
    store.dispatch(jobs.FetchAllClientsAction(store.state.newJobPageState));
  }

  void _deleteLocation(Store<AppState> store, DeleteLocation action, NextDispatcher next) async{
    await LocationDao.delete(action.pageState.id);
    store.dispatch(locations.FetchLocationsAction(store.state.locationsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  Future _initializeLocation(Store<AppState> store, action, next) async {

  }
}