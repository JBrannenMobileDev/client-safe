import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageState.dart';
import 'package:dandylight/pages/answer_questionnaire_page/AnswerQuestionnairePageState.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageState.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionPageState.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/pages/collections_page/CollectionsPageState.dart';
import 'package:dandylight/pages/contract_edit_page/ContractEditPageState.dart';
import 'package:dandylight/pages/contracts_page/ContractsPageState.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/pages/edit_branding_page/EditBrandingPageState.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/jobs_page/JobsPageState.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';
import 'package:dandylight/pages/login_page/LoginPageState.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
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
import 'package:dandylight/pages/new_question_page/NewQuestionPageState.dart';
import 'package:dandylight/pages/new_questionnaire_page/NewQuestionnairePageState.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageState.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageState.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageState.dart';
import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:dandylight/pages/questionnaires_page/QuestionnairesPageState.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageState.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageState.dart';
import 'package:dandylight/pages/job_types/JobTypesPageState.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesPageState.dart';
import 'package:dandylight/pages/select_a_photo_page/SelectAPhotoPageState.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientPageState.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:dandylight/pages/upload_pose_page/UploadPosePageState.dart';
import 'package:dandylight/web/pages/ClientPortalPageState.dart';
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
  final DashboardPageState dashboardPageState;
  final ClientsPageState clientsPageState;
  final ClientDetailsPageState clientDetailsPageState;
  final JobsPageState jobsPageState;
  final CollectionsPageState collectionsPageState;
  final MainSettingsPageState mainSettingsPageState;
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
  final ResponsesPageState responsesPageState;
  final ManageSubscriptionPageState manageSubscriptionPageState;
  final LibraryPoseGroupPageState libraryPoseGroupPageState;
  final OnBoardingPageState onBoardingPageState;
  final UploadPosePageState uploadPosePageState;
  final ReviewPosesPageState reviewPosesPageState;
  final ClientPortalPageState clientPortalPageState;
  final ShareWithClientPageState shareWithClientPageState;
  final ContractsPageState contractsPageState;
  final ContractEditPageState contractEditPageState;
  final EditBrandingPageState editBrandingPageState;
  final QuestionnairesPageState questionnairesPageState;
  final NewQuestionnairePageState newQuestionnairePageState;
  final NewQuestionPageState newQuestionPageState;
  final SelectAPhotoPageState selectAPhotoPageState;
  final AnswerQuestionnairePageState answerQuestionnairePageState;

  AppState({
    @required this.newLocationPageState,
    @required this.locationsPageState,
    @required this.pricingProfilePageState,
    @required this.pricingProfilesPageState,
    @required this.newContactPageState,
    @required this.dashboardPageState,
    @required this.clientsPageState,
    @required this.clientDetailsPageState,
    @required this.jobsPageState,
    @required this.collectionsPageState,
    @required this.mainSettingsPageState,
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
    @required this.responsesPageState,
    @required this.manageSubscriptionPageState,
    @required this.libraryPoseGroupPageState,
    @required this.onBoardingPageState,
    @required this.uploadPosePageState,
    @required this.reviewPosesPageState,
    @required this.clientPortalPageState,
    @required this.shareWithClientPageState,
    @required this.contractsPageState,
    @required this.contractEditPageState,
    @required this.editBrandingPageState,
    @required this.questionnairesPageState,
    @required this.newQuestionnairePageState,
    @required this.newQuestionPageState,
    @required this.selectAPhotoPageState,
    @required this.answerQuestionnairePageState,
  });

  factory AppState.initial() {
    return AppState(
      newLocationPageState: NewLocationPageState.initial(),
      locationsPageState: LocationsPageState.initial(),
      pricingProfilePageState: NewPricingProfilePageState.initial(),
      pricingProfilesPageState: PricingProfilesPageState.initial(),
      newContactPageState: NewContactPageState.initial(),
      dashboardPageState: DashboardPageState.initial(),
      clientsPageState: ClientsPageState.initial(),
      clientDetailsPageState: ClientDetailsPageState.initial(),
      jobsPageState: JobsPageState.initial(),
      collectionsPageState: CollectionsPageState.initial(),
      mainSettingsPageState: MainSettingsPageState.initial(),
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
      responsesPageState: ResponsesPageState.initial(),
      manageSubscriptionPageState: ManageSubscriptionPageState.initial(),
      libraryPoseGroupPageState: LibraryPoseGroupPageState.initial(),
      onBoardingPageState: OnBoardingPageState.initial(),
      uploadPosePageState: UploadPosePageState.initial(),
      reviewPosesPageState: ReviewPosesPageState.initial(),
      clientPortalPageState: ClientPortalPageState.initial(),
      shareWithClientPageState: ShareWithClientPageState.initial(),
      contractsPageState: ContractsPageState.initial(),
      contractEditPageState: ContractEditPageState.initial(),
      editBrandingPageState: EditBrandingPageState.initial(),
      questionnairesPageState: QuestionnairesPageState.initial(),
      newQuestionnairePageState: NewQuestionnairePageState.initial(),
      newQuestionPageState: NewQuestionPageState.initial(),
      selectAPhotoPageState: SelectAPhotoPageState.initial(),
      answerQuestionnairePageState: AnswerQuestionnairePageState.initial(),
    );
  }

  AppState copyWith({
    NewLocationPageState newLocationPageState,
    LocationsPageState locationsPageState,
    NewPricingProfilePageState pricingProfilePageState,
    PricingProfilesPageState pricingProfilesPageState,
    NewContactPageState newContactPageState,
    DashboardPageState dashboardPageState,
    ClientsPageState clientsPageState,
    ClientDetailsPageState clientDetailsPageState,
    JobsPageState jobsPageState,
    CollectionsPageState collectionsPageState,
    MainSettingsPageState settingsPageState,
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
    ResponsesPageState responsesPageState,
    ManageSubscriptionPageState manageSubscriptionPageState,
    LibraryPoseGroupPageState libraryPoseGroupPageState,
    OnBoardingPageState onBoardingPageState,
    UploadPosePageState uploadPosePageState,
    ReviewPosesPageState reviewPosesPageState,
    ClientPortalPageState clientPortalPageState,
    ShareWithClientPageState shareWithClientPageState,
    ContractsPageState contractsPageState,
    ContractEditPageState contractEditPageState,
    EditBrandingPageState editBrandingPageState,
    QuestionnairesPageState questionnairesPageState,
    NewQuestionnairePageState newQuestionnairePageState,
    NewQuestionPageState newQuestionPageState,
    SelectAPhotoPageState selectAPhotoPageState,
    AnswerQuestionnairePageState answerQuestionnairePageState,
  }){
    return AppState(
      newLocationPageState: newLocationPageState ?? this.newLocationPageState,
      locationsPageState: locationsPageState ?? this.locationsPageState,
      pricingProfilePageState: pricingProfilePageState ?? this.pricingProfilePageState,
      pricingProfilesPageState: pricingProfilesPageState ?? this.pricingProfilesPageState,
      newContactPageState: newContactPageState ?? this.newContactPageState,
      dashboardPageState: dashboardPageState ?? this.dashboardPageState,
      clientsPageState: clientsPageState ?? this.clientsPageState,
      clientDetailsPageState: clientDetailsPageState?? this.clientDetailsPageState,
      jobsPageState: jobsPageState ?? this.jobsPageState,
      collectionsPageState: collectionsPageState ?? this.collectionsPageState,
      mainSettingsPageState: settingsPageState ?? this.mainSettingsPageState,
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
      responsesPageState: responsesPageState ?? this.responsesPageState,
      manageSubscriptionPageState: manageSubscriptionPageState ?? this.manageSubscriptionPageState,
      libraryPoseGroupPageState: libraryPoseGroupPageState ?? this.libraryPoseGroupPageState,
      onBoardingPageState: onBoardingPageState ?? this.onBoardingPageState,
      uploadPosePageState: uploadPosePageState ?? this.uploadPosePageState,
      reviewPosesPageState: reviewPosesPageState ?? this.reviewPosesPageState,
      clientPortalPageState: clientPortalPageState ?? this.clientPortalPageState,
      shareWithClientPageState: shareWithClientPageState ?? this.shareWithClientPageState,
      contractsPageState: contractsPageState ?? this.contractsPageState,
      contractEditPageState: contractEditPageState ?? this.contractEditPageState,
      editBrandingPageState: editBrandingPageState ?? this.editBrandingPageState,
      questionnairesPageState: questionnairesPageState ?? this.questionnairesPageState,
      newQuestionnairePageState: newQuestionnairePageState ?? this.newQuestionnairePageState,
      newQuestionPageState: newQuestionPageState ?? this.newQuestionPageState,
      selectAPhotoPageState: selectAPhotoPageState ?? this.selectAPhotoPageState,
      answerQuestionnairePageState: answerQuestionnairePageState ?? this.answerQuestionnairePageState,
    );
  }

  @override
  int get hashCode =>
  newLocationPageState.hashCode ^
    locationsPageState.hashCode ^
    pricingProfilePageState.hashCode ^
    pricingProfilesPageState.hashCode ^
    newContactPageState.hashCode ^
    dashboardPageState.hashCode ^
    clientsPageState.hashCode ^
    clientDetailsPageState.hashCode ^
    jobsPageState.hashCode ^
    collectionsPageState.hashCode ^
    mainSettingsPageState.hashCode ^
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
    responsesPageState.hashCode ^
    manageSubscriptionPageState.hashCode ^
    libraryPoseGroupPageState.hashCode ^
    onBoardingPageState.hashCode ^
    uploadPosePageState.hashCode ^
    reviewPosesPageState.hashCode ^
    clientPortalPageState.hashCode ^
    shareWithClientPageState.hashCode ^
    contractsPageState.hashCode ^
    contractEditPageState.hashCode ^
    questionnairesPageState.hashCode ^
    newQuestionnairePageState.hashCode ^
    newQuestionPageState.hashCode ^
    selectAPhotoPageState.hashCode ^
    answerQuestionnairePageState.hashCode ^
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
              dashboardPageState == other.dashboardPageState &&
              clientsPageState == other.clientsPageState &&
              clientDetailsPageState == other.clientDetailsPageState &&
              jobsPageState == other.jobsPageState &&
              collectionsPageState == other.collectionsPageState &&
              mainSettingsPageState == other.mainSettingsPageState &&
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
              newQuestionPageState == other.newQuestionPageState &&
              calendarSelectionPageState == other.calendarSelectionPageState &&
              incomeAndExpenseSettingsPageState == other.incomeAndExpenseSettingsPageState &&
              paymentRequestInfoPageState == other.paymentRequestInfoPageState &&
              responsesPageState == other.responsesPageState &&
              manageSubscriptionPageState == other.manageSubscriptionPageState &&
              libraryPoseGroupPageState == other.libraryPoseGroupPageState &&
              onBoardingPageState == other.onBoardingPageState &&
              uploadPosePageState == other.uploadPosePageState &&
              clientPortalPageState == other.clientPortalPageState &&
              reviewPosesPageState == other.reviewPosesPageState &&
              shareWithClientPageState == other.shareWithClientPageState &&
              contractsPageState == other.contractsPageState &&
              contractEditPageState == other.contractEditPageState &&
              questionnairesPageState == other.questionnairesPageState &&
              newQuestionnairePageState == other.newQuestionnairePageState &&
              selectAPhotoPageState == other.selectAPhotoPageState &&
              answerQuestionnairePageState == other.answerQuestionnairePageState &&
              incomeAndExpensesPageState == other.incomeAndExpensesPageState;
}