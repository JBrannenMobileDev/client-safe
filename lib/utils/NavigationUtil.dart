import 'package:client_safe/models/RecurringExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/RecurringExpenseDetails.dart';
import 'package:client_safe/pages/calendar_page/CalendarPage.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPage.dart';
import 'package:client_safe/pages/home_page/HomePage.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPage.dart';
import 'package:client_safe/pages/map_location_selection_widget/MapLocationSelectionWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  static void onSuccessfulLogin(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => HomePage()));
  }
}




