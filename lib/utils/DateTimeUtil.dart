class DateTimeUtil {
  static DateTime subtractMonths(DateTime given, int monthsToSubtract) {
    int currentMonth = given.month;
    if(currentMonth - monthsToSubtract > 0) {
      return DateTime(given.year, given.month-monthsToSubtract, given.day);
    } else {
      int actualMonth = (given.month - monthsToSubtract) + 12;
      return DateTime(given.year-1, actualMonth);
    }
  }
}