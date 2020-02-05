import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/calendar_page/CalendarPageReducer.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPageReducer.dart';
import 'package:client_safe/pages/clients_page/ClientsPageReducer.dart';
import 'package:client_safe/pages/collections_page/CollectionsPageReducer.dart';
import 'package:client_safe/pages/dashboard_page/DashboardPageReducer.dart';
import 'package:client_safe/pages/home_page/HomePageReducer.dart';
import 'package:client_safe/pages/jobs_page/JobsPageReducer.dart';
import 'package:client_safe/pages/locations_page/LocationsPageReducer.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageReducer.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageReducer.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageReducer.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageReducer.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageReducer.dart';
import 'package:client_safe/pages/search_page/SearchPageReducer.dart';
import 'package:client_safe/pages/settings_page/SettingsPageReducer.dart';

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
        settingsPageState: settingsPageReducer(state.settingsPageState, action),
        searchPageState: searchPageReducer(state.searchPageState, action),
        calendarPageState: calendarPageReducer(state.calendarPageState, action),
    );
