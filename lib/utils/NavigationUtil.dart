import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RecurringExpenseDetails.dart';
import 'package:dandylight/pages/calendar_page/CalendarPage.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPage.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobListPage.dart';
import 'package:dandylight/pages/home_page/HomePage.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPage.dart';
import 'package:dandylight/pages/login_page/LoginPage.dart';
import 'package:dandylight/pages/main_settings_page/EditAccountPage.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPage.dart';
import 'package:dandylight/pages/main_settings_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/Job.dart';
import '../pages/dashboard_page/DashboardPageState.dart';

class NavigationUtil {
  static onClientTapped(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ClientDetailsPage()));
  }
  static onJobTapped(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => JobDetailsPage()));
  }
  static onCalendarSelected(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => CalendarPage()));
  }
  static onRecurringChargeSelected(BuildContext context, RecurringExpense recurringExpense) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => RecurringExpenseDetailsPage(recurringExpense)));
  }
  static onSelectMapLocation(BuildContext context, Function(LatLng) onLocationSaved, double lat, double lng) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => MapLocationSelectionWidget(onLocationSaved, lat, lng)));
  }
  static onSignOutSelected(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => LoginPage()));
  }
  static onMainSettingsSelected(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => MainSettingsPage()));
  }
  static onEditProfileSelected(BuildContext context, Profile profile) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => EditAccountPage(profile)));
  }
  static onManageSubscriptionSelected(BuildContext context, Profile profile) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ManageSubscriptionPage(profile)));
  }
  static onStageStatsSelected(BuildContext context, DashboardPageState pageState, List<Job> jobs, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobListPage(pageState: pageState, jobs: jobs, pageTitle: title,)));
  }

  static void onSuccessfulLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (context, animation1, animation2) => HomePage(),
      ),
    );
  }
}




