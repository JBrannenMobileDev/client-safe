
class TimeFormatUtil {
  static DateTime nearestQuarter(DateTime val) {
    return DateTime(val.year, val.month, val.day, val.hour,
        [0, 15, 30, 45, 60][(val.minute / 15).floor()]);
  }
}




