import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/new_single_expense_page/NewSingleExpensePageState.dart';

class LoadExistingPricingProfileData{
  final NewSingleExpensePageState pageState;
  final SingleExpense singleExpense;
  LoadExistingPricingProfileData(this.pageState, this.singleExpense);
}

class SaveSingleExpenseProfileAction{
  final NewSingleExpensePageState pageState;
  SaveSingleExpenseProfileAction(this.pageState);
}

class ClearSingleEpenseStateAction{
  final NewSingleExpensePageState pageState;
  ClearSingleEpenseStateAction(this.pageState);
}

class DeleteSingleExpenseAction{
  final NewSingleExpensePageState pageState;
  DeleteSingleExpenseAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewSingleExpensePageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewSingleExpensePageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class UpdateExpenseNameAction{
  final NewSingleExpensePageState pageState;
  final String expenseName;
  UpdateExpenseNameAction(this.pageState, this.expenseName);
}

class SetExpenseDateAction{
  final NewSingleExpensePageState pageState;
  final DateTime expenseDate;
  SetExpenseDateAction(this.pageState, this.expenseDate);
}

class UpdateCostAction{
  final NewSingleExpensePageState pageState;
  final String newCost;
  UpdateCostAction(this.pageState, this.newCost);
}

class LoadExistingSingleExpenseAction{
  final NewSingleExpensePageState pageState;
  final SingleExpense singleExpense;
  LoadExistingSingleExpenseAction(this.pageState, this.singleExpense);
}





