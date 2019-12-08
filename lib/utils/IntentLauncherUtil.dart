import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:url_launcher/url_launcher.dart';

class IntentLauncherUtil{
  static Future<bool> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> makePhoneCall(String phoneNum) async {
    String trimmedPhoneNum = trimPhoneNumber(phoneNum);
    String formattedPhoneNum = 'tel:$trimmedPhoneNum';
    if (await canLaunch(formattedPhoneNum)) {
      await launch(formattedPhoneNum);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendSMS(String phoneNum) async {
    String trimmedPhoneNum = trimPhoneNumber(phoneNum);
    String formattedPhoneNum = 'sms:$trimmedPhoneNum';
    if (await canLaunch(formattedPhoneNum)) {
      await launch(formattedPhoneNum);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendSMSWithBody(String phoneNum, String body) async {
    String trimmedPhoneNum = trimPhoneNumber(phoneNum);
    String formattedPhoneNum = 'sms:$trimmedPhoneNum';
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

  static String trimPhoneNumber(String phoneNum){
    String trimmedPhoneNum = phoneNum.replaceAll(new RegExp("[^0-9.]"),'');
    return trimmedPhoneNum;
  }

  static Future<void> launchDrivingDirections(String originLat, String originLng, String destinationLat, String destinationLng) async{
    // lat,long like 123.34,68.56
    String origin = originLat + "," + originLng;
    String destination = destinationLat + "," + destinationLng;
    if (Device.get().isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    }
    else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false);
    } else {
    throw 'Could not launch $url';
    }
  }
  }
}