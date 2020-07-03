import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
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
      documentId: store.state.newRecurringExpensePageState.documentId,
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

  void _deleteSingleExpense(Store<AppState> store, DeleteRecurringExpenseAction action, NextDispatcher next) async{
    await RecurringExpenseDao.delete(store.state.newRecurringExpensePageState.id, store.state.newRecurringExpensePageState.documentId);
    store.dispatch(FetchRecurringExpenses(store.state.incomeAndExpensesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}