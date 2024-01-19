import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/api_clients/GoogleApiClient.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:sembast/sembast.dart';

import '../../credentials.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../job_details_page/JobDetailsActions.dart';


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
    GeoData startAddress = await getAddress(action.mileageExpense.startLat, action.mileageExpense.startLng);
    store.dispatch(SetStartLocationNameAction(store.state.newMileageExpensePageState, LatLng(action.mileageExpense.startLat, action.mileageExpense.startLng), startAddress.address));
    GeoData endAddress = await getAddress(action.mileageExpense.endLat, action.mileageExpense.endLng);
    store.dispatch(SetEndLocationNameAction(store.state.newMileageExpensePageState, LatLng(action.mileageExpense.endLat, action.mileageExpense.endLng), endAddress.address));

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

    EventSender().sendEvent(eventName: EventNames.CREATED_MILEAGE_TRIP, properties: {
      EventNames.TRIP_PARAM_LAT_START : expense.startLat,
      EventNames.TRIP_PARAM_LON_START : expense.startLng,
      EventNames.TRIP_PARAM_LAT_END : expense.endLat,
      EventNames.TRIP_PARAM_LON_END : expense.endLng,
      EventNames.TRIP_PARAM_DIST_MILES : expense.totalMiles,
    });
  }

  void updateEndLocation(Store<AppState> store, UpdateEndLocationAction action, NextDispatcher next) async{
    GeoData endAddress = null;
    try{
      endAddress = await getAddress(action.endLocation.latitude, action.endLocation.longitude);
    } catch(e) {
      print(e);
    }

    store.dispatch(SetEndLocationNameAction(store.state.newMileageExpensePageState, LatLng(action.endLocation.latitude, action.endLocation.longitude), endAddress.address));

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

  void deleteExpense(Store<AppState> store, DeleteMileageExpenseAction action, NextDispatcher next) async{
    await MileageExpenseDao.delete(action.pageState.documentId);
    MileageExpense expense = await MileageExpenseDao.getMileageExpenseById(action.pageState.documentId);
    if(expense != null) {
      await MileageExpenseDao.delete(action.pageState.documentId);
    }
    store.dispatch(FetchMileageExpenses(store.state.incomeAndExpensesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }

  void loadLocations(Store<AppState> store, NextDispatcher next, LoadNewMileageLocationsAction action) async {
    List<LocationDandy> locations = await LocationDao.getAllSortedMostFrequent();
    List<File> imageFiles = [];

    // for(LocationDandy location in locations) {
    //   imageFiles.add(await FileStorage.getLocationImageFile(location));
    // }

    store.dispatch(SetMileageLocationsAction(store.state.newMileageExpensePageState, locations, imageFiles));
  }

  void getLocationData(Store<AppState> store, NextDispatcher next, FetchLastKnowPosition action) async {
    List<LocationDandy> locations = await LocationDao.getAllSortedMostFrequent();
    List<File> imageFiles = [];

    for(LocationDandy location in locations) {
      imageFiles.add(await FileStorage.getLocationImageFile(location));
    }
    store.dispatch(SetMileageLocationsAction(store.state.newMileageExpensePageState, locations, imageFiles));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    store.dispatch(MileageDocumentPathAction(store.state.newMileageExpensePageState, path));
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null) {
      store.dispatch(SetProfileData(store.state.newMileageExpensePageState, profile));
      if(profile.hasDefaultHome()){
        GeoData address = await getAddress(profile.latDefaultHome, profile.lngDefaultHome);
        store.dispatch(SetLocationNameAction(store.state.newMileageExpensePageState, address.address));
      }
    }
    Position positionLastKnown = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(positionLastKnown != null) {
      store.dispatch(SetInitialMapLatLng(store.state.newMileageExpensePageState, positionLastKnown.latitude, positionLastKnown.longitude));
    }

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) async {
      List<LocationDandy> locations = [];
      List<File> imageFiles = [];
      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(LocationDandy.fromMap(locationSnapshot.value));
      }

      for(LocationDandy location in locations) {
        imageFiles.add(await FileStorage.getLocationImageFile(location));
      }
      store.dispatch(SetMileageLocationsAction(store.state.newMileageExpensePageState, locations, imageFiles));
    });
  }

  void saveHomeLocation(Store<AppState> store, SaveHomeLocationAction action, NextDispatcher next) async{
    GeoData homeAddress = await getAddress(action.startLocation.latitude, action.startLocation.longitude);
    store.dispatch(SetLocationNameAction(store.state.newMileageExpensePageState, homeAddress.address));
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.latDefaultHome = action.startLocation.latitude;
    profile.lngDefaultHome = action.startLocation.longitude;
    await ProfileDao.insertOrUpdate(profile);
    store.dispatch(SetProfileData(store.state.newMileageExpensePageState, profile));
    updateStartLocation(store, homeAddress, action.startLocation.latitude, action.startLocation.longitude, action.startLocation);
  }

  void updateStartLocation(Store<AppState> store, GeoData address, double lat, double lon, LatLng startLocation) async{
    store.dispatch(SetStartLocationNameAction(store.state.newMileageExpensePageState, LatLng(lat, lon), address.address));

    LatLng endLatLngToUse;
    if(store.state.newMileageExpensePageState.endLocation == null) {
      endLatLngToUse = null;
    }else {
      endLatLngToUse = store.state.newMileageExpensePageState.endLocation;
    }
    if(endLatLngToUse != null) {
      _calculateAndSetDistance(endLatLngToUse, startLocation, store);
    }
  }

  void _calculateAndSetDistance(LatLng endLocation, LatLng startLocation, Store<AppState> store) async{
    double milesDriven = await GoogleApiClient(httpClient: http.Client()).getTravelDistance(startLocation, endLocation);
    store.dispatch(SetMilesDrivenAction(store.state.newMileageExpensePageState, milesDriven));
  }

  Future<GeoData> getAddress(double lat, double lng) async {
    return await Geocoder2.getDataFromCoordinates(
        latitude: lat,
        longitude: lng,
        googleMapApiKey: PLACES_API_KEY
    );
  }
}