import 'package:client_safe/pages/collections_page/CollectionsPageState.dart';
import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/pages/messages_page/MessagesPageState.dart';
import 'package:client_safe/pages/search_page/SearchPageState.dart';
import 'package:client_safe/pages/settings_page/SettingsPageState.dart';
import 'package:meta/meta.dart';

import 'pages/clients_page/ClientsPageState.dart';

@immutable
class AppState {
  final HomePageState homePageState;
  final DashboardPageState dashboardPageState;
  final ClientsPageState clientsPageState;
  final MessagesPageState messagesPageState;
  final JobsPageState jobsPageState;
  final CollectionsPageState collectionsPageState;
  final SettingsPageState settingsPageState;
  final SearchPageState searchPageState;

  AppState({
    @required this.homePageState,
    @required this.dashboardPageState,
    @required this.clientsPageState,
    @required this.messagesPageState,
    @required this.jobsPageState,
    @required this.collectionsPageState,
    @required this.settingsPageState,
    @required this.searchPageState,
  });

  factory AppState.initial() {
    return AppState(
      homePageState: HomePageState.initial(),
      dashboardPageState: DashboardPageState.initial(),
      clientsPageState: ClientsPageState.initial(),
      messagesPageState: MessagesPageState.initial(),
      jobsPageState: JobsPageState.initial(),
      collectionsPageState: CollectionsPageState.initial(),
      settingsPageState: SettingsPageState.initial(),
      searchPageState: SearchPageState.initial(),
    );
  }

  AppState copyWith({
    HomePageState homePageState,
    DashboardPageState dashboardPageState,
    ClientsPageState clientsPageState,
    MessagesPageState messagesPageState,
    JobsPageState jobsPageState,
    CollectionsPageState collectionsPageState,
    SettingsPageState settingsPageState,
    SearchPageState searchPageState,
  }){
    return AppState(
      homePageState: homePageState ?? this.homePageState,
      dashboardPageState: dashboardPageState ?? this.dashboardPageState,
      clientsPageState: clientsPageState ?? this.clientsPageState,
      messagesPageState: messagesPageState ?? this.messagesPageState,
      jobsPageState: jobsPageState ?? this.jobsPageState,
      collectionsPageState: collectionsPageState ?? this.collectionsPageState,
      settingsPageState: settingsPageState ?? this.settingsPageState,
      searchPageState: searchPageState ?? this.searchPageState,
    );
  }

  @override
  int get hashCode =>
    homePageState.hashCode ^
    dashboardPageState.hashCode ^
    clientsPageState.hashCode ^
    messagesPageState.hashCode ^
    jobsPageState.hashCode ^
    collectionsPageState.hashCode ^
    settingsPageState.hashCode ^
    searchPageState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              homePageState == other.homePageState &&
              dashboardPageState == other.dashboardPageState &&
              clientsPageState == other.clientsPageState &&
              messagesPageState == other.messagesPageState &&
              jobsPageState == other.jobsPageState &&
              collectionsPageState == other.collectionsPageState &&
              settingsPageState == other.settingsPageState &&
              searchPageState == other.searchPageState;
}