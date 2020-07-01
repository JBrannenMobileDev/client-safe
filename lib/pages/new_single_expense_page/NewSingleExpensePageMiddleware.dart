import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:redux/redux.dart';

class NewSingleExpensePageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveSingleExpenseProfileAction){
      saveProfile(store, action, next);
    }
    if(action is DeleteSingleExpenseAction){
      _deleteSingleExpense(store, action, next);
    }
  }

  void saveProfile(Store<AppState> store, action, NextDispatcher next) async{
    Charge charge = Charge();
    charge.chargeDate = store.state.newSingleExpensePageState.expenseDate;
    charge.chargeAmount = store.state.newSingleExpensePageState.expenseCost;
    SingleExpense singleExpense = SingleExpense(
      id: store.state.newSingleExpensePageState.id,
      expenseName: store.state.newSingleExpensePageState.expenseName,
      charge: charge,
    );
    await SingleExpenseDao.insertOrUpdate(singleExpense);
    store.dispatch(ClearSingleEpenseStateAction(store.state.newSingleExpensePageState));
    store.dispatch(FetchSingleExpenses(store.state.incomeAndExpensesPageState));
  }

  void _deleteSingleExpense(Store<AppState> store, DeleteSingleExpenseAction action, NextDispatcher next) async{
    await SingleExpenseDao.delete(store.state.newSingleExpensePageState.id, store.state.newSingleExpensePageState.documentId);
    store.dispatch(FetchSingleExpenses(store.state.incomeAndExpensesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}