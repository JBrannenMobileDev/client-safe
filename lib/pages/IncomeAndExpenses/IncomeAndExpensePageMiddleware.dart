import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/InvoiceDao.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:redux/redux.dart';

class IncomeAndExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadAllInvoicesAction){
      fetchInvoices(store, next);
    }
  }

  void fetchInvoices(Store<AppState> store, NextDispatcher next) async{
      next(LoadAllInvoicesAction(store.state.incomeAndExpensesPageState, await InvoiceDao.getAllSortedByDueDate()));
  }
}