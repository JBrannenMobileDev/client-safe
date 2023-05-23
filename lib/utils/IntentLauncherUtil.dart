import 'dart:async';
import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_extend/share_extend.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'PdfUtil.dart';
import 'TextFormatterUtil.dart';

class IntentLauncherUtil{
  static Future<bool> launchURL(String url) async {
    Uri uri = Uri.tryParse(url.trimLeft());
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
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
    String uri = '';
    if (Platform.isAndroid) {
      uri = 'sms:$trimmedPhoneNum?body=' + Uri.encodeComponent(body);
    } else if (Platform.isIOS) {
      // iOS
      uri = 'sms:$trimmedPhoneNum&body=' + Uri.encodeComponent(body);
    }
    if (await canLaunch(formattedPhoneNum)) {
      await launch(uri);
      return true;
    } else {
      return false;
    }
  }

  static Future shareDepositRequest(depositAmount) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    String zelleInfo = profile.zellePhoneEmail != null && profile.zellePhoneEmail.isNotEmpty ? '\n\nZelle\n' + 'Add recipient info:\n' + (TextFormatterUtil.isEmail(profile.zellePhoneEmail) ? 'Email: ' : TextFormatterUtil.isPhone(profile.zellePhoneEmail) ? 'Phone: ' : 'Phone or Email') + TextFormatterUtil.formatPhoneOrEmail(profile.zellePhoneEmail) + '\nName: ' + profile.zelleFullName : '';
    String venmoInfo = profile.venmoLink != null && profile.venmoLink.isNotEmpty ? '\n\nVenmo\n' + profile.venmoLink : '';
    String cashAppInfo = profile.cashAppLink != null && profile.cashAppLink.isNotEmpty ? '\n\nCash App\n' + profile.cashAppLink : '';
    String applePayInfo = profile.applePayPhone != null && profile.applePayPhone.isNotEmpty ? '\n\nApple Pay\n' + TextFormatterUtil.formatPhoneNum(profile.applePayPhone) : '';
    FlutterShare.share(title: profile.businessName + ' Deposit Request', text: 'YOUR MESSAGE GOES HERE\n\nDeposit Amount Due: ' + TextFormatterUtil.formatSimpleCurrency(depositAmount) + (zelleInfo.isNotEmpty || venmoInfo.isNotEmpty || cashAppInfo.isNotEmpty || applePayInfo.isNotEmpty ? '\n\nHere are the forms of payment i accept:' + zelleInfo + venmoInfo + cashAppInfo + applePayInfo : ''));
  }

  static Future sharePaymentLinks() async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    String zelleInfo = profile.zellePhoneEmail != null && profile.zellePhoneEmail.isNotEmpty ? '\n\nZelle\n' + 'Add recipient info:\n' + (TextFormatterUtil.isEmail(profile.zellePhoneEmail) ? 'Email: ' : TextFormatterUtil.isPhone(profile.zellePhoneEmail) ? 'Phone: ' : 'Phone or Email') + TextFormatterUtil.formatPhoneOrEmail(profile.zellePhoneEmail) + '\nName: ' + profile.zelleFullName : '';
    String venmoInfo = profile.venmoLink != null && profile.venmoLink.isNotEmpty ? '\n\nVenmo\n' + profile.venmoLink : '';
    String cashAppInfo = profile.cashAppLink != null && profile.cashAppLink.isNotEmpty ? '\n\nCash App\n' + profile.cashAppLink : '';
    String applePayInfo = profile.applePayPhone != null && profile.applePayPhone.isNotEmpty ? '\n\nApple Pay\n' + TextFormatterUtil.formatPhoneNum(profile.applePayPhone) : '';
    FlutterShare.share(title: 'How to pay', text: 'Here are the forms of payment i accept:' + zelleInfo + venmoInfo + cashAppInfo + applePayInfo);
  }

  static Future shareInvoice(Invoice invoice) async{
    File invoiceFile = File(await PdfUtil.getInvoiceFilePath(invoice.invoiceId));
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    String zelleInfo = profile.zellePhoneEmail != null && profile.zellePhoneEmail.isNotEmpty ? '\n\nZelle\n' + 'Add recipient info:\n' + (TextFormatterUtil.isEmail(profile.zellePhoneEmail) ? 'Email: ' : TextFormatterUtil.isPhone(profile.zellePhoneEmail) ? 'Phone: ' : 'Phone or Email') + TextFormatterUtil.formatPhoneOrEmail(profile.zellePhoneEmail) + '\nName: ' + profile.zelleFullName : '';
    String venmoInfo = profile.venmoLink != null && profile.venmoLink.isNotEmpty ? '\n\nVenmo\n' + profile.venmoLink : '';
    String cashAppInfo = profile.cashAppLink != null && profile.cashAppLink.isNotEmpty ? '\n\nCash App\n' + profile.cashAppLink : '';
    String applePayInfo = profile.applePayPhone != null && profile.applePayPhone.isNotEmpty ? '\n\nApple Pay\n' + TextFormatterUtil.formatPhoneNum(profile.applePayPhone) : '';
    Share.shareXFiles([XFile(invoiceFile.path)], subject: profile.businessName + ' Invoice', text: profile.businessName + ' Invoice\n\nAmount Due: ' + TextFormatterUtil.formatDecimalCurrency(invoice.unpaidAmount) + '\n\nAccepted forms of payment:' + zelleInfo + venmoInfo + cashAppInfo + applePayInfo);
  }
  static Future shareInvoiceById(int invoiceId) async{
    File invoiceFile = File(await PdfUtil.getInvoiceFilePath(invoiceId));
    ShareExtend.share(invoiceFile.path, "file");
  }

  static Future<bool> sendInvoiceSMS(String phoneNum, String body) async {
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
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=' + subject + ' &body=' + body, //add subject and body here
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
      return true;
    } else {
      return false;
    }
  }

  static String trimPhoneNumber(String phoneNum){
    String trimmedPhoneNum = phoneNum.replaceAll(new RegExp("[^0-9.]"),'');
    return trimmedPhoneNum;
  }

  static Future<void> launchDrivingDirections(String destinationLat, String destinationLng) async{
    Position originPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // lat,long like 123.34,68.56
    String origin = originPosition.latitude.toString() + "," + originPosition.longitude.toString();
    String destination = destinationLat + "," + destinationLng;
    if (Device.get().isAndroid) {
      final AndroidIntent intent = new AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(
              "https://www.google.com/maps/dir/?api=1&origin=" +
                  origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate"),
          package: 'com.google.android.apps.maps');
      intent.launch();
    } else {
      String url = "https://www.google.com/maps/dir/?api=1&origin=" + origin + "&destination=" + destination + "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
    await launch(url, forceSafariVC: false);
    } else {
    throw 'Could not launch $url';
    }
  }
  }
}