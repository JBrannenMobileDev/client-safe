import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:redux/redux.dart';

final locationReducer = combineReducers<NewLocationPageState>([
  TypedReducer<NewLocationPageState, SetLocationsAction>(_setLocations),
  TypedReducer<NewLocationPageState, SetLatLongAction>(_setLatLong),
  TypedReducer<NewLocationPageState, ClearStateAction>(_clearState),
  TypedReducer<NewLocationPageState, UpdateLocation>(_updateLocation),
  TypedReducer<NewLocationPageState, UpdateLocationName>(_updateLocationName),
]);

NewLocationPageState _setLocations(NewLocationPageState previousState, SetLocationsAction action){
  return previousState.copyWith(
    locations: action.locations
  );
}

NewLocationPageState _setLatLong(NewLocationPageState previousState, SetLatLongAction action){
  return previousState.copyWith(
    newLocationLatitude: action.lat,
    newLocationLongitude: action.long
  );
}

NewLocationPageState _clearState(NewLocationPageState previousState, ClearStateAction action) {
  return action.pageState;
}

NewLocationPageState _updateLocation(NewLocationPageState previousState, UpdateLocation action) {
  return previousState.copyWith(
    newLocationLatitude: action.latLng.latitude,
    newLocationLongitude: action.latLng.longitude,
  );
}

NewLocationPageState _updateLocationName(NewLocationPageState previousState, UpdateLocationName action) {
  return previousState.copyWith(
    locationName: action.locationName,
  );
}
