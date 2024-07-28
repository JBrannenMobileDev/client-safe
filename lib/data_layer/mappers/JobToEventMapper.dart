import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../../models/Job.dart';
import 'package:timezone/timezone.dart';

import '../../models/Profile.dart';
import '../../models/SessionType.dart';
import '../../utils/UidUtil.dart';
import '../local_db/daos/ProfileDao.dart';

class JobToEventMapper {
  static map(Job? job, String? calendarId, String? eventIdSaved) async {
    Profile? profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(job!.selectedDate == null || job.selectedTime == null) return null;
    return Event(
      calendarId,
      eventId: eventIdSaved,
      title: (profile!.businessName!.isNotEmpty ? profile.businessName! + ' - ' : 'Dandylight - ') + job.jobTitle!,
      description: job.notes,
      start: await buildStartDateTime(job.selectedDate!, job.selectedTime!),
      end: ((job.sessionType?.durationMinutes ?? 0) > 0 || (job.sessionType?.durationHours ?? 0) > 0)  == true ?  await buildEndDateTime(job.selectedDate!, job.selectedTime!, job.sessionType!) :  await createEndTZDateTime(job),
      location: job.location!.locationName
    );
  }

  static buildEndDateTime(DateTime selectedDate, DateTime selectedTime, SessionType sessionType) async {

    Location? currentLocation;
    String? timezone;
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    currentLocation = getLocation(timezone!);

    DateTime startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
    DateTime endTime = startTime.add(Duration(hours: sessionType.durationHours, minutes: sessionType.durationMinutes));

    return TZDateTime.from(
        endTime,
        currentLocation);
  }

  static buildStartDateTime(DateTime selectedDate, DateTime selectedTime) async {

    Location? _currentLocation = null;
    String? timezone = null;
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    _currentLocation = getLocation(timezone!);

    return TZDateTime.from(
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute),
        _currentLocation);
  }

  static createEndTZDateTime(Job job) async {
    DateTime? endTime = job.selectedEndTime != null ? job.selectedEndTime : DateTime(job.selectedDate!.year, job.selectedDate!.month, job.selectedDate!.day, job.selectedTime!.hour + 1);
    Location? _currentLocation = null;
    String? timezone = null;
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    _currentLocation = getLocation(timezone!);

    return TZDateTime.from(
        endTime!,
        _currentLocation);
  }
}