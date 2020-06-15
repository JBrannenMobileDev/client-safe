import 'package:client_safe/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:client_safe/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:client_safe/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:redux/redux.dart';

final newMileageExpensePageReducer = combineReducers<NewMileageExpensePageState>([
  TypedReducer<NewMileageExpensePageState, SetExpenseDateAction>(_setExpenseDate),
  TypedReducer<NewMileageExpensePageState, ClearSingleEpenseStateAction>(_clearState),
  TypedReducer<NewMileageExpensePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewMileageExpensePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewMileageExpensePageState, LoadExistingPricingProfileData>(_loadPriceProfile),
  TypedReducer<NewMileageExpensePageState, UpdateExpenseNameAction>(_updateName),
  TypedReducer<NewMileageExpensePageState, UpdateCostAction>(_updateCost),
  TypedReducer<NewMileageExpensePageState, LoadExistingSingleExpenseAction>(_setSelectedSingleExpense),
]);

NewSingleExpensePageState _setSelectedSingleExpense(NewSingleExpensePageState previousState, LoadExistingSingleExpenseAction action){
  return previousState.copyWith(
    expenseName: action.singleExpense.expenseName,
    expenseDate: action.singleExpense.charge.chargeDate,
    expenseCost: action.singleExpense.charge.chargeAmount,
    id: action.singleExpense.id,
    shouldClear: false,
  );
}

NewSingleExpensePageState _updateCost(NewSingleExpensePageState previousState, UpdateCostAction action){
  String resultCost = action.newCost.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = double.parse(resultCost);
  doubleCost = doubleCost * 10;
  return previousState.copyWith(
    expenseCost: doubleCost,
  );
}

NewSingleExpensePageState _setExpenseDate(NewSingleExpensePageState previousState, SetExpenseDateAction action){
  return previousState.copyWith(
    expenseDate: action.expenseDate,
  );
}

NewSingleExpensePageState _updateName(NewSingleExpensePageState previousState, UpdateExpenseNameAction action){
  return previousState.copyWith(
      expenseName: action.expenseName,
  );
}

//fix this method
NewSingleExpensePageState _loadPriceProfile(NewSingleExpensePageState previousState, LoadExistingPricingProfileData action){
  return previousState.copyWith(
    id: action.singleExpense.id,
    shouldClear: false,
    expenseName: action.singleExpense.expenseName,
    expenseDate: action.singleExpense.charge.chargeDate,
    expenseCost: action.singleExpense.charge.chargeAmount,
  );
}

NewSingleExpensePageState _incrementPageViewIndex(NewSingleExpensePageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewSingleExpensePageState _decrementPageViewIndex(NewSingleExpensePageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewSingleExpensePageState _clearState(NewSingleExpensePageState previousState, ClearSingleEpenseStateAction action) {
  return NewSingleExpensePageState.initial();
}
