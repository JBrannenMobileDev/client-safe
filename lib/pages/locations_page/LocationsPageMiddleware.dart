import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/LocationDao.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/pages/locations_page/LocationsActions.dart' as prefix1;
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart' as prefix2;
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class LocationsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is prefix1.FetchLocationsAction){
      fetchProfiles(store, next);
    }
    if(action is prefix1.DeleteLocationAction){
      _deleteLocation(store, action, next);
    }
  }

  void fetchProfiles(Store<AppState> store, NextDispatcher next) async{
    LocationDao locationDao = LocationDao();
    List<Location> locations = await locationDao.getAllSortedMostFrequent();
    next(prefix1.SetLocationsAction(store.state.locationsPageState, locations));
  }

  void _deleteLocation(Store<AppState> store, action, NextDispatcher next) async{
    LocationDao locationDao = LocationDao();
    await locationDao.delete(action.location);
    store.dispatch(prefix1.FetchLocationsAction(store.state.locationsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}