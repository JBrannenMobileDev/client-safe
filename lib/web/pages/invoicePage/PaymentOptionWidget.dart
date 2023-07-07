import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/IntentLauncherUtil.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/ColorConstants.dart';
import '../../../widgets/TextDandyLight.dart';

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

  PaymentOptionWidget({this.title, this.message, this.link, this.phone, this.email, this.sendSms, this.sendEmail, this.messageBody, this.messageTitle});

  @override
  State<StatefulWidget> createState() {
    return _PaymentOptionWidgetState(title, message, link, phone, email, sendSms, sendEmail, messageBody, messageTitle);
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

  _PaymentOptionWidgetState(this.title, this.message, this.link, this.phone, this.email, this.sendSms, this.sendEmail, this.messageBody, this.messageTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            child: TextDandyLight(
              textAlign: TextAlign.center,
              type: TextDandyLight.LARGE_TEXT,
              text: title,
              isBold: true,
            ),
          ),

          Container(
            margin: EdgeInsets.only(),
            child: TextDandyLight(
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: message,
            ),
          ),
          link != null ? MouseRegion(
            child: GestureDetector(
              onTap: () {
                IntentLauncherUtil.launchURL(link);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Color(ColorConstants.getPeachDark())
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'PAY NOW',
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
            cursor: SystemMouseCursors.click,
          ) : SizedBox(),
          phone != null ? Container(
            margin: EdgeInsets.only(top: 16),
            child: TextDandyLight(
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: phone,
              isBold: true,
            ),
          ) : SizedBox(),
          email != null ? Container(
            child: TextDandyLight(
              textAlign: TextAlign.center,
              type: TextDandyLight.SMALL_TEXT,
              text: email,
              isBold: true,
            ),
          ) : SizedBox(),
          sendSms != null && DeviceType.getDeviceTypeByContext(context) != Type.Website ? MouseRegion(
            child: GestureDetector(
              onTap: () {
                IntentLauncherUtil.sendSMSWithBody(sendSms, messageBody);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Color(ColorConstants.getPeachDark())
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'SEND SMS',
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
            cursor: SystemMouseCursors.click,
          ) : SizedBox(),
          sendEmail != null ? MouseRegion(
            child: GestureDetector(
              onTap: () {
                IntentLauncherUtil.sendEmail(sendEmail, messageTitle, messageBody);
              },
              child: Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Color(ColorConstants.getPeachDark())
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'SEND EMAIL',
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
            cursor: SystemMouseCursors.click,
          ) : SizedBox(),
        ],
      ),
    );
  }
}