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

class OnInvoiceSelected{
  final IncomeAndExpensesPageState pageState;
  final int jobId;
  OnInvoiceSelected(this.pageState, this.jobId);
}

class InvoiceEditSelected{
  final IncomeAndExpensesPageState pageState;
  final Invoice invoice;
  InvoiceEditSelected(this.pageState, this.invoice);
}