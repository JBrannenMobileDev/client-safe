import 'package:client_safe/pages/calendar_page/CalendarPage.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPage.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPage.dart';
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
}




