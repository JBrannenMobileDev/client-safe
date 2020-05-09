import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
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
  LoadAllInvoicesAction(this.pageState);
}

class SetAllInvoicesAction{
  final IncomeAndExpensesPageState pageState;
  final List<Invoice> allInvoices;
  SetAllInvoicesAction(this.pageState, this.allInvoices);
}

class UpdateShowHideState{
  final IncomeAndExpensesPageState pageState;
  UpdateShowHideState(this.pageState);
}

class InvoiceEditSelected{
  final IncomeAndExpensesPageState pageState;
  final Invoice invoice;
  InvoiceEditSelected(this.pageState, this.invoice);
}

class DeleteInvoiceAction{
  final IncomeAndExpensesPageState pageState;
  final Invoice invoice;
  DeleteInvoiceAction(this.pageState, this.invoice);
}

class OnInvoiceSentAction{
  final IncomeAndExpensesPageState pageState;
  final Invoice invoice;
  OnInvoiceSentAction(this.pageState, this.invoice);
}

class OnAllInvoicesFilterChangedAction{
  final IncomeAndExpensesPageState pageState;
  final String filter;
  OnAllInvoicesFilterChangedAction(this.pageState, this.filter);
}