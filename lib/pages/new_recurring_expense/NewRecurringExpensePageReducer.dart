import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:redux/redux.dart';
import 'NewRecurringExpensePageState.dart';

final newRecurringExpensePageReducer = combineReducers<NewRecurringExpensePageState>([
  TypedReducer<NewRecurringExpensePageState, SetExpenseDateAction>(_setExpenseDate),
  TypedReducer<NewRecurringExpensePageState, ClearRecurringExpenseStateAction>(_clearState),
  TypedReducer<NewRecurringExpensePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewRecurringExpensePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewRecurringExpensePageState, LoadExistingRecurringExpenseData>(_loadRecurringExpense),
  TypedReducer<NewRecurringExpensePageState, UpdateExpenseNameAction>(_updateName),
  TypedReducer<NewRecurringExpensePageState, UpdateCostAction>(_updateCost),
  TypedReducer<NewRecurringExpensePageState, LoadExistingRecurringExpenseAction>(_setSelectedRecurringExpense),
  TypedReducer<NewRecurringExpensePageState, UpdateSelectedBillingPeriodAction>(_setSelectedBillingPeriod),
  TypedReducer<NewRecurringExpensePageState, UpdateAutoPaySelected>(_setIsAutoPay),
]);

NewRecurringExpensePageState _setIsAutoPay(NewRecurringExpensePageState previousState, UpdateAutoPaySelected action){
  return previousState.copyWith(
    isAutoPay: action.isAutoPay,
  );
}

NewRecurringExpensePageState _setSelectedBillingPeriod(NewRecurringExpensePageState previousState, UpdateSelectedBillingPeriodAction action){
  return previousState.copyWith(
    billingPeriod: action.selectedBillingPeriod,
  );
}

NewRecurringExpensePageState _setSelectedRecurringExpense(NewRecurringExpensePageState previousState, LoadExistingRecurringExpenseAction action){
  return previousState.copyWith(
    expenseName: action.recurringExpense.expenseName,
    expenseDate: action.recurringExpense.initialChargeDate,
    expenseCost: action.recurringExpense.cost,
    billingPeriod: action.recurringExpense.billingPeriod,
    id: action.recurringExpense.id,
    documentId: action.recurringExpense.documentId,
    shouldClear: false,
  );
}

NewRecurringExpensePageState _updateCost(NewRecurringExpensePageState previousState, UpdateCostAction action){
  String resultCost = action.newCost.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = double.parse(resultCost);
  doubleCost = doubleCost * 10;
  return previousState.copyWith(
    expenseCost: doubleCost,
  );
}

NewRecurringExpensePageState _setExpenseDate(NewRecurringExpensePageState previousState, SetExpenseDateAction action){
  return previousState.copyWith(
    expenseDate: action.expenseDate,
  );
}

NewRecurringExpensePageState _updateName(NewRecurringExpensePageState previousState, UpdateExpenseNameAction action){
  return previousState.copyWith(
      expenseName: action.expenseName,
  );
}

NewRecurringExpensePageState _loadRecurringExpense(NewRecurringExpensePageState previousState, LoadExistingRecurringExpenseData action){
  return previousState.copyWith(
    id: action.recurringExpense.id,
    documentId: action.recurringExpense.documentId,
    shouldClear: false,
    expenseName: action.recurringExpense.expenseName,
    expenseDate: action.recurringExpense.initialChargeDate,
    expenseCost: action.recurringExpense.cost,
    billingPeriod: action.recurringExpense.billingPeriod,
  );
}

NewRecurringExpensePageState _incrementPageViewIndex(NewRecurringExpensePageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewRecurringExpensePageState _decrementPageViewIndex(NewRecurringExpensePageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewRecurringExpensePageState _clearState(NewRecurringExpensePageState previousState, ClearRecurringExpenseStateAction action) {
  return NewRecurringExpensePageState.initial();
}
