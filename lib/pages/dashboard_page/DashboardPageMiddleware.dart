import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/AppSettingsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/AppSettings.dart';
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
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:version/version.dart';

import '../../data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import '../../models/Pose.dart';
import '../../models/SingleExpense.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../new_reminder_page/WhenSelectionWidget.dart';

class DashboardPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if(action is LoadJobsAction) {
      await _loadAllJobs(store);
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
    if(action is CheckForReviewRequestAction) {
      _checkForReviewRequest(store, action, next);
    }
    if(action is CheckForPMFSurveyAction) {
      _checkForPMFSurvey(store, action, next);
    }
    if(action is UpdateCanShowPMFSurveyAction) {
      _updateCanShowPMF(store, action, next);
    }
    if(action is UpdateCanShowRequestReviewAction) {
      _updateCanShowReviewRequest(store, action, next);
    }
    if(action is LaunchDrivingDirectionsAction) {
      _launchDrivingDirections(store, action);
    }
    if(action is SetUnseenFeaturedPosesAsSeenAction) {
      _setUnseenFeaturedPosesToSeen(store, action);
    }
    if(action is CheckForAppUpdateAction) {
      _checkForUpdate(store, action);
    }
    if(action is SetUpdateSeenTimestampAction) {
      _setUpdateLastSeenTime(store, action);
    }
  }

  Future<void> _setUpdateLastSeenTime(Store<AppState> store, SetUpdateSeenTimestampAction action) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.updateLastSeenDate = action.lastSeenDate;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
    store.dispatch(SetShouldShowUpdateAction(store.state.dashboardPageState, false, (await AppSettingsDao.getAll())?.first));
  }

  Future<void> _updateCanShowPMF(Store<AppState> store, UpdateCanShowPMFSurveyAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.canShowPMFSurvey = action.canShow;
    profile.requestPMFSurveyDate = action.lastSeenDate;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));

  }

  Future<void> _updateCanShowReviewRequest(Store<AppState> store, UpdateCanShowRequestReviewAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.canShowAppReview = action.canShow;
    profile.requestReviewDate = action.lastSeenDate;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));

  }

  void _checkForUpdate(Store<AppState> store, CheckForAppUpdateAction action) async {
    List<AppSettings> settingsList = (await AppSettingsDao.getAll());
    AppSettings settings = settingsList != null && settingsList.length > 0 ? settingsList.first : null;
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(settings != null) {
      if(settings.show) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        Version currentVersion = Version.parse(packageInfo.version);
        Version latestVersion = Version.parse(settings.currentBuildVersionNumber);

        if (latestVersion > currentVersion && (profile.updateLastSeenDate == null || (profile.updateLastSeenDate != null && hasBeenLongEnoughSinceLastRequest(profile.updateLastSeenDate, 1)))) {
          store.dispatch(SetShouldShowUpdateAction(store.state.dashboardPageState, true, settings));
        } else {
          store.dispatch(SetShouldShowUpdateAction(store.state.dashboardPageState, false, settings));
        }
      }
    } else {
      store.dispatch(SetShouldShowUpdateAction(store.state.dashboardPageState, false, settings));
    }
  }

  void _launchDrivingDirections(Store<AppState> store, LaunchDrivingDirectionsAction action) async {
    IntentLauncherUtil.launchDrivingDirections(
        action.location.latitude.toString(),
        action.location.longitude.toString());
  }

  Future<void> _checkForReviewRequest(Store<AppState> store, CheckForReviewRequestAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile.isSubscribed && profile.jobsCreatedCount > 5 && profile.canShowAppReview && hasBeenLongEnoughSinceLastRequest(profile.requestReviewDate, 7)) {
      next(SetShouldAppReview(store.state.dashboardPageState, true));
    } else {
      next(SetShouldAppReview(store.state.dashboardPageState, false));
    }
  }

  Future<void> _checkForPMFSurvey(Store<AppState> store, CheckForPMFSurveyAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile.isSubscribed && profile.jobsCreatedCount > 12 && profile.canShowPMFSurvey && hasBeenLongEnoughSinceLastRequest(profile.requestPMFSurveyDate, 7)) {
      next(SetShouldShowPMF(store.state.dashboardPageState, true));
    } else {
      next(SetShouldShowPMF(store.state.dashboardPageState, false));
    }
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
    List<Pose> myPoses = (await PoseSubmittedGroupDao.getByUid(UidUtil().getUid()))?.poses;
    if(myPoses != null) {
      return myPoses.where((pose) => pose.isUnseenFeaturedPose()).toList();
    } else {
      return [];
    }
  }

  Future<void> _updateProfileWithShowcaseSeen(Store<AppState> store, UpdateProfileWithShowcaseSeen action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.hasSeenShowcase = true;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
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

  Future<void> _loadAllJobs(Store<AppState> store) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));

    List<Job> allJobs = await JobDao.getAllJobs();
    await allJobs.forEach((job) async {
      job.paymentReceivedDate = job.createdDate;
      await JobDao.update(job);
    });
    allJobs = await JobDao.getAllJobs();

    List<JobType> allJobTypes = await JobTypeDao.getAll();
    List<SingleExpense> singleExpenses = await SingleExpenseDao.getAll();
    List<MileageExpense> mileageExpenses = await MileageExpenseDao.getAll();
    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();


    store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
    store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, singleExpenses, recurringExpenses, mileageExpenses));
    store.dispatch(SetJobTypeChartData(store.state.dashboardPageState, allJobs, allJobTypes));

    (await ProfileDao.getProfileStream()).listen((profilesSnapshots) async {
      List<Profile> profiles = [];
      for(RecordSnapshot record in profilesSnapshots) {
        profiles.add(Profile.fromMap(record.value));
      }

      Profile newProfile = null;
      String uid = UidUtil().getUid();
      for(Profile profile in profiles) {
        if(profile.uid == uid) {
          newProfile = profile;
        }
      }

      if(newProfile != null) {
        if(profile.logoUrl != newProfile.logoUrl) {
          store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, newProfile));
        }
      }
    });

    await purchases.Purchases.logIn(store.state.dashboardPageState.profile.uid);

    (await JobTypeDao.getJobTypeStream()).listen((jobSnapshots) async {
      List<JobType> jobTypes = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        jobTypes.add(JobType.fromMap(clientSnapshot.value));
      }
      allJobs = await JobDao.getAllJobs();
      store.dispatch(SetJobsDataAction(store.state.jobsPageState, allJobs));
      store.dispatch(SetJobTypeChartData(store.state.dashboardPageState, allJobs, allJobTypes));
    });

    (await SingleExpenseDao.getSingleExpenseStream()).listen((singleSnapshots) async {
      List<SingleExpense> expenses = [];
      for(RecordSnapshot clientSnapshot in singleSnapshots) {
        expenses.add(SingleExpense.fromMap(clientSnapshot.value));
      }
      allJobs = await JobDao.getAllJobs();
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, expenses, recurringExpenses, mileageExpenses));
    });

    (await RecurringExpenseDao.getRecurringExpenseStream()).listen((singleSnapshots) async {
      List<RecurringExpense> expenses = [];
      for(RecordSnapshot clientSnapshot in singleSnapshots) {
        expenses.add(RecurringExpense.fromMap(clientSnapshot.value));
      }
      allJobs = await JobDao.getAllJobs();
      store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, singleExpenses, expenses, mileageExpenses));
    });

    (await MileageExpenseDao.getMileageExpenseStream()).listen((singleSnapshots) async {
      List<MileageExpense> expenses = [];
      for(RecordSnapshot clientSnapshot in singleSnapshots) {
        expenses.add(MileageExpense.fromMap(clientSnapshot.value));
      }
      allJobs = await JobDao.getAllJobs();
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

  bool hasBeenLongEnoughSinceLastRequest(DateTime lastRequestDate, int minTimeDays) {
    final DateTime now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: minTimeDays));
    return lastRequestDate.isBefore(oneWeekAgo);
  }
}