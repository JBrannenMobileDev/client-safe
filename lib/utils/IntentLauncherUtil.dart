import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class IntentLauncherUtil{
  static Future<bool> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> makePhoneCall(String phoneNum) async {
    String formattedPhoneNum = 'tel:$phoneNum';
    if (await canLaunch(formattedPhoneNum)) {
      await launch(formattedPhoneNum);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendSMS(String phoneNum) async {
    String formattedPhoneNum = 'sms:$phoneNum';
    if (await canLaunch(formattedPhoneNum)) {
      await launch(formattedPhoneNum);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendEmail(String email, String subject, String body) async {
    String formattedPhoneNum = 'mailto:$email?subject=$subject&body=$body';
    if (await canLaunch(formattedPhoneNum)) {
      await launch(formattedPhoneNum);
      return true;
    } else {
      return false;
    }
  }
}