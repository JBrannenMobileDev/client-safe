import 'dart:async';
import 'dart:collection';

import 'package:dandylight/data_layer/local_db/shared_preferences/DandylightSharedPrefs.dart';
import 'package:dandylight/data_layer/mappers/JobToEventMapper.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:device_calendar/device_calendar.dart';

import '../data_layer/local_db/daos/JobDao.dart';
import '../data_layer/local_db/daos/ProfileDao.dart';
import 'UidUtil.dart';

class CalendarSyncUtil {
  static Future<List<Event>> getDeviceEventsForDateRange(
      DateTime startDate, DateTime endDate) async {
    List<Event> events = [];
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      return _getAllEvents(
          calendarsResult, _deviceCalendarPlugin, startDate, endDate);
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
    List<Calendar> allCalendars = calendarsResult.data != null ? calendarsResult.data!.toList(growable: false) : [];
    List<Calendar> calendars = [];

    for (Calendar calendar in allCalendars) {
      if (calendar.accountType != 'Birthdays') calendars.add(calendar);
    }

    for (Calendar calendar in calendars) {
      RetrieveEventsParams params = RetrieveEventsParams(startDate: startDate, endDate: endDate);
      List<Event>? eventsForCalendar = (await deviceCalendarPlugin.retrieveEvents(calendar.id, params))
              .data!
              .toList(growable: false);
      if(eventsForCalendar.isNotEmpty) {
        events.addAll(eventsForCalendar);
      }
    }

    List<Event> eventsNoDuplicates = [];
    if(events.isNotEmpty) {
      eventsNoDuplicates.add(events.elementAt(0));
      for (Event event in events) {
        if (!eventsNoDuplicates.contains(event)) eventsNoDuplicates.add(event);
      }
    }

    return eventsNoDuplicates;
  }

  static void removeJobsFromDeviceCalendars() async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      List<dynamic> calendarsIds = (await ProfileDao.getMatchingProfile(UidUtil().getUid()))!.calendarIdsToSync!.toList();
      List<String> calendarsToSync = List<String>.from(calendarsIds);
      List<Job> unfinishedJobs = await getUnfinishedJobs();

      for (String calendarId in calendarsToSync) {
        for (Job job in unfinishedJobs) {
          Event event = await JobToEventMapper.map(
              job,
              calendarId,
              await DandylightSharedPrefs.getEventIdByJobAndCalendar(
                  job.documentId!, calendarId));
          if (event.eventId!.isNotEmpty) {
            await _deviceCalendarPlugin.deleteEvent(
                event.calendarId, event.eventId);
          }
        }
      }
      DandylightSharedPrefs.deleteAllEvents();
    } catch (e) {
      print(e);
    }
  }

  static void syncJobsToDeviceCalendars() async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      List<dynamic> calendarsIds = (await ProfileDao.getMatchingProfile(UidUtil().getUid()))!.calendarIdsToSync!.toList();
      List<String> calendarsToSync = List<String>.from(calendarsIds);

      List<Job> unfinishedJobs = await getUnfinishedJobs();

      for (String calendarId in calendarsToSync) {
        for (Job job in unfinishedJobs) {
          if(job.selectedTime != null && job.selectedDate != null){
            Event event = await JobToEventMapper.map(job, calendarId, await DandylightSharedPrefs.getEventIdByJobAndCalendar(job.documentId!, calendarId));
            final createEventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
            if (createEventResult!.isSuccess && (createEventResult.data?.isNotEmpty ?? false)) {
              String eventId = createEventResult.data!;
              DandylightSharedPrefs.saveEventId(
                  eventId, calendarId, job.documentId);
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Job>> getUnfinishedJobs() async {
    List<Job>? allJobs = await JobDao.getAllJobs();
    List<Job> unfinishedJobs = [];
    DateTime now = DateTime.now();

    for (Job job in allJobs!) {
      if (job.selectedDate!.isAfter(now)) {
        unfinishedJobs.add(job);
      }
    }
    return unfinishedJobs;
  }

  static List<Calendar> _getWritableCalendars(Result<UnmodifiableListView<Calendar>> calendarsResult) {
    List<Calendar> allCalendars = calendarsResult.data!.toList(growable: false);
    List<Calendar> writableCalendars = [];
    for (Calendar calendar in allCalendars) {
      if (!calendar.isReadOnly!) {
        writableCalendars.add(calendar);
      }
    }
    return writableCalendars;
  }

  static Future<List<Calendar>> getWritableCalendars() async {
    List<Calendar> writableCalendars = [];
    try{
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

      List<Calendar> allCalendars = calendarsResult.data!.toList(growable: false);
      for (Calendar calendar in allCalendars) {
        if (!calendar.isReadOnly!) {
          writableCalendars.add(calendar);
        }
      }
    } catch (e) {
      print(e);
    }
    return writableCalendars;
  }

  static void insertJobEvent(Job job) async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      List<dynamic> calendarsIds = (await ProfileDao.getMatchingProfile(UidUtil().getUid()))!.calendarIdsToSync!.toList();
      List<String> calendarsToSync = List<String>.from(calendarsIds);

      for (String calendarId in calendarsToSync) {
        Event event = await JobToEventMapper.map(
            job,
            calendarId,
            await DandylightSharedPrefs.getEventIdByJobAndCalendar(
                job.documentId!, calendarId));
        final createEventResult =
            await _deviceCalendarPlugin.createOrUpdateEvent(event);
        if (createEventResult!.isSuccess &&
            (createEventResult.data?.isNotEmpty ?? false)) {
          String eventId = createEventResult.data!;
          DandylightSharedPrefs.saveEventId(
              eventId, calendarId, job.documentId);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static void updateJobEvent(Job job) async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      Profile? profile = (await ProfileDao.getMatchingProfile(UidUtil().getUid()));
      List<dynamic> calendarsIds = [];
      if(profile!.calendarIdsToSync != null) {
        calendarsIds = profile.calendarIdsToSync!.toList();
      }
      List<String> calendarsToSync = calendarsIds.length > 0 ? List<String>.from(calendarsIds) : [];

      for (String calendarId in calendarsToSync) {
        Event event = await JobToEventMapper.map(
            job,
            calendarId,
            await DandylightSharedPrefs.getEventIdByJobAndCalendar(job.documentId!, calendarId));
        final createEventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
        if (createEventResult!.isSuccess && (createEventResult!.data?.isNotEmpty ?? false)) {
          String eventId = createEventResult.data!;
          DandylightSharedPrefs.saveEventId(eventId, calendarId, job.documentId);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static void deleteJobEvent(Job job) async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      List<dynamic> calendarsIds = (await ProfileDao.getMatchingProfile(UidUtil().getUid()))!.calendarIdsToSync!.toList();
      List<String> calendarsToSync = List<String>.from(calendarsIds);

      for (String calendarId in calendarsToSync) {
        Event event = await JobToEventMapper.map(
            job,
            calendarId,
            await DandylightSharedPrefs.getEventIdByJobAndCalendar(job.documentId!, calendarId));
        final deleteEventResult = await _deviceCalendarPlugin.deleteEvent(calendarId, event.eventId);
        if (deleteEventResult.isSuccess && deleteEventResult.data!) {
          DandylightSharedPrefs.deleteEvent(job.documentId!);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
