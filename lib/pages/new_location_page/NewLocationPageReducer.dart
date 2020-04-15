import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:redux/redux.dart';

final locationReducer = combineReducers<NewLocationPageState>([
  TypedReducer<NewLocationPageState, SetLocationsAction>(_setLocations),
  TypedReducer<NewLocationPageState, SetLatLongAction>(_setLatLong),
  TypedReducer<NewLocationPageState, ClearStateAction>(_clearState),
  TypedReducer<NewLocationPageState, UpdateLocation>(_updateLocation),
  TypedReducer<NewLocationPageState, UpdateLocationName>(_updateLocationName),
  TypedReducer<NewLocationPageState, LoadExistingLocationData>(_loadLocationData),
  TypedReducer<NewLocationPageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewLocationPageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewLocationPageState, SetDocumentPathAction>(_setDocumentPath),
  TypedReducer<NewLocationPageState, SaveImagePathNewAction>(_setImagePath),
]);

NewLocationPageState _setImagePath(NewLocationPageState previousState, SaveImagePathNewAction action) {
  return previousState.copyWith(
    imagePath: action.imagePath,
  );
}

NewLocationPageState _setDocumentPath(NewLocationPageState previousState, SetDocumentPathAction action) {
  return previousState.copyWith(
      documentFilePath: action.documentPath,
  );
}

NewLocationPageState _incrementPageViewIndex(NewLocationPageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewLocationPageState _decrementPageViewIndex(NewLocationPageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewLocationPageState _updatePageView(NewLocationPageState previousState, IncrementPageViewIndex action){
  return previousState.copyWith(
    pageViewIndex: (previousState.pageViewIndex + 1),
  );
}

NewLocationPageState _setLocations(NewLocationPageState previousState, SetLocationsAction action){
  return previousState.copyWith(
    locations: action.locations,
    pageViewIndex: 0,
  );
}

NewLocationPageState _setLatLong(NewLocationPageState previousState, SetLatLongAction action){
  return previousState.copyWith(
    newLocationLatitude: action.lat,
    newLocationLongitude: action.long,
  );
}

NewLocationPageState _clearState(NewLocationPageState previousState, ClearStateAction action) {
  NewLocationPageState newState = NewLocationPageState.initial();
  return newState.copyWith(
    newLocationLatitude: 0,
    newLocationLongitude: 0,
    pageViewIndex: 0,
  );
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

NewLocationPageState _loadLocationData(NewLocationPageState previousState, LoadExistingLocationData action){
  return previousState.copyWith(
    id: action.location.id,
    shouldClear: false,
    locationName: action.location.locationName,
    newLocationLatitude: action.location.latitude,
    newLocationLongitude: action.location.longitude,
    imagePath: action.location.imagePath,
    pageViewIndex: 0,
  );
}
