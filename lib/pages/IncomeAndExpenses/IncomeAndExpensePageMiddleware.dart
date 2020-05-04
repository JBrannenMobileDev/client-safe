import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadAllInvoicesAction){
      fetchInvoices(store, next);
    }
    if(action is InvoiceEditSelected){
      onEditInvoice(store, action, next);
    }
    if(action is DeleteInvoiceAction){
      deleteInvoice(store, action, next);
    }
  }

  void deleteInvoice(Store<AppState> store, DeleteInvoiceAction action, NextDispatcher next) async {
    await InvoiceDao.deleteByInvoice(action.invoice);
    store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
    store.dispatch(LoadJobsAction(store.state.dashboardPageState));
  }

  void fetchInvoices(Store<AppState> store, NextDispatcher next) async{
      store.dispatch(SetAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
  }

  void onEditInvoice(Store<AppState> store, InvoiceEditSelected action, NextDispatcher next) async {
    Job job = await JobDao.getJobById(action.invoice.jobId);
    store.dispatch(SetShouldClearAction(store.state.newInvoicePageState, false));
    store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, job));
  }
}