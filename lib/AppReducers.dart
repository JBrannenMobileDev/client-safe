import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/IncomeAndExpenses/IncomeAndExpensePageReducer.dart';
import 'package:dandylight/pages/calendar_page/CalendarPageReducer.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageReducer.dart';
import 'package:dandylight/pages/clients_page/ClientsPageReducer.dart';
import 'package:dandylight/pages/collections_page/CollectionsPageReducer.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageReducer.dart';
import 'package:dandylight/pages/home_page/HomePageReducer.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsReducer.dart';
import 'package:dandylight/pages/jobs_page/JobsPageReducer.dart';
import 'package:dandylight/pages/locations_page/LocationsPageReducer.dart';
import 'package:dandylight/pages/login_page/LoginPageReducer.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageReducer.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidgetReducer.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageReducer.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageReducer.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageReducer.dart';
import 'package:dandylight/pages/new_job_reminder/NewJobRemnderPageReducer.dart';
import 'package:dandylight/pages/new_job_types_page/NewJobTypePageReducer.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageReducer.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageReducer.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageReducer.dart';
import 'package:dandylight/pages/new_recurring_expense/NewRecurringExpensePageReducer.dart';
import 'package:dandylight/pages/new_reminder_page/NewReminderPageReducer.dart';
import 'package:dandylight/pages/new_single_expense_page/NewSingleExpensePageReducer.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesPageReducer.dart';
import 'package:dandylight/pages/reminders_page/RemindersPageReducer.dart';
import 'package:dandylight/pages/job_types/JobTypesPageReducer.dart';
import 'package:dandylight/pages/search_page/SearchPageReducer.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageReducer.dart';

AppState appReducers(AppState state, dynamic action) =>
    AppState(
        newLocationPageState: locationReducer(state.newLocationPageState, action),
        locationsPageState: locationsReducer(state.locationsPageState, action),
        pricingProfilePageState: newPricingProfilePageReducer(state.pricingProfilePageState, action),
        pricingProfilesPageState: pricingProfilesReducer(state.pricingProfilesPageState, action),
        newJobPageState: newJobPageReducer(state.newJobPageState, action),
        newContactPageState: newContactPageReducer(state.newContactPageState, action),
        homePageState: homePageReducer(state.homePageState, action),
        dashboardPageState: dashboardPageReducer(state.dashboardPageState, action),
        clientsPageState: clientsPageReducer(state.clientsPageState, action),
        clientDetailsPageState: clientDetailsPageReducer(state.clientDetailsPageState, action),
        jobsPageState: jobsPageReducer(state.jobsPageState, action),
        collectionsPageState: collectionsPageReducer(state.collectionsPageState, action),
        mainSettingsPageState: mainSettingsPageReducer(state.mainSettingsPageState, action),
        searchPageState: searchPageReducer(state.searchPageState, action),
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
    );
