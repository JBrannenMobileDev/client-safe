import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPage.dart';
import 'package:dandylight/pages/new_reminder_page/WhenSelectionWidget.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../job_details_page/JobDetailsActions.dart';

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
    List<ReminderDandyLight> allReminders = await ReminderDao.getAll();
    store.dispatch(SetAllRemindersAction(store.state.newJobReminderPageState, _getFilteredReminders(allReminders, store), allReminders.length));

    (await ReminderDao.getReminderStream()).listen((snapshots) async {
      List<ReminderDandyLight> remindersToUpdate = [];
      for(RecordSnapshot reminderSnapshot in snapshots) {
        remindersToUpdate.add(ReminderDandyLight.fromMap(reminderSnapshot.value));
      }
      store.dispatch(SetAllRemindersAction(store.state.newJobReminderPageState, _getFilteredReminders(remindersToUpdate, store), remindersToUpdate.length));
    });
  }

  List<ReminderDandyLight> _getFilteredReminders(List<ReminderDandyLight> reminders, Store<AppState> store) {
    List<ReminderDandyLight> filteredReminders = [];
    List<JobReminder> jobReminders = store.state.jobDetailsPageState.reminders;
    for(ReminderDandyLight reminder in reminders) {
      bool alreadyAdded = false;
      for(JobReminder jobReminder in jobReminders) {
        if(reminder.description == jobReminder.reminder.description) {
          alreadyAdded = true;
        }
      }
      if(!alreadyAdded) {
        filteredReminders.add(reminder);
      }
    }
    return filteredReminders;
  }

  void _saveNewJobReminder(Store<AppState> store, SaveNewJobReminderAction action, NextDispatcher next) async {
    JobReminder jobReminderToSave = JobReminder(
      id: store.state.newJobReminderPageState.id,
      documentId: store.state.newJobReminderPageState.documentId,
      jobDocumentId: action.job.documentId,
      reminder: store.state.newJobReminderPageState.selectedReminder,
      hasBeenSeen: false,
      payload: action.job.documentId,
    );
    await JobReminderDao.insertOrUpdate(jobReminderToSave);
    store.dispatch(FetchJobRemindersAction(store.state.jobDetailsPageState));
  }
}