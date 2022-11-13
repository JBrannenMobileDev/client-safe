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
  List<MileageExpense> mileageExpenseForSelectedYear = action.mileageExpenses.where((expense) => expense.charge.chargeDate.year == previousState.selectedYear).toList();
  mileageExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge.chargeDate.isBefore(expenseB.charge.chargeDate) == true ? 1 : -1);

  double singleExpensesTotal = 0;
  for(SingleExpense expense in previousState.singleExpensesForSelectedYear){
    singleExpensesTotal = singleExpensesTotal + expense.charge.chargeAmount;
  }

  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in previousState.recurringExpensesForSelectedYear){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(previousState.selectedYear);
  }

  double mileageExpensesTotal = 0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge.chargeAmount;
  }

  double totalMilesDriven = 0.0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    totalMilesDriven = totalMilesDriven + expense.totalMiles;
  }
  return previousState.copyWith(
    mileageExpensesForSelectedYear: mileageExpenseForSelectedYear,
    allMileageExpenses: action.mileageExpenses,
    totalMilesDriven: totalMilesDriven,
    mileageExpensesForSelectedYearTotal: mileageExpensesTotal,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal + mileageExpensesTotal,
  );
}

IncomeAndExpensesPageState _setSelectorPosition(IncomeAndExpensesPageState previousState, UpdateAlInvoicesSelectorPosition action) {
  return previousState.copyWith(
    allInvoicesFilterType: action.isUnpaidFilter ? AllInvoicesPage.FILTER_TYPE_UNPAID : AllInvoicesPage.FILTER_TYPE_PAID,
  );
}

IncomeAndExpensesPageState _setExpensesSelectorPosition(IncomeAndExpensesPageState previousState, UpdateAllExpensesSelectorPosition action) {
  return previousState.copyWith(
    allExpensesFilterType: action.index == 0 ? AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES : action.index == 1 ? AllExpensesPage.FILTER_TYPE_SINGLE_EXPENSES : AllExpensesPage.FILTER_TYPE_RECURRING_EXPENSES,
  );
}

IncomeAndExpensesPageState _setSingleExpenses(IncomeAndExpensesPageState previousState, SetSingleExpensesAction action) {
  List<SingleExpense> singleExpenseForSelectedYear = action.singleExpenses.where((expense) => expense.charge.chargeDate.year == previousState.selectedYear).toList();
  singleExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge.chargeDate.isBefore(expenseB.charge.chargeDate) == true ? 1 : -1);

  double singleExpensesTotal = 0;
  for(SingleExpense expense in singleExpenseForSelectedYear){
    singleExpensesTotal = singleExpensesTotal + expense.charge.chargeAmount;
  }

  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in previousState.recurringExpensesForSelectedYear){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(previousState.selectedYear);
  }

  double mileageExpensesTotal = 0;
  for(MileageExpense expense in previousState.mileageExpensesForSelectedYear){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge.chargeAmount;
  }
  return previousState.copyWith(
    singleExpensesForSelectedYear: singleExpenseForSelectedYear,
    allSingleExpenses: action.singleExpenses,
    singleExpensesForSelectedYearTotal: singleExpensesTotal,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal + mileageExpensesTotal,
  );
}

IncomeAndExpensesPageState _setRecurringExpenses(IncomeAndExpensesPageState previousState, SetRecurringExpensesAction action) {
  List<RecurringExpense> recurringExpenseForSelectedYear = action.recurringExpenses.where((expense) => expense.initialChargeDate.year <= previousState.selectedYear && (expense.cancelDate == null || expense.cancelDate.year >= previousState.selectedYear)).toList();
  double singleExpensesTotal = 0;
  for(SingleExpense expense in previousState.singleExpensesForSelectedYear){
    singleExpensesTotal = singleExpensesTotal + expense.charge.chargeAmount;
  }

  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in action.recurringExpenses){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(previousState.selectedYear);
  }

  double mileageExpensesTotal = 0;
  for(MileageExpense expense in previousState.mileageExpensesForSelectedYear){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge.chargeAmount;
  }
  return previousState.copyWith(
    recurringExpensesForSelectedYear: recurringExpenseForSelectedYear,
    allRecurringExpenses: action.recurringExpenses,
    recurringExpensesForSelectedYearTotal: recurringExpenseTotal,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal + mileageExpensesTotal,
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

IncomeAndExpensesPageState _updateAllExpensesFilter(IncomeAndExpensesPageState previousState, OnAllExpensesFilterChangedAction action) {
  return previousState.copyWith(
    allExpensesFilterType: action.filter,
  );
}

IncomeAndExpensesPageState _updateSingleExpenseShowHideState(IncomeAndExpensesPageState previousState, UpdateSingleExpenseShowHideState action) {
  return previousState.copyWith(
    isSingleExpensesMinimized: !previousState.isSingleExpensesMinimized,
  );
}

IncomeAndExpensesPageState _setInvoices(IncomeAndExpensesPageState previousState, SetAllInvoicesAction action){
  List<Invoice> unpaidInvoices = action.allInvoices.where((invoice) => invoice.invoicePaid == false).toList();
  List<Invoice> paidInvoices = action.allInvoices.where((invoice) => invoice.invoicePaid == true).toList();
  paidInvoices.sort((invoiceA, invoiceB) => invoiceA.jobName.compareTo(invoiceB.jobName));
  unpaidInvoices.sort((invoiceA, invoiceB) => (invoiceA.dueDate != null && invoiceB.dueDate != null) ? (invoiceA.dueDate.isAfter(invoiceB.dueDate) ? 1 : -1) : 1);
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
  List<Invoice> unpaidInvoices = previousState.allInvoices.where((invoice) => invoice.invoicePaid == false).toList();
  List<Job> jobsWithOnlyDepositReceived = action.allJobs.where((job) => job.isPaymentReceived() == false && job.isDepositPaid() == true).toList();

  double totalForSelectedYear = 0.0;
  double thisMonth = 0.0;
  double lastMonth = 0.0;
  double thisMonthLastYear = 0.0;
  double lastMonthLastYear = 0.0;

  DateTime now = DateTime.now();
  DateTime lastMonthDate = DateTime(now.year, now.month -1, now.day);
  DateTime thisMonthLastYearDate = DateTime(now.year-1, now.month, now.day);
  DateTime lastMonthLastYearDate = DateTime(now.year-1, now.month-1, now.day);

  List<Invoice> paidInvoices = previousState.allInvoices.where((invoice) => invoice.invoicePaid).toList();
  List<Invoice> paidInvoicesForSelectedYear = paidInvoices.where((invoice) => invoice.createdDate.year == action.year).toList();
  for(Invoice invoice in paidInvoicesForSelectedYear){
    totalForSelectedYear = totalForSelectedYear + (invoice.total - invoice.discount);
    if(invoice.dueDate.year == now.year && invoice.dueDate.month == now.month) {
      thisMonth = thisMonth + (invoice.total - invoice.discount);
    }
    if(invoice.dueDate.year == lastMonthDate.year && invoice.dueDate.month == lastMonthDate.month) {
      lastMonth = lastMonth + (invoice.total - invoice.discount);
    }
    if(invoice.dueDate.year == thisMonthLastYearDate.year && invoice.dueDate.month == thisMonthLastYearDate.month) {
      thisMonthLastYear = thisMonthLastYear + (invoice.total - invoice.discount);
    }
    if(invoice.dueDate.year == lastMonthLastYearDate.year && invoice.dueDate.month == lastMonthLastYearDate.month) {
      lastMonthLastYear = lastMonthLastYear + (invoice.total - invoice.discount);
    }
  }

  for(Job job in jobsWithOnlyDepositReceived){
      if(job.depositReceivedDate.year == action.year) {
        totalForSelectedYear = totalForSelectedYear + job.depositAmount;
      }

      if(job.depositReceivedDate.year == now.year && job.depositReceivedDate.month == now.month) {
        thisMonth = thisMonth + job.depositAmount;
      }
      if(job.depositReceivedDate.year == lastMonthDate.year && job.depositReceivedDate.month == lastMonthDate.month) {
        lastMonth = lastMonth + job.depositAmount;
      }
      if(job.depositReceivedDate.year == thisMonthLastYearDate.year && job.depositReceivedDate.month == thisMonthLastYearDate.month) {
        thisMonthLastYear = thisMonthLastYear + job.depositAmount;
      }
      if(job.depositReceivedDate.year == lastMonthLastYearDate.year && job.depositReceivedDate.month == lastMonthLastYearDate.month) {
        lastMonthLastYear = lastMonthLastYear + job.depositAmount;
      }
  }

  for(Job job in action.allJobs.where((job) => job.isPaymentReceived() == true).toList()) {
    if(job.invoice == null) {
      if(job.paymentReceivedDate.year == action.year) {
        totalForSelectedYear = totalForSelectedYear + job.priceProfile.flatRate;
      }

      if(job.paymentReceivedDate.year == now.year && job.paymentReceivedDate.month == now.month) {
        thisMonth = thisMonth + job.priceProfile.flatRate + (job.tipAmount != null ? job.tipAmount : 0);
      }
      if(job.paymentReceivedDate.year == lastMonthDate.year && job.paymentReceivedDate.month == lastMonthDate.month) {
        lastMonth = lastMonth + job.priceProfile.flatRate + (job.tipAmount != null ? job.tipAmount : 0);
      }
      if(job.paymentReceivedDate.year == thisMonthLastYearDate.year && job.paymentReceivedDate.month == thisMonthLastYearDate.month) {
        thisMonthLastYear = thisMonthLastYear + job.priceProfile.flatRate + (job.tipAmount != null ? job.tipAmount : 0);
      }
      if(job.paymentReceivedDate.year == lastMonthLastYearDate.year && job.paymentReceivedDate.month == lastMonthLastYearDate.month) {
        lastMonthLastYear = lastMonthLastYear + job.priceProfile.flatRate + (job.tipAmount != null ? job.tipAmount : 0);
      }
    } else {
      if(job.paymentReceivedDate.year == now.year && job.paymentReceivedDate.month == now.month) {
        thisMonth = thisMonth + job.tipAmount ?? 0.0;
      }
      if(job.paymentReceivedDate.year == lastMonthDate.year && job.paymentReceivedDate.month == lastMonthDate.month) {
        lastMonth = lastMonth + job.tipAmount ?? 0.0;
      }
      if(job.paymentReceivedDate.year == thisMonthLastYearDate.year && job.paymentReceivedDate.month == thisMonthLastYearDate.month) {
        thisMonthLastYear = thisMonthLastYear + job.tipAmount;
      }
      if(job.paymentReceivedDate.year == lastMonthLastYearDate.year && job.paymentReceivedDate.month == lastMonthLastYearDate.month) {
        lastMonthLastYear = lastMonthLastYear + job.tipAmount;
      }
    }
  }

  unpaidInvoices.sort((invoiceA, invoiceB) => (invoiceA.dueDate != null && invoiceB.dueDate != null) ? (invoiceA.dueDate.isAfter(invoiceB.dueDate) ? 1 : -1) : 1);

  List<SingleExpense> singleExpenseForSelectedYear = previousState.allSingleExpenses.where((expense) => expense.charge.chargeDate.year == action.year).toList();
  singleExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge.chargeDate.isBefore(expenseB.charge.chargeDate) == true ? 1 : -1);

  double singleExpensesTotal = 0;
  for(SingleExpense expense in singleExpenseForSelectedYear){
    singleExpensesTotal = singleExpensesTotal + expense.charge.chargeAmount;
  }

  List<RecurringExpense> recurringExpenseForSelectedYear = previousState.allRecurringExpenses.where((expense) => expense.initialChargeDate.year <= action.year && (expense.cancelDate == null || expense.cancelDate.year >= action.year)).toList();
  double recurringExpenseTotal = 0;
  for(RecurringExpense recurringExpense in recurringExpenseForSelectedYear){
    recurringExpenseTotal = recurringExpenseTotal + recurringExpense.getTotalOfChargesForYear(action.year);
  }


  List<MileageExpense> mileageExpenseForSelectedYear = previousState.allMileageExpenses.where((expense) => expense.charge.chargeDate.year == action.year).toList();
  mileageExpenseForSelectedYear.sort((expenseA, expenseB) => expenseA.charge.chargeDate.isBefore(expenseB.charge.chargeDate) == true ? 1 : -1);
  double mileageExpensesTotal = 0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    mileageExpensesTotal = mileageExpensesTotal + expense.charge.chargeAmount;
  }

  double totalMilesDriven = 0.0;
  for(MileageExpense expense in mileageExpenseForSelectedYear){
    totalMilesDriven = totalMilesDriven + expense.totalMiles;
  }

  List<Job> jobsWithPaymentReceived = action.allJobs.where((job) => job.isPaymentReceived() == true).toList();
  List<LineChartMonthData> chartItems = buildChartData(jobsWithPaymentReceived, jobsWithOnlyDepositReceived);

  return previousState.copyWith(
    selectedYear: action.year,
    incomeForSelectedYear: totalForSelectedYear,
    unpaidInvoices: unpaidInvoices,
    paidInvoices: paidInvoices,
    totalMilesDriven: totalMilesDriven,
    mileageExpensesForSelectedYear: mileageExpenseForSelectedYear,
    mileageExpensesForSelectedYearTotal: mileageExpensesTotal,
    singleExpensesForSelectedYear: singleExpenseForSelectedYear,
    recurringExpensesForSelectedYear: recurringExpenseForSelectedYear,
    expensesForSelectedYear: singleExpensesTotal + recurringExpenseTotal + mileageExpensesTotal,
    recurringExpensesForSelectedYearTotal: recurringExpenseTotal,
    thisMonthIncome: thisMonth.toInt(),
    lastMonthIncome: lastMonth.toInt(),
    thisMonthLastYearIncome: thisMonthLastYear.toInt(),
    lastMonthLastYearIncome: lastMonthLastYear.toInt(),
    lineChartMonthData: chartItems.reversed.toList(),
  );
}

List<LineChartMonthData> buildChartData(List<Job> jobsWithPaymentReceived, List<Job> jobsWithOnlyDepositReceived) {
  List<LineChartMonthData> chartItems = [];
  DateTime now = DateTime.now();
  int currentYear = now.year;

  String name5 = DateFormat.MMMM().format(now);
  LineChartMonthData data5 = LineChartMonthData(name: name5, income: 0, monthInt: now.month);
  chartItems.add(data5);

  DateTime nowMinus1 = DateTime(now.year, now.month - 1, now.day);
  String name4 = DateFormat.MMMM().format(nowMinus1);
  LineChartMonthData data4 = LineChartMonthData(name: name4, income: 0, monthInt: nowMinus1.month);
  chartItems.add(data4);

  DateTime nowMinus2 = DateTime(now.year, now.month - 2, now.day);
  String name3 = DateFormat.MMMM().format(nowMinus2);
  LineChartMonthData data3 = LineChartMonthData(name: name3, income: 0, monthInt: nowMinus2.month);
  chartItems.add(data3);

  DateTime nowMinus3 = DateTime(now.year, now.month - 3, now.day);
  String name2 = DateFormat.MMMM().format(nowMinus3);
  LineChartMonthData data2 = LineChartMonthData(name: name2, income: 0, monthInt: nowMinus3.month);
  chartItems.add(data2);

  DateTime nowMinus4 = DateTime(now.year, now.month - 4, now.day);
  String name1 = DateFormat.MMMM().format(nowMinus4);
  LineChartMonthData data1 = LineChartMonthData(name: name1, income: 0, monthInt: nowMinus4.month);
  chartItems.add(data1);

  DateTime nowMinus5 = DateTime(now.year, now.month - 5, now.day);
  String name0 = DateFormat.MMMM().format(nowMinus5);
  LineChartMonthData data = LineChartMonthData(name: name0, income: 0, monthInt: nowMinus5.month);
  chartItems.add(data);

  for(Job job in jobsWithOnlyDepositReceived) {
    DateTime depositReceivedDate = job.depositReceivedDate;

    if(depositReceivedDate != null && depositReceivedDate.year == currentYear) {
      int depositMonth = depositReceivedDate.month;

      if(depositMonth == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income += (job.depositAmount != null ? job.depositAmount : 0);
      }

      if(depositMonth == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income += (job.depositAmount != null ? job.depositAmount : 0);
      }
    }
  }

  for(Job job in jobsWithPaymentReceived) {
    DateTime paymentReceivedDate = job.paymentReceivedDate != null ? job.paymentReceivedDate : job.selectedDate;

    if(paymentReceivedDate != null && paymentReceivedDate.year == currentYear) {
      int jobMonth = paymentReceivedDate.month;

      if(jobMonth == chartItems.elementAt(0).monthInt) {
        chartItems.elementAt(0).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(0).income += (job.invoice.total - job.invoice.discount).toInt();
        } else {
          chartItems.elementAt(0).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(1).monthInt) {
        chartItems.elementAt(1).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(1).income += (job.invoice.total - job.invoice.discount).toInt();
        } else {
          chartItems.elementAt(1).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(2).monthInt) {
        chartItems.elementAt(2).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(2).income += (job.invoice.total - job.invoice.discount).toInt();
        } else {
          chartItems.elementAt(2).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(3).monthInt) {
        chartItems.elementAt(3).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(3).income += (job.invoice.total - job.invoice.discount).toInt();
        } else {
          chartItems.elementAt(3).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(4).monthInt) {
        chartItems.elementAt(4).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(4).income += (job.invoice.total - job.invoice.discount).toInt();
        } else {
          chartItems.elementAt(4).income += job.priceProfile.flatRate.toInt();
        }
      }

      if(jobMonth == chartItems.elementAt(5).monthInt) {
        chartItems.elementAt(5).income += (job.tipAmount != null ? job.tipAmount : 0);

        if(job.invoice != null) {
          chartItems.elementAt(5).income += (job.invoice.total - job.invoice.discount).toInt();
        } else {
          chartItems.elementAt(5).income += job.priceProfile.flatRate.toInt();
        }
      }
    }
  }
  return chartItems;
}