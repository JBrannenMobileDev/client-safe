import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Location.dart';
import 'package:client_safe/models/PlacesLocation.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';

@immutable
class NewMileageExpensePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int id;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final DateTime expenseDate;
  final double expenseCost;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function() onDeleteMileageExpenseSelected;
  final Function(LatLng) onStartLocationChanged;
  final Function(LatLng) onEndLocationChanged;
  final Function(DateTime) onExpenseDateSelected;
  final Function(String) onSearchInputChanged;
  final Function(String) onThrottleGetLocations;
  final String searchText;
  final double lat;
  final double lng;
  final List<PlacesLocation> locationsResults;
  final Function(PlacesLocation) onSearchLocationSelected;
  final Location selectedSearchLocation;
  final Function(LatLng) onMapLocationChanged;
  final Function() onMapLocationSaved;

  NewMileageExpensePageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.onDeleteMileageExpenseSelected,
    @required this.onStartLocationChanged,
    @required this.onEndLocationChanged,
    @required this.onExpenseDateSelected,
    @required this.expenseDate,
    @required this.expenseCost,
    @required this.onMapLocationSaved,
    @required this.lat,
    @required this.lng,
    @required this.onSearchInputChanged,
    @required this.searchText,
    @required this.locationsResults,
    @required this.onSearchLocationSelected,
    @required this.selectedSearchLocation,
    @required this.onThrottleGetLocations,
    @required this.onMapLocationChanged,
  });

  NewMileageExpensePageState copyWith({
    int id,
    int pageViewIndex,
    saveButtonEnabled,
    bool shouldClear,
    DateTime expenseDate,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(PriceProfile) onDeleteMileageExpenseSelected,
    Function(LatLng) onStartLocationChanged,
    Function(LatLng) onEndLocationChanged,
    Function(DateTime) onExpenseDateSelected,
    double expenseCost,
    Function(LatLng) onMapLocationChanged,
    Function() onMapLocationSaved,
    double lat,
    double lng,
    Function(String) onSearchInputChanged,
    String searchText,
    List<PlacesLocation> locationResults,
    Function(PlacesLocation) onSearchLocationSelected,
    Location selectedSearchLocation,
    Function(String) onThrottleGetLocations,
    List<PlacesLocation> locationsResults,
  }){
    return NewMileageExpensePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onDeleteMileageExpenseSelected: onDeleteMileageExpenseSelected?? this.onDeleteMileageExpenseSelected,
      onExpenseDateSelected: onExpenseDateSelected ?? this.onExpenseDateSelected,
      expenseDate: expenseDate ?? this.expenseDate,
      expenseCost: expenseCost ?? this.expenseCost,
      onStartLocationChanged: onStartLocationChanged ?? this.onStartLocationChanged,
      onEndLocationChanged: onEndLocationChanged ?? this.onEndLocationChanged,
      onMapLocationChanged: onMapLocationChanged ?? this.onMapLocationChanged,
      onMapLocationSaved: onMapLocationSaved ?? this.onMapLocationSaved,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      onSearchInputChanged: onSearchInputChanged ?? this.onSearchInputChanged,
      searchText: searchText ?? this.searchText,
      locationsResults: locationResults ?? this.locationsResults,
      onSearchLocationSelected: onSearchLocationSelected ?? this.onSearchLocationSelected,
      selectedSearchLocation: selectedSearchLocation ?? this.selectedSearchLocation,
      onThrottleGetLocations: onThrottleGetLocations ?? this.onThrottleGetLocations,
    );
  }

  factory NewMileageExpensePageState.initial() => NewMileageExpensePageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onDeleteMileageExpenseSelected: null,
        onStartLocationChanged: null,
        expenseDate: null,
        onExpenseDateSelected: null,
        expenseCost: 0.0,
        onEndLocationChanged: null,
        onMapLocationChanged: null,
        onMapLocationSaved: null,
        lat: 0.0,
        lng: 0.0,
        onSearchInputChanged: null,
        searchText: '',
        locationsResults: List(),
        onSearchLocationSelected: null,
        selectedSearchLocation: null,
        onThrottleGetLocations: null,
      );

  factory NewMileageExpensePageState.fromStore(Store<AppState> store) {
    return NewMileageExpensePageState(
      id: store.state.newMileageExpensePageState.id,
      pageViewIndex: store.state.newMileageExpensePageState.pageViewIndex,
      saveButtonEnabled: store.state.newMileageExpensePageState.saveButtonEnabled,
      shouldClear: store.state.newMileageExpensePageState.shouldClear,
      expenseDate: store.state.newMileageExpensePageState.expenseDate,
      expenseCost: store.state.newMileageExpensePageState.expenseCost,
      lat: store.state.newMileageExpensePageState.lat,
      lng: store.state.newMileageExpensePageState.lng,
      searchText: store.state.newMileageExpensePageState.searchText,
      locationsResults: store.state.newMileageExpensePageState.locationsResults,
      selectedSearchLocation: store.state.newMileageExpensePageState.selectedSearchLocation,
      onSavePressed: () => store.dispatch(SaveSingleExpenseProfileAction(store.state.newMileageExpensePageState)),
      onCancelPressed: () => store.dispatch(ClearSingleEpenseStateAction(store.state.newMileageExpensePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newMileageExpensePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newMileageExpensePageState)),
      onDeleteMileageExpenseSelected: () {
        store.dispatch(DeleteSingleExpenseAction(store.state.newMileageExpensePageState));
        store.dispatch(ClearSingleEpenseStateAction(store.state.newMileageExpensePageState));
      },
      onStartLocationChanged: (latLng) => store.dispatch(UpdateStartLocationAction(store.state.newMileageExpensePageState, latLng)),
      onEndLocationChanged: (latLng) => store.dispatch(UpdateEndLocationAction(store.state.newMileageExpensePageState, latLng)),
      onExpenseDateSelected: (expenseDate) => store.dispatch(SetExpenseDateAction(store.state.newMileageExpensePageState, expenseDate)),
      onMapLocationChanged: (newLatLng) => store.dispatch(SetCurrentMapLatLngAction(store.state.sunsetWeatherPageState, newLatLng)),
      onMapLocationSaved: () => store.dispatch(SaveCurrentMapLatLngAction(store.state.sunsetWeatherPageState)),
      onSearchInputChanged: (input) => store.dispatch(SetSearchTextAction(store.state.sunsetWeatherPageState, input)),
      onSearchLocationSelected: (searchLocation) {
        store.dispatch(FetchSearchLocationDetails(store.state.sunsetWeatherPageState, searchLocation));
        store.dispatch(SetSearchTextAction(store.state.sunsetWeatherPageState, searchLocation.description));
      },
      onThrottleGetLocations: (input) => store.dispatch(FetchGoogleLocationsAction(store.state.sunsetWeatherPageState, input)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      onSearchInputChanged.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      locationsResults.hashCode ^
      onStartLocationChanged.hashCode ^
      expenseDate.hashCode ^
      expenseCost.hashCode ^
      onDeleteMileageExpenseSelected.hashCode ^
      onEndLocationChanged.hashCode ^
      onMapLocationChanged.hashCode ^
      onMapLocationSaved.hashCode ^
      selectedSearchLocation.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      onSearchLocationSelected.hashCode ^
      searchText.hashCode ^
      onExpenseDateSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewMileageExpensePageState &&
          id == other.id &&
          locationsResults == other.locationsResults &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          onDeleteMileageExpenseSelected == other.onDeleteMileageExpenseSelected &&
          shouldClear == other.shouldClear &&
          onSavePressed == other.onSavePressed &&
          onSearchLocationSelected == other.onSearchLocationSelected &&
          onSearchInputChanged == other.onSearchInputChanged &&
          onCancelPressed == other.onCancelPressed &&
          selectedSearchLocation == other.selectedSearchLocation &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onStartLocationChanged == other.onStartLocationChanged &&
          onEndLocationChanged == other.onEndLocationChanged &&
          expenseDate == other.expenseDate &&
          expenseCost == other.expenseCost &&
          searchText == other.searchText &&
          lat == other.lat &&
          lng == other.lng &&
          onMapLocationChanged == other.onMapLocationChanged &&
          onMapLocationSaved == other.onMapLocationSaved &&
          onExpenseDateSelected == other.onExpenseDateSelected;
}
