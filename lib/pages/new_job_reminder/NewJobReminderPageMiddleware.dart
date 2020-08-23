import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

class NewJobReminderPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is FetchAllRemindersAction) {
      _loadAll(store, action, next);
    }

    if(action is SaveNewJobReminderAction) {
      _saveNewJobReminder(store, action, next);
    }
  }

  void _loadAll(Store<AppState> store, action, NextDispatcher next) async {
    List<Reminder> allReminders = await ReminderDao.getAll();
    store.dispatch(SetAllRemindersAction(store.state.newJobReminderPageState, allReminders));

    (await ReminderDao.getReminderStream()).listen((snapshots) async {
      List<Reminder> remindersToUpdate = List();
      for(RecordSnapshot reminderSnapshot in snapshots) {
        remindersToUpdate.add(Reminder.fromMap(reminderSnapshot.value));
      }
      store.dispatch(SetAllRemindersAction(store.state.newJobReminderPageState, remindersToUpdate));
    });
  }

  void _saveNewJobReminder(Store<AppState> store, SaveNewJobReminderAction action, NextDispatcher next) async {
    JobReminder jobReminderToSave = JobReminder(

    );
    await JobReminderDao.insertOrUpdate(jobReminderToSave);
    store.dispatch(ClearNewJobReminderStateAction(store.state.newJobReminderPageState));
  }
}