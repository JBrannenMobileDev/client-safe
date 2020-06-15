import 'package:client_safe/pages/new_mileage_expense/NewMileageExpenseActions.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpensePageState.dart';
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
]);

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
