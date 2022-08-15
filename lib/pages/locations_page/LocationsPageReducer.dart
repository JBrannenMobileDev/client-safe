import 'package:dandylight/pages/locations_page/LocationsActions.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';
import 'package:redux/redux.dart';

final locationsReducer = combineReducers<LocationsPageState>([
  TypedReducer<LocationsPageState, SetLocationsAction>(_setLocations),
]);

LocationsPageState _setLocations(LocationsPageState previousState, SetLocationsAction action){
  return previousState.copyWith(
      locations: action.locations,
      locationImages: action.imageFiles,
  );
}
