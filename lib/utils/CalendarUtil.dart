import 'package:dandylight/data_layer/local_db/daos/JobDao.dart';
import 'package:dandylight/models/Job.dart';
import 'package:flutter/cupertino.dart';

import '../models/EventDandyLight.dart';
import '../pages/calendar_page/JobCalendarItem.dart';

class CalendarUtil {
  static Widget buildEventList(
      DateTime? selectedDate,
      List<EventDandyLight>? eventList,
      int? selectedYear,
      int? selectedMonth,
      int? selectedDay,
      List<Job>? allJobs,
      Function(Job)? onJobClicked
  ) {
    List<JobCalendarItem> calendarListItems = [];
    List<JobCalendarItem> fromJobs = _getJobListForSelectedDate(selectedDate, eventList!, selectedYear!, selectedMonth!, selectedDay!, allJobs!)
        .map((job) => JobCalendarItem(job: job, paddingRight: 24.0, paddingLeft: 24.0, onJobClicked: onJobClicked,))
        .toList();
    List<JobCalendarItem> fromDeviceEvents = _getEventListForSelectedDate(selectedDate, eventList, selectedYear, selectedMonth, selectedDay)
        .map((event) => JobCalendarItem(eventDandyLight: event, paddingRight: 24.0, paddingLeft: 24.0, onJobClicked: null,))
        .toList();
    calendarListItems.addAll(fromJobs);
    calendarListItems.addAll(fromDeviceEvents);

    return ListView(
      children: calendarListItems,
    );
  }

  static List<Job> _getJobListForSelectedDate(
      DateTime? selectedDate,
      List<EventDandyLight> eventList,
      int selectedYear,
      int selectedMonth,
      int selectedDay,
      List<Job> allJobs,
  ) {
    List<EventDandyLight> matchingEvents = [];
    if (selectedDate != null) {
      for (EventDandyLight event in eventList) {
        if(event.selectedDate != null){
          if (event.selectedDate!.year == selectedYear &&
              event.selectedDate!.month == selectedMonth &&
              event.selectedDate!.day == selectedDay) {
            matchingEvents.add(event);
          }
        }
      }
    }
    if(matchingEvents.length > 0) {
      return _getListOfJobsFromEvents(matchingEvents, allJobs);
    } else {
      return [];
    }
  }

  static List<Job> _getListOfJobsFromEvents(List<EventDandyLight> events, List<Job> allJobs) {
    List<Job> jobs = [];
    for(EventDandyLight event in events){
      for(Job job in allJobs){
        if(job.documentId == event.jobDocumentId) jobs.add(job);
      }
    }
    return jobs;
  }

  static List<EventDandyLight> _getEventListForSelectedDate(
      DateTime? selectedDate,
      List<EventDandyLight> eventList,
      int selectedYear,
      int selectedMonth,
      int selectedDay
  ) {
    List<EventDandyLight> matchingEvents = [];
    if (selectedDate != null) {
      for (EventDandyLight event in eventList) {
        if(event.start != null){
          if (event.start!.year == selectedYear &&
              event.start!.month == selectedMonth &&
              event.start!.day == selectedDay) {
            matchingEvents.add(event);
          }
        }
      }
    }
    if(matchingEvents.length > 0) {
      return _getListOfDeviceCalendarEventsFromEvents(matchingEvents);
    } else {
      return [];
    }
  }

  static List<EventDandyLight> _getListOfDeviceCalendarEventsFromEvents(List<EventDandyLight> events) {
    List<EventDandyLight> eventsResult = [];
    for(EventDandyLight event in events){
      if(event.isPersonalEvent!) {
        eventsResult.add(event);

      }
    }
    return eventsResult;
  }
}