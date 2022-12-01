import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:dandylight/pages/reminders_page/RemindersActions.dart' as collectionReminders;
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../new_job_types_page/NewJobTypeActions.dart';

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
    ReminderDandyLight reminder = ReminderDandyLight(
      id: store.state.newReminderPageState.id,
      documentId: store.state.newReminderPageState.documentId,
      description: store.state.newReminderPageState.reminderDescription,
      daysWeeksMonths: store.state.newReminderPageState.daysWeeksMonths,
      when: store.state.newReminderPageState.when,
      amount: store.state.newReminderPageState.daysWeeksMonthsAmount,
      time: store.state.newReminderPageState.selectedTime,
    );
    await ReminderDao.insertOrUpdate(reminder);

    EventSender().sendEvent(eventName: EventNames.CREATED_REMINDER, properties: {
      EventNames.REMINDER_PARAM_NAME : reminder.description,
      EventNames.REMINDER_PARAM_BEFORE_ON_AFTER : reminder.when,
      EventNames.REMINDER_PARAM_DAYS_WEEKS_MONTHS : reminder.daysWeeksMonths,
      EventNames.REMINDER_PARAM_DAYS_WEEKS_MONTHS_AMOUNT : reminder.amount,
    });

    store.dispatch(ClearNewReminderStateAction(store.state.newReminderPageState));
    store.dispatch(collectionReminders.FetchRemindersAction(store.state.remindersPageState));
    store.dispatch(LoadPricesPackagesAndRemindersAction(store.state.newJobTypePageState));
  }

  void _deleteReminder(Store<AppState> store, DeleteReminderAction action, NextDispatcher next) async{
    await ReminderDao.delete(store.state.newReminderPageState.documentId);
    ReminderDandyLight reminder = await ReminderDao.getReminderById(action.pageState.documentId);
    if(reminder != null) {
      await ReminderDao.delete(action.pageState.documentId);
    }
    store.dispatch(collectionReminders.FetchRemindersAction(store.state.remindersPageState));
  }
}