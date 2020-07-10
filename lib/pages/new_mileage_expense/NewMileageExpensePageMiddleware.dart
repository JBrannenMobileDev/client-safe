import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/api_clients/GoogleApiClient.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:sembast/sembast.dart';


class NewMileageExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveHomeLocationAction){
      saveHomeLocation(store, action, next);
    }
    if(action is DeleteMileageExpenseAction){
      deleteExpense(store, action, next);
    }
    if(action is FetchLastKnowPosition){
      getLocationData(store, next, action);
    }
    if(action is UpdateStartLocationAction){
      updateStartLocation(store, action, next);
    }
    if(action is UpdateEndLocationAction){
      updateEndLocation(store, action, next);
    }
    if(action is SaveMileageExpenseProfileAction){
      saveMileageExpense(store, next, action);
    }
    if(action is LoadExistingMileageExpenseAction){
      loadExistingMileageExpense(store, next, action);
    }
    if(action is LoadNewMileageLocationsAction) {
      loadLocations(store, next, action);
    }
  }

  void loadExistingMileageExpense(Store<AppState> store, NextDispatcher next, LoadExistingMileageExpenseAction action) async {
    store.dispatch(SetExistingMileageExpenseAction(store.state.newMileageExpensePageState, action.mileageExpense));
    List<Placemark> placeMarkStart = await Geolocator().placemarkFromCoordinates(action.mileageExpense.startLat, action.mileageExpense.startLng);
    store.dispatch(SetStartLocationNameAction(store.state.newMileageExpensePageState, LatLng(action.mileageExpense.startLat, action.mileageExpense.startLng), placeMarkStart.elementAt(0).thoroughfare + ', ' + placeMarkStart.elementAt(0).locality));

    List<Placemark> placeMarkEnd = await Geolocator().placemarkFromCoordinates(action.mileageExpense.endLat, action.mileageExpense.endLng);
    store.dispatch(SetEndLocationNameAction(store.state.newMileageExpensePageState, LatLng(action.mileageExpense.endLat, action.mileageExpense.endLng), placeMarkEnd.elementAt(0).thoroughfare + ', ' + placeMarkEnd.elementAt(0).locality));

    LatLng startLatLngToUse = LatLng(action.mileageExpense.startLat, action.mileageExpense.startLng);
    LatLng endLatLngToUse = LatLng(action.mileageExpense.endLat, action.mileageExpense.endLng);
    _calculateAndSetDistance(endLatLngToUse, startLatLngToUse, store);
  }

  void saveMileageExpense(Store<AppState> store, NextDispatcher next, SaveMileageExpenseProfileAction action) async {
    MileageExpense expense = MileageExpense(
      id: action.pageState.id,
      documentId: action.pageState?.documentId,
      totalMiles: action.pageState.isOneWay ? action.pageState.milesDrivenOneWay : action.pageState.milesDrivenRoundTrip,
      isRoundTrip: !action.pageState.isOneWay,
      startLat: action.pageState.startLocation != null ? action.pageState.startLocation.latitude : action.pageState.profile.latDefaultHome,
      startLng: action.pageState.startLocation != null ? action.pageState.startLocation.longitude : action.pageState.profile.lngDefaultHome,
      endLat: action.pageState.endLocation.latitude,
      endLng: action.pageState.endLocation.longitude,
      deductionRate: action.pageState.deductionRate,
      charge: Charge(chargeDate: action.pageState.expenseDate, chargeAmount: action.pageState.expenseCost),
    );
    await MileageExpenseDao.insertOrUpdate(expense);
  }

  void updateEndLocation(Store<AppState> store, UpdateEndLocationAction action, NextDispatcher next) async{
    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(action.endLocation.latitude, action.endLocation.longitude);
    store.dispatch(SetEndLocationNameAction(store.state.newMileageExpensePageState, action.endLocation, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));
    LatLng startLatLngToUse;
    if(store.state.newMileageExpensePageState.startLocation == null) {
      if(store.state.newMileageExpensePageState.profile.hasDefaultHome()){
        startLatLngToUse = LatLng(store.state.newMileageExpensePageState.profile.latDefaultHome, store.state.newMileageExpensePageState.profile.lngDefaultHome);
      }else {
        startLatLngToUse = null;
      }
    }else {
      startLatLngToUse = store.state.newMileageExpensePageState.startLocation;
    }
    if(startLatLngToUse != null) {
      _calculateAndSetDistance(action.endLocation, startLatLngToUse, store);
    }
  }

  void updateStartLocation(Store<AppState> store, UpdateStartLocationAction action, NextDispatcher next) async{
    List<Placemark> placeMark = await Geolocator().placemarkFromCoordinates(action.startLocation.latitude, action.startLocation.longitude);
    store.dispatch(SetStartLocationNameAction(store.state.newMileageExpensePageState, action.startLocation, placeMark.elementAt(0).thoroughfare + ', ' + placeMark.elementAt(0).locality));
    LatLng endLatLngToUse;
    if(store.state.newMileageExpensePageState.endLocation == null) {
      endLatLngToUse = null;
    }else {
      endLatLngToUse = store.state.newMileageExpensePageState.endLocation;
    }
    if(endLatLngToUse != null) {
      _calculateAndSetDistance(endLatLngToUse, action.startLocation, store);
    }
  }

  void deleteExpense(Store<AppState> store, DeleteMileageExpenseAction action, NextDispatcher next) async{
    await MileageExpenseDao.delete(action.pageState.documentId);
    store.dispatch(FetchMileageExpenses(store.state.incomeAndExpensesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void loadLocations(Store<AppState> store, NextDispatcher next, LoadNewMileageLocationsAction action) async {
    List<Location> locations = await LocationDao.getAllSortedMostFrequent();
    store.dispatch(SetMileageLocationsAction(store.state.newMileageExpensePageState, locations));
  }

  void getLocationData(Store<AppState> store, NextDispatcher next, FetchLastKnowPosition action) async {
    List<Location> locations = await LocationDao.getAllSortedMostFrequent();
    store.dispatch(SetMileageLocationsAction(store.state.newMileageExpensePageState, locations));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    store.dispatch(MileageDocumentPathAction(store.state.newMileageExpensePageState, path));
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

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) {
      List<Location> locations = List();
      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(Location.fromMap(locationSnapshot.value));
      }
      store.dispatch(SetMileageLocationsAction(store.state.newMileageExpensePageState, locations));
    });
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

  void _calculateAndSetDistance(LatLng endLocation, LatLng startLocation, Store<AppState> store) async{
    double milesDriven = await GoogleApiClient(httpClient: http.Client()).getTravelDistance(startLocation, endLocation);
    store.dispatch(SetMilesDrivenAction(store.state.newMileageExpensePageState, milesDriven));
  }
}