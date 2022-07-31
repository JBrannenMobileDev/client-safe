import 'dart:async';
import 'dart:collection';

import 'package:dandylight/models/Job.dart';
import 'package:device_calendar/device_calendar.dart';

import '../data_layer/local_db/daos/ProfileDao.dart';
import '../models/Profile.dart';
import 'UidUtil.dart';

class CalendarSyncUtil {

  static void addCalendarEvent(Job job) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile.calendarEnabled) {

    }
  }

  static Future<List<Event>> getDeviceEventsForDateRange(DateTime startDate, DateTime endDate) async{
    List<Event> events = [];
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return events;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

      return _getAllEvents(calendarsResult, _deviceCalendarPlugin, startDate, endDate);
    } catch (e) {
      print(e);
    }
    return events;
  }

  static Future<List<Event>> _getAllEvents(
      Result<UnmodifiableListView<Calendar>> calendarsResult,
      DeviceCalendarPlugin deviceCalendarPlugin,
      DateTime startDate,
      DateTime endDate) async {

    List<Event> events = [];
    List<Calendar> calendars = calendarsResult.data.toList(growable: false);

    for(Calendar calendar in calendars) {
      RetrieveEventsParams params = RetrieveEventsParams(startDate: startDate, endDate: endDate);
      List<Event> eventsForCalendar = (await deviceCalendarPlugin.retrieveEvents(calendar.id, params)).data.toList(growable: false);
      events.addAll(eventsForCalendar);
    }

    return events;
  }
}