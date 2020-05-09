import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/AllInvoicesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensesPageState {
  final String filterType;
  final String allInvoicesFilterType;
  final int selectedYear;
  final List<Invoice> allInvoices;
  final List<Invoice> paidInvoices;
  final List<Invoice> unpaidInvoices;
  final double totalIncome;
  final double incomeForSelectedYear;
  final bool isMinimized;
  final Function(String) onFilterChanged;
  final Function(String) onAllInvoicesFilterChanged;
  final Function(int) onYearChanged;
  final Function() onViewAllHideSelected;
  final Function(Invoice) onEditInvoiceSelected;
  final Function(Invoice) onDeleteSelected;
  final Function(Invoice) onInvoiceSent;

  IncomeAndExpensesPageState({
    @required this.filterType,
    @required this.selectedYear,
    @required this.allInvoices,
    @required this.totalIncome,
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
  });

  IncomeAndExpensesPageState copyWith({
    String filterType,
    String allInvoicesFilterType,
    int selectedYear,
    List<Invoice> allInvoices,
    List<Invoice> paidInvoices,
    List<Invoice> unpaidInvoices,
    double totalIncome,
    double incomeForSelectedYear,
    Function(String) onFilterChanged,
    Function(int) onYearChanged,
    bool isMinimized,
    Function() onViewAllHideSelected,
    Function(Invoice) onEditInvoiceSelected,
    Function(Invoice) onDeleteSelected,
    Function(Invoice) onInvoiceSent,
    Function(String) onAllInvoicesFilterChanged,
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
      allInvoicesFilterType: allInvoicesFilterType ?? this.allInvoicesFilterType,
      onAllInvoicesFilterChanged: onAllInvoicesFilterChanged ?? this.onAllInvoicesFilterChanged,
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
    allInvoicesFilterType: AllInvoicesPage.FILTER_TYPE_UNPAID,
    onAllInvoicesFilterChanged: null,
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
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.incomeAndExpensesPageState, filterType)),
      onYearChanged: (year) => store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, year)),
      onViewAllHideSelected: () => store.dispatch(UpdateShowHideState(store.state.incomeAndExpensesPageState)),
      onEditInvoiceSelected: (invoice) => store.dispatch(InvoiceEditSelected(store.state.incomeAndExpensesPageState, invoice)),
      onDeleteSelected: (invoice) => store.dispatch(DeleteInvoiceAction(store.state.incomeAndExpensesPageState, invoice)),
      onInvoiceSent: (invoice) => store.dispatch(OnInvoiceSentAction(store.state.incomeAndExpensesPageState, invoice)),
      onAllInvoicesFilterChanged: (filter) => store.dispatch(OnAllInvoicesFilterChangedAction(store.state.incomeAndExpensesPageState, filter)),
    );
  }

  @override
  int get hashCode =>
      filterType.hashCode ^
      onAllInvoicesFilterChanged.hashCode ^
      selectedYear.hashCode ^
      allInvoices.hashCode ^
      totalIncome.hashCode ^
      incomeForSelectedYear.hashCode ^
      onFilterChanged.hashCode ^
      isMinimized.hashCode ^
      unpaidInvoices.hashCode ^
      onViewAllHideSelected.hashCode ^
      onEditInvoiceSelected.hashCode ^
      onInvoiceSent.hashCode ^
      paidInvoices.hashCode ^
      allInvoicesFilterType.hashCode ^
      onYearChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IncomeAndExpensesPageState &&
              filterType == other.filterType &&
              selectedYear == other.selectedYear &&
              onAllInvoicesFilterChanged == other.onAllInvoicesFilterChanged &&
              allInvoices == other.allInvoices &&
              totalIncome == other.totalIncome &&
              incomeForSelectedYear == other.incomeForSelectedYear &&
              onFilterChanged == other.onFilterChanged &&
              isMinimized == other.isMinimized &&
              unpaidInvoices == other.unpaidInvoices &&
              onInvoiceSent == other.onInvoiceSent &&
              onEditInvoiceSelected == other.onEditInvoiceSelected &&
              onViewAllHideSelected == other.onViewAllHideSelected &&
              paidInvoices == other.paidInvoices &&
              allInvoicesFilterType == other.allInvoicesFilterType &&
              onYearChanged == other.onYearChanged;
}
