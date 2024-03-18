import 'package:dandylight/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:redux/redux.dart';
import 'NewSingleExpensePageState.dart';

final newSingleExpensePageReducer = combineReducers<NewSingleExpensePageState>([
  TypedReducer<NewSingleExpensePageState, SetExpenseDateAction>(_setExpenseDate),
  TypedReducer<NewSingleExpensePageState, ClearSingleEpenseStateAction>(_clearState),
  TypedReducer<NewSingleExpensePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewSingleExpensePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewSingleExpensePageState, LoadExistingPricingProfileData>(_loadPriceProfile),
  TypedReducer<NewSingleExpensePageState, UpdateExpenseNameAction>(_updateName),
  TypedReducer<NewSingleExpensePageState, UpdateCostAction>(_updateCost),
  TypedReducer<NewSingleExpensePageState, LoadExistingSingleExpenseAction>(_setSelectedSingleExpense),
]);

NewSingleExpensePageState _setSelectedSingleExpense(NewSingleExpensePageState previousState, LoadExistingSingleExpenseAction action){
  return previousState.copyWith(
    expenseName: action.singleExpense!.expenseName,
    expenseDate: action.singleExpense!.charge!.chargeDate,
    expenseCost: action.singleExpense!.charge!.chargeAmount,
    id: action.singleExpense!.id,
    documentId: action.singleExpense!.documentId,
    shouldClear: false,
  );
}

NewSingleExpensePageState _updateCost(NewSingleExpensePageState previousState, UpdateCostAction action){
  String resultCost = action.newCost!.replaceAll('\$', '');
  resultCost = resultCost.replaceAll(',', '');
  resultCost = resultCost.replaceAll(' ', '');
  double doubleCost = double.parse(resultCost);
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
    id: action.singleExpense!.id,
    documentId: action.singleExpense!.documentId,
    shouldClear: false,
    expenseName: action.singleExpense!.expenseName,
    expenseDate: action.singleExpense!.charge!.chargeDate,
    expenseCost: action.singleExpense!.charge!.chargeAmount,
  );
}

NewSingleExpensePageState _incrementPageViewIndex(NewSingleExpensePageState previousState, IncrementPageViewIndex action) {
  int incrementedIndex = previousState.pageViewIndex!;
  incrementedIndex++;
  return previousState.copyWith(
      pageViewIndex: incrementedIndex
  );
}

NewSingleExpensePageState _decrementPageViewIndex(NewSingleExpensePageState previousState, DecrementPageViewIndex action) {
  int decrementedIndex = previousState.pageViewIndex!;
  decrementedIndex--;
  return previousState.copyWith(
      pageViewIndex: decrementedIndex
  );
}

NewSingleExpensePageState _clearState(NewSingleExpensePageState previousState, ClearSingleEpenseStateAction action) {
  return NewSingleExpensePageState.initial();
}
