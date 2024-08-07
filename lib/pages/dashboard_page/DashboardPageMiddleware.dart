import 'dart:async';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/AppSettingsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ClientDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobReminderDao.dart';
import 'package:dandylight/data_layer/local_db/daos/JobTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/MileageExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/QuestionnairesDao.dart';
import 'package:dandylight/data_layer/local_db/daos/RecurringExpenseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SessionTypeDao.dart';
import 'package:dandylight/data_layer/local_db/daos/SingleExpenseDao.dart';
import 'package:dandylight/models/AppSettings.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Contract.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/MileageExpense.dart';
import 'package:dandylight/models/PoseSubmittedGroup.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/models/SessionType.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LineChartMonthData.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';
import 'package:version/version.dart';
import 'package:http/http.dart' as http;

import '../../data_layer/api_clients/DandylightFunctionsClient.dart';
import '../../data_layer/api_clients/GoogleApiClient.dart';
import '../../data_layer/local_db/daos/IncomeAndExpenseDao.dart';
import '../../data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import '../../data_layer/local_db/daos/PoseSubmittedGroupDao.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../data_layer/repositories/PendingEmailsRepository.dart';
import '../../models/Charge.dart';
import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
import '../../models/Progress.dart';
import '../../models/Questionnaire.dart';
import '../../models/SingleExpense.dart';
import '../../utils/JobUtil.dart';
import '../../utils/NumberConstants.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../new_reminder_page/WhenSelectionWidget.dart';
import '../poses_page/PosesActions.dart';

class DashboardPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if(action is LoadJobsAction) {
      await _checkAndCreateMileageTrips(store, action, next);
      await _loadAllJobs(store);
      await _loadClients(store, action, next);
      await _loadJobReminders(store, action, next);
      await _fetchSubscriptionState(store, next);
      await _loadAllQuestionnaires(store);
      await _loadLibraryPoseGroups(store);
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
    if(action is MarkContractsAsReviewed) {
      _updateContractsAsReviewed(store, action);
    }
    if(action is MarkQuestionnaireAsReviewed) {
      _updateQuestionnaireAsReviewed(store, action);
    }
    if(action is UpdateProgressItemCompleteAction) {
      _updateProgressItemComplete(store, action);
    }
    if(action is UpdateProgressNoShow) {
      _updateProgressNoShow(store, action);
    }
    if(action is UpdateSessionMigrationToReadAction) {
      _updateSessionMigrationToRead(store, action, next);
    }
  }

  Future<void> _updateSessionMigrationToRead(Store<AppState> store, UpdateSessionMigrationToReadAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.showSessionMigrationMessage = false;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
  }

  Future<void> _loadLibraryPoseGroups(Store<AppState> store) async {
    List<PoseLibraryGroup> groups = await PoseLibraryGroupDao.getAllSortedMostFrequent();
    for(PoseLibraryGroup group in groups) {
      group.sort();
    }
    store.dispatch(SetPoseLibraryGroupsDashboardAction(store.state.dashboardPageState, groups));
  }

  Future<void> _updateProgressNoShow(Store<AppState> store, UpdateProgressNoShow action) async {
    Profile? profile = action.pageState?.profile;
    if(profile != null) {
      profile.progress.canShow = false;
      ProfileDao.update(profile);
      store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
    }
  }

  Future<void> _updateProgressItemComplete(Store<AppState> store, UpdateProgressItemCompleteAction action) async {
    Profile? profile = action.pageState?.profile;
    switch(action.itemType) {
      case Progress.PREVIEW_CLIENT_PORTAL:
        if(!(profile?.progress.previewClientPortal ?? false)) {
          profile?.progress.previewClientPortal = true;
          EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
            EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.PREVIEW_CLIENT_PORTAL,
          });
        }
        break;
      case Progress.SHARED_WITH_FRIEND:
        if(!(profile?.progress.sharedWithFriend ?? false)) {
          profile?.progress.sharedWithFriend = true;
          EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
            EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.SHARED_WITH_FRIEND,
          });
        }
        break;
      case Progress.PREVIEW_SAMPLE_JOB:
        if(!(profile?.progress.previewSampleJob ?? false)) {
          profile?.progress.previewSampleJob = true;
          PendingEmailsRepository(functions: DandylightFunctionsApi(httpClient: http.Client())).sendNextStageEmail(Progress.getNext(Progress.PREVIEW_SAMPLE_JOB));
          EventSender().sendEvent(eventName: EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED, properties: {
            EventNames.GETTING_STARTED_CHECKLIST_ITEM_COMPLETED_PARAM : Progress.PREVIEW_SAMPLE_JOB,
          });
        }
        break;
    }
    if(profile != null) {
      ProfileDao.update(profile);
      store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
    }
  }

  Future<void> _updateQuestionnaireAsReviewed(Store<AppState> store, MarkQuestionnaireAsReviewed action) async {
    Questionnaire questionnaire = action.questionnaire;
    if(questionnaire.jobDocumentId != null && questionnaire.jobDocumentId!.isNotEmpty) {
      Job? job = await JobDao.getJobById(questionnaire.jobDocumentId);
      if(job != null) {
        List<Questionnaire> questionnaires = job.proposal?.questionnaires ?? [];
        for(Questionnaire questionnaireToUpdate in questionnaires) {
          if(questionnaireToUpdate.documentId == questionnaire.documentId) {
            questionnaireToUpdate.isReviewed = true;
          }
        }
        if(job.proposal != null) {
          job.proposal!.questionnaires = questionnaires;
          await JobDao.update(job);
          List<Job>? allJobs = await JobDao.getAllJobs();
          store.dispatch(SetJobsDataAction(store.state.jobsPageState!, allJobs));
          store.dispatch(LoadJobsAction(store.state.dashboardPageState));
          EventSender().sendEvent(eventName: EventNames.QUESTIONNAIRE_REVIEWED);
        }
      }
    } else if(questionnaire.jobDocumentId != null){
      Questionnaire questionnaire = action.questionnaire;
      questionnaire.isReviewed = true;
      QuestionnairesDao.update(questionnaire);
      EventSender().sendEvent(eventName: EventNames.QUESTIONNAIRE_REVIEWED);
    }
  }

  Future<void> _updateContractsAsReviewed(Store<AppState> store, MarkContractsAsReviewed action) async {
    List<Contract> allSignedContracts = action.pageState?.allSignedContracts ?? [];
    for(Contract contract in allSignedContracts) {
      if(!(contract.isReviewed ?? false)){
        contract.isReviewed = true;
        Job? jobForContract = await JobUtil.getJob(contract);
        if(jobForContract != null) {
          int indexOfContract = jobForContract.proposal!.contracts!.indexWhere((item) => item.documentId == contract.documentId);
          jobForContract.proposal!.contracts![indexOfContract] = contract;
          await JobDao.update(jobForContract);
        }
      }
    }

    List<Job>? allJobs = await JobDao.getAllJobs();
    store.dispatch(SetJobsDataAction(store.state.jobsPageState!, allJobs));
  }

  Future<void> _checkAndCreateMileageTrips(Store<AppState> store, LoadJobsAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    List<Job> jobsThatNeedMileageTripAdded = (await JobDao.getAllJobs()).where((job) => job.isMissingMileageTrip()).toList();

    if(profile!.latDefaultHome != null && profile.lngDefaultHome != null) {
      for(Job job in jobsThatNeedMileageTripAdded) {
        if(profile.latDefaultHome  != 0 && profile.lngDefaultHome != 0){
          LatLng start = LatLng(profile.latDefaultHome!, profile.lngDefaultHome!);
          LatLng end = LatLng(job.location!.latitude!, job.location!.longitude!);
          double milesDriven = await GoogleApiClient(httpClient: http.Client()).getTravelDistance(start, end);
          MileageExpense newMileageTrip = MileageExpense(
            jobDocumentId: job.documentId,
            totalMiles: milesDriven * 2,
            isRoundTrip: true,
            startLat: start.latitude,
            startLng: start.longitude,
            endLat: end.latitude,
            endLng: end.longitude,
            deductionRate: NumberConstants.TAX_MILEAGE_DEDUCTION_RATE,
            charge: Charge(
              chargeDate: job.selectedDate,
              chargeAmount: (milesDriven * 2 * NumberConstants.TAX_MILEAGE_DEDUCTION_RATE),
              isPaid: true,
            ),
          );
          newMileageTrip = await MileageExpenseDao.insert(newMileageTrip);
          job.hasAddedMileageTrip = true;
          await JobDao.update(job);
          EventSender().sendEvent(eventName: EventNames.CREATED_MILEAGE_TRIP, properties: {
            EventNames.TRIP_PARAM_LAT_START : newMileageTrip.startLat!,
            EventNames.TRIP_PARAM_LON_START : newMileageTrip.startLng!,
            EventNames.TRIP_PARAM_LAT_END : newMileageTrip.endLat!,
            EventNames.TRIP_PARAM_LON_END : newMileageTrip.endLng!,
            EventNames.TRIP_PARAM_DIST_MILES : newMileageTrip.totalMiles!,
          });
        }
      }
    }
  }

  Future<void> _setUpdateLastSeenTime(Store<AppState> store, SetUpdateSeenTimestampAction action) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.updateLastSeenDate = action.lastSeenDate;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
    store.dispatch(SetShouldShowUpdateAction(store.state.dashboardPageState, false, (await AppSettingsDao.getAll())?.first));
  }

  Future<void> _updateCanShowPMF(Store<AppState> store, UpdateCanShowPMFSurveyAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.canShowPMFSurvey = action.canShow;
    profile.requestPMFSurveyDate = action.lastSeenDate;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
  }

  Future<void> _updateCanShowReviewRequest(Store<AppState> store, UpdateCanShowRequestReviewAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.canShowAppReview = action.canShow;
    profile.requestReviewDate = action.lastSeenDate;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
  }

  void _checkForUpdate(Store<AppState> store, CheckForAppUpdateAction action) async {
    List<AppSettings>? settingsList = (await AppSettingsDao.getAll());
    AppSettings? settings = settingsList != null && settingsList.isNotEmpty ? settingsList.first : null;
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(settings != null) {
      if(settings.show!) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        Version currentVersion = Version.parse(packageInfo.version);
        Version latestVersion = Version.parse(settings.currentBuildVersionNumber!);

        if (latestVersion > currentVersion && (profile!.updateLastSeenDate == null || (profile.updateLastSeenDate != null && hasBeenLongEnoughSinceLastRequest(profile.updateLastSeenDate, 1)))) {
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
        action.location!.latitude.toString(),
        action.location!.longitude.toString());
  }

  Future<void> _checkForReviewRequest(Store<AppState> store, CheckForReviewRequestAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile!.isSubscribed! && profile.jobsCreatedCount! > 2 && profile.canShowAppReview! && hasBeenLongEnoughSinceLastRequest(profile.requestReviewDate, 7)) {
      next(SetShouldAppReview(store.state.dashboardPageState, true));
    } else {
      next(SetShouldAppReview(store.state.dashboardPageState, false));
    }
  }

  Future<void> _checkForPMFSurvey(Store<AppState> store, CheckForPMFSurveyAction action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile!.isSubscribed! && profile.jobsCreatedCount! > 8 && profile.canShowPMFSurvey! && hasBeenLongEnoughSinceLastRequest(profile.requestPMFSurveyDate, 7)) {
      next(SetShouldShowPMF(store.state.dashboardPageState, true));
    } else {
      next(SetShouldShowPMF(store.state.dashboardPageState, false));
    }
  }

  Future<void> _checkForGoToJob(Store<AppState> store, CheckForGoToJobAction action) async {
    List<Job>? allJobs = await JobDao.getAllJobs();
    DateTime now = DateTime.now();
    for(Job job in allJobs!) {
      if(job.selectedTime != null && job.selectedEndTime != null) {
        DateTime startTime = job.selectedTime!.copyWith(year: job.selectedDate!.year, month: job.selectedDate!.month, day: job.selectedDate!.day);
        startTime.add(const Duration(hours: -1));
        DateTime endTime = job.selectedEndTime!.copyWith(year: job.selectedDate!.year, month: job.selectedDate!.month, day: job.selectedDate!.day);
        if(now.isAfter(startTime) && now.isBefore(endTime)) {
          store.dispatch(SetGoToPosesJob(store.state.dashboardPageState, job));
          break;
        }
      } else if(job.selectedTime != null && job.selectedEndTime == null) {
        DateTime startTime = job.selectedTime!.copyWith(year: job.selectedDate!.year, month: job.selectedDate!.month, day: job.selectedDate!.day);
        DateTime endTime = DateTime(startTime.year, startTime.month, startTime.day, startTime.hour, startTime.minute);
        endTime.add(const Duration(hours: 1));
        startTime.add(const Duration(hours: -1));
        if(now.isAfter(startTime) && now.isBefore(endTime)) {
          store.dispatch(SetGoToPosesJob(store.state.dashboardPageState, job));
          break;
        }
      }
    }
  }

  Future<void> _updateProfileWithSeenRestorePurchases(Store<AppState> store, UpdateProfileRestorePurchasesSeen action) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.shouldShowRestoreSubscription = false;
    ProfileDao.update(profile);
  }

  Future<void> _fetchSubscriptionState(Store<AppState> store, NextDispatcher next) async {
    purchases.CustomerInfo? subscriptionState = await _getSubscriptionState();
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if ((subscriptionState!.entitlements.all["standard"] != null && subscriptionState.entitlements.all["standard"]!.isActive) || (subscriptionState.entitlements.all["standard_1699"] != null && subscriptionState.entitlements.all["standard_1699"]!.isActive)) {
      profile!.isSubscribed = true;
    } else {
      profile!.isSubscribed = false;
    }
    ProfileDao.update(profile);

    store.dispatch(SetSubscriptionStateAction(store.state.dashboardPageState, subscriptionState));
  }

  Future<List<Pose>> _getUnseenFeaturedPoses() async {
    List<Pose>? myPoses = (await PoseSubmittedGroupDao.getByUid(UidUtil().getUid()))?.poses;
    if(myPoses != null) {
      return myPoses.where((pose) => pose.isUnseenFeaturedPose()).toList();
    } else {
      return [];
    }
  }

  Future<void> _updateProfileWithShowcaseSeen(Store<AppState> store, UpdateProfileWithShowcaseSeen action, NextDispatcher next) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile!.hasSeenShowcase = true;
    await ProfileDao.update(profile);
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));
  }

  Future<void> _setUnseenFeaturedPosesToSeen(Store<AppState> store, SetUnseenFeaturedPosesAsSeenAction action) async {
    PoseSubmittedGroup? group = await PoseSubmittedGroupDao.getByUid(UidUtil().getUid());
    List<Pose>? myPoses = group!.poses;
    for (var pose in myPoses!) {
      if(!pose.hasSeen!) {
        pose.hasSeen = true;
      }
    }
    group.poses = myPoses;
    await PoseSubmittedGroupDao.update(group);

    List<JobReminder> reminders = await JobReminderDao.getTriggeredReminders();
    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen!) {
        unseenCount++;
      }
    }
    store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));
  }

  Future<void> _setNotificationToSeen(Store<AppState> store, SetNotificationToSeen action) async {
    action.reminder!.hasBeenSeen = true;
    await JobReminderDao.update(action.reminder!);

    List<JobReminder> reminders = await JobReminderDao.getTriggeredReminders();
    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen!) {
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

    if(unseenFeaturedPoses.isNotEmpty) {
      ReminderDandyLight unseenFeaturedPosesReminder = ReminderDandyLight(description: 'Poses Featured!', when: WhenSelectionWidget.BEFORE, daysWeeksMonths: WhenSelectionWidget.DAYS, amount: 1, time: DateTime.now());
      reminders.add(JobReminder(
        reminder: unseenFeaturedPosesReminder,
        hasBeenSeen: false,
        payload: JobReminder.POSE_FEATURED_ID,
      ));
    }

    int unseenCount = 0;
    for(JobReminder reminder in reminders) {
      if(reminder.hasBeenSeen == null || !reminder.hasBeenSeen!) {
        unseenCount++;
      }
    }
    if(unseenFeaturedPoses.isNotEmpty) {
      unseenCount++;
    }
    store.dispatch(SetUnseenReminderCount(store.state.dashboardPageState, unseenCount, reminders));

    List<JobReminder> pendingReminders = await JobReminderDao.getPendingJobReminders();
    for(JobReminder reminder in pendingReminders) {
      DateTime now = DateTime.now();
      DateTime triggerTime = reminder.triggerTime!;
      int diff = (now.millisecondsSinceEpoch - triggerTime.millisecondsSinceEpoch).abs();

      Timer(Duration(milliseconds: diff), () {
        _loadJobReminders(store, action, next);
      });
    }
  }

  Future<void> _loadAllQuestionnaires(Store<AppState> store) async {
    List<Questionnaire> directSendQuestionnaires = (await QuestionnairesDao.getAll());
    directSendQuestionnaires.retainWhere((questionnaire) => !(questionnaire.isTemplate ?? false));
    List<Questionnaire> allQuestionnaires = directSendQuestionnaires;
    List<Questionnaire> notCompleteQuestionnaires = directSendQuestionnaires.where((questionnaire) => !questionnaire.isComplete!).toList();
    List<Questionnaire> completeQuestionnaire = directSendQuestionnaires.where((questionnaire) => questionnaire.isComplete!).toList();

    List<Job>? activeJobs = JobUtil.getActiveJobs(await JobDao.getAllJobs());
    List<Job> activeJobsWithQuestionnaires = JobUtil.getJobsWithQuestionnaires(activeJobs);

    for(Job job in activeJobsWithQuestionnaires) {
      for(Questionnaire questionnaire in job.proposal!.questionnaires!) {
        if(!questionnaire.isComplete!) {
          notCompleteQuestionnaires.add(questionnaire);
        }
        if(questionnaire.isComplete!) {
          completeQuestionnaire.add(questionnaire);
        }
      }
      allQuestionnaires.addAll(job.proposal!.questionnaires!);
    }

    allQuestionnaires = allQuestionnaires.reversed.toList();
    notCompleteQuestionnaires = notCompleteQuestionnaires.reversed.toList();
    completeQuestionnaire = completeQuestionnaire.reversed.toList();

    store.dispatch(SetQuestionnairesToDashboardAction(store.state.dashboardPageState!, notCompleteQuestionnaires, completeQuestionnaire, allQuestionnaires));
  }

  Future<void> _loadAllJobs(Store<AppState> store) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, profile));

    List<Job>? allJobs = await JobDao.getAllJobs();

    List<SessionType>? allSessionTypes = await SessionTypeDao.getAll();
    List<SingleExpense> singleExpenses = await SingleExpenseDao.getAll();
    List<MileageExpense> mileageExpenses = await MileageExpenseDao.getAll();
    List<RecurringExpense> recurringExpenses = await RecurringExpenseDao.getAll();

    store.dispatch(SetJobsDataAction(store.state.jobsPageState!, allJobs));
    store.dispatch(SetJobToStateAction(store.state.dashboardPageState, allJobs, singleExpenses, recurringExpenses, mileageExpenses));
    store.dispatch(SetSessionTypeChartData(store.state.dashboardPageState, allJobs, allSessionTypes));
    List<LineChartMonthData> chartItems = await IncomeAndExpenseDao.getNetProfitChartData();
    store.dispatch(SetIncomeInfoAction(store.state.dashboardPageState, chartItems));

    (await ProfileDao.getProfileStream()).listen((profilesSnapshots) async {
      List<Profile> profiles = [];
      for(RecordSnapshot record in profilesSnapshots) {
        profiles.add(Profile.fromMap(record.value! as Map<String, dynamic>));
      }

      Profile? newProfile;
      String uid = UidUtil().getUid();
      for(Profile profile in profiles) {
        if(profile.uid == uid) {
          newProfile = profile;
        }
      }

      if(newProfile != null) {
        if(profile!.logoUrl != newProfile.logoUrl || profile.bannerMobileUrl != newProfile.bannerMobileUrl) {
          store.dispatch(SetProfileDashboardAction(store.state.dashboardPageState, newProfile));
        }
      }
    });

    await purchases.Purchases.logIn(store.state.dashboardPageState!.profile!.uid!);

    (await SessionTypeDao.getSessionTypeStream()).listen((jobSnapshots) async {
      List<SessionType> sessionTypes = [];
      for(RecordSnapshot clientSnapshot in jobSnapshots) {
        sessionTypes.add(SessionType.fromMap(clientSnapshot.value! as Map<String,dynamic>));
      }
      allJobs = await JobDao.getAllJobs();
      store.dispatch(SetJobsDataAction(store.state.jobsPageState!, allJobs));
      store.dispatch(SetSessionTypeChartData(store.state.dashboardPageState, allJobs, sessionTypes));
    });
  }

  Future<void> _loadClients(Store<AppState> store, action, NextDispatcher next) async {
    List<Client>? clients = await ClientDao.getAll();
    store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));

    (await ClientDao.getClientsStream()).listen((clientSnapshots) {
      List<Client> clients = [];
      for(RecordSnapshot clientSnapshot in clientSnapshots) {
        clients.add(Client.fromMap(clientSnapshot.value! as Map<String,dynamic>));
      }
      store.dispatch(SetClientsDashboardAction(store.state.dashboardPageState, clients));
    });
  }

  Future<purchases.CustomerInfo?> _getSubscriptionState() async {
    purchases.CustomerInfo? currentInfo;
    try {
      currentInfo = await purchases.Purchases.getCustomerInfo();
    } on PlatformException catch (e) {
      print(e);
    }
    return currentInfo;
  }

  bool hasBeenLongEnoughSinceLastRequest(DateTime? lastRequestDate, int minTimeDays) {
    final DateTime now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: minTimeDays));
    return lastRequestDate != null ? lastRequestDate.isBefore(oneWeekAgo) : true;
  }
}