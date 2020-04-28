import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:redux/redux.dart';

final incomeAndExpensesPageReducer = combineReducers<IncomeAndExpensesPageState>([
  TypedReducer<IncomeAndExpensesPageState, SetAllInvoicesAction>(_setInvoices),
  TypedReducer<IncomeAndExpensesPageState, FilterChangedAction>(_updateFilterSelection),
  TypedReducer<IncomeAndExpensesPageState, UpdateSelectedYearAction>(_setSelectedYear),
  TypedReducer<IncomeAndExpensesPageState, UpdateShowHideState>(_updateShowHideState),
]);

IncomeAndExpensesPageState _updateShowHideState(IncomeAndExpensesPageState previousState, UpdateShowHideState action) {
  List<Invoice> unpaidInvoices;
  if(previousState.isMinimized){
    unpaidInvoices = previousState.allInvoices.where((invoice) => (!invoice.invoicePaid && invoice.createdDate.year == previousState.selectedYear)).toList();
  }else{
    unpaidInvoices = (previousState.allInvoices.length > 3? previousState.allInvoices.sublist(0, 3) : previousState.allInvoices);
  }

  return previousState.copyWith(
    isMinimized: !previousState.isMinimized,
    unpaidInvoicesForSelectedYear: unpaidInvoices,
  );
}

IncomeAndExpensesPageState _setInvoices(IncomeAndExpensesPageState previousState, SetAllInvoicesAction action){
  List<Invoice> unpaidInvoices = action.allInvoices.where((invoice) => (!invoice.invoicePaid && invoice.createdDate.year == previousState.selectedYear)).toList();
  List<Invoice> invoicesForSelectedYear = action.allInvoices.where((invoice) => invoice.createdDate.year == previousState.selectedYear).toList();
  return previousState.copyWith(
    allInvoices: action.allInvoices,
    unpaidInvoicesForSelectedYear: unpaidInvoices,
    invoicesForSelectedYear: invoicesForSelectedYear,
  );
}

IncomeAndExpensesPageState _updateFilterSelection(IncomeAndExpensesPageState previousState, FilterChangedAction action){
  return previousState.copyWith(
    filterType: action.filterType,
  );
}

IncomeAndExpensesPageState _setSelectedYear(IncomeAndExpensesPageState previousState, UpdateSelectedYearAction action){
  return previousState.copyWith(
    selectedYear: action.year,
  );
}