import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionPageState.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/collections_page/CollectionsPageState.dart';
import 'package:dandylight/pages/home_page/HomePageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/jobs_page/JobsPageState.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';
import 'package:dandylight/pages/login_page/LoginPageState.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageState.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypePageState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/pages/new_pose_group_page/NewPoseGroupPageState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageState.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:dandylight/pages/onboarding_flow_pages/OnboardingFlowPageState.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageState.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageState.dart';
import 'package:dandylight/pages/search_page/SearchPageState.dart';
import 'package:dandylight/pages/job_types/JobTypesPageState.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
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
  final MainSettingsPageState mainSettingsPageState;
  final SearchPageState searchPageState;
  final CalendarPageState calendarPageState;
  final JobDetailsPageState jobDetailsPageState;
  final NewInvoicePageState newInvoicePageState;
  final IncomeAndExpensesPageState incomeAndExpensesPageState;
  final SunsetWeatherPageState sunsetWeatherPageState;
  final NewSingleExpensePageState newSingleExpensePageState;
  final NewRecurringExpensePageState newRecurringExpensePageState;
  final NewMileageExpensePageState newMileageExpensePageState;
  final MapLocationSelectionWidgetState mapLocationSelectionWidgetState;
  final LoginPageState loginPageState;
  final RemindersPageState remindersPageState;
  final NewReminderPageState newReminderPageState;
  final NewJobReminderPageState newJobReminderPageState;
  final JobTypesPageState jobTypesPageState;
  final NewJobTypePageState newJobTypePageState;
  final PosesPageState posesPageState;
  final NewPoseGroupPageState newPoseGroupPageState;
  final PoseGroupPageState poseGroupPageState;
  final CalendarSelectionPageState calendarSelectionPageState;
  final IncomeAndExpenseSettingsPageState incomeAndExpenseSettingsPageState;
  final PaymentRequestInfoPageState paymentRequestInfoPageState;
  final OnBoardingFlowPageState onBoardingFlowPageState;
  final ResponsesPageState responsesPageState;

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
    @required this.mainSettingsPageState,
    @required this.searchPageState,
    @required this.newJobPageState,
    @required this.calendarPageState,
    @required this.jobDetailsPageState,
    @required this.newInvoicePageState,
    @required this.incomeAndExpensesPageState,
    @required this.sunsetWeatherPageState,
    @required this.newSingleExpensePageState,
    @required this.newRecurringExpensePageState,
    @required this.newMileageExpensePageState,
    @required this.mapLocationSelectionWidgetState,
    @required this.loginPageState,
    @required this.remindersPageState,
    @required this.newReminderPageState,
    @required this.newJobReminderPageState,
    @required this.jobTypesPageState,
    @required this.newJobTypePageState,
    @required this.posesPageState,
    @required this.newPoseGroupPageState,
    @required this.poseGroupPageState,
    @required this.calendarSelectionPageState,
    @required this.incomeAndExpenseSettingsPageState,
    @required this.paymentRequestInfoPageState,
    @required this.onBoardingFlowPageState,
    @required this.responsesPageState,
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
      mainSettingsPageState: MainSettingsPageState.initial(),
      searchPageState: SearchPageState.initial(),
      newJobPageState: NewJobPageState.initial(),
      calendarPageState: CalendarPageState.initial(),
      jobDetailsPageState: JobDetailsPageState.initial(),
      newInvoicePageState: NewInvoicePageState.initial(),
      incomeAndExpensesPageState: IncomeAndExpensesPageState.initial(),
      sunsetWeatherPageState: SunsetWeatherPageState.initial(),
      newSingleExpensePageState: NewSingleExpensePageState.initial(),
      newRecurringExpensePageState: NewRecurringExpensePageState.initial(),
      newMileageExpensePageState: NewMileageExpensePageState.initial(),
      mapLocationSelectionWidgetState: MapLocationSelectionWidgetState.initial(),
      loginPageState: LoginPageState.initial(),
      remindersPageState: RemindersPageState.initial(),
      newReminderPageState: NewReminderPageState.initial(),
      newJobReminderPageState: NewJobReminderPageState.initial(),
      jobTypesPageState: JobTypesPageState.initial(),
      newJobTypePageState: NewJobTypePageState.initial(),
      posesPageState: PosesPageState.initial(),
      newPoseGroupPageState: NewPoseGroupPageState.initial(),
      poseGroupPageState: PoseGroupPageState.initial(),
      calendarSelectionPageState: CalendarSelectionPageState.initial(),
      incomeAndExpenseSettingsPageState: IncomeAndExpenseSettingsPageState.initial(),
      paymentRequestInfoPageState: PaymentRequestInfoPageState.initial(),
      onBoardingFlowPageState: OnBoardingFlowPageState.initial(),
      responsesPageState: ResponsesPageState.initial(),
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
    MainSettingsPageState settingsPageState,
    SearchPageState searchPageState,
    NewJobPageState newJobPageState,
    CalendarPageState calendarPageState,
    JobDetailsPageState jobDetailsPageState,
    NewInvoicePageState newInvoicePageState,
    IncomeAndExpensesPageState incomeAndExpensesPageState,
    SunsetWeatherPageState sunsetWeatherPageState,
    NewSingleExpensePageState newSingleExpensePageState,
    NewRecurringExpensePageState newRecurringExpensePageState,
    NewMileageExpensePageState newMileageExpensePageState,
    MapLocationSelectionWidgetState mapLocationSelectionWidgetState,
    LoginPageState loginPageState,
    RemindersPageState remindersPageState,
    NewReminderPageState newReminderPageState,
    NewJobReminderPageState newJobReminderPageState,
    JobTypesPageState jobStagesPageState,
    NewJobTypePageState newJobTypePageState,
    PosesPageState posesPageState,
    NewPoseGroupPageState newPoseGroupPageState,
    PoseGroupPageState poseGroupPageState,
    CalendarSelectionPageState calendarSelectionPageState,
    IncomeAndExpenseSettingsPageState incomeAndExpenseSettingsPageState,
    PaymentRequestInfoPageState paymentRequestInfoPageState,
    OnBoardingFlowPageState onBoardingFlowPageState,
    ResponsesPageState responsesPageState,
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
      mainSettingsPageState: settingsPageState ?? this.mainSettingsPageState,
      searchPageState: searchPageState ?? this.searchPageState,
      newJobPageState: newJobPageState ?? this.newJobPageState,
      calendarPageState: calendarPageState ?? this.calendarPageState,
      jobDetailsPageState: jobDetailsPageState ?? this.jobDetailsPageState,
      newInvoicePageState: newInvoicePageState ?? this.newInvoicePageState,
      incomeAndExpensesPageState: incomeAndExpensesPageState ?? this.incomeAndExpensesPageState,
      sunsetWeatherPageState: sunsetWeatherPageState ?? this.sunsetWeatherPageState,
      newSingleExpensePageState: newSingleExpensePageState ?? this.newSingleExpensePageState,
      newRecurringExpensePageState: newRecurringExpensePageState ?? this.newRecurringExpensePageState,
      newMileageExpensePageState: newMileageExpensePageState ?? this.newMileageExpensePageState,
      mapLocationSelectionWidgetState: mapLocationSelectionWidgetState ?? this.mapLocationSelectionWidgetState,
      loginPageState: loginPageState ?? this.loginPageState,
      remindersPageState: remindersPageState ?? this.remindersPageState,
      newReminderPageState: newReminderPageState ?? this.newReminderPageState,
      newJobReminderPageState: newJobReminderPageState ?? this.newJobReminderPageState,
      jobTypesPageState: jobStagesPageState ?? this.jobTypesPageState,
      newJobTypePageState: newJobTypePageState ?? this.newJobTypePageState,
      posesPageState: posesPageState ?? this.posesPageState,
      newPoseGroupPageState: newPoseGroupPageState ?? this.newPoseGroupPageState,
      poseGroupPageState: poseGroupPageState ?? this.poseGroupPageState,
      calendarSelectionPageState: calendarSelectionPageState ?? this.calendarSelectionPageState,
      incomeAndExpenseSettingsPageState: incomeAndExpenseSettingsPageState ?? this.incomeAndExpenseSettingsPageState,
      paymentRequestInfoPageState: paymentRequestInfoPageState ?? this.paymentRequestInfoPageState,
      onBoardingFlowPageState: onBoardingFlowPageState ?? this.onBoardingFlowPageState,
      responsesPageState: responsesPageState ?? this.responsesPageState,
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
    mainSettingsPageState.hashCode ^
    searchPageState.hashCode ^
    newJobPageState.hashCode ^
    jobDetailsPageState.hashCode ^
    calendarPageState.hashCode ^
    newInvoicePageState.hashCode ^
    sunsetWeatherPageState.hashCode ^
    newSingleExpensePageState.hashCode ^
    newRecurringExpensePageState.hashCode ^
    newMileageExpensePageState.hashCode ^
    mapLocationSelectionWidgetState.hashCode ^
    loginPageState.hashCode ^
    remindersPageState.hashCode ^
    newReminderPageState.hashCode ^
    newJobReminderPageState.hashCode ^
    jobTypesPageState.hashCode ^
    newJobTypePageState.hashCode ^
    posesPageState.hashCode ^
    newPoseGroupPageState.hashCode ^
    poseGroupPageState.hashCode ^
    calendarSelectionPageState.hashCode ^
    incomeAndExpenseSettingsPageState.hashCode ^
    paymentRequestInfoPageState.hashCode ^
    onBoardingFlowPageState.hashCode ^
    responsesPageState.hashCode ^
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
              mainSettingsPageState == other.mainSettingsPageState &&
              searchPageState == other.searchPageState &&
              newJobPageState == other.newJobPageState &&
              jobDetailsPageState == other.jobDetailsPageState &&
              calendarPageState == other.calendarPageState &&
              newInvoicePageState == other.newInvoicePageState &&
              sunsetWeatherPageState == other.sunsetWeatherPageState &&
              newSingleExpensePageState == other.newSingleExpensePageState &&
              newRecurringExpensePageState == other.newRecurringExpensePageState &&
              newMileageExpensePageState == other.newMileageExpensePageState &&
              mapLocationSelectionWidgetState == other.mapLocationSelectionWidgetState &&
              loginPageState == other.loginPageState &&
              remindersPageState == other.remindersPageState &&
              newReminderPageState == other.newReminderPageState &&
              newJobReminderPageState == other.newJobReminderPageState &&
              jobTypesPageState == other.jobTypesPageState &&
              newJobTypePageState == other.newJobTypePageState &&
              posesPageState == other.posesPageState &&
              newPoseGroupPageState == other.newPoseGroupPageState &&
              poseGroupPageState == other.poseGroupPageState &&
              calendarSelectionPageState == other.calendarSelectionPageState &&
              incomeAndExpenseSettingsPageState == other.incomeAndExpenseSettingsPageState &&
              paymentRequestInfoPageState == other.paymentRequestInfoPageState &&
              onBoardingFlowPageState == other.onBoardingFlowPageState &&
              responsesPageState == other.responsesPageState &&
              incomeAndExpensesPageState == other.incomeAndExpensesPageState;
}