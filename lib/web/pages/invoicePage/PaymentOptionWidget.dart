import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../widgets/TextDandyLight.dart';
import '../ClientPortalPageState.dart';
import 'PayNowPage.dart';

class PaymentOptionWidget extends StatefulWidget {
  final String title;
  final String message;
  final String link;
  final String phone;
  final String email;
  final String sendSms;
  final String sendEmail;
  final String messageBody;
  final String messageTitle;
  final String type;

  PaymentOptionWidget({this.title, this.message, this.link, this.phone, this.email, this.sendSms, this.sendEmail, this.messageBody, this.messageTitle, this.type});

  @override
  State<StatefulWidget> createState() {
    return _PaymentOptionWidgetState(title, message, link, phone, email, sendSms, sendEmail, messageBody, messageTitle, type);
  }
}

class _PaymentOptionWidgetState extends State<PaymentOptionWidget> {
  final String title;
  final String message;
  final String link;
  final String phone;
  final String email;
  final String sendSms;
  final String sendEmail;
  final String messageBody;
  final String messageTitle;
  final String type;

  _PaymentOptionWidgetState(this.title, this.message, this.link, this.phone, this.email, this.sendSms, this.sendEmail, this.messageBody, this.messageTitle, this.type);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ClientPortalPageState>(
  converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
  builder: (BuildContext context, ClientPortalPageState pageState) => Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: 264,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: TextDandyLight(
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
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
              fontFamily: pageState.profile.selectedFontTheme.titleFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: message,
            ),
          ),
          link != null ? MouseRegion(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PaymentConfirmationWidget(pageState);
                  }
                );
                IntentLauncherUtil.launchURL(link);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor)
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'PAY NOW',
                  fontFamily: pageState.profile.selectedFontTheme.titleFont,
                  color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor),
                ),
              ),
            ),
            cursor: SystemMouseCursors.click,
          ) : SizedBox(),
          phone != null ? Container(
            margin: EdgeInsets.only(top: 16),
            child: TextDandyLight(
              fontFamily: pageState.profile.selectedFontTheme.bodyFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: phone,
              isBold: true,
            ),
          ) : SizedBox(),
          email != null ? Container(
            child: TextDandyLight(
              fontFamily: pageState.profile.selectedFontTheme.bodyFont,
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: email,
              isBold: true,
            ),
          ) : SizedBox(),
          sendSms != null && DeviceType.getDeviceTypeByContext(context) != Type.Website ? MouseRegion(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentConfirmationWidget(pageState);
                    }
                );
                IntentLauncherUtil.sendSMSWithBody(sendSms, messageBody);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor)
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'SEND SMS',
                    fontFamily: pageState.profile.selectedFontTheme.titleFont,
                  color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor)
                ),
              ),
            ),
            cursor: SystemMouseCursors.click,
          ) : SizedBox(),
          sendEmail != null ? MouseRegion(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PaymentConfirmationWidget(pageState);
                    }
                );
                IntentLauncherUtil.sendEmail(sendEmail, messageTitle, messageBody);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor)
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'SEND EMAIL',
                  fontFamily: pageState.profile.selectedFontTheme.titleFont,
                  color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor),
                ),
              ),
            ),
            cursor: SystemMouseCursors.click,
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
        width: 400,
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
                    fontFamily: pageState.profile.selectedFontTheme.titleFont,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32, left: 32, right: 32),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                    text: 'When payment is complete please mark it as paid.',
                    color: Color(ColorConstants.getPrimaryBlack()),
                    textAlign: TextAlign.center,
                  ),
                ),
                MouseRegion(
                  child: GestureDetector(
                    onTap: () {
                      switch(type) {
                        case PayNowPage.TYPE_RETAINER:
                          pageState.onMarkAsPaidDepositSelected(true);
                          break;
                        case PayNowPage.TYPE_BALANCE:
                          pageState.onMarkAsPaidSelected(true);
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
                          color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor)
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        fontFamily: pageState.profile.selectedFontTheme.titleFont,
                        text: 'MARK AS PAID',
                        color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor),
                      ),
                    ),
                  ),
                  cursor: SystemMouseCursors.click,
                ),
              ],
            ),
            MouseRegion(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close_sharp, color: Color(ColorConstants.getPrimaryBlack()), size: 32),
              ),
              cursor: SystemMouseCursors.click,
            ),
          ],
        ),
      ),
    );
  }
}