import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/AllExpensesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/AllInvoicesPage.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../models/JobStage.dart';
import '../dashboard_page/widgets/LineChartMonthData.dart';

final incomeAndExpensesPageReducer = combineReducers<IncomeAndExpensesPageState>([
  TypedReducer<IncomeAndExpensesPageState, SetAllInvoicesAction>(_setInvoices),
  TypedReducer<IncomeAndExpensesPageState, FilterChangedAction>(_updateFilterSelection),
  TypedReducer<IncomeAndExpensesPageState, SetSelectedYearAction>(_setSelectedYear),
  TypedReducer<IncomeAndExpensesPageState, UpdateSingleExpenseShowHideState>(_updateSingleExpenseShowHideState),
  TypedReducer<IncomeAndExpensesPageState, OnAllInvoicesFilterChangedAction>(_updateAllInvoicesFilter),
  TypedReducer<IncomeAndExpensesPageState, OnAllExpensesFilterChangedAction>(_updateAllExpensesFilter),
  TypedReducer<IncomeAndExpensesPageState, SetTipTotalsAction>(_setTipInfo),
  TypedReducer<IncomeAndExpensesPageState, JobSearchTextChangedAction>(_setJobSearchText),
  TypedReducer<IncomeAndExpensesPageState, IncrementTipPageViewIndex>(_incrementTipPageViewIndex),
  TypedReducer<IncomeAndExpensesPageState, DecrementTipPageViewIndex>(_decrementTipPageViewIndex),
  TypedReducer<IncomeAndExpensesPageState, SetSelectedJobForTipAction>(_setSelectedJob),
  TypedReducer<IncomeAndExpensesPageState, AddToTipAction>(_addToUnsavedDeposit),
  TypedReducer<IncomeAndExpensesPageState, ClearUnsavedTipAction>(_clearUnsavedDeposit),
  TypedReducer<IncomeAndExpensesPageState, ClearAddTipStateAction>(_clearAddTipState),
  TypedReducer<IncomeAndExpensesPageState, SetSingleExpensesAction>(_setSingleExpenses),
  TypedReducer<IncomeAndExpensesPageState, SetRecurringExpensesAction>(_setRecurringExpenses),
  TypedReducer<IncomeAndExpensesPageState, UpdateAlInvoicesSelectorPosition>(_setSelectorPosition),
  TypedReducer<IncomeAndExpensesPageState, UpdateAllExpensesSelectorPosition>(_setExpensesSelectorPosition),
  TypedReducer<IncomeAndExpensesPageState, SetProfileAction>(_setProfile),
  TypedReducer<IncomeAndExpensesPageState, SetMileageExpensesAction>(_setMileageExpenses),
]);

IncomeAndExpensesPageState _setProfile(IncomeAndExpensesPageState previousState, SetProfileAction action) {
  return previousState.copyWith(
    profile: action.profile,
  );
}

IncomeAndExpensesPageState _setMileageExpenses(IncomeAndExpensesPageState previousState, SetMileageExpensesAction action) {
  List<MileageExpense> mileageExpenseForSelectedYear = action.mileageExpenses!.where((expense) => expense.charge!.chargeDate!.year == previousState.selectedYear).toList();
  mileageExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge!.chargeDate!.isBefore(expenseB.charge!.chargeDate!) == true ? 1 : -1);

  double singleExpensesTotal = 0;
  for(SingleExpense expense in previousState.singleExpensesForSelectedYear!){
    singleExpensesTotal = singleExpensesTotal + expense.charge!.chargeAmount!;
  }

  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in previousState.recurringExpensesForSelectedYear!){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(previousState.selectedYear!);
  }

  double mileageExpensesTotal = 0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge!.chargeAmount!;
  }

  double totalMilesDriven = 0.0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    totalMilesDriven = totalMilesDriven + expense.totalMiles!;
  }
  return previousState.copyWith(
    mileageExpensesForSelectedYear: mileageExpenseForSelectedYear,
    allMileageExpenses: action.mileageExpenses,
    totalMilesDriven: totalMilesDriven,
    mileageExpensesForSelectedYearTotal: mileageExpensesTotal,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal,
  );
}

IncomeAndExpensesPageState _setSelectorPosition(IncomeAndExpensesPageState previousState, UpdateAlInvoicesSelectorPosition action) {
  return previousState.copyWith(
    allInvoicesFilterType: action.isUnpaidFilter! ? AllInvoicesPage.FILTER_TYPE_UNPAID : AllInvoicesPage.FILTER_TYPE_PAID,
  );
}

IncomeAndExpensesPageState _setExpensesSelectorPosition(IncomeAndExpensesPageState previousState, UpdateAllExpensesSelectorPosition action) {
  return previousState.copyWith(
    allExpensesFilterType: action.index == 0 ? AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES : action.index == 1 ? AllExpensesPage.FILTER_TYPE_SINGLE_EXPENSES : AllExpensesPage.FILTER_TYPE_RECURRING_EXPENSES,
  );
}

IncomeAndExpensesPageState _setSingleExpenses(IncomeAndExpensesPageState previousState, SetSingleExpensesAction action) {
  List<SingleExpense> singleExpenseForSelectedYear = action.singleExpenses!.where((expense) => expense.charge!.chargeDate!.year == previousState.selectedYear).toList();
  singleExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge!.chargeDate!.isBefore(expenseB.charge!.chargeDate!) == true ? 1 : -1);

  double singleExpensesTotal = 0;
  for(SingleExpense expense in singleExpenseForSelectedYear){
    singleExpensesTotal = singleExpensesTotal + expense.charge!.chargeAmount!;
  }

  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in previousState.recurringExpensesForSelectedYear!){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(previousState.selectedYear!);
  }

  double mileageExpensesTotal = 0;
  for(MileageExpense expense in previousState.mileageExpensesForSelectedYear!){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge!.chargeAmount!;
  }
  return previousState.copyWith(
    singleExpensesForSelectedYear: singleExpenseForSelectedYear,
    allSingleExpenses: action.singleExpenses,
    singleExpensesForSelectedYearTotal: singleExpensesTotal,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal,
  );
}

IncomeAndExpensesPageState _setRecurringExpenses(IncomeAndExpensesPageState previousState, SetRecurringExpensesAction action) {
  List<RecurringExpense> recurringExpenseForSelectedYear = action.recurringExpenses!.where((expense) => expense.initialChargeDate!.year <= previousState.selectedYear! && (expense.cancelDate == null || expense.cancelDate!.year >= previousState.selectedYear!)).toList();
  double singleExpensesTotal = 0;
  for(SingleExpense expense in previousState.singleExpensesForSelectedYear!){
    singleExpensesTotal = singleExpensesTotal + expense.charge!.chargeAmount!;
  }

  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in action.recurringExpenses!){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(previousState.selectedYear!);
  }

  double mileageExpensesTotal = 0;
  for(MileageExpense expense in previousState.mileageExpensesForSelectedYear!){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge!.chargeAmount!;
  }
  return previousState.copyWith(
    recurringExpensesForSelectedYear: recurringExpenseForSelectedYear,
    allRecurringExpenses: action.recurringExpenses,
    recurringExpensesForSelectedYearTotal: recurringExpenseTotal,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal,
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
  int newAmount = previousState.unsavedTipAmount! + action.amountToAdd!;
  return previousState.copyWith(unsavedTipAmount: newAmount);
}

IncomeAndExpensesPageState _setSelectedJob(IncomeAndExpensesPageState previousState, SetSelectedJobForTipAction action) {
  return previousState.copyWith(
    selectedJob: action.selectedJob,
  );
}

IncomeAndExpensesPageState _incrementTipPageViewIndex(IncomeAndExpensesPageState previousState, IncrementTipPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: previousState.pageViewIndex! + 1,
  );
}

IncomeAndExpensesPageState _decrementTipPageViewIndex(IncomeAndExpensesPageState previousState, DecrementTipPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: previousState.pageViewIndex! - 1,
  );
}

IncomeAndExpensesPageState _setJobSearchText(IncomeAndExpensesPageState previousState, JobSearchTextChangedAction action) {
  List<Job>? filteredJobs = action.jobSearchText!.length > 0
      ? previousState.allJobs!
      .where((job) => job
      .jobTitle!
      .toLowerCase()
      .contains(action.jobSearchText!.toLowerCase()))
      .toList()
      : previousState.allJobs;
  return previousState.copyWith(
    jobSearchText: action.jobSearchText,
    filteredJobs: filteredJobs,
  );
}

IncomeAndExpensesPageState _setTipInfo(IncomeAndExpensesPageState previousState, SetTipTotalsAction action) {
  List<Job> jobsSelectedYear = action.allJobs!.where((job) => (job.selectedDate != null ? job.selectedDate!.year : 0) == previousState.selectedYear).toList();
  int totalTipsForYear = 0;
  for(Job? job in jobsSelectedYear) {
    if(job != null && job.tipAmount != null) {
      totalTipsForYear = totalTipsForYear + job.tipAmount!;
    }
  }
  return previousState.copyWith(
    totalTips: totalTipsForYear.toDouble(),
    allJobs: action.allJobs,
    filteredJobs: action.allJobs!.where((job) => (job.tipAmount == null || job.tipAmount == 0)).toList().reversed.toList(),
  );
}

IncomeAndExpensesPageState _updateAllInvoicesFilter(IncomeAndExpensesPageState previousState, OnAllInvoicesFilterChangedAction action) {
  return previousState.copyWith(
    allInvoicesFilterType: action.filter,
  );
}

IncomeAndExpensesPageState _updateAllExpensesFilter(IncomeAndExpensesPageState previousState, OnAllExpensesFilterChangedAction action) {
  return previousState.copyWith(
    allExpensesFilterType: action.filter,
  );
}

IncomeAndExpensesPageState _updateSingleExpenseShowHideState(IncomeAndExpensesPageState previousState, UpdateSingleExpenseShowHideState action) {
  return previousState.copyWith(
    isSingleExpensesMinimized: !previousState.isSingleExpensesMinimized!,
  );
}

IncomeAndExpensesPageState _setInvoices(IncomeAndExpensesPageState previousState, SetAllInvoicesAction action){
  List<Invoice> unpaidInvoices = action.allInvoices!.where((invoice) => invoice.invoicePaid == false).toList();
  List<Invoice> paidInvoices = action.allInvoices!.where((invoice) => invoice.invoicePaid == true).toList();
  paidInvoices.sort((invoiceA, invoiceB) => invoiceA.jobName!.compareTo(invoiceB.jobName!));
  unpaidInvoices.sort((invoiceA, invoiceB) => (invoiceA.dueDate != null && invoiceB.dueDate != null) ? (invoiceA.dueDate!.isAfter(invoiceB.dueDate!) ? 1 : -1) : 1);
  return previousState.copyWith(
    allInvoices: action.allInvoices,
    paidInvoices: paidInvoices,
    unpaidInvoices: unpaidInvoices,
    pageViewIndex: 0,
  );
}

IncomeAndExpensesPageState _updateFilterSelection(IncomeAndExpensesPageState previousState, FilterChangedAction action){
  return previousState.copyWith(
    filterType: action.filterType,
  );
}

IncomeAndExpensesPageState _setSelectedYear(IncomeAndExpensesPageState previousState, SetSelectedYearAction action){
  List<Invoice> unpaidInvoices = previousState.allInvoices!.where((invoice) => invoice.invoicePaid == false).toList();
  List<Invoice> paidInvoices = previousState.allInvoices!.where((invoice) => invoice.invoicePaid!).toList();

  unpaidInvoices.sort((invoiceA, invoiceB) => (invoiceA.dueDate != null && invoiceB.dueDate != null) ? (invoiceA.dueDate!.isAfter(invoiceB.dueDate!) ? 1 : -1) : 1);

  List<SingleExpense> singleExpenseForSelectedYear = previousState.allSingleExpenses!.where((expense) => expense.charge!.chargeDate!.year == action.year).toList();
  singleExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge!.chargeDate!.isBefore(expenseB.charge!.chargeDate!) == true ? 1 : -1);

  double singleExpensesTotal = 0;
  for(SingleExpense expense in singleExpenseForSelectedYear){
    singleExpensesTotal = singleExpensesTotal + expense.charge!.chargeAmount!;
  }

  List<RecurringExpense> recurringExpenseForSelectedYear = previousState.allRecurringExpenses!.where((expense) => expense.initialChargeDate!.year <= action.year! && (expense.cancelDate == null || expense.cancelDate!.year >= action.year!)).toList();
  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in recurringExpenseForSelectedYear){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(action.year!);
  }


  List<MileageExpense> mileageExpenseForSelectedYear = previousState.allMileageExpenses!.where((expense) => expense.charge!.chargeDate!.year == action.year).toList();
  mileageExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge!.chargeDate!.isBefore(expenseB.charge!.chargeDate!) == true ? 1 : -1);
  double mileageExpensesTotal = 0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge!.chargeAmount!;
  }

  double totalMilesDriven = 0.0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    totalMilesDriven = totalMilesDriven + expense.totalMiles!;
  }

  return previousState.copyWith(
    selectedYear: action.year,
    incomeForSelectedYear: action.totalIncomeForYear,
    unpaidInvoices: unpaidInvoices,
    paidInvoices: paidInvoices,
    totalMilesDriven: totalMilesDriven,
    mileageExpensesForSelectedYear: mileageExpenseForSelectedYear,
    mileageExpensesForSelectedYearTotal: mileageExpensesTotal,
    singleExpensesForSelectedYear: singleExpenseForSelectedYear,
    recurringExpensesForSelectedYear: recurringExpenseForSelectedYear,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal,
    recurringExpensesForSelectedYearTotal: recurringExpenseTotal,
    thisMonthIncome: action.totalIncomeForThisMonth.toInt(),
    lastMonthIncome: action.totalIncomeForLastMonth.toInt(),
    lineChartMonthData: action.chartItems.reversed.toList(),
  );
}