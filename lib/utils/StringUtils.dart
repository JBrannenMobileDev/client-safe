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
}