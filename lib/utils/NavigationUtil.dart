import 'package:client_safe/models/RecurringExpense.dart';
import 'package:client_safe/pages/IncomeAndExpenses/RecurringExpenseDetails.dart';
import 'package:client_safe/pages/calendar_page/CalendarPage.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPage.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPage.dart';
import 'package:client_safe/pages/new_mileage_expense/SelectStartLocationMapPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  static onAddStartLocationSelected(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => SelectStartLocationMapPage()));
  }
}




