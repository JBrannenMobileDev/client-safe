import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Charge.dart';
import 'package:dandylight/models/SingleExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../models/Profile.dart';
import '../../utils/UidUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../dashboard_page/DashboardPageActions.dart';

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
    charge.chargeDate = store.state.newSingleExpensePageState!.expenseDate;
    charge.chargeAmount = store.state.newSingleExpensePageState!.expenseCost;
    SingleExpense singleExpense = SingleExpense(
      id: store.state.newSingleExpensePageState!.id,
      documentId: store.state.newSingleExpensePageState!.documentId,
      expenseName: store.state.newSingleExpensePageState!.expenseName,
      charge: charge,
    );
    await SingleExpenseDao.insertOrUpdate(singleExpense);

    EventSender().sendEvent(eventName: EventNames.CREATED_SINGLE_EXPENSE, properties: {
      EventNames.SINGLE_EXPENSE_PARAM_NAME : singleExpense.expenseName!,
      EventNames.SINGLE_EXPENSE_PARAM_COST : singleExpense.charge!.chargeAmount!,
    });

    store.dispatch(ClearSingleEpenseStateAction(store.state.newSingleExpensePageState));
    store.dispatch(FetchSingleExpenses(store.state.incomeAndExpensesPageState));

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null && !profile.progress.createSingleExpense) {
      profile.progress.createSingleExpense = true;
      await ProfileDao.update(profile);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
    }
  }

  void _deleteSingleExpense(Store<AppState> store, DeleteSingleExpenseAction action, NextDispatcher next) async{
    await SingleExpenseDao.delete(store.state.newSingleExpensePageState!.documentId!);
    SingleExpense? expense = await SingleExpenseDao.getSingleExpenseById(action.pageState!.documentId!);
    if(expense != null) {
      await SingleExpenseDao.delete(action.pageState!.documentId!);
    }
    store.dispatch(FetchSingleExpenses(store.state.incomeAndExpensesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState!.pop();
  }
}