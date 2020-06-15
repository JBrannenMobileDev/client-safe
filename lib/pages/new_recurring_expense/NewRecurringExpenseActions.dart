import 'package:client_safe/models/RecurringExpense.dart';
import 'package:client_safe/pages/new_recurring_expense/NewRecurringExpensePageState.dart';

class LoadExistingRecurringExpenseData{
  final NewRecurringExpensePageState pageState;
  final RecurringExpense recurringExpense;
  LoadExistingRecurringExpenseData(this.pageState, this.recurringExpense);
}

class SaveRecurringExpenseProfileAction{
  final NewRecurringExpensePageState pageState;
  SaveRecurringExpenseProfileAction(this.pageState);
}

class ClearRecurringExpenseStateAction{
  final NewRecurringExpensePageState pageState;
  ClearRecurringExpenseStateAction(this.pageState);
}

class DeleteRecurringExpenseAction{
  final NewRecurringExpensePageState pageState;
  DeleteRecurringExpenseAction(this.pageState);
}

class IncrementPageViewIndex{
  final NewRecurringExpensePageState pageState;
  IncrementPageViewIndex(this.pageState);
}

class DecrementPageViewIndex{
  final NewRecurringExpensePageState pageState;
  DecrementPageViewIndex(this.pageState);
}

class UpdateExpenseNameAction{
  final NewRecurringExpensePageState pageState;
  final String expenseName;
  UpdateExpenseNameAction(this.pageState, this.expenseName);
}

class SetExpenseDateAction{
  final NewRecurringExpensePageState pageState;
  final DateTime expenseDate;
  SetExpenseDateAction(this.pageState, this.expenseDate);
}

class UpdateCostAction{
  final NewRecurringExpensePageState pageState;
  final String newCost;
  UpdateCostAction(this.pageState, this.newCost);
}

class LoadExistingRecurringExpenseAction{
  final NewRecurringExpensePageState pageState;
  final RecurringExpense recurringExpense;
  LoadExistingRecurringExpenseAction(this.pageState, this.recurringExpense);
}

class UpdateSelectedBillingPeriodAction{
  final NewRecurringExpensePageState pageState;
  final String selectedBillingPeriod;
  UpdateSelectedBillingPeriodAction(this.pageState, this.selectedBillingPeriod);
}

class UpdateAutoPaySelected{
  final NewRecurringExpensePageState pageState;
  final bool isAutoPay;
  UpdateAutoPaySelected(this.pageState, this.isAutoPay);
}





