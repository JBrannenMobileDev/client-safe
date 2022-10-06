import 'package:dandylight/models/Action.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Notifications.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/widgets/LineChartMonthData.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/JobReminder.dart';
import '../../models/JobStage.dart';

class DashboardPageState {
  final String jobsProfitTotal;
  final bool isMinimized;
  final bool isLeadsMinimized;
  final List<Action> actionItems;
  final List<Client> recentLeads;
  final List<JobStage> allUserStages;
  final List<Job> upcomingJobs;
  final List<Job> allJobs;
  final List<Job> activeJobs;
  final int unseenNotificationCount;
  final List<JobReminder> reminders;
  final List<LineChartMonthData> lineChartMonthData;
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
  });

  DashboardPageState copyWith({
    String jobsProfitTotal,
    bool isMinimized,
    bool isLeadsMinimized,
    List<Action> actionItems,
    List<Client> recentLeads,
    List<Job> currentJobs,
    List<Job> allJobs,
    List<Job> activeJobs,
    List<JobStage> allUserStages,
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
      onLeadClicked: (client) => store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client)),
      onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
      onViewAllHideSelected: () => store.dispatch(UpdateShowHideState(store.state.dashboardPageState)),
      onViewAllHideLeadsSelected: () => store.dispatch(UpdateShowHideLeadsState(store.state.dashboardPageState)),
      onReminderSelected:  (reminder) => store.dispatch(SetJobInfoWithJobDocumentId(store.state.jobDetailsPageState, reminder.jobDocumentId)),
      onNotificationsSelected: () => store.dispatch(SetNotificationsToSeen(store.state.dashboardPageState)),
      onNotificationViewClosed: () => store.dispatch(UpdateNotificationIconAction(store.state.dashboardPageState)),
    );
  }

  factory DashboardPageState.initial() => DashboardPageState(
    jobsProfitTotal: "",
    actionItems: [],
    recentLeads: [],
    upcomingJobs: [],
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
      allJobs.hashCode ^
      reminders.hashCode ^
      activeJobs.hashCode ^
      onViewAllHideSelected.hashCode ^
      isLeadsMinimized.hashCode ^
      onViewAllHideLeadsSelected.hashCode ^
      allUserStages.hashCode ^
      lineChartMonthData.hashCode^
      onReminderSelected.hashCode^
      onNotificationsSelected.hashCode ^
      onNotificationViewClosed.hashCode ^
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
              onReminderSelected == other.onReminderSelected &&
              onNotificationsSelected == other.onNotificationsSelected &&
              onNotificationViewClosed == other.onNotificationViewClosed &&
              isMinimized == other.isMinimized;
}
