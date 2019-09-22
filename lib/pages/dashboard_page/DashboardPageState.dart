import 'package:client_safe/models/Action.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/Notifications.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class DashboardPageState {
  final String jobsProfitTotal;
  final List<Action> actionItems;
  final List<Client> recentLeads;
  final List<Job> currentJobs;
  final List<Notifications> unseenNotifications;
  final Function() onAddClicked;
  final Function() onSearchClientsClicked;
  final Function(Action) onActionItemClicked;
  final Function(Client) onLeadClicked;
  final Function(Job) onJobClicked;

  DashboardPageState({
    this.jobsProfitTotal,
    this.actionItems,
    this.recentLeads,
    this.currentJobs,
    this.unseenNotifications,
    this.onAddClicked,
    this.onSearchClientsClicked,
    this.onActionItemClicked,
    this.onLeadClicked,
    this.onJobClicked,
  });

  DashboardPageState copyWith({
    String jobsProfitTotal,
    List<Action> actionItems,
    List<Client> recentLeads,
    List<Job> currentJobs,
    List<Notifications> unseenNotifications,
    Function() onAddClicked,
    Function() onSearchClientsClicked,
    Function(Action) onActionItemClicked,
    Function(Client) onLeadClicked,
    Function(Job) onJobClicked,
  }){
    return DashboardPageState(
      jobsProfitTotal: jobsProfitTotal ?? this.jobsProfitTotal,
      actionItems: actionItems ?? this.actionItems,
      recentLeads: recentLeads ?? this.recentLeads,
      currentJobs: currentJobs ?? this.currentJobs,
      unseenNotifications: unseenNotifications ?? this.unseenNotifications,
      onAddClicked: onAddClicked ?? this.onAddClicked,
      onSearchClientsClicked: onSearchClientsClicked ?? this.onSearchClientsClicked,
      onActionItemClicked: onActionItemClicked ?? onActionItemClicked,
      onLeadClicked: onLeadClicked ?? this.onLeadClicked,
      onJobClicked: onJobClicked ?? this.onJobClicked,
    );
  }

  static DashboardPageState fromStore(Store<AppState> store) {
    return DashboardPageState(
      jobsProfitTotal: store.state.dashboardPageState.jobsProfitTotal,
      actionItems: store.state.dashboardPageState.actionItems,
      recentLeads: store.state.dashboardPageState.recentLeads,
      currentJobs: store.state.dashboardPageState.currentJobs,
      unseenNotifications: store.state.dashboardPageState.unseenNotifications,
      onAddClicked: store.state.dashboardPageState.onAddClicked,
      onSearchClientsClicked: store.state.dashboardPageState.onSearchClientsClicked,
      onActionItemClicked: store.state.dashboardPageState.onActionItemClicked,
      onLeadClicked: store.state.dashboardPageState.onLeadClicked,
      onJobClicked: store.state.dashboardPageState.onJobClicked,
    );
  }

  factory DashboardPageState.initial() => DashboardPageState(
    jobsProfitTotal: "",
    actionItems: new List(),
    recentLeads: new List(),
    currentJobs: new List(),
    unseenNotifications: new List(),
    onAddClicked: null,
    onSearchClientsClicked: null,
    onActionItemClicked: null,
    onLeadClicked: null,
    onJobClicked: null,
  );
}
