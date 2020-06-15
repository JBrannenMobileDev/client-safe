import 'package:client_safe/AppState.dart';
import 'package:client_safe/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:client_safe/models/RecurringExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:client_safe/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:client_safe/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

class NewRecurringExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveRecurringExpenseProfileAction){
      saveRecurringExpense(store, action, next);
    }
    if(action is DeleteRecurringExpenseAction){
      _deleteSingleExpense(store, action, next);
    }
  }

  void saveRecurringExpense(Store<AppState> store, action, NextDispatcher next) async{
    RecurringExpense recurringExpense = RecurringExpense(
      id: store.state.newRecurringExpensePageState.id,
      expenseName: store.state.newRecurringExpensePageState.expenseName,
      cost: store.state.newRecurringExpensePageState.expenseCost,
      initialChargeDate: store.state.newRecurringExpensePageState.expenseDate,
      billingPeriod: store.state.newRecurringExpensePageState.billingPeriod,
      isAutoPay: store.state.newRecurringExpensePageState.isAutoPay,
      charges: List(),
    );
    recurringExpense.updateChargeList();
    await RecurringExpenseDao.insertOrUpdate(recurringExpense);
    store.dispatch(ClearRecurringExpenseStateAction(store.state.newRecurringExpensePageState));
    store.dispatch(FetchRecurringExpenses(store.state.incomeAndExpensesPageState));
  }

  void _deleteSingleExpense(Store<AppState> store, action, NextDispatcher next) async{
    await RecurringExpenseDao.delete(store.state.newRecurringExpensePageState.id);
    store.dispatch(FetchRecurringExpenses(store.state.incomeAndExpensesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}