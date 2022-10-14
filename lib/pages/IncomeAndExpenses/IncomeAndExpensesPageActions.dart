import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';

class FilterChangedAction{
  final IncomeAndExpensesPageState pageState;
  final String filterType;
  FilterChangedAction(this.pageState, this.filterType);
}

class UpdateSelectedYearAction{
  final IncomeAndExpensesPageState pageState;
  final int year;
  UpdateSelectedYearAction(this.pageState, this.year);
}

class SetSelectedYearAction{
  final IncomeAndExpensesPageState pageState;
  final int year;
  final List<Job> completedJobs;
  SetSelectedYearAction(this.pageState, this.year, this.completedJobs);
}

class LoadAllInvoicesAction{
  final IncomeAndExpensesPageState pageState;
  LoadAllInvoicesAction(this.pageState);
}

class SetAllInvoicesAction{
  final IncomeAndExpensesPageState pageState;
  final List<Invoice> allInvoices;
  SetAllInvoicesAction(this.pageState, this.allInvoices);
}

class UpdateShowHideState{
  final IncomeAndExpensesPageState pageState;
  UpdateShowHideState(this.pageState);
}

class UpdateSingleExpenseShowHideState{
  final IncomeAndExpensesPageState pageState;
  UpdateSingleExpenseShowHideState(this.pageState);
}

class InvoiceEditSelected{
  final IncomeAndExpensesPageState pageState;
  final Invoice invoice;
  InvoiceEditSelected(this.pageState, this.invoice);
}

class DeleteInvoiceAction{
  final IncomeAndExpensesPageState pageState;
  final Invoice invoice;
  DeleteInvoiceAction(this.pageState, this.invoice);
}

class OnInvoiceSentAction{
  final IncomeAndExpensesPageState pageState;
  final Invoice invoice;
  OnInvoiceSentAction(this.pageState, this.invoice);
}

class OnAllInvoicesFilterChangedAction{
  final IncomeAndExpensesPageState pageState;
  final String filter;
  OnAllInvoicesFilterChangedAction(this.pageState, this.filter);
}

class OnAllExpensesFilterChangedAction{
  final IncomeAndExpensesPageState pageState;
  final String filter;
  OnAllExpensesFilterChangedAction(this.pageState, this.filter);
}

class LoadAllJobsAction {
  final IncomeAndExpensesPageState pageState;
  LoadAllJobsAction(this.pageState);
}

class SetTipTotalsAction {
  final IncomeAndExpensesPageState pageState;
  final List<Job> allJobs;
  SetTipTotalsAction(this.pageState, this.allJobs);
}

class JobSearchTextChangedAction {
  final IncomeAndExpensesPageState pageState;
  final String jobSearchText;
  JobSearchTextChangedAction(this.pageState, this.jobSearchText);
}

class DecrementTipPageViewIndex {
  final IncomeAndExpensesPageState pageState;
  DecrementTipPageViewIndex(this.pageState);
}

class IncrementTipPageViewIndex {
  final IncomeAndExpensesPageState pageState;
  IncrementTipPageViewIndex(this.pageState);
}

class ClearAddTipStateAction {
  final IncomeAndExpensesPageState pageState;
  ClearAddTipStateAction(this.pageState);
}

class SaveTipAction {
  final IncomeAndExpensesPageState pageState;
  SaveTipAction(this.pageState);
}

class SetSelectedJobForTipAction{
  final IncomeAndExpensesPageState pageState;
  final Job selectedJob;
  SetSelectedJobForTipAction(this.pageState, this.selectedJob);
}

class AddToTipAction{
  final IncomeAndExpensesPageState pageState;
  final int amountToAdd;
  AddToTipAction(this.pageState, this.amountToAdd);
}

class SaveTipIncomeChangeAction{
  final IncomeAndExpensesPageState pageState;
  SaveTipIncomeChangeAction(this.pageState);
}

class ClearUnsavedTipAction{
  final IncomeAndExpensesPageState pageState;
  ClearUnsavedTipAction(this.pageState);
}

class FetchSingleExpenses{
  final IncomeAndExpensesPageState pageState;
  FetchSingleExpenses(this.pageState);
}

class FetchRecurringExpenses{
  final IncomeAndExpensesPageState pageState;
  FetchRecurringExpenses(this.pageState);
}

class FetchMileageExpenses{
  final IncomeAndExpensesPageState pageState;
  FetchMileageExpenses(this.pageState);
}

class SetMileageExpensesAction{
  final IncomeAndExpensesPageState pageState;
  final List<MileageExpense> mileageExpenses;
  SetMileageExpensesAction(this.pageState, this.mileageExpenses);
}

class SetSingleExpensesAction{
  final IncomeAndExpensesPageState pageState;
  final List<SingleExpense> singleExpenses;
  SetSingleExpensesAction(this.pageState, this.singleExpenses);
}

class SetRecurringExpensesAction{
  final IncomeAndExpensesPageState pageState;
  final List<RecurringExpense> recurringExpenses;
  SetRecurringExpensesAction(this.pageState, this.recurringExpenses);
}

class UpdateAlInvoicesSelectorPosition{
  final IncomeAndExpensesPageState pageState;
  final bool isUnpaidFilter;
  UpdateAlInvoicesSelectorPosition(this.pageState, this.isUnpaidFilter);
}

class UpdateAllExpensesSelectorPosition{
  final IncomeAndExpensesPageState pageState;
  final int index;
  UpdateAllExpensesSelectorPosition(this.pageState, this.index);
}

class UpdateSelectedRecurringChargeAction{
  final IncomeAndExpensesPageState pageState;
  final Charge charge;
  final RecurringExpense expense;
  final bool isChecked;
  UpdateSelectedRecurringChargeAction(this.pageState, this.charge, this.expense, this.isChecked);
}

class SaveCancelledSubscriptionAction{
  final IncomeAndExpensesPageState pageState;
  final RecurringExpense expense;
  SaveCancelledSubscriptionAction(this.pageState, this.expense);
}

class SaveResumedSubscriptionAction{
  final IncomeAndExpensesPageState pageState;
  final RecurringExpense expense;
  SaveResumedSubscriptionAction(this.pageState, this.expense);
}

class SetProfileAction{
  final IncomeAndExpensesPageState pageState;
  final Profile profile;
  SetProfileAction(this.pageState, this.profile);
}