import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Reminder.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPage.dart';
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
      id: store.state.newJobReminderPageState.id,
      documentId: store.state.newJobReminderPageState.documentId,
      jobDocumentId: action.job.documentId,
      reminder: store.state.newJobReminderPageState.selectedReminder,
      exactDateAndTime: _generateExactDateAndTime(store.state.newJobReminderPageState, action.job),
    );
    await JobReminderDao.insertOrUpdate(jobReminderToSave);
    store.dispatch(ClearNewJobReminderStateAction(store.state.newJobReminderPageState));
  }

  DateTime _generateExactDateAndTime(NewJobReminderPageState pageState, Job job) {
    DateTime exactDateAndTime = job.selectedDate;
    int resultMilliseconds = exactDateAndTime.millisecondsSinceEpoch;
    switch(pageState.selectedReminder.when){
      case NewReminderPage.BEFORE:
        resultMilliseconds = resultMilliseconds - getMillisecondsOffset(pageState);
        break;
      case NewReminderPage.ON:
        //do nothing
        break;
      case NewReminderPage.AFTER:
        resultMilliseconds = resultMilliseconds + getMillisecondsOffset(pageState);
        break;
    }
    return DateTime.fromMillisecondsSinceEpoch(resultMilliseconds);
  }

  int getMillisecondsOffset(NewJobReminderPageState pageState) {
    int offset = 0;
    switch(pageState.selectedReminder.daysWeeksMonths) {
      case NewReminderPage.DAYS:
        offset = Duration.millisecondsPerDay * pageState.selectedReminder.amount;
        break;
      case NewReminderPage.WEEKS:
        offset = Duration.millisecondsPerDay * 7 * pageState.selectedReminder.amount;
        break;
      case NewReminderPage.MONTHS:
        offset = Duration.millisecondsPerDay * 30 * pageState.selectedReminder.amount;
        break;
    }
    return offset;
  }
}