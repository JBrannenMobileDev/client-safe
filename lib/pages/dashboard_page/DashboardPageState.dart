import 'package:dandylight/models/Action.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LineChartMonthData.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/JobReminder.dart';
import '../../models/JobStage.dart';
import '../../models/Location.dart';
import '../../models/Pose.dart';
import '../../models/Profile.dart';
import 'JobTypePieChartRowData.dart';
import 'LeadSourcePieChartRowData.dart';

class DashboardPageState {
  final String jobsProfitTotal;
  final bool isMinimized;
  final bool isLeadsMinimized;
  final bool shouldShowNewMileageExpensePage;
  final bool hasSeenShowcase;
  final bool goToSeen;
  final bool areJobsLoaded;
  final Job goToPosesJob;
  final int leadConversionRate;
  final int unconvertedLeadCount;
  final purchases.CustomerInfo subscriptionState;
  final List<Action> actionItems;
  final List<Client> recentLeads;
  final List<JobStage> allUserStages;
  final List<JobTypePieChartRowData> jobTypePieChartRowData;
  final List<Job> upcomingJobs;
  final List<Job> allJobs;
  final List<Job> activeJobs;
  final List<Job> jobsThisWeek;
  final List<PieChartSectionData> jobTypeBreakdownData;
  final List<PieChartSectionData> leadSourcesData;
  final int unseenNotificationCount;
  final List<JobReminder> reminders;
  final List<LineChartMonthData> lineChartMonthData;
  final List<LeadSourcePieChartRowData> leadSourcePieChartRowData;
  final List<Pose> unseenFeaturedPoses;
  final Profile profile;
  final Function() onAddClicked;
  final Function() onSearchClientsClicked;
  final Function(Action) onActionItemClicked;
  final Function(Client) onLeadClicked;
  final Function(Job) onJobClicked;
  final Function(JobReminder) onReminderSelected;
  final Function() onViewAllHideSelected;
  final Function() onViewAllHideLeadsSelected;
  final Function() onNotificationsSelected;
  final Function() onNotificationViewClosed;
  final Function() onShowcaseSeen;
  final Function() markAllAsSeen;
  final Function() onGoToSeen;
  final Function(Location) drivingDirectionsSelected;

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
    this.jobTypeBreakdownData,
    this.leadSourcesData,
    this.jobTypePieChartRowData,
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
  });

  DashboardPageState copyWith({
    String jobsProfitTotal,
    bool isMinimized,
    bool isLeadsMinimized,
    bool hasSeenShowcase,
    bool goToSeen,
    bool areJobsLoaded,
    int leadConversionRate,
    Job goToPosesJob,
    int unconvertedLeadCount,
    List<Action> actionItems,
    List<Client> recentLeads,
    List<Job> currentJobs,
    List<Job> allJobs,
    List<Job> activeJobs,
    List<Job> jobsThisWeek,
    List<JobStage> allUserStages,
    List<Pose> unseenFeaturedPoses,
    int unseenNotificationCount,
    List<LineChartMonthData> lineChartMonthData,
    Function() onAddClicked,
    Function() onSearchClientsClicked,
    Function(Action) onActionItemClicked,
    Function(Client) onLeadClicked,
    Function(Job) onJobClicked,
    Function() onViewAllHideSelected,
    Function() onViewAllHideLeadsSelected,
    List<JobReminder> reminders,
    Function(JobReminder) onReminderSelected,
    Function() onNotificationsSelected,
    Function() onNotificationViewClosed,
    Function() onShowcaseSeen,
    Function() markAllAsSeen,
    bool shouldShowNewMileageExpensePage,
    List<PieChartSectionData> jobTypeBreakdownData,
    List<PieChartSectionData> leadSourcesData,
    List<JobTypePieChartRowData> jobTypePieChartRowData,
    List<LeadSourcePieChartRowData> leadSourcePieChartRowData,
    Profile profile,
    purchases.CustomerInfo subscriptionState,
    Function() onGoToSeen,
    Function(Location) drivingDirectionsSelected,
  }){
    return DashboardPageState(
      jobsProfitTotal: jobsProfitTotal ?? this.jobsProfitTotal,
      isMinimized: isMinimized ?? this.isMinimized,
      actionItems: actionItems ?? this.actionItems,
      recentLeads: recentLeads ?? this.recentLeads,
      upcomingJobs: currentJobs ?? this.upcomingJobs,
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
      jobTypeBreakdownData: jobTypeBreakdownData ?? this.jobTypeBreakdownData,
      leadSourcesData: leadSourcesData ?? this.leadSourcesData,
      jobTypePieChartRowData: jobTypePieChartRowData ?? this.jobTypePieChartRowData,
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
    );
  }

  static DashboardPageState fromStore(Store<AppState> store) {
    return DashboardPageState(
      jobsProfitTotal: store.state.dashboardPageState.jobsProfitTotal,
      actionItems: store.state.dashboardPageState.actionItems,
      recentLeads: store.state.dashboardPageState.recentLeads,
      upcomingJobs: store.state.dashboardPageState.upcomingJobs,
      unseenNotificationCount: store.state.dashboardPageState.unseenNotificationCount,
      onAddClicked: store.state.dashboardPageState.onAddClicked,
      onSearchClientsClicked: store.state.dashboardPageState.onSearchClientsClicked,
      onActionItemClicked: store.state.dashboardPageState.onActionItemClicked,
      isMinimized: store.state.dashboardPageState.isMinimized,
      allJobs: store.state.dashboardPageState.allJobs,
      activeJobs: store.state.dashboardPageState.activeJobs,
      isLeadsMinimized: store.state.dashboardPageState.isLeadsMinimized,
      allUserStages: store.state.dashboardPageState.allUserStages,
      lineChartMonthData: store.state.dashboardPageState.lineChartMonthData,
      reminders: store.state.dashboardPageState.reminders,
      shouldShowNewMileageExpensePage: store.state.dashboardPageState.shouldShowNewMileageExpensePage,
      jobsThisWeek: store.state.dashboardPageState.jobsThisWeek,
      leadConversionRate: store.state.dashboardPageState.leadConversionRate,
      unconvertedLeadCount: store.state.dashboardPageState.unconvertedLeadCount,
      jobTypeBreakdownData: store.state.dashboardPageState.jobTypeBreakdownData,
      leadSourcesData: store.state.dashboardPageState.leadSourcesData,
      jobTypePieChartRowData: store.state.dashboardPageState.jobTypePieChartRowData,
      leadSourcePieChartRowData: store.state.dashboardPageState.leadSourcePieChartRowData,
      profile: store.state.dashboardPageState.profile,
      hasSeenShowcase: store.state.dashboardPageState.hasSeenShowcase,
      subscriptionState: store.state.dashboardPageState.subscriptionState,
      goToPosesJob: store.state.dashboardPageState.goToPosesJob,
      goToSeen: store.state.dashboardPageState.goToSeen,
      areJobsLoaded: store.state.dashboardPageState.areJobsLoaded,
      unseenFeaturedPoses: store.state.dashboardPageState.unseenFeaturedPoses,
      onLeadClicked: (client) => store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client)),
      onJobClicked: (job) {
        store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job));
        store.dispatch(FetchJobPosesAction(store.state.jobDetailsPageState));
        store.dispatch(SetGoToPosesJob(store.state.dashboardPageState, null));
      },
      onViewAllHideSelected: () => store.dispatch(UpdateShowHideState(store.state.dashboardPageState)),
      onViewAllHideLeadsSelected: () => store.dispatch(UpdateShowHideLeadsState(store.state.dashboardPageState)),
      onReminderSelected:  (reminder) {
        if(reminder.payload != JobReminder.POSE_FEATURED_ID) {
          store.dispatch(SetNotificationToSeen(store.state.dashboardPageState, reminder));
          store.dispatch(SetJobInfoWithJobDocumentId(store.state.jobDetailsPageState, reminder.jobDocumentId));
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
    lineChartMonthData: List.filled(6, LineChartMonthData(income: 1)),
    onViewAllHideSelected: null,
    isLeadsMinimized: true,
    onViewAllHideLeadsSelected: null,
    onReminderSelected: null,
    onNotificationsSelected: null,
    onNotificationViewClosed: null,
    jobsThisWeek: [],
    jobTypeBreakdownData: [],
    leadSourcesData: [],
    leadConversionRate: 0,
    unconvertedLeadCount: 0,
    jobTypePieChartRowData: [],
    leadSourcePieChartRowData: [],
    profile: null,
    subscriptionState: null,
    markAllAsSeen: null,
    goToPosesJob: null,
    goToSeen: false,
    onGoToSeen: null,
    drivingDirectionsSelected: null,
    areJobsLoaded: false,
    unseenFeaturedPoses: [],
  );

  @override
  int get hashCode =>
      jobsProfitTotal.hashCode ^
      actionItems.hashCode ^
      recentLeads.hashCode ^
      upcomingJobs.hashCode ^
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
      subscriptionState.hashCode ^
      leadConversionRate.hashCode ^
      unconvertedLeadCount.hashCode ^
      jobTypeBreakdownData.hashCode ^
      leadSourcesData.hashCode ^
      jobTypePieChartRowData.hashCode ^
      leadSourcePieChartRowData.hashCode ^
      profile.hashCode ^
      goToPosesJob.hashCode ^
      goToSeen.hashCode ^
      onGoToSeen.hashCode ^
      areJobsLoaded.hashCode ^
      unseenFeaturedPoses.hashCode ^
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
              activeJobs == other.activeJobs &&
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
              jobTypeBreakdownData == other.jobTypeBreakdownData &&
              leadSourcesData == other.leadSourcesData &&
              jobTypePieChartRowData == other.jobTypePieChartRowData &&
              leadSourcePieChartRowData == other.leadSourcePieChartRowData &&
              profile == other.profile &&
              goToPosesJob == other.goToPosesJob &&
              goToSeen == other.goToSeen &&
              onGoToSeen == other.onGoToSeen &&
              drivingDirectionsSelected == other.drivingDirectionsSelected &&
              areJobsLoaded == other.areJobsLoaded &&
              unseenFeaturedPoses == other.unseenFeaturedPoses &&
              isMinimized == other.isMinimized;
}
