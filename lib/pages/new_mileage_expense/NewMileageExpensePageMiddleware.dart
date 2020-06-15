import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/ProfileDao.dart';
import 'package:client_safe/models/Profile.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class NewMileageExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveHomeLocationAction){
      saveHomeLocation(store, action, next);
    }
    if(action is DeleteMileageExpenseAction){

    }
    if(action is FetchLastKnowPosition){
      getLocationData(store, next, action);
    }
  }

  void getLocationData(Store<AppState> store, NextDispatcher next, FetchLastKnowPosition action) async {
    List<Profile> profiles = await ProfileDao.getAll();
    Profile profile = profiles.elementAt(0);
    if(profile != null) {
      store.dispatch(SetProfileData(store.state.newMileageExpensePageState, profile));
      if(profile.hasDefaultHome()){
        List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(profile.latDefaultHome, profile.lngDefaultHome);
        store.dispatch(SetLocationNameAction(store.state.newMileageExpensePageState, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));
      }
    }
    Position positionLastKnown = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    if(positionLastKnown != null) {
      store.dispatch(SetInitialMapLatLng(store.state.newMileageExpensePageState, positionLastKnown.latitude, positionLastKnown.longitude));
    }
  }

  void saveHomeLocation(Store<AppState> store, SaveHomeLocationAction action, NextDispatcher next) async{
    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(action.homeLocation.latitude, action.homeLocation.longitude);
    store.dispatch(SetLocationNameAction(store.state.newMileageExpensePageState, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));
    Profile profile = store.state.newMileageExpensePageState.profile;
    profile.latDefaultHome = action.homeLocation.latitude;
    profile.lngDefaultHome = action.homeLocation.longitude;
    await ProfileDao.insertOrUpdate(profile);
    store.dispatch(SetProfileData(store.state.newMileageExpensePageState, profile));
  }
}