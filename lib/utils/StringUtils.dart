import 'dart:math';

class StringUtils {
  static List<String> getJobTypesList() {
    return [
      'Advertising',
      'Anniversary',
      'Architecture',
      'Birthday',
      'Boudoir',
      'Breastfeeding',
      'Engagement',
      'Event',
      'Family',
      'Headshots',
      'Maternity',
      'Modeling',
      'Nature',
      'Newborn',
      'Pet',
      'Wedding',
      'Other',
    ];
  }

  static String generateRandomString(int length) {
    final random = Random();
    const availableChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)]).join();

    return randomString;
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  static String formatSessionDuration(int? hours, int? minutes) {
    String result = '';

    if((hours ?? 0) > 0) {
      if((hours ?? 0) > 1) {
        result = '${hours.toString()}hrs  ';
      } else {
        result = '${hours.toString()}hr  ';
      }
    }

    if((minutes ?? 0) > 0) {
      result = '$result${minutes.toString()}min ';
    }

    return result;
  }
}