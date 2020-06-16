import 'package:client_safe/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:client_safe/pages/new_mileage_expense/SelectStartEndLocations.dart';
import 'package:client_safe/utils/TextFormatterUtil.dart';
import 'package:redux/redux.dart';

final newMileageExpensePageReducer = combineReducers<NewMileageExpensePageState>([
  TypedReducer<NewMileageExpensePageState, SetExpenseDateAction>(_setExpenseDate),
  TypedReducer<NewMileageExpensePageState, ClearMileageExpenseStateAction>(_clearState),
  TypedReducer<NewMileageExpensePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewMileageExpensePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewMileageExpensePageState, UpdateCostAction>(_updateCost),
  TypedReducer<NewMileageExpensePageState, LoadExistingMileageExpenseAction>(_setSelectedMileageExpense),
  TypedReducer<NewMileageExpensePageState, SetInitialMapLatLng>(_setInitMapLatLng),
  TypedReducer<NewMileageExpensePageState, SetLocationNameAction>(_setHomeLocationName),
  TypedReducer<NewMileageExpensePageState, SetProfileData>(_setProfile),
  TypedReducer<NewMileageExpensePageState, SetStartLocationNameAction>(_setStartLocationName),
  TypedReducer<NewMileageExpensePageState, SetEndLocationNameAction>(_setEndLocationName),
  TypedReducer<NewMileageExpensePageState, SetMilesDrivenAction>(_setMilesDriven),
  TypedReducer<NewMileageExpensePageState, SetSelectedFilterAction>(_setSelectedFilter),
]);

NewMileageExpensePageState _setSelectedFilter(NewMileageExpensePageState previousState, SetSelectedFilterAction action){
  bool isOneWay = action.selectedFilter == SelectStartEndLocationsPage.FILTER_TYPE_ONE_WAY;
  return previousState.copyWith(
    filterType: action.selectedFilter,
    isOneWay: isOneWay,
    expenseCost: (isOneWay ? 1 : 2) * double.parse((previousState.milesDriven * 0.575).toStringAsFixed(2)),
  );
}

NewMileageExpensePageState _setMilesDriven(NewMileageExpensePageState previousState, SetMilesDrivenAction action){
  return previousState.copyWith(
    milesDriven: double.parse(action.milesDriven.toStringAsFixed(1)),
    expenseCost: (previousState.isOneWay ? 1 : 2) * double.parse((action.milesDriven * 0.575).toStringAsFixed(2)),
  );
}

NewMileageExpensePageState _setEndLocationName(NewMileageExpensePageState previousState, SetEndLocationNameAction action){
  return previousState.copyWith(
    endLocationName: action.endLocationName,
    endLocation: action.endLocation,
  );
}

NewMileageExpensePageState _setStartLocationName(NewMileageExpensePageState previousState, SetStartLocationNameAction action){
  return previousState.copyWith(
    startLocationName: action.startLocationName,
    startLocation: action.startLocation,
  );
}

NewMileageExpensePageState _setHomeLocationName(NewMileageExpensePageState previousState, SetLocationNameAction action){
  return previousState.copyWith(
    selectedHomeLocationName: action.selectedLocationName,
  );
}

NewMileageExpensePageState _setProfile(NewMileageExpensePageState previousState, SetProfileData action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

NewMileageExpensePageState _setInitMapLatLng(NewMileageExpensePageState previousState, SetInitialMapLatLng action){
  return previousState.copyWith(
    lat: action.lat,
    lng: action.lng,
  );
}

NewMileageExpensePageState _setSelectedMileageExpense(NewMileageExpensePageState previousState, LoadExistingMileageExpenseAction action){
  return previousState.copyWith(

  );
}

NewMileageExpensePageState _updateCost(NewMileageExpensePageState previousState, UpdateCostAction action){
  double doubleCost = 25.55;
  return previousState.copyWith(
    expenseCost: doubleCost,
  );
}

NewMileageExpensePageState _setExpenseDate(NewMileageExpensePageState previousState, SetExpenseDateAction action){
  return previousState.copyWith(
    expenseDate: action.expenseDate,
  );
}

NewMileageExpensePageState _incrementPageViewIndex(NewMileageExpensePageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewMileageExpensePageState _decrementPageViewIndex(NewMileageExpensePageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewMileageExpensePageState _clearState(NewMileageExpensePageState previousState, ClearMileageExpenseStateAction action) {
  return NewMileageExpensePageState.initial();
}
