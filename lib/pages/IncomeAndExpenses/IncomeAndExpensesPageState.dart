import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Charge.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/MileageExpense.dart';
import 'package:client_safe/models/Profile.dart';
import 'package:client_safe/models/RecurringExpense.dart';
import 'package:client_safe/models/SingleExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/AllExpensesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/AllInvoicesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:client_safe/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensesPageState {
  final String filterType;
  final String allInvoicesFilterType;
  final String allExpensesFilterType;
  final int selectedYear;
  final int pageViewIndex;
  final Job selectedJob;
  final List<Invoice> allInvoices;
  final List<Invoice> paidInvoices;
  final List<Invoice> unpaidInvoices;
  final List<Job> allJobs;
  final List<Job> filteredJobs;
  final List<Client> allClients;
  final List<SingleExpense> allSingleExpenses;
  final List<SingleExpense> singleExpensesForSelectedYear;
  final List<RecurringExpense> recurringExpensesForSelectedYear;
  final List<RecurringExpense> allRecurringExpenses;
  final List<MileageExpense> allMileageExpenses;
  final List<MileageExpense> mileageExpensesForSelectedYear;
  final bool isFinishedFetchingClients;
  final String jobSearchText;
  final Function(String) onJobSearchTextChanged;
  final double totalIncome;//not from tips
  final double totalTips;
  final double incomeForSelectedYear;
  final double expensesForSelectedYear;
  final int singleExpensesForSelectedYearTotal;
  final int recurringExpensesForSelectedYearTotal;
  final int mileageExpensesForSelectedYearTotal;
  final bool isSingleExpensesMinimized;
  final Profile profile;
  final Function(String) onFilterChanged;
  final Function(String) onAllInvoicesFilterChanged;
  final Function(String) onAllExpensesFilterChanged;
  final Function(int) onYearChanged;
  final Function(Invoice) onEditInvoiceSelected;
  final Function(Invoice) onDeleteSelected;
  final Function(Invoice) onInvoiceSent;
  final Function() onBackPressed;
  final Function() onCancelPressed;
  final Function() onSaveTipSelected;
  final Function() onNextPressed;
  final Function(Job) onJobSelected;
  final Function(int) onAddToTip;
  final Function() onSaveTipChange;
  final Function() onClearUnsavedTip;
  final int unsavedTipAmount;
  final Function(SingleExpense) onSingleExpenseItemSelected;
  final Function(RecurringExpense) onEditRecurringExpenseItemSelected;
  final Function(bool) onViewAllSelected;
  final Function(int) onViewAllExpensesSelected;
  final Function(Charge, RecurringExpense, bool) onRecurringExpenseChargeChecked;
  final Function(RecurringExpense) onCancelRecurringSubscriptionSelected;
  final Function(RecurringExpense) onResumeRecurringSubscriptionSelected;

  IncomeAndExpensesPageState({
    @required this.filterType,
    @required this.selectedYear,
    @required this.allInvoices,
    @required this.totalIncome,
    @required this.selectedJob,
    @required this.incomeForSelectedYear,
    @required this.onFilterChanged,
    @required this.onYearChanged,
    @required this.onEditInvoiceSelected,
    @required this.onDeleteSelected,
    @required this.unpaidInvoices,
    @required this.onInvoiceSent,
    @required this.paidInvoices,
    @required this.allInvoicesFilterType,
    @required this.onAllInvoicesFilterChanged,
    @required this.totalTips,
    @required this.allJobs,
    @required this.isSingleExpensesMinimized,
    @required this.filteredJobs,
    @required this.allClients,
    @required this.isFinishedFetchingClients,
    @required this.onJobSearchTextChanged,
    @required this.jobSearchText,
    @required this.pageViewIndex,
    @required this.onBackPressed,
    @required this.onCancelPressed,
    @required this.onSaveTipSelected,
    @required this.onNextPressed,
    @required this.onJobSelected,
    @required this.onAddToTip,
    @required this.onSaveTipChange,
    @required this.onClearUnsavedTip,
    @required this.unsavedTipAmount,
    @required this.singleExpensesForSelectedYear,
    @required this.singleExpensesForSelectedYearTotal,
    @required this.allSingleExpenses,
    @required this.onSingleExpenseItemSelected,
    @required this.expensesForSelectedYear,
    @required this.onViewAllSelected,
    @required this.allExpensesFilterType,
    @required this.onAllExpensesFilterChanged,
    @required this.onViewAllExpensesSelected,
    @required this.allRecurringExpenses,
    @required this.recurringExpensesForSelectedYear,
    @required this.recurringExpensesForSelectedYearTotal,
    @required this.onEditRecurringExpenseItemSelected,
    @required this.onRecurringExpenseChargeChecked,
    @required this.onCancelRecurringSubscriptionSelected,
    @required this.onResumeRecurringSubscriptionSelected,
    @required this.profile,
    @required this.allMileageExpenses,
    @required this.mileageExpensesForSelectedYear,
    @required this.mileageExpensesForSelectedYearTotal,
  });

  IncomeAndExpensesPageState copyWith({
    List<RecurringExpense> allRecurringExpenses,
    List<RecurringExpense> recurringExpensesForSelectedYear,
    int recurringExpensesForSelectedYearTotal,
    String filterType,
    String allInvoicesFilterType,
    int selectedYear,
    List<Invoice> allInvoices,
    List<Invoice> paidInvoices,
    List<Invoice> unpaidInvoices,
    double totalIncome,
    double totalTips,
    double incomeForSelectedYear,
    double expensesForSelectedYear,
    Function(String) onFilterChanged,
    Function(int) onYearChanged,
    Job selectedJob,
    Function(Invoice) onEditInvoiceSelected,
    Function(Invoice) onDeleteSelected,
    Function(Invoice) onInvoiceSent,
    Function(String) onAllInvoicesFilterChanged,
    Function(String) onAllExpensesFilterChanged,
    List<Job> allJobs,
    List<Job> filteredJobs,
    List<Client> allClients,
    bool isFinishedFetchingClients,
    Function(String) onJobTextChanged,
    String jobSearchText,
    int pageViewIndex,
    int singleExpensesForSelectedYearTotal,
    Function() onBackPressed,
    Function() onCancelPressed,
    Function() onSaveTipSelected,
    Function() onNextPressed,
    Function(Job) onJobSelected,
    Function(int) onAddToTip,
    Function() onSaveTipChange,
    Function() onClearUnsavedTip,
    int unsavedTipAmount,
    List<SingleExpense> singleExpensesForSelectedYear,
    List<SingleExpense> allSingleExpenses,
    bool isSingleExpensesMinimized,
    Function(SingleExpense) onSingleExpenseItemSelected,
    Function(bool) onViewAllSelected,
    String allExpensesFilterType,
    Function(int) onViewAllExpensesSelected,
    Function(RecurringExpense) onRecurringExpenseItemSelected,
    Function(Charge, RecurringExpense, bool) onRecurringExpenseChargeChecked,
    Function(RecurringExpense) onCancelRecurringSubscriptionSelected,
    Function(RecurringExpense) onResumeRecurringSubscriptionSelected,
    Profile profile,
    List<MileageExpense> allMileageExpenses,
    List<MileageExpense> mileageExpensesForSelectedYear,
    int mileageExpensesForSelectedYearTotal,
  }){
    return IncomeAndExpensesPageState(
      filterType: filterType?? this.filterType,
      selectedYear: selectedYear ?? this.selectedYear,
      allInvoices: allInvoices ?? this.allInvoices,
      totalIncome: totalIncome ?? this.totalIncome,
      incomeForSelectedYear: incomeForSelectedYear ?? this.incomeForSelectedYear,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
      onYearChanged: onYearChanged ?? this.onYearChanged,
      onEditInvoiceSelected: onEditInvoiceSelected ?? this.onEditInvoiceSelected,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      unpaidInvoices: unpaidInvoices ?? this.unpaidInvoices,
      onInvoiceSent: onInvoiceSent ?? this.onInvoiceSent,
      paidInvoices: paidInvoices ?? this.paidInvoices,
      totalTips: totalTips ?? this.totalTips,
      selectedJob: selectedJob ?? this.selectedJob,
      allInvoicesFilterType: allInvoicesFilterType ?? this.allInvoicesFilterType,
      onAllExpensesFilterChanged: onAllExpensesFilterChanged ?? this.onAllExpensesFilterChanged,
      onAllInvoicesFilterChanged: onAllInvoicesFilterChanged ?? this.onAllInvoicesFilterChanged,
      allJobs: allJobs ?? this.allJobs,
      filteredJobs: filteredJobs ?? this.filteredJobs,
      allClients: allClients ?? this.allClients,
      isFinishedFetchingClients: isFinishedFetchingClients ?? this.isFinishedFetchingClients,
      onJobSearchTextChanged: onJobSearchTextChanged ?? this.onJobSearchTextChanged,
      jobSearchText: jobSearchText ?? this.jobSearchText,
      pageViewIndex: pageViewIndex ?? this.pageViewIndex,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      onCancelPressed: onCancelPressed ?? this.onCancelPressed,
      onSaveTipSelected: onSaveTipSelected ?? this.onSaveTipSelected,
      onNextPressed: onNextPressed ?? this.onNextPressed,
      onJobSelected: onJobSelected ?? this.onJobSelected,
      onAddToTip: onAddToTip ?? this.onAddToTip,
      onSaveTipChange: onSaveTipChange ?? this.onSaveTipChange,
      onClearUnsavedTip: onClearUnsavedTip ?? this.onClearUnsavedTip,
      unsavedTipAmount: unsavedTipAmount ?? this.unsavedTipAmount,
      singleExpensesForSelectedYear: singleExpensesForSelectedYear ?? this.singleExpensesForSelectedYear,
      singleExpensesForSelectedYearTotal: singleExpensesForSelectedYearTotal ?? this.singleExpensesForSelectedYearTotal,
      allSingleExpenses: allSingleExpenses ?? this.allSingleExpenses,
      isSingleExpensesMinimized: isSingleExpensesMinimized ?? this.isSingleExpensesMinimized,
      onSingleExpenseItemSelected: onSingleExpenseItemSelected ?? this.onSingleExpenseItemSelected,
      expensesForSelectedYear: expensesForSelectedYear ?? this.expensesForSelectedYear,
      onViewAllSelected: onViewAllSelected ?? this.onViewAllSelected,
      allExpensesFilterType: allExpensesFilterType ?? this.allExpensesFilterType,
      onViewAllExpensesSelected: onViewAllExpensesSelected ?? this.onViewAllExpensesSelected,
      allRecurringExpenses: allRecurringExpenses ?? this.allRecurringExpenses,
      recurringExpensesForSelectedYear: recurringExpensesForSelectedYear ?? this.recurringExpensesForSelectedYear,
      recurringExpensesForSelectedYearTotal: recurringExpensesForSelectedYearTotal ?? this.recurringExpensesForSelectedYearTotal,
      onEditRecurringExpenseItemSelected: onRecurringExpenseItemSelected ?? this.onEditRecurringExpenseItemSelected,
      onRecurringExpenseChargeChecked: onRecurringExpenseChargeChecked ?? this.onRecurringExpenseChargeChecked,
      onCancelRecurringSubscriptionSelected: onCancelRecurringSubscriptionSelected ?? this.onCancelRecurringSubscriptionSelected,
      onResumeRecurringSubscriptionSelected: onResumeRecurringSubscriptionSelected ?? this.onResumeRecurringSubscriptionSelected,
      profile: profile ?? this.profile,
      allMileageExpenses: allMileageExpenses ?? this.allMileageExpenses,
      mileageExpensesForSelectedYear: mileageExpensesForSelectedYear ?? this.mileageExpensesForSelectedYear,
      mileageExpensesForSelectedYearTotal: mileageExpensesForSelectedYearTotal ?? this.mileageExpensesForSelectedYearTotal,
    );
  }

  factory IncomeAndExpensesPageState.initial() => IncomeAndExpensesPageState(
    filterType: IncomeAndExpensesPage.FILTER_TYPE_INCOME,
    selectedYear: DateTime.now().year,
    allInvoices: List(),
    totalIncome: 0,
    incomeForSelectedYear: 0,
    onFilterChanged: null,
    onYearChanged: null,
    onEditInvoiceSelected: null,
    onDeleteSelected: null,
    unpaidInvoices: List(),
    onInvoiceSent: null,
    paidInvoices: List(),
    totalTips: 0.0,
    singleExpensesForSelectedYearTotal: 0,
    selectedJob: null,
    allInvoicesFilterType: AllInvoicesPage.FILTER_TYPE_UNPAID,
    onAllInvoicesFilterChanged: null,
    allJobs: List(),
    filteredJobs: List(),
    allClients: List(),
    isFinishedFetchingClients: false,
    onJobSearchTextChanged: null,
    jobSearchText: '',
    pageViewIndex: 0,
    onBackPressed: null,
    onCancelPressed: null,
    onSaveTipSelected: null,
    onNextPressed: null,
    onJobSelected: null,
    onAddToTip: null,
    onClearUnsavedTip: null,
    onSaveTipChange: null,
    unsavedTipAmount: 0,
    singleExpensesForSelectedYear: List(),
    allSingleExpenses: List(),
    isSingleExpensesMinimized: true,
    onSingleExpenseItemSelected: null,
    expensesForSelectedYear: 0.0,
    onViewAllSelected: null,
    onAllExpensesFilterChanged: null,
    allExpensesFilterType: AllExpensesPage.FILTER_TYPE_MILEAGE_EXPENSES,
    onViewAllExpensesSelected: null,
    allRecurringExpenses: List(),
    recurringExpensesForSelectedYear: List(),
    recurringExpensesForSelectedYearTotal: 0,
    onEditRecurringExpenseItemSelected: null,
    onRecurringExpenseChargeChecked: null,
    onCancelRecurringSubscriptionSelected: null,
    onResumeRecurringSubscriptionSelected: null,
    profile: null,
    allMileageExpenses: List(),
    mileageExpensesForSelectedYear: List(),
    mileageExpensesForSelectedYearTotal: 0,
  );

  factory IncomeAndExpensesPageState.fromStore(Store<AppState> store) {
    return IncomeAndExpensesPageState(
      filterType: store.state.incomeAndExpensesPageState.filterType,
      selectedYear: store.state.incomeAndExpensesPageState.selectedYear,
      allInvoices: store.state.incomeAndExpensesPageState.allInvoices,
      totalIncome: store.state.incomeAndExpensesPageState.totalIncome,
      incomeForSelectedYear: store.state.incomeAndExpensesPageState.incomeForSelectedYear,
      unpaidInvoices: store.state.incomeAndExpensesPageState.unpaidInvoices,
      paidInvoices: store.state.incomeAndExpensesPageState.paidInvoices,
      allInvoicesFilterType: store.state.incomeAndExpensesPageState.allInvoicesFilterType,
      totalTips: store.state.incomeAndExpensesPageState.totalTips,
      allJobs: store.state.incomeAndExpensesPageState.allJobs,
      filteredJobs: store.state.incomeAndExpensesPageState.filteredJobs,
      allClients: store.state.incomeAndExpensesPageState.allClients,
      isSingleExpensesMinimized: store.state.incomeAndExpensesPageState.isSingleExpensesMinimized,
      isFinishedFetchingClients: store.state.incomeAndExpensesPageState.isFinishedFetchingClients,
      jobSearchText: store.state.incomeAndExpensesPageState.jobSearchText,
      pageViewIndex: store.state.incomeAndExpensesPageState.pageViewIndex,
      selectedJob: store.state.incomeAndExpensesPageState.selectedJob,
      unsavedTipAmount: store.state.incomeAndExpensesPageState.unsavedTipAmount,
      singleExpensesForSelectedYear: store.state.incomeAndExpensesPageState.singleExpensesForSelectedYear,
      singleExpensesForSelectedYearTotal: store.state.incomeAndExpensesPageState.singleExpensesForSelectedYearTotal,
      allSingleExpenses: store.state.incomeAndExpensesPageState.allSingleExpenses,
      expensesForSelectedYear: store.state.incomeAndExpensesPageState.expensesForSelectedYear,
      allExpensesFilterType: store.state.incomeAndExpensesPageState.allExpensesFilterType,
      allRecurringExpenses: store.state.incomeAndExpensesPageState.allRecurringExpenses,
      recurringExpensesForSelectedYear: store.state.incomeAndExpensesPageState.recurringExpensesForSelectedYear,
      recurringExpensesForSelectedYearTotal: store.state.incomeAndExpensesPageState.recurringExpensesForSelectedYearTotal,
      profile: store.state.incomeAndExpensesPageState.profile,
      allMileageExpenses: store.state.incomeAndExpensesPageState.allMileageExpenses,
      mileageExpensesForSelectedYear: store.state.incomeAndExpensesPageState.mileageExpensesForSelectedYear,
      mileageExpensesForSelectedYearTotal: store.state.incomeAndExpensesPageState.mileageExpensesForSelectedYearTotal,
      onJobSearchTextChanged: (searchText) => store.dispatch(JobSearchTextChangedAction(store.state.incomeAndExpensesPageState, searchText)),
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.incomeAndExpensesPageState, filterType)),
      onYearChanged: (year) => store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, year)),
      onEditInvoiceSelected: (invoice) => store.dispatch(InvoiceEditSelected(store.state.incomeAndExpensesPageState, invoice)),
      onDeleteSelected: (invoice) => store.dispatch(DeleteInvoiceAction(store.state.incomeAndExpensesPageState, invoice)),
      onInvoiceSent: (invoice) => store.dispatch(OnInvoiceSentAction(store.state.incomeAndExpensesPageState, invoice)),
      onAllInvoicesFilterChanged: (filter) => store.dispatch(OnAllInvoicesFilterChangedAction(store.state.incomeAndExpensesPageState, filter)),
      onAllExpensesFilterChanged: (filter) => store.dispatch(OnAllExpensesFilterChangedAction(store.state.incomeAndExpensesPageState, filter)),
      onBackPressed: () => store.dispatch(DecrementTipPageViewIndex(store.state.incomeAndExpensesPageState)),
      onNextPressed: () => store.dispatch(IncrementTipPageViewIndex(store.state.incomeAndExpensesPageState)),
      onCancelPressed: () => store.dispatch(ClearAddTipStateAction(store.state.incomeAndExpensesPageState)),
      onSaveTipSelected: () {
        store.dispatch(SaveTipIncomeChangeAction(store.state.incomeAndExpensesPageState));
        store.dispatch(ClearUnsavedTipAction(store.state.incomeAndExpensesPageState));
      },
      onJobSelected: (selectedJob) => store.dispatch(SetSelectedJobForTipAction(store.state.incomeAndExpensesPageState, selectedJob)),
      onAddToTip: (amountToAdd) => store.dispatch(AddToTipAction(store.state.incomeAndExpensesPageState, amountToAdd)),
      onSaveTipChange: () => store.dispatch(SaveTipIncomeChangeAction(store.state.incomeAndExpensesPageState)),
      onClearUnsavedTip: () => store.dispatch(ClearUnsavedTipAction(store.state.incomeAndExpensesPageState)),
      onSingleExpenseItemSelected: (selectedSingleExpense) => store.dispatch(LoadExistingSingleExpenseAction(store.state.newSingleExpensePageState, selectedSingleExpense)),
      onViewAllSelected: (isUnpaidFilter) => store.dispatch(UpdateAlInvoicesSelectorPosition(store.state.incomeAndExpensesPageState, isUnpaidFilter)),
      onViewAllExpensesSelected: (index) => store.dispatch(UpdateAllExpensesSelectorPosition(store.state.incomeAndExpensesPageState, index)),
      onEditRecurringExpenseItemSelected: (recurringExpense) => store.dispatch(LoadExistingRecurringExpenseAction(store.state.newRecurringExpensePageState, recurringExpense)),
      onRecurringExpenseChargeChecked: (charge, expense, isChecked) => store.dispatch(UpdateSelectedRecurringChargeAction(store.state.incomeAndExpensesPageState, charge, expense, isChecked)),
      onCancelRecurringSubscriptionSelected: (expense) => store.dispatch(SaveCancelledSubscriptionAction(store.state.incomeAndExpensesPageState, expense)),
      onResumeRecurringSubscriptionSelected: (expense) => store.dispatch(SaveResumedSubscriptionAction(store.state.incomeAndExpensesPageState, expense)),
    );
  }

  @override
  int get hashCode =>
      filterType.hashCode ^
      filteredJobs.hashCode ^
      allClients.hashCode ^
      onCancelRecurringSubscriptionSelected.hashCode ^
      onEditRecurringExpenseItemSelected.hashCode ^
      allExpensesFilterType.hashCode ^
      singleExpensesForSelectedYearTotal.hashCode ^
      isFinishedFetchingClients.hashCode ^
      jobSearchText.hashCode ^
      onJobSearchTextChanged.hashCode ^
      onAllInvoicesFilterChanged.hashCode ^
      expensesForSelectedYear.hashCode ^
      selectedYear.hashCode ^
      profile.hashCode ^
      allInvoices.hashCode ^
      onResumeRecurringSubscriptionSelected.hashCode ^
      onAllExpensesFilterChanged.hashCode ^
      onSingleExpenseItemSelected.hashCode ^
      isSingleExpensesMinimized.hashCode ^
      totalIncome.hashCode ^
      pageViewIndex.hashCode ^
      incomeForSelectedYear.hashCode ^
      onFilterChanged.hashCode ^
      unpaidInvoices.hashCode ^
      selectedJob.hashCode ^
      onEditInvoiceSelected.hashCode ^
      onInvoiceSent.hashCode ^
      paidInvoices.hashCode ^
      totalTips.hashCode ^
      mileageExpensesForSelectedYearTotal.hashCode ^
      allMileageExpenses.hashCode ^
      mileageExpensesForSelectedYear.hashCode ^
      allJobs.hashCode ^
      singleExpensesForSelectedYear.hashCode ^
      allInvoicesFilterType.hashCode ^
      onBackPressed.hashCode ^
      onNextPressed.hashCode ^
      onCancelPressed.hashCode ^
      onSaveTipSelected.hashCode ^
      allSingleExpenses.hashCode ^
      onViewAllExpensesSelected.hashCode ^
      onViewAllSelected.hashCode ^
      allRecurringExpenses.hashCode ^
      recurringExpensesForSelectedYear.hashCode ^
      recurringExpensesForSelectedYearTotal.hashCode ^
      onRecurringExpenseChargeChecked.hashCode ^
      onYearChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IncomeAndExpensesPageState &&
              filterType == other.filterType &&
              selectedYear == other.selectedYear &&
              filteredJobs == other.filteredJobs &&
              allClients == other.allClients &&
              allRecurringExpenses == other.allRecurringExpenses &&
              recurringExpensesForSelectedYearTotal == other.recurringExpensesForSelectedYearTotal &&
              recurringExpensesForSelectedYear == other.recurringExpensesForSelectedYear &&
              onViewAllExpensesSelected == other.onViewAllExpensesSelected &&
              onViewAllSelected == other.onViewAllSelected &&
              onEditRecurringExpenseItemSelected == other.onEditRecurringExpenseItemSelected &&
              onSingleExpenseItemSelected == other.onSingleExpenseItemSelected &&
              singleExpensesForSelectedYearTotal == other.singleExpensesForSelectedYearTotal &&
              pageViewIndex == other.pageViewIndex &&
              onResumeRecurringSubscriptionSelected == other.onResumeRecurringSubscriptionSelected &&
              selectedJob == other.selectedJob &&
              isSingleExpensesMinimized == other.isSingleExpensesMinimized &&
              isFinishedFetchingClients == other.isFinishedFetchingClients &&
              jobSearchText == other.jobSearchText &&
              profile == other.profile &&
              onCancelRecurringSubscriptionSelected == other.onCancelRecurringSubscriptionSelected &&
              allExpensesFilterType == other.allExpensesFilterType &&
              expensesForSelectedYear == other.expensesForSelectedYear &&
              onJobSearchTextChanged == other.onJobSearchTextChanged &&
              onAllInvoicesFilterChanged == other.onAllInvoicesFilterChanged &&
              allInvoices == other.allInvoices &&
              mileageExpensesForSelectedYearTotal == other.mileageExpensesForSelectedYearTotal &&
              totalIncome == other.totalIncome &&
              incomeForSelectedYear == other.incomeForSelectedYear &&
              onFilterChanged == other.onFilterChanged &&
              unpaidInvoices == other.unpaidInvoices &&
              onInvoiceSent == other.onInvoiceSent &&
              totalTips == other.totalTips &&
              allJobs == other.allJobs &&
              allMileageExpenses == other.allMileageExpenses &&
              mileageExpensesForSelectedYear == other.mileageExpensesForSelectedYear &&
              onAllExpensesFilterChanged == other.onAllExpensesFilterChanged &&
              singleExpensesForSelectedYear == other.singleExpensesForSelectedYear &&
              onEditInvoiceSelected == other.onEditInvoiceSelected &&
              paidInvoices == other.paidInvoices &&
              onRecurringExpenseChargeChecked == other.onRecurringExpenseChargeChecked &&
              allInvoicesFilterType == other.allInvoicesFilterType &&
              onBackPressed == other.onBackPressed &&
              onNextPressed == other.onNextPressed &&
              onCancelPressed == other.onCancelPressed &&
              onSaveTipSelected == other.onSaveTipSelected &&
              allSingleExpenses == other.allSingleExpenses &&
              onYearChanged == other.onYearChanged;
}
