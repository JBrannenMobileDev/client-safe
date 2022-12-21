
import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensePageMiddleware.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensesPageActions.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageActions.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageMiddleware.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionActions.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionPageMiddleware.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageMiddleware.dart';
import 'package:dandylight/pages/clients_page/ClientsPageActions.dart';
import 'package:dandylight/pages/clients_page/ClientsPageMiddleware.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageMiddleware.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageActions.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageMiddleware.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageMiddleware.dart';
import 'package:dandylight/pages/job_types/JobTypesActions.dart';
import 'package:dandylight/pages/job_types/JobTypesPageMiddleware.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:dandylight/pages/jobs_page/JobsPageMiddleware.dart';
import 'package:dandylight/pages/locations_page/LocationsActions.dart';
import 'package:dandylight/pages/locations_page/LocationsPageMiddleware.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/login_page/LoginPageMiddleware.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageMiddleware.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetMiddleware.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetActions.dart' as mapLocationSelection;
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageMiddleware.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageMiddleware.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageActions.dart' as newJobPageActions;
import 'package:dandylight/pages/new_job_page/NewJobPageMiddleware.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageActions.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobReminderPageMiddleware.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypeActions.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypePageMiddleware.dart';
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart' as prefix2;
import 'package:dandylight/pages/new_location_page/NewLocationPageMiddleware.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageMiddleware.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpenseActions.dart' as mileageActions;
import 'package:dandylight/pages/new_pose_group_page/NewPoseGroupActions.dart';
import 'package:dandylight/pages/new_pose_group_page/NewPoseGroupPageMiddleware.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart' as prefix0;
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageMiddleware.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpenseActions.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageMiddleware.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderActions.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageMiddleware.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpenseActions.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageMiddleware.dart';
import 'package:dandylight/pages/onboarding_flow_pages/OnBoardingFlowPageActions.dart';
import 'package:dandylight/pages/onboarding_flow_pages/OnBoardingFlowPageMiddleware.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageMiddleware.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageActions.dart' as paymentLinks;
import 'package:dandylight/pages/pose_group_page/PoseGroupActions.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageMiddleware.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/pages/poses_page/PosesActions.dart';
import 'package:dandylight/pages/poses_page/PosesPageMiddleware.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart' as prefix1;
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageMiddleware.dart';
import 'package:dandylight/pages/reminders_page/RemindersActions.dart' as collectionReminders;
import 'package:dandylight/pages/reminders_page/RemindersPageMiddleware.dart';
import 'package:dandylight/pages/responses_page/ResponsesActions.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageMiddleware.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageActions.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageMiddleware.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware() {
  List<Middleware<AppState>> middlewareList = [];
  middlewareList.add(TypedMiddleware<AppState, FetchClientData>(ClientsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewContactAction>(NewContactPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, InitializeClientDetailsAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteClientAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, InstagramSelectedAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, OnSaveLeadSourceUpdateAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNotesAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchClientDetailsResponsesAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveImportantDatesAction>(ClientDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.FetchAllAction>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SavePricingProfileAction>(NewPricingProfilePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchPricingProfilesAction>(PricingProfilesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix0.DeletePriceProfileAction>(NewPricingProfilePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix1.DeletePriceProfileAction>(PricingProfilesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchLocationsAction>(LocationsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix2.SaveLocationAction>(NewLocationPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix2.FetchGoogleLocationsAction>(NewLocationPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix2.FetchSearchLocationDetails>(NewLocationPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, prefix2.DeleteLocation>(NewLocationPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DrivingDirectionsSelected>(LocationsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, ShareLocationSelected>(LocationsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.FetchTimeOfSunsetAction>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.UpdateWithNewPricePackageAction>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.UpdateWithNewJobTypeAction>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.SaveNewJobAction>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadJobsAction>(DashboardPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SetNotificationToSeen>(DashboardPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateNotificationIconAction>(DashboardPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateProfileWithShowcaseSeen>(DashboardPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, GetDeviceContactsAction>(NewContactPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchJobsAction>(JobsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchAllCalendarJobsAction>(CalendarPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchDeviceEvents>(CalendarPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.SetSelectedDateAction>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.SetSelectedLocation>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveStageCompleted>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UndoStageAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteJobAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SetJobInfo>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SetJobInfoWithJobDocumentId>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, JobInstagramSelectedAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchTimeOfSunsetJobAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateJobTimeAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateJobEndTimeAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateJobDateAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchJobsForDateSelection>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchJobDetailsLocationsAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateNewLocationAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveJobNameChangeAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveUpdatedJobTypeAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveTipChangeAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchJobDetailsPricePackagesAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveUpdatedPricePackageAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchAllInvoiceJobsAction>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveAddOnCostAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewLineItemAction>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewDiscountAction>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteDiscountAction>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateDepositStatusAction>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, GenerateInvoicePdfAction>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewInvoiceAction>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateJobOnInvoiceSent>(NewInvoicePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadAllInvoicesAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, InvoiceEditSelected>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteInvoiceAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, OnInvoiceSentAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadAllJobsAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveTipIncomeChangeAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchSingleExpenses>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchRecurringExpenses>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateSelectedRecurringChargeAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveCancelledSubscriptionAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveResumedSubscriptionAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SetPaymentRequestAsSeen>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SetIncomeInfoSeenAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchMileageExpenses>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateSelectedYearAction>(IncomeAndExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, OnDeleteInvoiceSelectedAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, InvoiceSentAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SetLastKnowPosition>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchDataForSelectedDateAction>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, OnLocationSavedAction>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveCurrentMapLatLngAction>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchGoogleLocationsAction>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchSearchLocationDetails>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadLocationImageFilesAction>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadInitialLocationAndDateComingFromNewJobAction>(SunsetWeatherPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveSingleExpenseProfileAction>(NewSingleExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteSingleExpenseAction>(NewSingleExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveRecurringExpenseProfileAction>(NewRecurringExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteRecurringExpenseAction>(NewRecurringExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.FetchLastKnowPosition>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.UpdateStartLocationAction>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.UpdateEndLocationAction>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.LoadExistingMileageExpenseAction>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.SaveMileageExpenseProfileAction>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.DeleteMileageExpenseAction>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.SaveHomeLocationAction>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mileageActions.LoadNewMileageLocationsAction>(NewMileageExpensePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mapLocationSelection.SetLastKnowPosition>(MapLocationSelectionWidgetMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mapLocationSelection.FetchGoogleLocationsAction>(MapLocationSelectionWidgetMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, mapLocationSelection.FetchSearchLocationDetails>(MapLocationSelectionWidgetMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, CreateAccountAction>(LoginPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, CheckForCurrentUserAction>(LoginPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, ResendEmailVerificationAction>(LoginPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, ResetPasswordAction>(LoginPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoginAction>(LoginPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadSettingsFromProfile>(MainSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SavePushNotificationSettingAction>(MainSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveCalendarSettingAction>(MainSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveUpdatedUserProfileAction>(MainSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, RemoveDeviceTokenAction>(MainSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SendSuggestionAction>(MainSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteAccountAction>(MainSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewReminderAction>(NewReminderPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteReminderAction>(NewReminderPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteReminderFromJobAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchJobDetailsDeviceEvents>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchAllJobTypesAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, collectionReminders.FetchRemindersAction>(RemindersPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, collectionReminders.DeleteReminderAction>(RemindersPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchAllRemindersAction>(NewJobReminderPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchJobRemindersAction>(JobDetailsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewJobReminderAction>(NewJobReminderPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.FetchNewJobDeviceEvents>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, newJobPageActions.SetLastKnowInitialPosition>(NewJobPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewJobTypeAction>(NewJobTypePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteJobTypeAction>(NewJobTypePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadPricesPackagesAndRemindersAction>(NewJobTypePageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchJobTypesAction>(JobTypesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchPoseGroupsAction>(PosesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveAction>(NewPoseGroupPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeletePoseAction>(PoseGroupPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeletePoseGroupSelected>(PoseGroupPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SharePosesAction>(PoseGroupPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SavePosesToGroupAction>(PoseGroupPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadPoseImagesFromStorage>(PoseGroupPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteSelectedPoses>(PoseGroupPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchWritableCalendars>(CalendarSelectionPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveSelectedAction>(CalendarSelectionPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadPaymentSettingsFromProfile>(IncomeAndExpenseSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveZelleFullNameInput>(IncomeAndExpenseSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveZellePhoneEmailInput>(IncomeAndExpenseSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveVenmoInput>(IncomeAndExpenseSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveCashAppInput>(IncomeAndExpenseSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveApplePayInput>(IncomeAndExpenseSettingsPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, paymentLinks.LoadPaymentSettingsFromProfile>(PaymentRequestInfoPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, paymentLinks.SaveZelleFullNameInput>(PaymentRequestInfoPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, paymentLinks.SaveZellePhoneEmailInput>(PaymentRequestInfoPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, paymentLinks.SaveVenmoInput>(PaymentRequestInfoPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, paymentLinks.SaveCashAppInput>(PaymentRequestInfoPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, paymentLinks.SaveApplePayInput>(PaymentRequestInfoPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveTermsAndPrivacyStateAction>(OnBoardingFlowPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, LoadSettingsFromProfileOnBoarding>(OnBoardingFlowPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SavePushNotificationSettingActionOnBoarding>(OnBoardingFlowPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveCalendarSettingActionOnBoarding>(OnBoardingFlowPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, FetchResponsesAction>(ResponsesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, UpdateResponseAction>(ResponsesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, SaveNewResponseAction>(ResponsesPageMiddleware()));
  middlewareList.add(TypedMiddleware<AppState, DeleteResponseAction>(ResponsesPageMiddleware()));
  return middlewareList;
}