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
  List<Invoice> unpaidInvoices = previousState.allInvoices.where((invoice) => invoice.invoicePaid == false).toList();

  return previousState.copyWith(
    isMinimized: !previousState.isMinimized,
    unpaidInvoices: unpaidInvoices,
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
  return previousState.copyWith(
    allInvoices: action.allInvoices,
    isMinimized: true,
    incomeForSelectedYear: totalForSelectedYear,
    unpaidInvoices: unpaidInvoices,
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
  return previousState.copyWith(
    selectedYear: action.year,
    incomeForSelectedYear: totalForSelectedYear,
    unpaidInvoices: unpaidInvoices,
  );
}