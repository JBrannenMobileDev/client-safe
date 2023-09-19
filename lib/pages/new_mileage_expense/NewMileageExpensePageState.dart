import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/LocationDandy.dart';
import 'package:dandylight/models/PlacesLocation.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:dandylight/pages/new_mileage_expense/SelectStartEndLocations.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';

@immutable
class NewMileageExpensePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_PROFILE_NAME_MISSING = "missingProfileName";

  final int id;
  final String documentId;
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
  final String searchText;
  final double lat;
  final double lng;
  final LocationDandy selectedSearchLocation;
  final Profile profile;
  final String selectedHomeLocationName;
  final String startLocationName;
  final String endLocationName;
  final bool isOneWay;
  final double milesDrivenOneWay;
  final double milesDrivenRoundTrip;
  final double deductionRate;
  final LatLng startLocation;
  final LatLng endLocation;
  final String filterType;
  final Function(String) onFilterChanged;
  final LocationDandy selectedLocation;
  final List<LocationDandy> locations;
  final List<File> imageFiles;
  final Function(LocationDandy) onLocationSelected;
  final String documentPath;

  NewMileageExpensePageState({
    @required this.id,
    @required this.documentId,
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
    @required this.lat,
    @required this.lng,
    @required this.searchText,
    @required this.selectedSearchLocation,
    @required this.profile,
    @required this.selectedHomeLocationName,
    @required this.startLocationName,
    @required this.endLocationName,
    @required this.isOneWay,
    @required this.milesDrivenOneWay,
    @required this.milesDrivenRoundTrip,
    @required this.deductionRate,
    @required this.startLocation,
    @required this.endLocation,
    @required this.filterType,
    @required this.onFilterChanged,
    @required this.selectedLocation,
    @required this.locations,
    @required this.onLocationSelected,
    @required this.documentPath,
    @required this.imageFiles,
  });

  NewMileageExpensePageState copyWith({
    int id,
    String documentId,
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
    double lat,
    double lng,
    String searchText,
    List<PlacesLocation> locationResults,
    LocationDandy selectedSearchLocation,
    Profile profile,
    String selectedHomeLocationName,
    String startLocationName,
    String endLocationName,
    bool isOneWay,
    double milesDrivenOneWay,
    double milesDrivenRoundTrip,
    double deductionRate,
    LatLng startLocation,
    LatLng endLocation,
    String filterType,
    Function(String) onFilterChanged,
    LocationDandy selectedLocation,
    List<LocationDandy> locations,
    List<File> imageFiles,
    Function(LocationDandy) onLocationSelected,
    String documentPath,
  }){
    return NewMileageExpensePageState(
      id: id?? this.id,
      documentId: documentId ?? this.documentId,
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
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      searchText: searchText ?? this.searchText,
      selectedSearchLocation: selectedSearchLocation ?? this.selectedSearchLocation,
      profile: profile ?? this.profile,
      selectedHomeLocationName: selectedHomeLocationName ?? this.selectedHomeLocationName,
      startLocationName: startLocationName ?? this.startLocationName,
      endLocationName: endLocationName ?? this.endLocationName,
      isOneWay: isOneWay ?? this.isOneWay,
      milesDrivenOneWay: milesDrivenOneWay ?? this.milesDrivenOneWay,
      milesDrivenRoundTrip: milesDrivenRoundTrip ?? this.milesDrivenRoundTrip,
      deductionRate: deductionRate ?? this.deductionRate,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      filterType: filterType ?? this.filterType,
      onFilterChanged: onFilterChanged ?? this.onFilterChanged,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      locations: locations ?? this.locations,
      onLocationSelected: onLocationSelected ?? this.onLocationSelected,
      documentPath: documentPath ?? this.documentPath,
      imageFiles: imageFiles ?? this.imageFiles,
    );
  }

  factory NewMileageExpensePageState.initial() => NewMileageExpensePageState(
    id: null,
    documentId: '',
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
    lat: 0.0,
    lng: 0.0,
    searchText: '',
    selectedSearchLocation: null,
    profile: null,
    selectedHomeLocationName: '',
    startLocationName: '',
    endLocationName: 'Select a location',
    isOneWay: false,
    milesDrivenOneWay: 0.0,
    milesDrivenRoundTrip: 0.0,
    deductionRate: 0.655,
    startLocation: null,
    endLocation: null,
    filterType: SelectStartEndLocationsPage.FILTER_TYPE_ROUND_TRIP,
    onFilterChanged: null,
    selectedLocation: null,
    locations: [],
    imageFiles: [],
    onLocationSelected: null,
    documentPath: '',
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
      selectedSearchLocation: store.state.newMileageExpensePageState.selectedSearchLocation,
      profile: store.state.newMileageExpensePageState.profile,
      selectedHomeLocationName: store.state.newMileageExpensePageState.selectedHomeLocationName,
      startLocationName: store.state.newMileageExpensePageState.startLocationName,
      endLocationName: store.state.newMileageExpensePageState.endLocationName,
      isOneWay: store.state.newMileageExpensePageState.isOneWay,
      milesDrivenOneWay: store.state.newMileageExpensePageState.milesDrivenOneWay,
      milesDrivenRoundTrip: store.state.newMileageExpensePageState.milesDrivenRoundTrip,
      deductionRate: store.state.newMileageExpensePageState.deductionRate,
      startLocation: store.state.newMileageExpensePageState.startLocation,
      endLocation: store.state.newMileageExpensePageState.endLocation,
      filterType: store.state.newMileageExpensePageState.filterType,
      selectedLocation: store.state.newMileageExpensePageState.selectedLocation,
      locations: store.state.newMileageExpensePageState.locations,
      documentPath: store.state.newMileageExpensePageState.documentPath,
      documentId: store.state.newMileageExpensePageState.documentId,
      imageFiles: store.state.newMileageExpensePageState.imageFiles,
      onSavePressed: () => store.dispatch(SaveMileageExpenseProfileAction(store.state.newMileageExpensePageState)),
      onCancelPressed: () => store.dispatch(ClearMileageExpenseStateAction(store.state.newMileageExpensePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newMileageExpensePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newMileageExpensePageState)),
      onDeleteMileageExpenseSelected: () {
        store.dispatch(DeleteMileageExpenseAction(store.state.newMileageExpensePageState));
        store.dispatch(ClearMileageExpenseStateAction(store.state.newMileageExpensePageState));
      },
      onStartLocationChanged: (latLng) => {
        store.dispatch(SaveHomeLocationAction(store.state.newMileageExpensePageState, latLng)),
        store.dispatch(UpdateStartLocationAction(store.state.newMileageExpensePageState, latLng))
      },
      onEndLocationChanged: (latLng) => store.dispatch(UpdateEndLocationAction(store.state.newMileageExpensePageState, latLng)),
      onExpenseDateSelected: (expenseDate) => store.dispatch(SetExpenseDateAction(store.state.newMileageExpensePageState, expenseDate)),
      onFilterChanged: (selectedFilter) => store.dispatch(SetSelectedFilterAction(store.state.newMileageExpensePageState, selectedFilter)),
      onLocationSelected: (selectedLocation) => store.dispatch(SetSelectedLocationAction(store.state.newMileageExpensePageState, selectedLocation)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      documentId.hashCode ^
      startLocationName.hashCode ^
      endLocationName.hashCode ^
      isOneWay.hashCode ^
      milesDrivenOneWay.hashCode ^
      deductionRate.hashCode ^
      selectedHomeLocationName.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      filterType.hashCode ^
      onFilterChanged.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      milesDrivenRoundTrip.hashCode ^
      onBackPressed.hashCode ^
      onStartLocationChanged.hashCode ^
      expenseDate.hashCode ^
      documentPath.hashCode ^
      expenseCost.hashCode ^
      onDeleteMileageExpenseSelected.hashCode ^
      onEndLocationChanged.hashCode ^
      selectedSearchLocation.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      searchText.hashCode ^
      profile.hashCode ^
      startLocation.hashCode ^
      endLocation.hashCode ^
      selectedLocation.hashCode ^
      locations.hashCode ^
      onLocationSelected.hashCode ^
      imageFiles.hashCode ^
      onExpenseDateSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewMileageExpensePageState &&
          id == other.id &&
          documentId == other.documentId &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          filterType == other.filterType &&
          selectedLocation == other.selectedLocation &&
          locations == other.locations &&
          onFilterChanged == other.onFilterChanged &&
          onDeleteMileageExpenseSelected == other.onDeleteMileageExpenseSelected &&
          shouldClear == other.shouldClear &&
          startLocationName == other.startLocationName &&
          endLocationName == other.endLocationName &&
          isOneWay == other.isOneWay &&
          milesDrivenRoundTrip == other.milesDrivenRoundTrip &&
          documentPath == other.documentPath &&
          milesDrivenOneWay == other.milesDrivenOneWay &&
          deductionRate == other.deductionRate &&
          selectedHomeLocationName == other.selectedHomeLocationName &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          startLocation == other.startLocation &&
          endLocation == other.endLocation &&
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
          profile == other.profile &&
          imageFiles == other.imageFiles &&
          onExpenseDateSelected == other.onExpenseDateSelected;
}
