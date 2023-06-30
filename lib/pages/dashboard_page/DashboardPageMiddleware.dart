import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/JobType.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/PoseSubmittedGroup.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import '../../models/Pose.dart';
import '../../models/SingleExpense.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../new_reminder_page/WhenSelectionWidget.dart';

class DashboardPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if(action is LoadJobsAction) {
      await _loadAllJobs(store, action, next);
      await _loadClients(store, action, next);
      await _loadJobReminders(store, action, next);
      await _fetchSubscriptionState(store, next);
    }
    if(action is SetNotificationToSeen) {
      _setNotificationToSeen(store, action);
    }
    if(action is UpdateNotificationIconAction) {
      _loadJobReminders(store, action, next);
    }
    if(action is UpdateProfileWithShowcaseSeen) {
      _updateProfileWithShowcaseSeen(store, action, next);
    }
    if(action is UpdateProfileRestorePurchasesSeen) {
      _updateProfileWithSeenRestorePurchases(store, action);
    }
    if(action is MarkAllAsSeenAction) {
      _markAllAsSeen(store, action);
    }
    if(action is CheckForGoToJobAction) {
      _checkForGoToJob(store, action);
    }
    if(action is LaunchDrivingDirectionsAction) {
      _launchDrivingDirections(store, action);
    }
    if(action is SetUnseenFeaturedPosesAsSeenAction) {
      _setUnseenFeaturedPosesToSeen(store, action);
    }
  }

  void _launchDrivingDirections(Store<AppState> store, LaunchDrivingDirectionsAction action) async {
    IntentLauncherUtil.launchDrivingDirections(
        action.location.latitude.toString(),
        action.location.longitude.toString());
  }

  Future<void> _checkForGoToJob(Store<AppState> store, CheckForGoToJobAction action) async {
    List<Job> allJobs = await JobDao.getAllJobs();
    DateTime now = DateTime.now();
    for(Job job in allJobs) {
      if(job.selectedTime != null && job.selectedEndTime != null) {
        DateTime startTime = job.selectedTime.copyWith(year: job.selectedDate.year, month: job.selectedDate.month, day: job.selectedDate.day);
        startTime.add(Duration(hours: -1));
        DateTime endTime = job.selectedEndTime.copyWith(year: job.selectedDate.year, month: job.selectedDate.month, day: job.selectedDate.day);
        if(now.isAfter(startTime) && now.isBefore(endTime)) {
          store.dispatch(SetGoToPosesJob(store.state.dashboardPageState, job));
          break;
        }
      } else if(job.selectedTime != null && job.selectedEndTime == null) {
        DateTime startTime = job.selectedTime.copyWith(year: job.selectedDate.year, month: job.selectedDate.month, day: job.selectedDate.day);
        DateTime endTime = DateTime(startTime.year, startTime.month, startTime.day, startTime.hour, startTime.minute);
        endTime.add(Duration(hours: 1));
        startTime.add(Duration(hours: -1));
        if(now.isAfter(startTime) && now.isBefore(endTime)) {
          store.dispatch(SetGoToPosesJob(store.state.dashboardPageState, job));
          break;
        }
      }
    }
  }

  Future<void> _updateProfileWithSeenRestorePurchases(Store<AppState> store, UpdateProfileRestorePurchasesSeen action) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.shouldShowRestoreSubscription = false;
    ProfileDao.update(profile);
  }

  Future<void> _fetchSubscriptionState(Store<AppState> store, NextDispatcher next) async {
    purchases.CustomerInfo subscriptionState = await _getSubscriptionState();
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if (subscriptionState.entitlements.all["standard"] != null && subscriptionState.entitlements.all["standard"].isActive) {
      profile.isSubscribed = true;
    } else {
      profile.isSubscribed = false;
    }
    ProfileDao.update(profile);

    store.dispatch(SetSubscriptionStateAction(store.state.dashboardPageState, subscriptionState));
  }

  Future<List<Pose>> _getUnseenFeaturedPoses() async {
    List<Pose> myPoses = (await PoseSubmittedGroupDao.getByUid(UidUtil().getUid())).poses;
    return myPoses.where((pose) => pose.isUnseenFeaturedPose()).toList();
  }

  Future<void> _updateProfileWithShowcaseSeen(Store<AppState> store, UpdateProfileWithShowcaseSeen action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.hasSeenShowcase = true;
    ProfileDao.update(profile);
  }

  Future<void> _setUnseenFeaturedPosesToSeen(Store<AppState> store, SetUnseenFeaturedPosesAsSeenAction action) async {
    PoseSubmittedGroup group = await PoseSubmittedGroupDao.getByUid(UidUtil().getUid());
    List<Pose> myPoses = group.poses;
    myPoses.forEach((pose) {
      if(!pose.hasSeen) {
        pose.hasSeen = true;
      }
    });
    group.poses = myPoses;
    await PoseSubmittedGroupDao.update(group);

    List<JobReminder> reminders = await JobReminderDao.getTriggeredReminders();
    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen) {
        unseenCount++;
      }
    }
    store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));
  }

  Future<void> _setNotificationToSeen(Store<AppState> store, SetNotificationToSeen action) async {
    action.reminder.hasBeenSeen = true;
    await JobReminderDao.update(action.reminder);

    List<JobReminder> reminders = await JobReminderDao.getTriggeredReminders();
    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen) {
        unseenCount++;
      }
    }
    store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));
  }

  Future<void> _markAllAsSeen(Store<AppState> store, MarkAllAsSeenAction action) async {
    List<JobReminder> reminders = await JobReminderDao.getTriggeredReminders();
    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      reminder.hasBeenSeen = true;
    }
    await JobReminderDao.updateAll(reminders);
    await JobReminderDao.updateAll(reminders);
    store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));
  }

  Future<void> _loadJobReminders(Store<AppState> store, action, NextDispatcher next) async {
    List<JobReminder> reminders = await JobReminderDao.getTriggeredReminders();
    List<Pose> unseenFeaturedPoses = await _getUnseenFeaturedPoses();
    store.dispatch(SetUnseenFeaturedPosesAction(store.state.dashboardPageState, unseenFeaturedPoses));

    if(unseenFeaturedPoses.length > 0) {
      ReminderDandyLight unseenFeaturedPosesReminder = ReminderDandyLight(description: 'Poses Featured!', when: WhenSelectionWidget.BEFORE, daysWeeksMonths: WhenSelectionWidget.DAYS, amount: 1, time: DateTime.now());
      reminders.add(JobReminder(
        reminder: unseenFeaturedPosesReminder,
        hasBeenSeen: false,
        payload: JobReminder.POSE_FEATURED_ID,
      ));
    }

    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen) {
        unseenCount++;
      }
    }
    if(unseenFeaturedPoses.length > 0) {
      unseenCount++;
    }
    store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));

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
    List<JobType> allJobTypes = await JobTypeDao.getAll();
    List<SingleExpense> singleExpenses = await SingleExpenseDao.getAll();
    List<MileageExpense> mileageExpenses = await MileageExpenseDao.getAll();
    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());

    store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
    store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, singleExpenses, recurringExpenses, mileageExpenses));
    store.dispatch(SetJobTypeChartData(store.state.dashboardPageState, allJobs, allJobTypes));
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));

    await purchases.Purchases.logIn(store.state.dashboardPageState.profile.uid);

    (await ProfileDao.getProfileStream()).listen((profilesSnapshots) async {
      List<Profile> profiles = [];
      for(RecordSnapshot record in profilesSnapshots) {
        profiles.add(Profile.fromMap(record.value));
      }

      Profile result = null;
      String uid = UidUtil().getUid();
      for(Profile profile in profiles) {
        if(profile.uid == uid) {
          result = profile;
        }
      }
      store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, result));
    });

    (await JobTypeDao.getJobTypeStream()).listen((jobSnapshots) async {
      List<JobType> jobTypes = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobTypes.add(JobType.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
      store.dispatch(SetJobTypeChartData(store.state.dashboardPageState, allJobs, allJobTypes));
    });

    (await JobDao.getJobsStream()).listen((jobSnapshots) async {
      List<Job> jobs = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobs.add(Job.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetJobsDataAction(store.state.jobsPageState, jobs));
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, jobs, singleExpenses, recurringExpenses, mileageExpenses));
      store.dispatch(SetJobTypeChartData(store.state.dashboardPageState, allJobs, allJobTypes));
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
      List<Client> clients = [];
      for(RecordSnapshot clientSnapshot in clientSnapshots) {
        clients.add(Client.fromMap(clientSnapshot.value));
      }
      store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));
    });
  }

  Future<purchases.CustomerInfo> _getSubscriptionState() async {
    purchases.CustomerInfo currentInfo = null;
    try {
      currentInfo = await purchases.Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      print(e);
    }
    return currentInfo;
  }
}