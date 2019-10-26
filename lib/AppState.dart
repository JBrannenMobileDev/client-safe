import 'package:client_safe/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:client_safe/pages/collections_page/CollectionsPageState.dart';
import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/pages/messages_page/MessagesPageState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:client_safe/pages/search_page/SearchPageState.dart';
import 'package:client_safe/pages/settings_page/SettingsPageState.dart';
import 'package:meta/meta.dart';

import 'pages/clients_page/ClientsPageState.dart';

@immutable
class AppState {
  final PricingProfilesPageState pricingProfilesPageState;
  final NewJobPageState newJobPageState;
  final NewContactPageState newContactPageState;
  final HomePageState homePageState;
  final DashboardPageState dashboardPageState;
  final ClientsPageState clientsPageState;
  final ClientDetailsPageState clientDetailsPageState;
  final MessagesPageState messagesPageState;
  final JobsPageState jobsPageState;
  final CollectionsPageState collectionsPageState;
  final SettingsPageState settingsPageState;
  final SearchPageState searchPageState;

  AppState({
    @required this.pricingProfilesPageState,
    @required this.newContactPageState,
    @required this.homePageState,
    @required this.dashboardPageState,
    @required this.clientsPageState,
    @required this.clientDetailsPageState,
    @required this.messagesPageState,
    @required this.jobsPageState,
    @required this.collectionsPageState,
    @required this.settingsPageState,
    @required this.searchPageState,
    @required this.newJobPageState,
  });

  factory AppState.initial() {
    return AppState(
      pricingProfilesPageState: PricingProfilesPageState.initial(),
      newContactPageState: NewContactPageState.initial(),
      homePageState: HomePageState.initial(),
      dashboardPageState: DashboardPageState.initial(),
      clientsPageState: ClientsPageState.initial(),
      clientDetailsPageState: ClientDetailsPageState.initial(),
      messagesPageState: MessagesPageState.initial(),
      jobsPageState: JobsPageState.initial(),
      collectionsPageState: CollectionsPageState.initial(),
      settingsPageState: SettingsPageState.initial(),
      searchPageState: SearchPageState.initial(),
      newJobPageState: NewJobPageState.initial(),
    );
  }

  AppState copyWith({
    PricingProfilesPageState pricingProfilesPageState,
    NewContactPageState newContactPageState,
    HomePageState homePageState,
    DashboardPageState dashboardPageState,
    ClientsPageState clientsPageState,
    ClientDetailsPageState clientDetailsPageState,
    MessagesPageState messagesPageState,
    JobsPageState jobsPageState,
    CollectionsPageState collectionsPageState,
    SettingsPageState settingsPageState,
    SearchPageState searchPageState,
    NewJobPageState newJobPageState,
  }){
    return AppState(
      pricingProfilesPageState: pricingProfilesPageState ?? this.pricingProfilesPageState,
      newContactPageState: newContactPageState ?? this.newContactPageState,
      homePageState: homePageState ?? this.homePageState,
      dashboardPageState: dashboardPageState ?? this.dashboardPageState,
      clientsPageState: clientsPageState ?? this.clientsPageState,
      clientDetailsPageState: clientDetailsPageState?? this.clientDetailsPageState,
      messagesPageState: messagesPageState ?? this.messagesPageState,
      jobsPageState: jobsPageState ?? this.jobsPageState,
      collectionsPageState: collectionsPageState ?? this.collectionsPageState,
      settingsPageState: settingsPageState ?? this.settingsPageState,
      searchPageState: searchPageState ?? this.searchPageState,
      newJobPageState: newJobPageState ?? this.newJobPageState,
    );
  }

  @override
  int get hashCode =>
    pricingProfilesPageState.hashCode ^
    newContactPageState.hashCode ^
    homePageState.hashCode ^
    dashboardPageState.hashCode ^
    clientsPageState.hashCode ^
    clientDetailsPageState.hashCode ^
    messagesPageState.hashCode ^
    jobsPageState.hashCode ^
    collectionsPageState.hashCode ^
    settingsPageState.hashCode ^
    searchPageState.hashCode ^
    newJobPageState.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              pricingProfilesPageState == other.pricingProfilesPageState &&
              newContactPageState == other.newContactPageState &&
              homePageState == other.homePageState &&
              dashboardPageState == other.dashboardPageState &&
              clientsPageState == other.clientsPageState &&
              clientDetailsPageState == other.clientDetailsPageState &&
              messagesPageState == other.messagesPageState &&
              jobsPageState == other.jobsPageState &&
              collectionsPageState == other.collectionsPageState &&
              settingsPageState == other.settingsPageState &&
              searchPageState == other.searchPageState &&
              newJobPageState == other.newJobPageState;
}