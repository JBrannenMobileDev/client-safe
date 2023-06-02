import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/RecurringExpense.dart';
import 'package:dandylight/pages/IncomeAndExpenses/RecurringExpenseDetails.dart';
import 'package:dandylight/pages/calendar_page/CalendarPage.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPage.dart';
import 'package:dandylight/pages/client_details_page/JobHistoryListPage.dart';
import 'package:dandylight/pages/dashboard_page/widgets/JobListPage.dart';
import 'package:dandylight/pages/dashboard_page/widgets/ReminderNotificationsPage.dart';
import 'package:dandylight/pages/home_page/HomePage.dart';
import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPage.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPage.dart';
import 'package:dandylight/pages/job_details_page/JobPosesPage.dart';
import 'package:dandylight/pages/login_page/LoginPage.dart';
import 'package:dandylight/pages/main_settings_page/EditAccountPage.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPage.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/map_location_selection_widget/MapLocationSelectionWidget.dart';
import 'package:dandylight/pages/onboarding/OnBoardingPage.dart';
import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPage.dart';
import 'package:dandylight/pages/poses_page/PosesSearchPage.dart';
import 'package:dandylight/pages/subscribe_now_page/SubscribeNowPage.dart';
import 'package:dandylight/pages/upload_pose_page/UploadPosePage.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../models/Job.dart';
import '../models/JobStage.dart';
import '../models/Location.dart';
import '../pages/dashboard_page/DashboardPageState.dart';
import '../pages/poses_page/PosesPage.dart';

class NavigationUtil {
  static onShowSubscribeNowPage(BuildContext context) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => SubscribeNowPage(profile: profile,)));
  }
  static onClientTapped(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ClientDetailsPage()));
  }
  static onJobTapped(BuildContext context, bool comingFromOnBoarding) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => JobDetailsPage(comingFromOnBoarding: comingFromOnBoarding,)));
  }
  static onCalendarSelected(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => CalendarPage()));
  }
  static onRecurringChargeSelected(BuildContext context, RecurringExpense recurringExpense) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => RecurringExpenseDetailsPage(recurringExpense)));
  }
  static onSelectMapLocation(BuildContext context, Function(LatLng) onLocationSaved, double lat, double lng, Function(Location) saveSelectedLocation) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => MapLocationSelectionWidget(onLocationSaved, lat, lng, saveSelectedLocation)));
  }
  static onSignOutSelected(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => LoginPage()));
  }
  static onMainSettingsSelected(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => MainSettingsPage()));
  }
  static onIncomeAndExpenseSettingsSelected(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => IncomeAndExpenseSettingsPage()));
  }
  static onPaymentRequestInfoSelected(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => PaymentRequestInfoPage()));
  }
  static onEditProfileSelected(BuildContext context, Profile profile) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => EditAccountPage(profile)));
  }
  static onManageSubscriptionSelected(BuildContext context, Profile profile) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => ManageSubscriptionPage(profile)));
  }
  static onStageStatsSelected(BuildContext context, DashboardPageState pageState, String title, JobStage stage, bool isActiveJobs) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobListPage(pageState: pageState, pageTitle: title, stage: stage, isActiveJobs: isActiveJobs)));
  }
  static onJobHistorySelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobHistoryListPage()));
  }
  static onReminderNotificationItemSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailsPage(comingFromOnBoarding: false)));
  }
  static onNotificationsSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReminderNotificationsPage()));
  }
  static onJobPosesSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobPosesPage()));
  }
  static onUploadPoseSelected(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => UploadPosePage()));
  }
  static onPosesSelected(BuildContext context, Job job, bool comingFromJobDetails) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PosesPage(job, comingFromJobDetails)));
  }
  static onSearchPosesSelected(BuildContext context, Job job, bool comingFromJobDetails) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PosesSearchPage(job, comingFromJobDetails)));
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

  static void onShowOnBoarding(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (context, animation1, animation2) => OnBoardingPage(),
      ),
    );
  }
}




