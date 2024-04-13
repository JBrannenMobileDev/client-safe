import 'dart:async';
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/api_clients/GoogleApiClient.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart' as jobs;
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart';
import 'package:dandylight/pages/locations_page/LocationsActions.dart' as locations;
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:sembast/sembast.dart';


import '../../credentials.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';

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
    if(action is FetchGoogleLocationsAction){
      fetchGoogleLocations(store, next, action);
    }
    if(action is FetchSearchLocationDetails){
      fetchLocationDetails(store, next, action);
    }
  }

  void fetchLocationDetails(Store<AppState> store, NextDispatcher next, FetchSearchLocationDetails action) async {
    LocationDandy selectedSearchLocation = LocationDandy.LocationDandy(latitude: action.selectedSearchLocation!.lat, longitude: action.selectedSearchLocation!.lon);
    store.dispatch(SetSelectedSearchLocation(store.state.newLocationPageState, selectedSearchLocation));
  }

  void fetchGoogleLocations(Store<AppState> store, NextDispatcher next, FetchGoogleLocationsAction action) async {
    List<PlacesLocation> locations = await GoogleApiClient(httpClient: http.Client()).getLocationResults(action.input!);
    store.dispatch(SetLocationResultsAction(store.state.newLocationPageState, locations));
  }

  void fetchLocations(Store<AppState> store, NextDispatcher next) async{
    List<LocationDandy>? locations = await LocationDao.getAllSortedMostFrequent();
    next(SetLocationsAction(store.state.newLocationPageState, locations));

    (await LocationDao.getLocationsStream()).listen((locationSnapshots) {
      List<LocationDandy> locations = [];
      for(RecordSnapshot locationSnapshot in locationSnapshots) {
        locations.add(LocationDandy.fromMap(locationSnapshot.value! as Map<String,dynamic>));
      }
      store.dispatch(SetLocationsAction(store.state.newLocationPageState, locations));
    });
  }

  void _saveLocation(Store<AppState> store, SaveLocationAction action, NextDispatcher next) async{
    LocationDandy location = LocationDandy.LocationDandy();
    location.id = action.pageState!.id;
    location.documentId = action.pageState!.documentId;
    location.locationName = action.pageState!.locationName;
    location.latitude = action.pageState!.newLocationLatitude;
    location.longitude = action.pageState!.newLocationLongitude;
    if(location.latitude != null && location.longitude != null) {
      location.address = (await getAddress(location.latitude!, location.longitude!)).address;
    }

    LocationDandy locationWithId = await LocationDao.insertOrUpdate(location);

    if(action.pageState!.imagePath != null && action.pageState!.imagePath!.isNotEmpty) {
      await FileStorage.saveLocationImageFile(action.pageState!.imagePath!, locationWithId);
    }

    EventSender().sendEvent(eventName: EventNames.CREATED_LOCATION, properties: {
      EventNames.LOCATION_PARAM_NAME : location.locationName!,
      EventNames.LOCATION_PARAM_LAT : location.latitude!,
      EventNames.LOCATION_PARAM_LON : location.longitude!,
    });

    store.dispatch(ClearStateAction(store.state.newLocationPageState));
    store.dispatch(locations.FetchLocationsAction(store.state.locationsPageState));
    store.dispatch(jobs.FetchAllAction(store.state.newJobPageState));
    store.dispatch(LoadNewMileageLocationsAction(store.state.newMileageExpensePageState!));
    GlobalKeyUtil.instance.navigatorKey.currentState!.pop();
  }

  void _deleteLocation(Store<AppState> store, DeleteLocation action, NextDispatcher next) async{
    await LocationDao.delete(action.pageState!.documentId!);
    LocationDandy? location = await LocationDao.getById(action.pageState!.documentId!);
    if(location != null) {
      await LocationDao.delete(action.pageState!.documentId!);
    }
    await Future.delayed(Duration(seconds: 1));
    store.dispatch(locations.FetchLocationsAction(store.state.locationsPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState!.pop();
  }

  Future _initializeLocation(Store<AppState> store, action, next) async {

  }

  Future<GeoData> getAddress(double lat, double lng) async {
    return await Geocoder2.getDataFromCoordinates(
        latitude: lat,
        longitude: lng,
        googleMapApiKey: PLACES_API_KEY
    );
  }
}