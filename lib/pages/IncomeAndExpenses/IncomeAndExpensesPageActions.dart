import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';

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

class SetSingleExpensesAction{
  final IncomeAndExpensesPageState pageState;
  final List<SingleExpense> singleExpenses;
  SetSingleExpensesAction(this.pageState, this.singleExpenses);
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