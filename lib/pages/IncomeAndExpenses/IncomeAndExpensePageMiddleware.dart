import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:client_safe/data_layer/local_db/daos/JobDao.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadAllInvoicesAction){
      fetchInvoices(store, next);
    }
    if(action is OnInvoiceSelected){
      launchInvoiceView(store, action, next);
    }
    if(action is InvoiceEditSelected){
      onEditInvoice(store, action, next);
    }
  }

  void launchInvoiceView(Store<AppState> store, OnInvoiceSelected action, NextDispatcher next) async {
    Job job = await JobDao.getJobById(action.jobId);
    store.dispatch(SetShouldClearAction(store.state.newInvoicePageState, false));
    store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, job));
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