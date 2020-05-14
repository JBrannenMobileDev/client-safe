import 'package:client_safe/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:client_safe/pages/calendar_page/CalendarPageState.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:client_safe/pages/collections_page/CollectionsPageState.dart';
import 'package:client_safe/pages/home_page/HomePageState.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/jobs_page/JobsPageState.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:client_safe/pages/search_page/SearchPageState.dart';
import 'package:client_safe/pages/settings_page/SettingsPageState.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:meta/meta.dart';

import 'pages/clients_page/ClientsPageState.dart';

@immutable
class AppState {
  final NewLocationPageState newLocationPageState;
  final LocationsPageState locationsPageState;
  final NewPricingProfilePageState pricingProfilePageState;
  final PricingProfilesPageState pricingProfilesPageState;
  final NewJobPageState newJobPageState;
  final NewContactPageState newContactPageState;
  final HomePageState homePageState;
  final DashboardPageState dashboardPageState;
  final ClientsPageState clientsPageState;
  final ClientDetailsPageState clientDetailsPageState;
  final JobsPageState jobsPageState;
  final CollectionsPageState collectionsPageState;
  final SettingsPageState settingsPageState;
  final SearchPageState searchPageState;
  final CalendarPageState calendarPageState;
  final JobDetailsPageState jobDetailsPageState;
  final NewInvoicePageState newInvoicePageState;
  final IncomeAndExpensesPageState incomeAndExpensesPageState;
  final SunsetWeatherPageState sunsetWeatherPageState;

  AppState({
    @required this.newLocationPageState,
    @required this.locationsPageState,
    @required this.pricingProfilePageState,
    @required this.pricingProfilesPageState,
    @required this.newContactPageState,
    @required this.homePageState,
    @required this.dashboardPageState,
    @required this.clientsPageState,
    @required this.clientDetailsPageState,
    @required this.jobsPageState,
    @required this.collectionsPageState,
    @required this.settingsPageState,
    @required this.searchPageState,
    @required this.newJobPageState,
    @required this.calendarPageState,
    @required this.jobDetailsPageState,
    @required this.newInvoicePageState,
    @required this.incomeAndExpensesPageState,
    @required this.sunsetWeatherPageState,
  });

  factory AppState.initial() {
    return AppState(
      newLocationPageState: NewLocationPageState.initial(),
      locationsPageState: LocationsPageState.initial(),
      pricingProfilePageState: NewPricingProfilePageState.initial(),
      pricingProfilesPageState: PricingProfilesPageState.initial(),
      newContactPageState: NewContactPageState.initial(),
      homePageState: HomePageState.initial(),
      dashboardPageState: DashboardPageState.initial(),
      clientsPageState: ClientsPageState.initial(),
      clientDetailsPageState: ClientDetailsPageState.initial(),
      jobsPageState: JobsPageState.initial(),
      collectionsPageState: CollectionsPageState.initial(),
      settingsPageState: SettingsPageState.initial(),
      searchPageState: SearchPageState.initial(),
      newJobPageState: NewJobPageState.initial(),
      calendarPageState: CalendarPageState.initial(),
      jobDetailsPageState: JobDetailsPageState.initial(),
      newInvoicePageState: NewInvoicePageState.initial(),
      incomeAndExpensesPageState: IncomeAndExpensesPageState.initial(),
      sunsetWeatherPageState: SunsetWeatherPageState.initial(),
    );
  }

  AppState copyWith({
    NewLocationPageState newLocationPageState,
    LocationsPageState locationsPageState,
    NewPricingProfilePageState pricingProfilePageState,
    PricingProfilesPageState pricingProfilesPageState,
    NewContactPageState newContactPageState,
    HomePageState homePageState,
    DashboardPageState dashboardPageState,
    ClientsPageState clientsPageState,
    ClientDetailsPageState clientDetailsPageState,
    JobsPageState jobsPageState,
    CollectionsPageState collectionsPageState,
    SettingsPageState settingsPageState,
    SearchPageState searchPageState,
    NewJobPageState newJobPageState,
    CalendarPageState calendarPageState,
    JobDetailsPageState jobDetailsPageState,
    NewInvoicePageState newInvoicePageState,
    IncomeAndExpensesPageState incomeAndExpensesPageState,
    SunsetWeatherPageState sunsetWeatherPageState,
  }){
    return AppState(
      newLocationPageState: newLocationPageState ?? this.newLocationPageState,
      locationsPageState: locationsPageState ?? this.locationsPageState,
      pricingProfilePageState: pricingProfilePageState ?? this.pricingProfilePageState,
      pricingProfilesPageState: pricingProfilesPageState ?? this.pricingProfilesPageState,
      newContactPageState: newContactPageState ?? this.newContactPageState,
      homePageState: homePageState ?? this.homePageState,
      dashboardPageState: dashboardPageState ?? this.dashboardPageState,
      clientsPageState: clientsPageState ?? this.clientsPageState,
      clientDetailsPageState: clientDetailsPageState?? this.clientDetailsPageState,
      jobsPageState: jobsPageState ?? this.jobsPageState,
      collectionsPageState: collectionsPageState ?? this.collectionsPageState,
      settingsPageState: settingsPageState ?? this.settingsPageState,
      searchPageState: searchPageState ?? this.searchPageState,
      newJobPageState: newJobPageState ?? this.newJobPageState,
      calendarPageState: calendarPageState ?? this.calendarPageState,
      jobDetailsPageState: jobDetailsPageState ?? this.jobDetailsPageState,
      newInvoicePageState: newInvoicePageState ?? this.newInvoicePageState,
      incomeAndExpensesPageState: incomeAndExpensesPageState ?? this.incomeAndExpensesPageState,
      sunsetWeatherPageState: sunsetWeatherPageState ?? this.sunsetWeatherPageState,
    );
  }

  @override
  int get hashCode =>
  newLocationPageState.hashCode ^
    locationsPageState.hashCode ^
    pricingProfilePageState.hashCode ^
    pricingProfilesPageState.hashCode ^
    newContactPageState.hashCode ^
    homePageState.hashCode ^
    dashboardPageState.hashCode ^
    clientsPageState.hashCode ^
    clientDetailsPageState.hashCode ^
    jobsPageState.hashCode ^
    collectionsPageState.hashCode ^
    settingsPageState.hashCode ^
    searchPageState.hashCode ^
    newJobPageState.hashCode ^
    jobDetailsPageState.hashCode ^
    calendarPageState.hashCode ^
    newInvoicePageState.hashCode ^
    sunsetWeatherPageState.hashCode ^
    incomeAndExpensesPageState.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              newLocationPageState == other.newLocationPageState &&
              locationsPageState == other.locationsPageState &&
              pricingProfilePageState == other.pricingProfilePageState &&
              pricingProfilesPageState == other.pricingProfilesPageState &&
              newContactPageState == other.newContactPageState &&
              homePageState == other.homePageState &&
              dashboardPageState == other.dashboardPageState &&
              clientsPageState == other.clientsPageState &&
              clientDetailsPageState == other.clientDetailsPageState &&
              jobsPageState == other.jobsPageState &&
              collectionsPageState == other.collectionsPageState &&
              settingsPageState == other.settingsPageState &&
              searchPageState == other.searchPageState &&
              newJobPageState == other.newJobPageState &&
              jobDetailsPageState == other.jobDetailsPageState &&
              calendarPageState == other.calendarPageState &&
              newInvoicePageState == other.newInvoicePageState &&
              sunsetWeatherPageState == other.sunsetWeatherPageState &&
              incomeAndExpensesPageState == other.incomeAndExpensesPageState;
}