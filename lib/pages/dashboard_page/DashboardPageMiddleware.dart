import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../models/SingleExpense.dart';

class DashboardPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if(action is LoadJobsAction) {
      await _loadAllJobs(store, action, next);
      await _loadClients(store, action, next);
      await _loadJobReminders(store, action, next);
      await _setupDeepLinkObserver(store, action);
    }
    if(action is SetNotificationsToSeen) {
      _setNotificationsToSeen(store, action);
    }
    if(action is UpdateNotificationIconAction) {
      _loadJobReminders(store, action, next);
    }
  }

  Future<void> _setupDeepLinkObserver(Store<AppState> store, LoadJobsAction action) async {
    (await ProfileDao.getProfileStream()).listen((snapshots) async {
      List<Profile> streamProfiles = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamProfiles.add(Profile.fromMap(clientSnapshot.value));
      }
      Profile profile = streamProfiles.elementAt(0);
      if(profile.showNewMileageExpensePage ?? false) {
        await store.dispatch(SetShowNewMileageExpensePageAction(store.state.dashboardPageState, true));
        profile.showNewMileageExpensePage = false;
        await ProfileDao.update(profile);
        await store.dispatch(SetShowNewMileageExpensePageAction(store.state.dashboardPageState, false));
      }
    });
  }

  Future<void> _setNotificationsToSeen(Store<AppState> store, SetNotificationsToSeen action) async {
    List<JobReminder> reminders = action.pageState.reminders;
    if(reminders != null && reminders.isNotEmpty) {
      for(JobReminder reminder in reminders) {
        reminder.hasBeenSeen = true;
        await JobReminderDao.update(reminder);
      }
    }
  }

  Future<void> _loadJobReminders(Store<AppState> store, action, NextDispatcher next) async {
    List<JobReminder> reminders = await JobReminderDao.getTriggeredReminders();
    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen) {
        unseenCount++;
      }
    }
    store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));

    (await JobReminderDao.getReminderStream()).listen((snapshots) async {
      List<JobReminder> streamReminders = [];
      for(RecordSnapshot clientSnapshot in snapshots) {
        streamReminders.add(JobReminder.fromMap(clientSnapshot.value));
      }
      int unseenCount = 0;
      for(JobReminder reminder in reminders) {
        if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen) {
          unseenCount++;
        }
      }
      store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));
    });


    List<JobReminder> pendingReminders = await JobReminderDao.getPendingJobReminders();
    for(JobReminder reminder in pendingReminders) {
      DateTime now = DateTime.now();
      DateTime triggerTime = reminder.triggerTime;
      int diff = (now.millisecondsSinceEpoch - triggerTime.millisecondsSinceEpoch).abs();

      Timer(Duration(milliseconds: diff), () {
        _loadJobReminders(store, action, next);
      });
    }
  }

  Future<void> _loadAllJobs(Store<AppState> store, action, NextDispatcher next) async {
    List<Job> allJobs = await JobDao.getAllJobs();
    List<SingleExpense> singleExpenses = await SingleExpenseDao.getAll();
    List<MileageExpense> mileageExpenses = await MileageExpenseDao.getAll();
    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();

    store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
    store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, singleExpenses, recurringExpenses, mileageExpenses));

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobsDataAction(store.state.jobsPageState, jobs));
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, jobs, singleExpenses, recurringExpenses, mileageExpenses));
    });

    (await SingleExpenseDao.getSingleExpenseStream()).listen((singleSnapshots) async {
      List<SingleExpense> expenses = [];
      for(RecordSnapshot clientSnapshot in singleSnapshots) {
        expenses.add(SingleExpense.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, expenses, recurringExpenses, mileageExpenses));
    });

    (await RecurringExpenseDao.getRecurringExpenseStream()).listen((singleSnapshots) async {
      List<RecurringExpense> expenses = [];
      for(RecordSnapshot clientSnapshot in singleSnapshots) {
        expenses.add(RecurringExpense.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, singleExpenses, expenses, mileageExpenses));
    });

    (await MileageExpenseDao.getMileageExpenseStream()).listen((singleSnapshots) async {
      List<MileageExpense> expenses = [];
      for(RecordSnapshot clientSnapshot in singleSnapshots) {
        expenses.add(MileageExpense.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, singleExpenses, recurringExpenses, expenses));
    });
  }

  Future<void> _loadClients(Store<AppState> store, action, NextDispatcher next) async {
    List<Client> clients = await ClientDao.getAll();
    store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));

    (await ClientDao.getClientsStream()).listen((clientSnapshots) {
      List<Client> clients = List();
      for(RecordSnapshot clientSnapshot in clientSnapshots) {
        clients.add(Client.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));
    });
  }
}