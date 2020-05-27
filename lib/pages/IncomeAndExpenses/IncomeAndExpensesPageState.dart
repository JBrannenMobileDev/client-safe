import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/IncomeAndExpenses/AllInvoicesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensesPageState {
  final String filterType;
  final String allInvoicesFilterType;
  final int selectedYear;
  final int pageViewIndex;
  final Job selectedJob;
  final List<Invoice> allInvoices;
  final List<Invoice> paidInvoices;
  final List<Invoice> unpaidInvoices;
  final List<Job> allJobs;
  final List<Job> filteredJobs;
  final List<Client> allClients;
  final bool isFinishedFetchingClients;
  final String jobSearchText;
  final Function(String) onJobSearchTextChanged;
  final double totalIncome;//not from tips
  final double totalTips;
  final double incomeForSelectedYear;
  final bool isMinimized;
  final Function(String) onFilterChanged;
  final Function(String) onAllInvoicesFilterChanged;
  final Function(int) onYearChanged;
  final Function() onViewAllHideSelected;
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

  IncomeAndExpensesPageState({
    @required this.filterType,
    @required this.selectedYear,
    @required this.allInvoices,
    @required this.totalIncome,
    @required this.selectedJob,
    @required this.incomeForSelectedYear,
    @required this.onFilterChanged,
    @required this.onYearChanged,
    @required this.isMinimized,
    @required this.onViewAllHideSelected,
    @required this.onEditInvoiceSelected,
    @required this.onDeleteSelected,
    @required this.unpaidInvoices,
    @required this.onInvoiceSent,
    @required this.paidInvoices,
    @required this.allInvoicesFilterType,
    @required this.onAllInvoicesFilterChanged,
    @required this.totalTips,
    @required this.allJobs,
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
  });

  IncomeAndExpensesPageState copyWith({
    String filterType,
    String allInvoicesFilterType,
    int selectedYear,
    List<Invoice> allInvoices,
    List<Invoice> paidInvoices,
    List<Invoice> unpaidInvoices,
    double totalIncome,
    double totalTips,
    double incomeForSelectedYear,
    Function(String) onFilterChanged,
    Function(int) onYearChanged,
    bool isMinimized,
    Job selectedJob,
    Function() onViewAllHideSelected,
    Function(Invoice) onEditInvoiceSelected,
    Function(Invoice) onDeleteSelected,
    Function(Invoice) onInvoiceSent,
    Function(String) onAllInvoicesFilterChanged,
    List<Job> allJobs,
    List<Job> filteredJobs,
    List<Client> allClients,
    bool isFinishedFetchingClients,
    Function(String) onJobTextChanged,
    String jobSearchText,
    int pageViewIndex,
    Function() onBackPressed,
    Function() onCancelPressed,
    Function() onSaveTipSelected,
    Function() onNextPressed,
    Function(Job) onJobSelected,
    Function(int) onAddToTip,
    Function() onSaveTipChange,
    Function() onClearUnsavedTip,
    int unsavedTipAmount,
  }){
    return IncomeAndExpensesPageState(
      filterType: filterType?? this.filterType,
      selectedYear: selectedYear ?? this.selectedYear,
      allInvoices: allInvoices ?? this.allInvoices,
      totalIncome: totalIncome ?? this.totalIncome,
      incomeForSelectedYear: incomeForSelectedYear ?? this.incomeForSelectedYear,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
      onYearChanged: onYearChanged ?? this.onYearChanged,
      isMinimized: isMinimized ?? this.isMinimized,
      onViewAllHideSelected: onViewAllHideSelected ?? this.onViewAllHideSelected,
      onEditInvoiceSelected: onEditInvoiceSelected ?? this.onEditInvoiceSelected,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      unpaidInvoices: unpaidInvoices ?? this.unpaidInvoices,
      onInvoiceSent: onInvoiceSent ?? this.onInvoiceSent,
      paidInvoices: paidInvoices ?? this.paidInvoices,
      totalTips: totalTips ?? this.totalTips,
      selectedJob: selectedJob ?? this.selectedJob,
      allInvoicesFilterType: allInvoicesFilterType ?? this.allInvoicesFilterType,
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
    isMinimized: true,
    onViewAllHideSelected: null,
    onEditInvoiceSelected: null,
    onDeleteSelected: null,
    unpaidInvoices: List(),
    onInvoiceSent: null,
    paidInvoices: List(),
    totalTips: 0.0,
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
  );

  factory IncomeAndExpensesPageState.fromStore(Store<AppState> store) {
    return IncomeAndExpensesPageState(
      filterType: store.state.incomeAndExpensesPageState.filterType,
      selectedYear: store.state.incomeAndExpensesPageState.selectedYear,
      allInvoices: store.state.incomeAndExpensesPageState.allInvoices,
      totalIncome: store.state.incomeAndExpensesPageState.totalIncome,
      isMinimized: store.state.incomeAndExpensesPageState.isMinimized,
      incomeForSelectedYear: store.state.incomeAndExpensesPageState.incomeForSelectedYear,
      unpaidInvoices: store.state.incomeAndExpensesPageState.unpaidInvoices,
      paidInvoices: store.state.incomeAndExpensesPageState.paidInvoices,
      allInvoicesFilterType: store.state.incomeAndExpensesPageState.allInvoicesFilterType,
      totalTips: store.state.incomeAndExpensesPageState.totalTips,
      allJobs: store.state.incomeAndExpensesPageState.allJobs,
      filteredJobs: store.state.incomeAndExpensesPageState.filteredJobs,
      allClients: store.state.incomeAndExpensesPageState.allClients,
      isFinishedFetchingClients: store.state.incomeAndExpensesPageState.isFinishedFetchingClients,
      jobSearchText: store.state.incomeAndExpensesPageState.jobSearchText,
      pageViewIndex: store.state.incomeAndExpensesPageState.pageViewIndex,
      selectedJob: store.state.incomeAndExpensesPageState.selectedJob,
      unsavedTipAmount: store.state.incomeAndExpensesPageState.unsavedTipAmount,
      onJobSearchTextChanged: (searchText) => store.dispatch(JobSearchTextChangedAction(store.state.incomeAndExpensesPageState, searchText)),
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.incomeAndExpensesPageState, filterType)),
      onYearChanged: (year) => store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, year)),
      onViewAllHideSelected: () => store.dispatch(UpdateShowHideState(store.state.incomeAndExpensesPageState)),
      onEditInvoiceSelected: (invoice) => store.dispatch(InvoiceEditSelected(store.state.incomeAndExpensesPageState, invoice)),
      onDeleteSelected: (invoice) => store.dispatch(DeleteInvoiceAction(store.state.incomeAndExpensesPageState, invoice)),
      onInvoiceSent: (invoice) => store.dispatch(OnInvoiceSentAction(store.state.incomeAndExpensesPageState, invoice)),
      onAllInvoicesFilterChanged: (filter) => store.dispatch(OnAllInvoicesFilterChangedAction(store.state.incomeAndExpensesPageState, filter)),
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
    );
  }

  @override
  int get hashCode =>
      filterType.hashCode ^
      filteredJobs.hashCode ^
      allClients.hashCode ^
      isFinishedFetchingClients.hashCode ^
      jobSearchText.hashCode ^
      onJobSearchTextChanged.hashCode ^
      onAllInvoicesFilterChanged.hashCode ^
      selectedYear.hashCode ^
      allInvoices.hashCode ^
      totalIncome.hashCode ^
      pageViewIndex.hashCode ^
      incomeForSelectedYear.hashCode ^
      onFilterChanged.hashCode ^
      isMinimized.hashCode ^
      unpaidInvoices.hashCode ^
      selectedJob.hashCode ^
      onViewAllHideSelected.hashCode ^
      onEditInvoiceSelected.hashCode ^
      onInvoiceSent.hashCode ^
      paidInvoices.hashCode ^
      totalTips.hashCode ^
      allJobs.hashCode ^
      allInvoicesFilterType.hashCode ^
      onBackPressed.hashCode ^
      onNextPressed.hashCode ^
      onCancelPressed.hashCode ^
      onSaveTipSelected.hashCode ^
      onYearChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IncomeAndExpensesPageState &&
              filterType == other.filterType &&
              selectedYear == other.selectedYear &&
              filteredJobs == other.filteredJobs &&
              allClients == other.allClients &&
              pageViewIndex == other.pageViewIndex &&
              selectedJob == other.selectedJob &&
              isFinishedFetchingClients == other.isFinishedFetchingClients &&
              jobSearchText == other.jobSearchText &&
              onJobSearchTextChanged == other.onJobSearchTextChanged &&
              onAllInvoicesFilterChanged == other.onAllInvoicesFilterChanged &&
              allInvoices == other.allInvoices &&
              totalIncome == other.totalIncome &&
              incomeForSelectedYear == other.incomeForSelectedYear &&
              onFilterChanged == other.onFilterChanged &&
              isMinimized == other.isMinimized &&
              unpaidInvoices == other.unpaidInvoices &&
              onInvoiceSent == other.onInvoiceSent &&
              totalTips == other.totalTips &&
              allJobs == other.allJobs &&
              onEditInvoiceSelected == other.onEditInvoiceSelected &&
              onViewAllHideSelected == other.onViewAllHideSelected &&
              paidInvoices == other.paidInvoices &&
              allInvoicesFilterType == other.allInvoicesFilterType &&
              onBackPressed == other.onBackPressed &&
              onNextPressed == other.onNextPressed &&
              onCancelPressed == other.onCancelPressed &&
              onSaveTipSelected == other.onSaveTipSelected &&
              onYearChanged == other.onYearChanged;
}
