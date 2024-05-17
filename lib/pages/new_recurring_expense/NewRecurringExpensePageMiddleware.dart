import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../models/Profile.dart';
import '../../models/Progress.dart';
import '../../utils/UidUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../dashboard_page/DashboardPageActions.dart';

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
      id: store.state.newRecurringExpensePageState!.id,
      documentId: store.state.newRecurringExpensePageState!.documentId,
      expenseName: store.state.newRecurringExpensePageState!.expenseName,
      cost: store.state.newRecurringExpensePageState!.expenseCost,
      initialChargeDate: store.state.newRecurringExpensePageState!.expenseDate,
      billingPeriod: store.state.newRecurringExpensePageState!.billingPeriod,
      isAutoPay: store.state.newRecurringExpensePageState!.isAutoPay,
      charges: [],
    );
    recurringExpense.updateChargeList();
    await RecurringExpenseDao.insertOrUpdate(recurringExpense);

    EventSender().sendEvent(eventName: EventNames.CREATED_RECURRING_EXPENSE, properties: {
      EventNames.RECURRING_EXPENSE_PARAM_NAME : recurringExpense.expenseName!,
      EventNames.RECURRING_EXPENSE_PARAM_COST : recurringExpense.cost!,
    });

    store.dispatch(ClearRecurringExpenseStateAction(store.state.newRecurringExpensePageState));
    store.dispatch(FetchRecurringExpenses(store.state.incomeAndExpensesPageState));

    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null && !profile.progress.createRecurringExpense) {
      profile.progress.createRecurringExpense = true;
      await ProfileDao.update(profile);
      store.dispatch(LoadJobsAction(store.state.dashboardPageState));
      EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
        EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.CREATE_RECURRING_EXPENSE,
      });
    }
  }

  void _deleteSingleExpense(Store<AppState> store, DeleteRecurringExpenseAction action, NextDispatcher next) async{
    await RecurringExpenseDao.delete(store.state.newRecurringExpensePageState!.documentId!);
    RecurringExpense? expense = await RecurringExpenseDao.getRecurringExpenseById(action.pageState!.documentId!);
    if(expense != null) {
      await RecurringExpenseDao.delete(action.pageState!.documentId!);
    }
    store.dispatch(FetchRecurringExpenses(store.state.incomeAndExpensesPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState!.pop();
  }
}