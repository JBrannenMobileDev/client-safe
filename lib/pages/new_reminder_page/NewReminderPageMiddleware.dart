import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

class NewReminderPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is SaveNewReminderAction){
      saveReminder(store, action, next);
    }
    if(action is DeleteReminderAction){
      _deleteReminder(store, action, next);
    }
  }

  void saveReminder(Store<AppState> store, SaveNewReminderAction action, NextDispatcher next) async{
    Reminder reminder = Reminder(
      id: store.state.newReminderPageState.id,
      documentId: store.state.newReminderPageState.documentId,
      description: store.state.newReminderPageState.reminderDescription,
      daysWeeksMonths: store.state.newReminderPageState.daysWeeksMonths,
      when: store.state.newReminderPageState.when,
      amount: store.state.newReminderPageState.daysWeeksMonthsAmount,
    );
    await ReminderDao.insertOrUpdate(reminder);
    store.dispatch(ClearNewReminderStateAction(store.state.newReminderPageState));
    //TODO fetch reminders for the RemindersCollectionPage
  }

  void _deleteReminder(Store<AppState> store, DeleteReminderAction action, NextDispatcher next) async{
    await ReminderDao.delete(store.state.newReminderPageState.documentId);
    //TODO fetch reminders for the RemindersCollectionPage
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}