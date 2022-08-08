import 'package:dandylight/data_layer/local_db/shared_preferences/JobEventIdMap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DandylightSharedPrefs {
  static const String EVENT_ID_MAP_KEY = 'eventIdMapKey';

  static Future<String> getEventIdMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(EVENT_ID_MAP_KEY);
  }

  static Future<List<JobEventIdMap>> getListOfKnowJobEventsOnDeviceCalendars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mapString = prefs.getString(EVENT_ID_MAP_KEY);
    if(mapString != null) {
      return JobEventIdMap.decode(mapString);
    }
      return [];
  }

  static void saveEventId(String eventId, String calendarId, String jobId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    JobEventIdMap newMap = JobEventIdMap(calendarId: calendarId, jobId: jobId, eventId: eventId);
    String mapsString = await getEventIdMap();
    if(mapsString == null) {
      _addAndSaveNewEventIdMap(newMap, prefs, []);
    } else {
      List<JobEventIdMap> eventIds = JobEventIdMap.decode(mapsString);
      if(!eventIds.contains(newMap)) {
        _addAndSaveNewEventIdMap(newMap, prefs, eventIds);
      }
    }
  }

  static void _addAndSaveNewEventIdMap(JobEventIdMap newMap, SharedPreferences prefs, List<JobEventIdMap> eventIds) {
    eventIds.add(newMap);
    prefs.setString(EVENT_ID_MAP_KEY, JobEventIdMap.encode(eventIds));
  }

  static Future<String> getEventIdByJobAndCalendar(String jobId, String calendarId) async {
    String mapsString = await getEventIdMap();
    if(mapsString !=  null) {
      List<JobEventIdMap> eventIds = JobEventIdMap.decode(mapsString);

      eventIds.retainWhere((map){
        return map.jobId == jobId && map.calendarId == calendarId;
      });

      if(eventIds.isNotEmpty) {
        return eventIds.elementAt(0).eventId;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static void deleteAllEvents() async {
    (await SharedPreferences.getInstance()).remove(EVENT_ID_MAP_KEY);
  }

  static void deleteEvent(String jobId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mapsString = await getEventIdMap();
    if(mapsString != null) {
      List<JobEventIdMap> eventIds = JobEventIdMap.decode(mapsString);
      List<JobEventIdMap> eventsToSave = [];
      for(JobEventIdMap map in eventIds) {
        if(map.jobId == jobId) {
           //do not add this to maps to save. this is the one we want deleted.
        } else {
          eventsToSave.add(map);
        }
      }
      prefs.setString(EVENT_ID_MAP_KEY, JobEventIdMap.encode(eventsToSave));
    }
  }
}