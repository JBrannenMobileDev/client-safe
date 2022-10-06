import 'dart:async';
import 'dart:collection';

import 'package:dandylight/data_layer/local_db/shared_preferences/DandylightSharedPrefs.dart';
import 'package:dandylight/data_layer/mappers/JobToEventMapper.dart';
import 'package:dandylight/models/Job.dart';
import 'package:device_calendar/device_calendar.dart';

import '../data_layer/local_db/daos/JobDao.dart';
import '../data_layer/local_db/daos/ProfileDao.dart';
import '../models/Profile.dart';
import 'UidUtil.dart';

class CalendarSyncUtil {
  static Future<List<Event>> getDeviceEventsForDateRange(
      DateTime startDate, DateTime endDate) async {
    List<Event> events = [];
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return events;
        } else {
          Profile profile = (await ProfileDao.getAll()).elementAt(0);
          profile.calendarEnabled = true;
          await ProfileDao.update(profile);
        }
      }

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
    List<Calendar> allCalendars = calendarsResult.data.toList(growable: false);
    List<Calendar> calendars = [];

    for (Calendar calendar in allCalendars) {
      if (calendar.accountType != 'Birthdays') calendars.add(calendar);
    }

    for (Calendar calendar in calendars) {
      RetrieveEventsParams params =
          RetrieveEventsParams(startDate: startDate, endDate: endDate);
      List<Event> eventsForCalendar =
          (await deviceCalendarPlugin.retrieveEvents(calendar.id, params))
              .data
              .toList(growable: false);
      events.addAll(eventsForCalendar);
    }

    List<Event> eventsNoDuplicates = [];
    eventsNoDuplicates.add(events.elementAt(0));
    for (Event event in events) {
      if (!eventsNoDuplicates.contains(event)) eventsNoDuplicates.add(event);
    }

    return eventsNoDuplicates;
  }

  static void insertOrUpdateCalendarEvent(Job job) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if (profile.calendarEnabled) {}
  }

  static void removeJobsFromDeviceCalendars() async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          //do nothing. no permission granted.
        } else {
          Profile profile = (await ProfileDao.getAll()).elementAt(0);
          profile.calendarEnabled = true;
          await ProfileDao.update(profile);
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      List<Calendar> writableCalendars = getWritableCalendars(calendarsResult);
      List<Job> unfinishedJobs = await getUnfinishedJobs();

      for (Calendar calendar in writableCalendars) {
        for (Job job in unfinishedJobs) {
          Event event = await JobToEventMapper.map(
              job,
              calendar.id,
              await DandylightSharedPrefs.getEventIdByJobAndCalendar(
                  job.documentId, calendar.id));
          if (event.eventId.isNotEmpty) {
            await _deviceCalendarPlugin.deleteEvent(
                event.calendarId, event.eventId);
          }
        }
      }
      await DandylightSharedPrefs.deleteAllEvents();
    } catch (e) {
      print(e);
    }
  }

  static void syncJobsToDeviceCalendars() async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          //do nothing. no permission granted.
        } else {
          Profile profile = (await ProfileDao.getAll()).elementAt(0);
          profile.calendarEnabled = true;
          await ProfileDao.update(profile);
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      List<Calendar> writableCalendars = getWritableCalendars(calendarsResult);
      List<Job> unfinishedJobs = await getUnfinishedJobs();

      for (Calendar calendar in writableCalendars) {
        for (Job job in unfinishedJobs) {
          Event event = await JobToEventMapper.map(
              job,
              calendar.id,
              await DandylightSharedPrefs.getEventIdByJobAndCalendar(
                  job.documentId, calendar.id));
          final createEventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
          if (createEventResult.isSuccess &&
              (createEventResult.data?.isNotEmpty ?? false)) {
            String eventId = createEventResult.data;
            await DandylightSharedPrefs.saveEventId(
                eventId, calendar.id, job.documentId);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Job>> getUnfinishedJobs() async {
    List<Job> allJobs = await JobDao.getAllJobs();
    List<Job> unfinishedJobs = [];
    DateTime now = DateTime.now();

    for (Job job in allJobs) {
      if (job.selectedDate.isAfter(now)) {
        unfinishedJobs.add(job);
      }
    }
    return unfinishedJobs;
  }

  static List<Calendar> getWritableCalendars(
      Result<UnmodifiableListView<Calendar>> calendarsResult) {
    List<Calendar> allCalendars = calendarsResult.data.toList(growable: false);
    List<Calendar> writableCalendars = [];
    for (Calendar calendar in allCalendars) {
      if (!calendar.isReadOnly) {
        writableCalendars.add(calendar);
      }
    }
    return writableCalendars;
  }

  static void insertJobEvent(Job job) async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          //do nothing. no permission granted.
        } else {
          Profile profile = (await ProfileDao.getAll()).elementAt(0);
          profile.calendarEnabled = true;
          await ProfileDao.update(profile);
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      List<Calendar> writableCalendars = getWritableCalendars(calendarsResult);

      for (Calendar calendar in writableCalendars) {
        Event event = await JobToEventMapper.map(
            job,
            calendar.id,
            await DandylightSharedPrefs.getEventIdByJobAndCalendar(
                job.documentId, calendar.id));
        final createEventResult =
            await _deviceCalendarPlugin.createOrUpdateEvent(event);
        if (createEventResult.isSuccess &&
            (createEventResult.data?.isNotEmpty ?? false)) {
          String eventId = createEventResult.data;
          await DandylightSharedPrefs.saveEventId(
              eventId, calendar.id, job.documentId);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static void updateJobEvent(Job job) async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          //do nothing. no permission granted.
        } else {
          Profile profile = (await ProfileDao.getAll()).elementAt(0);
          profile.calendarEnabled = true;
          await ProfileDao.update(profile);
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      List<Calendar> writableCalendars = getWritableCalendars(calendarsResult);

      for (Calendar calendar in writableCalendars) {
        Event event = await JobToEventMapper.map(
            job,
            calendar.id,
            await DandylightSharedPrefs.getEventIdByJobAndCalendar(job.documentId, calendar.id));
        final createEventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
        if (createEventResult.isSuccess && (createEventResult.data?.isNotEmpty ?? false)) {
          String eventId = createEventResult.data;
          await DandylightSharedPrefs.saveEventId(eventId, calendar.id, job.documentId);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static void deleteJobEvent(Job job) async {
    try {
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          //do nothing. no permission granted.
        } else {
          Profile profile = (await ProfileDao.getAll()).elementAt(0);
          profile.calendarEnabled = true;
          await ProfileDao.update(profile);
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      List<Calendar> writableCalendars = getWritableCalendars(calendarsResult);

      for (Calendar calendar in writableCalendars) {
        Event event = await JobToEventMapper.map(
            job,
            calendar.id,
            await DandylightSharedPrefs.getEventIdByJobAndCalendar(job.documentId, calendar.id));
        final deleteEventResult = await _deviceCalendarPlugin.deleteEvent(calendar.id, event.eventId);
        if (deleteEventResult.isSuccess && deleteEventResult.data) {
          await DandylightSharedPrefs.deleteEvent(job.documentId);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
