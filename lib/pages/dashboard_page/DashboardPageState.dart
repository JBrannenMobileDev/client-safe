import 'package:dandylight/models/Action.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LineChartMonthData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/AppSettings.dart';
import '../../models/Contract.dart';
import '../../models/JobReminder.dart';
import '../../models/JobStage.dart';
import '../../models/LocationDandy.dart';
import '../../models/Pose.dart';
import '../../models/PoseLibraryGroup.dart';
import '../../models/Profile.dart';
import '../../models/Questionnaire.dart';
import 'LeadSourcePieChartRowData.dart';
import 'SessionTypePieChartRowData.dart';

class DashboardPageState {
  final String? jobsProfitTotal;
  final bool? isMinimized;
  final bool? isLeadsMinimized;
  final bool? shouldShowNewMileageExpensePage;
  final bool? hasSeenShowcase;
  final bool? goToSeen;
  final bool? areJobsLoaded;
  final bool? shouldShowRequestReview;
  final bool? shouldShowPMFRequest;
  final bool? shouldShowAppUpdate;
  final Job? goToPosesJob;
  final int? leadConversionRate;
  final int? unconvertedLeadCount;
  final purchases.CustomerInfo? subscriptionState;
  final List<Action>? actionItems;
  final List<Client>? recentLeads;
  final List<JobStage>? allUserStages;
  final List<SessionTypePieChartRowData>? sessionTypePieChartRowData;
  final List<Job>? upcomingJobs;
  final List<Job>? allJobs;
  final List<Job>? activeJobs;
  final List<Job>? jobsThisWeek;
  final List<Contract>? activeUnsignedContract;
  final List<Contract>? activeSignedContract;
  final List<Contract>? allUnsignedContracts;
  final List<Contract>? allSignedContracts;
  final List<PieChartSectionData>? sessionTypeBreakdownData;
  final List<PieChartSectionData>? leadSourcesData;
  final int? unseenNotificationCount;
  final List<JobReminder>? reminders;
  final List<LineChartMonthData>? lineChartMonthData;
  final List<LeadSourcePieChartRowData>? leadSourcePieChartRowData;
  final List<Pose>? unseenFeaturedPoses;
  final List<Questionnaire>? notCompleteQuestionnaires;
  final List<Questionnaire>? completedQuestionnaires;
  final List<Questionnaire>? allQuestionnaires;
  final List<PoseLibraryGroup>? poseGroups;
  final Profile? profile;
  final AppSettings? appSettings;
  final Function()? onAddClicked;
  final Function()? onSearchClientsClicked;
  final Function(Action)? onActionItemClicked;
  final Function(Client)? onLeadClicked;
  final Function(String)? onJobClicked;
  final Function(JobReminder)? onReminderSelected;
  final Function()? onViewAllHideSelected;
  final Function()? onViewAllHideLeadsSelected;
  final Function()? onNotificationsSelected;
  final Function()? onNotificationViewClosed;
  final Function()? onShowcaseSeen;
  final Function()? markAllAsSeen;
  final Function()? onGoToSeen;
  final Function(LocationDandy)? drivingDirectionsSelected;
  final Function(bool, DateTime)? updateCanShowPMF;
  final Function(bool, DateTime)? updateCanShowRequestReview;
  final Function(AppSettings)? markUpdateAsSeen;
  final Function()? markContractsAsReviewed;
  final Function(Questionnaire)? markQuestionnaireAsReviewed;
  final Function(String)? updateProgressItemComplete;
  final Function()? updateProgressNoShow;
  final Function()? updateSessionMigrationMessageRead;

  DashboardPageState({
    this.jobsProfitTotal,
    this.actionItems,
    this.recentLeads,
    this.upcomingJobs,
    this.allJobs,
    this.unseenNotificationCount,
    this.onAddClicked,
    this.onSearchClientsClicked,
    this.onActionItemClicked,
    this.onLeadClicked,
    this.onJobClicked,
    this.isMinimized,
    this.onViewAllHideSelected,
    this.isLeadsMinimized,
    this.onViewAllHideLeadsSelected,
    this.activeJobs,
    this.allUserStages,
    this.lineChartMonthData,
    this.reminders,
    this.onReminderSelected,
    this.onNotificationsSelected,
    this.onNotificationViewClosed,
    this.shouldShowNewMileageExpensePage,
    this.jobsThisWeek,
    this.leadConversionRate,
    this.unconvertedLeadCount,
    this.sessionTypeBreakdownData,
    this.leadSourcesData,
    this.sessionTypePieChartRowData,
    this.leadSourcePieChartRowData,
    this.profile,
    this.hasSeenShowcase,
    this.onShowcaseSeen,
    this.subscriptionState,
    this.markAllAsSeen,
    this.goToPosesJob,
    this.goToSeen,
    this.onGoToSeen,
    this.drivingDirectionsSelected,
    this.areJobsLoaded,
    this.unseenFeaturedPoses,
    this.shouldShowPMFRequest,
    this.shouldShowRequestReview,
    this.updateCanShowPMF,
    this.updateCanShowRequestReview,
    this.shouldShowAppUpdate,
    this.markUpdateAsSeen,
    this.appSettings,
    this.activeSignedContract,
    this.activeUnsignedContract,
    this.allSignedContracts,
    this.allUnsignedContracts,
    this.notCompleteQuestionnaires,
    this.completedQuestionnaires,
    this.allQuestionnaires,
    this.markContractsAsReviewed,
    this.markQuestionnaireAsReviewed,
    this.updateProgressItemComplete,
    this.updateProgressNoShow,
    this.poseGroups,
    this.updateSessionMigrationMessageRead,
  });

  DashboardPageState copyWith({
    String? jobsProfitTotal,
    bool? isMinimized,
    bool? isLeadsMinimized,
    bool? hasSeenShowcase,
    bool? goToSeen,
    bool? areJobsLoaded,
    bool? shouldShowPMFRequest,
    bool? shouldShowRequestReview,
    bool? shouldShowAppUpdate,
    int? leadConversionRate,
    Job? goToPosesJob,
    int? unconvertedLeadCount,
    List<Action>? actionItems,
    List<Client>? recentLeads,
    List<Job>? upcomingJobs,
    List<Job>? allJobs,
    List<Job>? activeJobs,
    List<Job>? jobsThisWeek,
    List<JobStage>? allUserStages,
    List<Pose>? unseenFeaturedPoses,
    List<Contract>? activeUnsignedContract,
    List<Contract>? activeSignedContract,
    List<Contract>? allUnsignedContract,
    List<Contract>? allSignedContract,
    List<PoseLibraryGroup>? poseGroups,
    int? unseenNotificationCount,
    List<LineChartMonthData>? lineChartMonthData,
    Function()? onAddClicked,
    Function()? onSearchClientsClicked,
    Function(Action)? onActionItemClicked,
    Function(Client)? onLeadClicked,
    Function(String)? onJobClicked,
    Function()? onViewAllHideSelected,
    Function()? onViewAllHideLeadsSelected,
    List<JobReminder>? reminders,
    Function(JobReminder)? onReminderSelected,
    Function()? onNotificationsSelected,
    Function()? onNotificationViewClosed,
    Function()? onShowcaseSeen,
    Function()? markAllAsSeen,
    bool? shouldShowNewMileageExpensePage,
    List<PieChartSectionData>? jobTypeBreakdownData,
    List<PieChartSectionData>? leadSourcesData,
    List<SessionTypePieChartRowData>? jobTypePieChartRowData,
    List<LeadSourcePieChartRowData>? leadSourcePieChartRowData,
    Profile? profile,
    purchases.CustomerInfo? subscriptionState,
    AppSettings? appSettings,
    Function()? onGoToSeen,
    Function(LocationDandy)? drivingDirectionsSelected,
    Function(bool, DateTime)? updateCanShowPMF,
    Function(bool, DateTime)? updateCanShowRequestReview,
    Function(AppSettings)? markUpdateAsSeen,
    List<Questionnaire>? notCompleteQuestionnaires,
    List<Questionnaire>? completedQuestionnaires,
    List<Questionnaire>? allQuestionnaires,
    Function()? markContractsAsReviewed,
    Function(Questionnaire)? markQuestionnaireAsReviewed,
    Function(String)? updateProgressItemComplete,
    Function()? updateProgressNoShow,
    Function()? updateSessionMigrationMessageRead,
  }){
    return DashboardPageState(
      jobsProfitTotal: jobsProfitTotal ?? this.jobsProfitTotal,
      isMinimized: isMinimized ?? this.isMinimized,
      actionItems: actionItems ?? this.actionItems,
      recentLeads: recentLeads ?? this.recentLeads,
      upcomingJobs: upcomingJobs ?? this.upcomingJobs,
      activeJobs: activeJobs ?? this.activeJobs,
      unseenNotificationCount: unseenNotificationCount ?? this.unseenNotificationCount,
      onAddClicked: onAddClicked ?? this.onAddClicked,
      onSearchClientsClicked: onSearchClientsClicked ?? this.onSearchClientsClicked,
      onActionItemClicked: onActionItemClicked ?? onActionItemClicked,
      onLeadClicked: onLeadClicked ?? this.onLeadClicked,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      onViewAllHideSelected: onViewAllHideSelected ?? this.onViewAllHideSelected,
      allJobs: allJobs ?? this.allJobs,
      isLeadsMinimized: isLeadsMinimized ?? this.isLeadsMinimized,
      onViewAllHideLeadsSelected: onViewAllHideLeadsSelected ?? this.onViewAllHideLeadsSelected,
      allUserStages: allUserStages ?? this.allUserStages,
      lineChartMonthData: lineChartMonthData ?? this.lineChartMonthData,
      reminders: reminders ?? this.reminders,
      onReminderSelected: onReminderSelected ?? this.onReminderSelected,
      onNotificationsSelected: onNotificationsSelected ?? this.onNotificationsSelected,
      onNotificationViewClosed: onNotificationViewClosed ?? this.onNotificationViewClosed,
      shouldShowNewMileageExpensePage: shouldShowNewMileageExpensePage ?? this.shouldShowNewMileageExpensePage,
      jobsThisWeek: jobsThisWeek ?? this.jobsThisWeek,
      leadConversionRate: leadConversionRate ?? this.leadConversionRate,
      unconvertedLeadCount: unconvertedLeadCount ?? this.unconvertedLeadCount,
      sessionTypeBreakdownData: jobTypeBreakdownData ?? this.sessionTypeBreakdownData,
      leadSourcesData: leadSourcesData ?? this.leadSourcesData,
      sessionTypePieChartRowData: jobTypePieChartRowData ?? this.sessionTypePieChartRowData,
      leadSourcePieChartRowData: leadSourcePieChartRowData ?? this.leadSourcePieChartRowData,
      profile: profile ?? this.profile,
      hasSeenShowcase: hasSeenShowcase ?? this.hasSeenShowcase,
      onShowcaseSeen: onShowcaseSeen ?? this.onShowcaseSeen,
      subscriptionState: subscriptionState ?? this.subscriptionState,
      markAllAsSeen: markAllAsSeen ?? this.markAllAsSeen,
      goToPosesJob: goToPosesJob ?? this.goToPosesJob,
      goToSeen: goToSeen ?? this.goToSeen,
      onGoToSeen: onGoToSeen ?? this.onGoToSeen,
      drivingDirectionsSelected: drivingDirectionsSelected ?? this.drivingDirectionsSelected,
      areJobsLoaded: areJobsLoaded ?? this.areJobsLoaded,
      unseenFeaturedPoses: unseenFeaturedPoses ?? this.unseenFeaturedPoses,
      shouldShowPMFRequest: shouldShowPMFRequest ?? this.shouldShowPMFRequest,
      shouldShowRequestReview: shouldShowRequestReview ?? this.shouldShowRequestReview,
      updateCanShowPMF: updateCanShowPMF ?? this.updateCanShowPMF,
      updateCanShowRequestReview: updateCanShowRequestReview ?? this.updateCanShowRequestReview,
      shouldShowAppUpdate : shouldShowAppUpdate ?? this.shouldShowAppUpdate,
      markUpdateAsSeen: markUpdateAsSeen ?? this.markUpdateAsSeen,
      appSettings: appSettings ?? this.appSettings,
      activeSignedContract: activeSignedContract ?? this.activeSignedContract,
      activeUnsignedContract: activeUnsignedContract ?? this.activeUnsignedContract,
      allSignedContracts: allSignedContract ?? this.allSignedContracts,
      allUnsignedContracts: allUnsignedContract ?? this.allUnsignedContracts,
      completedQuestionnaires: completedQuestionnaires ?? this.completedQuestionnaires,
      notCompleteQuestionnaires: notCompleteQuestionnaires ?? this.notCompleteQuestionnaires,
      allQuestionnaires: allQuestionnaires ?? this.allQuestionnaires,
      markContractsAsReviewed: markContractsAsReviewed ?? this.markContractsAsReviewed,
      markQuestionnaireAsReviewed: markQuestionnaireAsReviewed ?? this.markQuestionnaireAsReviewed,
      updateProgressItemComplete: updateProgressItemComplete ?? this.updateProgressItemComplete,
      updateProgressNoShow: updateProgressNoShow ?? this.updateProgressNoShow,
      poseGroups: poseGroups ?? this.poseGroups,
      updateSessionMigrationMessageRead: updateSessionMigrationMessageRead ?? this.updateSessionMigrationMessageRead,
    );
  }

  static DashboardPageState fromStore(Store<AppState> store) {
    return DashboardPageState(
      jobsProfitTotal: store.state.dashboardPageState!.jobsProfitTotal,
      actionItems: store.state.dashboardPageState!.actionItems,
      recentLeads: store.state.dashboardPageState!.recentLeads,
      upcomingJobs: store.state.dashboardPageState!.upcomingJobs,
      unseenNotificationCount: store.state.dashboardPageState!.unseenNotificationCount,
      onAddClicked: store.state.dashboardPageState!.onAddClicked,
      onSearchClientsClicked: store.state.dashboardPageState!.onSearchClientsClicked,
      onActionItemClicked: store.state.dashboardPageState!.onActionItemClicked,
      isMinimized: store.state.dashboardPageState!.isMinimized,
      allJobs: store.state.dashboardPageState!.allJobs,
      activeJobs: store.state.dashboardPageState!.activeJobs,
      isLeadsMinimized: store.state.dashboardPageState!.isLeadsMinimized,
      allUserStages: store.state.dashboardPageState!.allUserStages,
      lineChartMonthData: store.state.dashboardPageState!.lineChartMonthData,
      reminders: store.state.dashboardPageState!.reminders,
      shouldShowNewMileageExpensePage: store.state.dashboardPageState!.shouldShowNewMileageExpensePage,
      jobsThisWeek: store.state.dashboardPageState!.jobsThisWeek,
      leadConversionRate: store.state.dashboardPageState!.leadConversionRate,
      unconvertedLeadCount: store.state.dashboardPageState!.unconvertedLeadCount,
      sessionTypeBreakdownData: store.state.dashboardPageState!.sessionTypeBreakdownData,
      leadSourcesData: store.state.dashboardPageState!.leadSourcesData,
      sessionTypePieChartRowData: store.state.dashboardPageState!.sessionTypePieChartRowData,
      leadSourcePieChartRowData: store.state.dashboardPageState!.leadSourcePieChartRowData,
      profile: store.state.dashboardPageState!.profile,
      hasSeenShowcase: store.state.dashboardPageState!.hasSeenShowcase,
      subscriptionState: store.state.dashboardPageState!.subscriptionState,
      goToPosesJob: store.state.dashboardPageState!.goToPosesJob,
      goToSeen: store.state.dashboardPageState!.goToSeen,
      areJobsLoaded: store.state.dashboardPageState!.areJobsLoaded,
      unseenFeaturedPoses: store.state.dashboardPageState!.unseenFeaturedPoses,
      shouldShowPMFRequest: store.state.dashboardPageState!.shouldShowPMFRequest,
      shouldShowRequestReview: store.state.dashboardPageState!.shouldShowRequestReview,
      shouldShowAppUpdate: store.state.dashboardPageState!.shouldShowAppUpdate,
      appSettings: store.state.dashboardPageState!.appSettings,
      activeSignedContract: store.state.dashboardPageState!.activeSignedContract,
      activeUnsignedContract: store.state.dashboardPageState!.activeUnsignedContract,
      allSignedContracts: store.state.dashboardPageState!.allSignedContracts,
      allUnsignedContracts: store.state.dashboardPageState!.allUnsignedContracts,
      completedQuestionnaires: store.state.dashboardPageState!.completedQuestionnaires,
      notCompleteQuestionnaires: store.state.dashboardPageState!.notCompleteQuestionnaires,
      allQuestionnaires: store.state.dashboardPageState!.allQuestionnaires,
      poseGroups: store.state.dashboardPageState!.poseGroups,
      onLeadClicked: (client) => store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client)),
      onJobClicked: (job) {
        store.dispatch(SetGoToPosesJob(store.state.dashboardPageState, null));
      },
      onViewAllHideSelected: () => store.dispatch(UpdateShowHideState(store.state.dashboardPageState)),
      onViewAllHideLeadsSelected: () => store.dispatch(UpdateShowHideLeadsState(store.state.dashboardPageState)),
      onReminderSelected:  (reminder) {
        if(reminder.payload != JobReminder.POSE_FEATURED_ID) {
          store.dispatch(SetNotificationToSeen(store.state.dashboardPageState, reminder));
        } else {
          store.dispatch(SetUnseenFeaturedPosesAsSeenAction(store.state.dashboardPageState));
        }
      },
      onNotificationsSelected: () => null,
      onNotificationViewClosed: () => store.dispatch(UpdateNotificationIconAction(store.state.dashboardPageState)),
      onShowcaseSeen: () => store.dispatch(UpdateProfileWithShowcaseSeen(store.state.dashboardPageState)),
      markAllAsSeen: () => store.dispatch(MarkAllAsSeenAction(store.state.dashboardPageState)),
      onGoToSeen: () => store.dispatch(SetGoToAsSeenAction(store.state.dashboardPageState)),
      drivingDirectionsSelected: (location) => store.dispatch(LaunchDrivingDirectionsAction(store.state.dashboardPageState, location)),
      updateCanShowRequestReview: (canShow, lastSeenDate) => store.dispatch(UpdateCanShowRequestReviewAction(store.state.dashboardPageState, canShow, lastSeenDate)),
      updateCanShowPMF: (canShow, lastSeenDate) => store.dispatch(UpdateCanShowPMFSurveyAction(store.state.dashboardPageState, canShow, lastSeenDate)),
      markUpdateAsSeen: (appSettings) {
        store.dispatch(SetShouldShowUpdateAction(store.state.dashboardPageState, false, appSettings));
        store.dispatch(SetUpdateSeenTimestampAction(store.state.dashboardPageState, DateTime.now()));
      },
      markContractsAsReviewed: () => store.dispatch(MarkContractsAsReviewed(store.state.dashboardPageState)),
      markQuestionnaireAsReviewed: (questionnaire) => store.dispatch(MarkQuestionnaireAsReviewed(store.state.dashboardPageState, questionnaire)),
      updateProgressItemComplete: (itemType) => store.dispatch(UpdateProgressItemCompleteAction(store.state.dashboardPageState, itemType)),
      updateProgressNoShow: () => store.dispatch(UpdateProgressNoShow(store.state.dashboardPageState)),
      updateSessionMigrationMessageRead: () => store.dispatch(UpdateSessionMigrationToReadAction(store.state.dashboardPageState)),
    );
  }

  factory DashboardPageState.initial() => DashboardPageState(
    jobsProfitTotal: "",
    actionItems: [],
    recentLeads: [],
    upcomingJobs: [],
    shouldShowNewMileageExpensePage: false,
    unseenNotificationCount: 0,
    activeJobs: [],
    allUserStages: [],
    reminders: [],
    onAddClicked: null,
    onSearchClientsClicked: null,
    onActionItemClicked: null,
    onLeadClicked: null,
    onJobClicked: null,
    isMinimized: true,
    allJobs: [],
    appSettings: null,
    lineChartMonthData: List.filled(6, LineChartMonthData(income: 1)),
    onViewAllHideSelected: null,
    isLeadsMinimized: true,
    onViewAllHideLeadsSelected: null,
    onReminderSelected: null,
    onNotificationsSelected: null,
    onNotificationViewClosed: null,
    shouldShowAppUpdate: false,
    jobsThisWeek: [],
    sessionTypeBreakdownData: [],
    leadSourcesData: [],
    leadConversionRate: 0,
    unconvertedLeadCount: 0,
    sessionTypePieChartRowData: [],
    leadSourcePieChartRowData: [],
    activeUnsignedContract: [],
    activeSignedContract: [],
    allUnsignedContracts: [],
    allSignedContracts: [],
    profile: null,
    subscriptionState: null,
    markAllAsSeen: null,
    goToPosesJob: null,
    goToSeen: false,
    onGoToSeen: null,
    drivingDirectionsSelected: null,
    areJobsLoaded: false,
    shouldShowRequestReview: false,
    shouldShowPMFRequest: false,
    unseenFeaturedPoses: [],
    updateCanShowRequestReview: null,
    updateCanShowPMF: null,
    markUpdateAsSeen: null,
    hasSeenShowcase: true,
    completedQuestionnaires: [],
    notCompleteQuestionnaires: [],
    allQuestionnaires: [],
    markContractsAsReviewed: null,
    markQuestionnaireAsReviewed: null,
    updateProgressItemComplete: null,
    updateProgressNoShow: null,
    poseGroups: [],
    updateSessionMigrationMessageRead: null,
  );

  @override
  int get hashCode =>
      jobsProfitTotal.hashCode ^
      actionItems.hashCode ^
      recentLeads.hashCode ^
      upcomingJobs.hashCode ^
      hasSeenShowcase.hashCode ^
      unseenNotificationCount.hashCode ^
      onSearchClientsClicked.hashCode ^
      onActionItemClicked.hashCode ^
      onLeadClicked.hashCode ^
      onJobClicked.hashCode ^
      onAddClicked.hashCode ^
      shouldShowNewMileageExpensePage.hashCode ^
      allJobs.hashCode ^
      reminders.hashCode ^
      activeJobs.hashCode ^
      drivingDirectionsSelected.hashCode ^
      onViewAllHideSelected.hashCode ^
      isLeadsMinimized.hashCode ^
      onViewAllHideLeadsSelected.hashCode ^
      allUserStages.hashCode ^
      lineChartMonthData.hashCode^
      onReminderSelected.hashCode^
      markAllAsSeen.hashCode ^
      onNotificationsSelected.hashCode ^
      onNotificationViewClosed.hashCode ^
      jobsThisWeek.hashCode ^
      shouldShowAppUpdate.hashCode ^
      subscriptionState.hashCode ^
      leadConversionRate.hashCode ^
      unconvertedLeadCount.hashCode ^
      sessionTypeBreakdownData.hashCode ^
      poseGroups.hashCode ^
      leadSourcesData.hashCode ^
      sessionTypePieChartRowData.hashCode ^
      leadSourcePieChartRowData.hashCode ^
      profile.hashCode ^
      goToPosesJob.hashCode ^
      goToSeen.hashCode ^
      onGoToSeen.hashCode ^
      areJobsLoaded.hashCode ^
      shouldShowRequestReview.hashCode ^
      shouldShowPMFRequest.hashCode ^
      unseenFeaturedPoses.hashCode ^
      updateCanShowPMF.hashCode ^
      updateProgressNoShow.hashCode ^
      updateCanShowRequestReview.hashCode ^
      markUpdateAsSeen.hashCode ^
      appSettings.hashCode ^
      activeUnsignedContract.hashCode ^
      activeUnsignedContract.hashCode ^
      allUnsignedContracts.hashCode ^
      allSignedContracts.hashCode ^
      completedQuestionnaires.hashCode ^
      notCompleteQuestionnaires.hashCode ^
      allQuestionnaires.hashCode ^
      markContractsAsReviewed.hashCode ^
      updateProgressItemComplete.hashCode ^
      markQuestionnaireAsReviewed.hashCode ^
      updateSessionMigrationMessageRead.hashCode ^
      isMinimized.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DashboardPageState &&
              jobsProfitTotal == other.jobsProfitTotal &&
              actionItems == other.actionItems &&
              recentLeads == other.recentLeads &&
              upcomingJobs == other.upcomingJobs &&
              allJobs == other.allJobs &&
              isLeadsMinimized == other.isLeadsMinimized &&
              onViewAllHideLeadsSelected == other.onViewAllHideLeadsSelected &&
              unseenNotificationCount == other.unseenNotificationCount &&
              onSearchClientsClicked == other.onSearchClientsClicked &&
              onActionItemClicked == other.onActionItemClicked &&
              onLeadClicked == other.onLeadClicked &&
              onJobClicked == other.onJobClicked &&
              onAddClicked == other.onAddClicked &&
              poseGroups == other.poseGroups &&
              activeJobs == other.activeJobs &&
              hasSeenShowcase == other.hasSeenShowcase &&
              shouldShowAppUpdate == other.shouldShowAppUpdate &&
              allUserStages == other.allUserStages &&
              onViewAllHideSelected == other.onViewAllHideSelected &&
              lineChartMonthData == other.lineChartMonthData &&
              reminders == other.reminders &&
              subscriptionState == other.subscriptionState &&
              shouldShowNewMileageExpensePage == other.shouldShowNewMileageExpensePage &&
              onReminderSelected == other.onReminderSelected &&
              onNotificationsSelected == other.onNotificationsSelected &&
              onNotificationViewClosed == other.onNotificationViewClosed &&
              jobsThisWeek == other.jobsThisWeek &&
              markAllAsSeen == other.markAllAsSeen &&
              leadConversionRate == other.leadConversionRate &&
              unconvertedLeadCount == other.unconvertedLeadCount &&
              sessionTypeBreakdownData == other.sessionTypeBreakdownData &&
              leadSourcesData == other.leadSourcesData &&
              sessionTypePieChartRowData == other.sessionTypePieChartRowData &&
              leadSourcePieChartRowData == other.leadSourcePieChartRowData &&
              profile == other.profile &&
              appSettings == other.appSettings &&
              goToPosesJob == other.goToPosesJob &&
              goToSeen == other.goToSeen &&
              updateProgressNoShow == other.updateProgressNoShow &&
              onGoToSeen == other.onGoToSeen &&
              drivingDirectionsSelected == other.drivingDirectionsSelected &&
              areJobsLoaded == other.areJobsLoaded &&
              shouldShowRequestReview == other.shouldShowRequestReview &&
              shouldShowPMFRequest == other.shouldShowPMFRequest &&
              unseenFeaturedPoses == other.unseenFeaturedPoses &&
              updateCanShowPMF == other.updateCanShowPMF &&
              updateCanShowRequestReview == other.updateCanShowRequestReview &&
              markUpdateAsSeen == other.markUpdateAsSeen &&
              activeUnsignedContract == other.activeUnsignedContract &&
              activeSignedContract == other.activeSignedContract &&
              allSignedContracts == other.allSignedContracts &&
              allUnsignedContracts == other.allUnsignedContracts &&
              completedQuestionnaires == other.completedQuestionnaires &&
              notCompleteQuestionnaires == other.notCompleteQuestionnaires &&
              allQuestionnaires == other.allQuestionnaires &&
              markContractsAsReviewed == other.markContractsAsReviewed &&
              markQuestionnaireAsReviewed == other.markQuestionnaireAsReviewed &&
              updateProgressItemComplete == other.updateProgressItemComplete &&
              updateSessionMigrationMessageRead == other.updateSessionMigrationMessageRead &&
              isMinimized == other.isMinimized;
}
