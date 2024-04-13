import 'dart:convert';

class JobEventIdMap {
  String? calendarId;
  String? jobId;
  String? eventId;

  JobEventIdMap({
    this.calendarId,
    this.jobId,
    this.eventId,
  });

  @override
  bool operator == (other) {
    return (other is JobEventIdMap)
        && other.calendarId == calendarId
        && other.jobId == jobId
        && other.eventId == eventId;
  }

  static Map<String, dynamic> toMap(JobEventIdMap map) {
    return {
      'calendarId' : map.calendarId,
      'jobId' : map.jobId,
      'eventId' : map.eventId,
    };
  }

  factory JobEventIdMap.fromJson(Map<String, dynamic> jsonData) {
    return JobEventIdMap(
      calendarId: jsonData['calendarId'],
      jobId: jsonData['jobId'],
      eventId: jsonData['eventId']
    );
  }

  static JobEventIdMap fromMap(Map<String, dynamic> map) {
    return JobEventIdMap(
      calendarId: map['calendarId'],
      jobId: map['jobId'],
      eventId: map['eventId'],
    );
  }

  static String encode(List<JobEventIdMap> maps) => json.encode(
    maps.map<Map<String, dynamic>>((map) => JobEventIdMap.toMap(map)).toList(),
  );

  static List<JobEventIdMap> decode(String maps) =>
      (json.decode(maps) as List<dynamic>)
          .map<JobEventIdMap>((item) => JobEventIdMap.fromJson(item))
          .toList();
}