import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensePageReducer.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageReducer.dart';
import 'package:dandylight/pages/calendar_selection_page/CalendarSelectionPageReducer.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageReducer.dart';
import 'package:dandylight/pages/clients_page/ClientsPageReducer.dart';
import 'package:dandylight/pages/collections_page/CollectionsPageReducer.dart';
import 'package:dandylight/pages/contract_edit_page/ContractEditPageReducer.dart';
import 'package:dandylight/pages/contracts_page/ContractsPageReducer.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageReducer.dart';
import 'package:dandylight/pages/edit_branding_page/EditBrandingPageReducer.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageReducer.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsReducer.dart';
import 'package:dandylight/pages/jobs_page/JobsPageReducer.dart';
import 'package:dandylight/pages/locations_page/LocationsPageReducer.dart';
import 'package:dandylight/pages/login_page/LoginPageReducer.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageReducer.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageReducer.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetReducer.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageReducer.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageReducer.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageReducer.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobRemnderPageReducer.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypePageReducer.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageReducer.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageReducer.dart';
import 'package:dandylight/pages/new_pose_group_page/NewPoseGroupPageReducer.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageReducer.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageReducer.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageReducer.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageReducer.dart';
import 'package:dandylight/pages/onboarding/OnBoardingPageReducer.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageReducer.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageReducer.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageReducer.dart';
import 'package:dandylight/pages/poses_page/PosesPageReducer.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageReducer.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageReducer.dart';
import 'package:dandylight/pages/job_types/JobTypesPageReducer.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageReducer.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesPageReducer.dart';
import 'package:dandylight/pages/share_with_client_page/ShareWithClientPageReducer.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageReducer.dart';
import 'package:dandylight/pages/upload_pose_page/UploadPosePageReducer.dart';
import 'package:dandylight/web/pages/ClientPortalPageReducer.dart';

AppState appReducers(AppState state, dynamic action) =>
    AppState(
        newLocationPageState: locationReducer(state.newLocationPageState, action),
        locationsPageState: locationsReducer(state.locationsPageState, action),
        pricingProfilePageState: newPricingProfilePageReducer(state.pricingProfilePageState, action),
        pricingProfilesPageState: pricingProfilesReducer(state.pricingProfilesPageState, action),
        newJobPageState: newJobPageReducer(state.newJobPageState, action),
        newContactPageState: newContactPageReducer(state.newContactPageState, action),
        dashboardPageState: dashboardPageReducer(state.dashboardPageState, action),
        clientsPageState: clientsPageReducer(state.clientsPageState, action),
        clientDetailsPageState: clientDetailsPageReducer(state.clientDetailsPageState, action),
        jobsPageState: jobsPageReducer(state.jobsPageState, action),
        collectionsPageState: collectionsPageReducer(state.collectionsPageState, action),
        mainSettingsPageState: mainSettingsPageReducer(state.mainSettingsPageState, action),
        calendarPageState: calendarPageReducer(state.calendarPageState, action),
        jobDetailsPageState: jobDetailsReducer(state.jobDetailsPageState, action),
        newInvoicePageState: newInvoicePageReducer(state.newInvoicePageState, action),
        incomeAndExpensesPageState: incomeAndExpensesPageReducer(state.incomeAndExpensesPageState, action),
        sunsetWeatherPageState: sunsetWeatherPageReducer(state.sunsetWeatherPageState, action),
        newSingleExpensePageState: newSingleExpensePageReducer(state.newSingleExpensePageState, action),
        newRecurringExpensePageState: newRecurringExpensePageReducer(state.newRecurringExpensePageState, action),
        newMileageExpensePageState: newMileageExpensePageReducer(state.newMileageExpensePageState, action),
        mapLocationSelectionWidgetState: mapLocationSelectionWidgetReducer(state.mapLocationSelectionWidgetState, action),
        loginPageState: loginPageReducer(state.loginPageState, action),
        remindersPageState: remindersReducer(state.remindersPageState, action),
        newReminderPageState: newReminderPageReducer(state.newReminderPageState, action),
        newJobReminderPageState: newJobReminderPageReducer(state.newJobReminderPageState, action),
        jobTypesPageState: jobTypesPageReducer(state.jobTypesPageState, action),
        newJobTypePageState: newJobTypePageReducer(state.newJobTypePageState, action),
        posesPageState: posesReducer(state.posesPageState, action),
        newPoseGroupPageState: newPoseGroupReducer(state.newPoseGroupPageState, action),
        poseGroupPageState: poseGroupReducer(state.poseGroupPageState, action),
        calendarSelectionPageState: calendarSelectionPageReducer(state.calendarSelectionPageState, action),
        incomeAndExpenseSettingsPageState: incomeAndExpenseSettingsPageReducer(state.incomeAndExpenseSettingsPageState, action),
        paymentRequestInfoPageState: paymentRequestInfoPageReducer(state.paymentRequestInfoPageState, action),
        responsesPageState: responsesReducer(state.responsesPageState, action),
        manageSubscriptionPageState: manageSubscriptionPageReducer(state.manageSubscriptionPageState, action),
        libraryPoseGroupPageState: libraryPoseGroupReducer(state.libraryPoseGroupPageState, action),
        onBoardingPageState: onBoardingReducer(state.onBoardingPageState, action),
        uploadPosePageState: uploadPoseReducer(state.uploadPosePageState, action),
        reviewPosesPageState: reviewPosesReducer(state.reviewPosesPageState, action),
        clientPortalPageState: clientPortalReducer(state.clientPortalPageState, action),
        shareWithClientPageState: shareWithClientReducer(state.shareWithClientPageState, action),
        contractsPageState: contractsReducer(state.contractsPageState, action),
        contractEditPageState: contractEditReducer(state.contractEditPageState, action),
        editBrandingPageState: editBrandingReducer(state.editBrandingPageState, action),
    );
