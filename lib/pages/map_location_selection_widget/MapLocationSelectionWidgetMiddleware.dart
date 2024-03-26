import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/api_clients/GoogleApiClient.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetActions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:redux/redux.dart';

class MapLocationSelectionWidgetMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SetLastKnowPosition){
      setLocationData(store, next, action);
    }
    if(action is FetchGoogleLocationsAction){
      fetchLocations(store, next, action);
    }
    if(action is FetchSearchLocationDetails){
      fetchLocationDetails(store, next, action);
    }
  }

  void fetchLocationDetails(Store<AppState> store, NextDispatcher next, FetchSearchLocationDetails action) async {
    LocationDandy selectedSearchLocation = LocationDandy.LocationDandy(latitude: action.selectedSearchLocation!.lat, longitude: action.selectedSearchLocation!.lon, locationName: action.selectedSearchLocation!.name, address: action.selectedSearchLocation!.address);
    store.dispatch(SetSelectedSearchLocation(store.state.mapLocationSelectionWidgetState, selectedSearchLocation));
  }

  void fetchLocations(Store<AppState> store, NextDispatcher next, FetchGoogleLocationsAction action) async {
    List<PlacesLocation> locations = await GoogleApiClient(httpClient: http.Client()).getLocationResults(action.input!);
    store.dispatch(SetLocationResultsAction(store.state.mapLocationSelectionWidgetState, locations));
  }

  void setLocationData(Store<AppState> store, NextDispatcher next, SetLastKnowPosition action) async {
    Position positionLastKnown = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    store.dispatch(SetInitialMapLatLng(store.state.mapLocationSelectionWidgetState, positionLastKnown.latitude, positionLastKnown.longitude));
  }
}