import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';
import '../ClientPortalPageState.dart';
import 'PayNowPage.dart';

class PaymentOptionWidget extends StatefulWidget {
  final String? title;
  final String? message;
  final String? link;
  final String? phone;
  final String? email;
  final String? name;
  final String? sendSms;
  final String? sendEmail;
  final String? messageBody;
  final String? messageTitle;
  final String? type;

  PaymentOptionWidget({this.title, this.message, this.link, this.phone, this.email, this.sendSms, this.sendEmail, this.messageBody, this.messageTitle, this.type, this.name});

  @override
  State<StatefulWidget> createState() {
    return _PaymentOptionWidgetState(title, message, link, phone, email, sendSms, sendEmail, messageBody, messageTitle, type, name);
  }
}

class _PaymentOptionWidgetState extends State<PaymentOptionWidget> {
  final String? title;
  final String? message;
  final String? link;
  final String? phone;
  final String? email;
  final String? name;
  final String? sendSms;
  final String? sendEmail;
  final String? messageBody;
  final String? messageTitle;
  final String? type;

  _PaymentOptionWidgetState(this.title, this.message, this.link, this.phone, this.email, this.sendSms, this.sendEmail, this.messageBody, this.messageTitle, this.type, this.name);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ClientPortalPageState>(
  converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
  builder: (BuildContext context, ClientPortalPageState pageState) => Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 264 : MediaQuery.of(context).size.width-32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: TextDandyLight(
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.LARGE_TEXT,
              text: title,
              isBold: true,
            ),
          ),
          Container(
            height: 78,
            margin: EdgeInsets.only(),
            child: TextDandyLight(
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: message,
            ),
          ),
          link != null ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PaymentConfirmationWidget(pageState);
                  }
                );
                IntentLauncherUtil.launchURL(link!);
                if(title == 'Venmo') {
                  EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_VENMO_LINK_SELECTED);
                }
                if(title == 'CashApp') {
                  EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CASHAPP_LINK_SELECTED);
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'PAY NOW',
                  fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                  color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonTextColor!),
                ),
              ),
            ),
          ) : SizedBox(),
          phone != null ? Container(
            margin: EdgeInsets.only(top: 16),
            child: TextDandyLight(
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: phone,
              isBold: true,
            ),
          ) : SizedBox(),
          name != null ? Container(
            margin: EdgeInsets.only(top: 16),
            child: TextDandyLight(
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: name,
              isBold: true,
            ),
          ) : SizedBox(),
          email != null ? Container(
            child: TextDandyLight(
              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: email,
              isBold: true,
            ),
          ) : SizedBox(),
          sendSms != null && DeviceType.getDeviceTypeByContext(context) != Type.Website ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentConfirmationWidget(pageState);
                    }
                );
                IntentLauncherUtil.sendSMS(sendSms!);
                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CASH_SEND_SMS_SELECTED);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'SEND SMS',
                    fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                  color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonTextColor!)
                ),
              ),
            ),
          ) : SizedBox(),
          sendEmail != null ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentConfirmationWidget(pageState);
                    }
                );
                IntentLauncherUtil.sendEmail(sendEmail!, messageTitle!, messageBody!);
                EventSender().sendEvent(eventName: EventNames.CLIENT_PORTAL_CASH_SEND_EMAIL_SELECTED);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'SEND EMAIL',
                  fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                  color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonTextColor!),
                ),
              ),
            ),
          ) : SizedBox(),
        ],
      ),
    ),
  );

  Widget PaymentConfirmationWidget(ClientPortalPageState pageState) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        height: 250,
        width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 400 : MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Color(ColorConstants.getPrimaryWhite())
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 32),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Payment Confirmation',
                    fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32, left: 32, right: 32),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                    text: 'When payment is complete please mark it as paid.',
                    color: Color(ColorConstants.getPrimaryBlack()),
                    textAlign: TextAlign.center,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      switch(type) {
                        case PayNowPage.TYPE_RETAINER:
                          pageState.onMarkAsPaidDepositSelected!(true);
                          break;
                        case PayNowPage.TYPE_BALANCE:
                          pageState.onMarkAsPaidSelected!(true);
                          break;
                      }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 175,
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                        text: 'MARK AS PAID',
                        color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonTextColor!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_sharp, color: Color(ColorConstants.getPrimaryBlack()), size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}