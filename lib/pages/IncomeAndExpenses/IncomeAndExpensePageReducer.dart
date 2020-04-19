import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:redux/redux.dart';

final incomeAndExpensesPageReducer = combineReducers<IncomeAndExpensesPageState>([
  TypedReducer<IncomeAndExpensesPageState, LoadAllInvoicesAction>(_setInvoices),
  TypedReducer<IncomeAndExpensesPageState, FilterChangedAction>(_updateFilterSelection),
  TypedReducer<IncomeAndExpensesPageState, UpdateSelectedYearAction>(_setSelectedYear),
]);

IncomeAndExpensesPageState _setInvoices(IncomeAndExpensesPageState previousState, LoadAllInvoicesAction action){
  List<Invoice> unpaidInvoices = action.allInvoices.where((invoice) => (!invoice.totalPaid && invoice.sentDate.year == previousState.selectedYear)).toList();
  List<Invoice> invoicesForSelectedYear = action.allInvoices.where((invoice) => invoice.sentDate.year == previousState.selectedYear).toList();
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