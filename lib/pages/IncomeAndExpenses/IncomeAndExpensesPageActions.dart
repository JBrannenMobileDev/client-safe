import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';

class FilterChangedAction{
  final IncomeAndExpensesPageState pageState;
  final String filterType;
  FilterChangedAction(this.pageState, this.filterType);
}

class UpdateSelectedYearAction{
  final IncomeAndExpensesPageState pageState;
  final int year;
  UpdateSelectedYearAction(this.pageState, this.year);
}

class LoadAllInvoicesAction{
  final IncomeAndExpensesPageState pageState;
  final List<Invoice> allInvoices;
  LoadAllInvoicesAction(this.pageState, this.allInvoices);
}