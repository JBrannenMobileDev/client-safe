import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/reminders_page/RemindersActions.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

class RemindersPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchRemindersAction){
      fetchReminders(store, next);
    }
    if(action is DeleteReminderAction){
      _deleteReminders(store, action, next);
    }
  }

  void fetchReminders(Store<AppState> store, NextDispatcher next) async{
      List<Reminder> reminders = await ReminderDao.getAll();
      next(SetRemindersAction(store.state.remindersPageState, reminders));

      (await ReminderDao.getReminderStream()).listen((snapshots) async {
        List<Reminder> remindersToUpdate = List();
        for(RecordSnapshot reminderSnapshot in snapshots) {
          remindersToUpdate.add(Reminder.fromMap(reminderSnapshot.value));
        }
        store.dispatch(SetRemindersAction(store.state.remindersPageState, remindersToUpdate));
      });
  }

  void _deleteReminders(Store<AppState> store, DeleteReminderAction action, NextDispatcher next) async{
    await ReminderDao.delete(action.reminder.documentId);
    store.dispatch(FetchRemindersAction(store.state.remindersPageState));
    GlobalKeyUtil.instance.navigatorKey.currentState.pop();
  }
}