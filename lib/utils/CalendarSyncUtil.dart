import 'dart:async';

import 'package:device_calendar/device_calendar.dart';

class CalendarSyncUtil {

  static getDeviceCalendars() async{
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      return calendarsResult?.data;
    } catch (e) {
      print(e);
    }
  }
}