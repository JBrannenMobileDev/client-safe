import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPage.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensesPageState {
  final String filterType;
  final int selectedYear;
  final List<Invoice> allInvoices;
  final List<Invoice> invoicesForSelectedYear;
  final List<Invoice> unpaidInvoicesForSelectedYear;
  final double totalIncome;
  final double incomeForSelectedYear;
  final bool isMinimized;
  final Function(String) onFilterChanged;
  final Function(int) onYearChanged;
  final Function() onViewAllHideSelected;
  final Function(Invoice) onEditInvoiceSelected;
  final Function(Invoice) onDeleteSelected;

  IncomeAndExpensesPageState({
    @required this.filterType,
    @required this.selectedYear,
    @required this.allInvoices,
    @required this.invoicesForSelectedYear,
    @required this.unpaidInvoicesForSelectedYear,
    @required this.totalIncome,
    @required this.incomeForSelectedYear,
    @required this.onFilterChanged,
    @required this.onYearChanged,
    @required this.isMinimized,
    @required this.onViewAllHideSelected,
    @required this.onEditInvoiceSelected,
    @required this.onDeleteSelected,
  });

  IncomeAndExpensesPageState copyWith({
    String filterType,
    int selectedYear,
    List<Invoice> allInvoices,
    List<Invoice> invoicesForSelectedYear,
    List<Invoice> unpaidInvoicesForSelectedYear,
    double totalIncome,
    double incomeForSelectedYear,
    Function(String) onFilterChanged,
    Function(int) onYearChanged,
    bool isMinimized,
    Function() onViewAllHideSelected,
    Function(Invoice) onEditInvoiceSelected,
    Function(Invoice) onDeleteSelected,
  }){
    return IncomeAndExpensesPageState(
      filterType: filterType?? this.filterType,
      selectedYear: selectedYear ?? this.selectedYear,
      allInvoices: allInvoices ?? this.allInvoices,
      invoicesForSelectedYear: invoicesForSelectedYear ?? this.invoicesForSelectedYear,
      unpaidInvoicesForSelectedYear: unpaidInvoicesForSelectedYear ?? this.unpaidInvoicesForSelectedYear,
      totalIncome: totalIncome ?? this.totalIncome,
      incomeForSelectedYear: incomeForSelectedYear ?? this.incomeForSelectedYear,
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
      onYearChanged: onYearChanged ?? this.onYearChanged,
      isMinimized: isMinimized ?? this.isMinimized,
      onViewAllHideSelected: onViewAllHideSelected ?? this.onViewAllHideSelected,
      onEditInvoiceSelected: onEditInvoiceSelected ?? this.onEditInvoiceSelected,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
    );
  }

  factory IncomeAndExpensesPageState.initial() => IncomeAndExpensesPageState(
    filterType: IncomeAndExpensesPage.FILTER_TYPE_INCOME,
    selectedYear: DateTime.now().year,
    allInvoices: List(),
    invoicesForSelectedYear: List(),
    unpaidInvoicesForSelectedYear: List(),
    totalIncome: 0,
    incomeForSelectedYear: 0,
    onFilterChanged: null,
    onYearChanged: null,
    isMinimized: true,
    onViewAllHideSelected: null,
    onEditInvoiceSelected: null,
    onDeleteSelected: null,
  );

  factory IncomeAndExpensesPageState.fromStore(Store<AppState> store) {
    return IncomeAndExpensesPageState(
      filterType: store.state.incomeAndExpensesPageState.filterType,
      selectedYear: store.state.incomeAndExpensesPageState.selectedYear,
      allInvoices: store.state.incomeAndExpensesPageState.allInvoices,
      invoicesForSelectedYear: store.state.incomeAndExpensesPageState.invoicesForSelectedYear,
      unpaidInvoicesForSelectedYear: store.state.incomeAndExpensesPageState.unpaidInvoicesForSelectedYear,
      totalIncome: store.state.incomeAndExpensesPageState.totalIncome,
      isMinimized: store.state.incomeAndExpensesPageState.isMinimized,
      incomeForSelectedYear: store.state.incomeAndExpensesPageState.incomeForSelectedYear,
      onFilterChanged: (filterType) => store.dispatch(FilterChangedAction(store.state.incomeAndExpensesPageState, filterType)),
      onYearChanged: (year) => store.dispatch(UpdateSelectedYearAction(store.state.incomeAndExpensesPageState, year)),
      onViewAllHideSelected: () => store.dispatch(UpdateShowHideState(store.state.incomeAndExpensesPageState)),
      onEditInvoiceSelected: (invoice) => store.dispatch(InvoiceEditSelected(store.state.incomeAndExpensesPageState, invoice)),
      onDeleteSelected: (invoice) => store.dispatch(DeleteInvoiceAction(store.state.incomeAndExpensesPageState, invoice)),
    );
  }

  @override
  int get hashCode =>
      filterType.hashCode ^
      selectedYear.hashCode ^
      allInvoices.hashCode ^
      invoicesForSelectedYear.hashCode ^
      unpaidInvoicesForSelectedYear.hashCode ^
      totalIncome.hashCode ^
      incomeForSelectedYear.hashCode ^
      onFilterChanged.hashCode ^
      isMinimized.hashCode ^
      onViewAllHideSelected.hashCode ^
      onEditInvoiceSelected.hashCode ^
      onYearChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is IncomeAndExpensesPageState &&
              filterType == other.filterType &&
              selectedYear == other.selectedYear &&
              allInvoices == other.allInvoices &&
              invoicesForSelectedYear == other.invoicesForSelectedYear &&
              unpaidInvoicesForSelectedYear == other.unpaidInvoicesForSelectedYear &&
              totalIncome == other.totalIncome &&
              incomeForSelectedYear == other.incomeForSelectedYear &&
              onFilterChanged == other.onFilterChanged &&
              isMinimized == other.isMinimized &&
              onEditInvoiceSelected == other.onEditInvoiceSelected &&
              onViewAllHideSelected == other.onViewAllHideSelected &&
              onYearChanged == other.onYearChanged;
}