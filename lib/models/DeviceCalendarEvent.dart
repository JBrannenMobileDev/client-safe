import 'package:client_safe/models/Event.dart';

class DeviceCalendarEvent implements Event{
  DateTime date;
  String title;

  DeviceCalendarEvent(this.date, this.title);

  @override
  DateTime getDatetime() {
    return date;
  }

  @override
  String getTitle() {
    return title;
  }

}