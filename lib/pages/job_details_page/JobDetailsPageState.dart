import 'package:client_safe/models/Action.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Notifications.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class JobDetailsPageState {
  final String jobsProfitTotal;
  final List<Action> actionItems;
  final List<Client> recentLeads;
  final List<Job> currentJobs;
  final List<Job> potentialJobs;
  final List<Notifications> unseenNotifications;
  final Function() onAddClicked;
  final Function() onSearchClientsClicked;
  final Function(Action) onActionItemClicked;
  final Function(Client) onLeadClicked;
  final Function(Job) onJobClicked;

  JobDetailsPageState({
    this.jobsProfitTotal,
    this.actionItems,
    this.recentLeads,
    this.currentJobs,
    this.potentialJobs,
    this.unseenNotifications,
    this.onAddClicked,
    this.onSearchClientsClicked,
    this.onActionItemClicked,
    this.onLeadClicked,
    this.onJobClicked,
  });

  JobDetailsPageState copyWith({
    String jobsProfitTotal,
    List<Action> actionItems,
    List<Client> recentLeads,
    List<Job> currentJobs,
    List<Job> potentialJobs,
    List<Notifications> unseenNotifications,
    Function() onAddClicked,
    Function() onSearchClientsClicked,
    Function(Action) onActionItemClicked,
    Function(Client) onLeadClicked,
    Function(Job) onJobClicked,
  }){
    return JobDetailsPageState(
      jobsProfitTotal: jobsProfitTotal ?? this.jobsProfitTotal,
      actionItems: actionItems ?? this.actionItems,
      recentLeads: recentLeads ?? this.recentLeads,
      currentJobs: currentJobs ?? this.currentJobs,
      potentialJobs: potentialJobs ?? this.potentialJobs,
      unseenNotifications: unseenNotifications ?? this.unseenNotifications,
      onAddClicked: onAddClicked ?? this.onAddClicked,
      onSearchClientsClicked: onSearchClientsClicked ?? this.onSearchClientsClicked,
      onActionItemClicked: onActionItemClicked ?? onActionItemClicked,
      onLeadClicked: onLeadClicked ?? this.onLeadClicked,
      onJobClicked: onJobClicked ?? this.onJobClicked,
    );
  }

  static JobDetailsPageState fromStore(Store<AppState> store) {
    return JobDetailsPageState(
      jobsProfitTotal: store.state.dashboardPageState.jobsProfitTotal,
      actionItems: store.state.dashboardPageState.actionItems,
      recentLeads: store.state.dashboardPageState.recentLeads,
      currentJobs: store.state.dashboardPageState.currentJobs,
      potentialJobs: store.state.dashboardPageState.potentialJobs,
      unseenNotifications: store.state.dashboardPageState.unseenNotifications,
      onAddClicked: store.state.dashboardPageState.onAddClicked,
      onSearchClientsClicked: store.state.dashboardPageState.onSearchClientsClicked,
      onActionItemClicked: store.state.dashboardPageState.onActionItemClicked,
      onLeadClicked: store.state.dashboardPageState.onLeadClicked,
      onJobClicked: store.state.dashboardPageState.onJobClicked,
    );
  }

  factory JobDetailsPageState.initial() => JobDetailsPageState(
    jobsProfitTotal: "",
    actionItems: new List(),
    recentLeads: new List(),
    currentJobs: new List(),
    potentialJobs: new List(),
    unseenNotifications: new List(),
    onAddClicked: null,
    onSearchClientsClicked: null,
    onActionItemClicked: null,
    onLeadClicked: null,
    onJobClicked: null,
  );

  @override
  int get hashCode =>
      jobsProfitTotal.hashCode ^
      actionItems.hashCode ^
      recentLeads.hashCode ^
      currentJobs.hashCode ^
      potentialJobs.hashCode ^
      unseenNotifications.hashCode ^
      onSearchClientsClicked.hashCode ^
      onActionItemClicked.hashCode ^
      onLeadClicked.hashCode ^
      onJobClicked.hashCode ^
      onAddClicked.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobDetailsPageState &&
              jobsProfitTotal == other.jobsProfitTotal &&
              actionItems == other.actionItems &&
              recentLeads == other.recentLeads &&
              currentJobs == other.currentJobs &&
              potentialJobs == other.potentialJobs &&
              unseenNotifications == other.unseenNotifications &&
              onSearchClientsClicked == other.onSearchClientsClicked &&
              onActionItemClicked == other.onActionItemClicked &&
              onLeadClicked == other.onLeadClicked &&
              onJobClicked == other.onJobClicked &&
              onAddClicked == other.onAddClicked;
}
