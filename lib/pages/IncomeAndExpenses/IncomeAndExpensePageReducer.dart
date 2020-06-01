import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:redux/redux.dart';

final incomeAndExpensesPageReducer = combineReducers<IncomeAndExpensesPageState>([
  TypedReducer<IncomeAndExpensesPageState, SetAllInvoicesAction>(_setInvoices),
  TypedReducer<IncomeAndExpensesPageState, FilterChangedAction>(_updateFilterSelection),
  TypedReducer<IncomeAndExpensesPageState, UpdateSelectedYearAction>(_setSelectedYear),
  TypedReducer<IncomeAndExpensesPageState, UpdateShowHideState>(_updateShowHideState),
  TypedReducer<IncomeAndExpensesPageState, UpdateSingleExpenseShowHideState>(_updateSingleExpenseShowHideState),
  TypedReducer<IncomeAndExpensesPageState, OnAllInvoicesFilterChangedAction>(_updateAllInvoicesFilter),
  TypedReducer<IncomeAndExpensesPageState, SetTipTotalsAction>(_setTipInfo),
  TypedReducer<IncomeAndExpensesPageState, JobSearchTextChangedAction>(_setJobSearchText),
  TypedReducer<IncomeAndExpensesPageState, IncrementTipPageViewIndex>(_incrementTipPageViewIndex),
  TypedReducer<IncomeAndExpensesPageState, DecrementTipPageViewIndex>(_decrementTipPageViewIndex),
  TypedReducer<IncomeAndExpensesPageState, SetSelectedJobForTipAction>(_setSelectedJob),
  TypedReducer<IncomeAndExpensesPageState, AddToTipAction>(_addToUnsavedDeposit),
  TypedReducer<IncomeAndExpensesPageState, ClearUnsavedTipAction>(_clearUnsavedDeposit),
  TypedReducer<IncomeAndExpensesPageState, ClearAddTipStateAction>(_clearAddTipState),
  TypedReducer<IncomeAndExpensesPageState, SetSingleExpensesAction>(_setSingleExpenses),
]);

IncomeAndExpensesPageState _setSingleExpenses(IncomeAndExpensesPageState previousState, SetSingleExpensesAction action) {
  int singleExpensesTotal = 0;
  for(SingleExpense expense in action.singleExpenses){
    singleExpensesTotal = singleExpensesTotal + expense.cost.toInt();
  }
  List<SingleExpense> singleExpenseForSelectedYear = action.singleExpenses.where((expense) => expense.chargeDate.year == previousState.selectedYear).toList();
  return previousState.copyWith(
    singleExpensesForSelectedYear: singleExpenseForSelectedYear,
    allSingleExpenses: action.singleExpenses,
    singleExpensesTotal: singleExpensesTotal,
  );
}

IncomeAndExpensesPageState _clearAddTipState(IncomeAndExpensesPageState previousState, ClearAddTipStateAction action) {
  return previousState.copyWith(
    unsavedTipAmount: 0,
    pageViewIndex: 0,
    selectedJob: null,
    filteredJobs: previousState.allJobs,
  );
}

IncomeAndExpensesPageState _clearUnsavedDeposit(IncomeAndExpensesPageState previousState, ClearUnsavedTipAction action) {
  return previousState.copyWith(
    unsavedTipAmount: 0,
    pageViewIndex: 0,
    selectedJob: null,
    filteredJobs: previousState.allJobs,
  );
}

IncomeAndExpensesPageState _addToUnsavedDeposit(IncomeAndExpensesPageState previousState, AddToTipAction action) {
  int newAmount = previousState.unsavedTipAmount + action.amountToAdd;
  return previousState.copyWith(unsavedTipAmount: newAmount);
}

IncomeAndExpensesPageState _setSelectedJob(IncomeAndExpensesPageState previousState, SetSelectedJobForTipAction action) {
  return previousState.copyWith(
    selectedJob: action.selectedJob,
  );
}

IncomeAndExpensesPageState _incrementTipPageViewIndex(IncomeAndExpensesPageState previousState, IncrementTipPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: previousState.pageViewIndex + 1,
  );
}

IncomeAndExpensesPageState _decrementTipPageViewIndex(IncomeAndExpensesPageState previousState, DecrementTipPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: previousState.pageViewIndex - 1,
  );
}

IncomeAndExpensesPageState _setJobSearchText(IncomeAndExpensesPageState previousState, JobSearchTextChangedAction action) {
  List<Job> filteredJobs = action.jobSearchText.length > 0
      ? previousState.allJobs
      .where((job) => job
      .jobTitle
      .toLowerCase()
      .contains(action.jobSearchText.toLowerCase()))
      .toList()
      : previousState.allJobs;
  return previousState.copyWith(
    jobSearchText: action.jobSearchText,
    filteredJobs: filteredJobs,
  );
}

IncomeAndExpensesPageState _setTipInfo(IncomeAndExpensesPageState previousState, SetTipTotalsAction action) {
  List<Job> jobsSelectedYear = action.allJobs.where((job) => job.selectedDate.year == previousState.selectedYear).toList();
  int totalTipsForYear = 0;
  for(Job job in jobsSelectedYear) {
    if(job != null && job.tipAmount != null) {
      totalTipsForYear = totalTipsForYear + job.tipAmount;
    }
  }
  return previousState.copyWith(
    totalTips: totalTipsForYear.toDouble(),
    allJobs: action.allJobs,
    filteredJobs: action.allJobs.where((job) => (job.tipAmount == null || job.tipAmount == 0)).toList().reversed.toList(),
  );
}

IncomeAndExpensesPageState _updateAllInvoicesFilter(IncomeAndExpensesPageState previousState, OnAllInvoicesFilterChangedAction action) {
  return previousState.copyWith(
    allInvoicesFilterType: action.filter,
  );
}

IncomeAndExpensesPageState _updateShowHideState(IncomeAndExpensesPageState previousState, UpdateShowHideState action) {
  return previousState.copyWith(
    isMinimized: !previousState.isMinimized,
  );
}

IncomeAndExpensesPageState _updateSingleExpenseShowHideState(IncomeAndExpensesPageState previousState, UpdateSingleExpenseShowHideState action) {
  return previousState.copyWith(
    isSingleExpensesMinimized: !previousState.isSingleExpensesMinimized,
  );
}

IncomeAndExpensesPageState _setInvoices(IncomeAndExpensesPageState previousState, SetAllInvoicesAction action){
  List<Invoice> unpaidInvoices = action.allInvoices.where((invoice) => invoice.invoicePaid == false).toList();
  List<Invoice> unpaidInvoicesForSelectedYear = unpaidInvoices.where((invoice) => invoice.createdDate.year == previousState.selectedYear).toList();
  List<Invoice> paidInvoices = action.allInvoices.where((invoice) => invoice.invoicePaid == true).toList();
  List<Invoice> paidInvoicesForSelectedYear = paidInvoices.where((invoice) => invoice.createdDate.year == previousState.selectedYear).toList();
  double totalForSelectedYear = 0.0;

  for(Invoice invoice in paidInvoicesForSelectedYear){
    totalForSelectedYear = totalForSelectedYear + (invoice.total - invoice.discount);
  }
  for(Invoice unpaidInvoice in unpaidInvoicesForSelectedYear){
    if(unpaidInvoice.depositPaid){
      totalForSelectedYear = totalForSelectedYear + unpaidInvoice.depositAmount ?? 0.0;
    }
  }
  paidInvoices.sort((invoiceA, invoiceB) => invoiceA.jobName.compareTo(invoiceB.jobName));
  unpaidInvoices.sort((invoiceA, invoiceB) => (invoiceA.dueDate != null && invoiceB.dueDate != null) ? (invoiceA.dueDate.isAfter(invoiceB.dueDate) ? 1 : -1) : 1);
  return previousState.copyWith(
    allInvoices: action.allInvoices,
    paidInvoices: paidInvoices,
    isMinimized: true,
    incomeForSelectedYear: totalForSelectedYear,
    unpaidInvoices: unpaidInvoices,
    pageViewIndex: 0,
  );
}

IncomeAndExpensesPageState _updateFilterSelection(IncomeAndExpensesPageState previousState, FilterChangedAction action){
  return previousState.copyWith(
    filterType: action.filterType,
  );
}

IncomeAndExpensesPageState _setSelectedYear(IncomeAndExpensesPageState previousState, UpdateSelectedYearAction action){
  List<Invoice> unpaidInvoices = previousState.allInvoices.where((invoice) => invoice.invoicePaid == false).toList();
  List<Invoice> unpaidInvoicesForSelectedYear = unpaidInvoices.where((invoice) => invoice.createdDate.year == action.year).toList();

  double totalForSelectedYear = 0.0;

  List<Invoice> paidInvoices = previousState.allInvoices.where((invoice) => invoice.invoicePaid == true).toList();
  List<Invoice> paidInvoicesForSelectedYear = paidInvoices.where((invoice) => invoice.createdDate.year == action.year).toList();
  for(Invoice invoice in paidInvoicesForSelectedYear){
    totalForSelectedYear = totalForSelectedYear + (invoice.total - invoice.discount);
  }
  for(Invoice unpaidInvoice in unpaidInvoicesForSelectedYear){
    if(unpaidInvoice.depositPaid){
      totalForSelectedYear = totalForSelectedYear + unpaidInvoice.depositAmount;
    }
  }

  List<Job> jobsSelectedYear = previousState.allJobs.where((job) => job.selectedDate.year == previousState.selectedYear).toList();
  int totalTipsForYear = 0;
  for(Job job in jobsSelectedYear) {
    if(job != null && job.tipAmount != null) {
      totalTipsForYear = totalTipsForYear + job.tipAmount;
    }
  }
  unpaidInvoices.sort((invoiceA, invoiceB) => (invoiceA.dueDate != null && invoiceB.dueDate != null) ? (invoiceA.dueDate.isAfter(invoiceB.dueDate) ? 1 : -1) : 1);

  List<SingleExpense> singleExpenseForSelectedYear = previousState.singleExpensesForSelectedYear.where((expense) => expense.chargeDate.year == previousState.selectedYear).toList();

  return previousState.copyWith(
    selectedYear: action.year,
    incomeForSelectedYear: totalForSelectedYear,
    unpaidInvoices: unpaidInvoices,
    totalTips: totalTipsForYear.toDouble(),
    singleExpensesForSelectedYear: singleExpenseForSelectedYear,
  );
}