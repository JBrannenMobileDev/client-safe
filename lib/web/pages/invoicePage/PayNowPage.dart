import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/ColorConstants.dart';
import '../../../utils/TextFormatterUtil.dart';
import '../../../widgets/DividerWidget.dart';
import 'PaymentOptionWidget.dart';

class PayNowPage extends StatefulWidget {
  final double amount;

  PayNowPage({this.amount});

  @override
  State<StatefulWidget> createState() {
    return _PayNowPageState(amount);
  }
}

class _PayNowPageState extends State<PayNowPage> {
  bool isHoveredDownloadPDF = false;
  bool isHoveredPayDeposit = false;
  bool isHoveredPayFull = false;
  double amount;

  _PayNowPageState(this.amount);

  @override
  Widget build(BuildContext context) => Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: DeviceType.getDeviceTypeByContext(context) == Type.Website ? EdgeInsets.only(left: 72, right: 72) : EdgeInsets.only(),
            decoration: new BoxDecoration(
                color: Color(ColorConstants.white),
                borderRadius: new BorderRadius.all(Radius.circular(16.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 32, bottom: 32),
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                        text: 'Payment Options',
                      ),
                    ),
                    DeviceType.getDeviceTypeByContext(context) != Type.Website ? MouseRegion(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 16),
                          alignment: Alignment.topRight,
                          width: 438,
                          child: Icon(Icons.close_sharp, color: Color(ColorConstants.getPrimaryBlack()), size: 32,),
                        ),
                      ),
                      cursor: SystemMouseCursors.click,
                    ) : SizedBox(),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 32, right: 32),
                      height: 72,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Balance due',
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          TextDandyLight(
                              type: TextDandyLight.EXTRA_LARGE_TEXT,
                              text: TextFormatterUtil.formatDecimalCurrency(amount),
                              color: Color(ColorConstants.getPrimaryBlack())
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                //TODO once there is a proposal object, use it to determine the row structure. Use the number of payment options the photographer has selected.
                DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PaymentOptionWidget(
                        title: 'Venmo',
                        message: 'Please send funds to our Venmo account by selecting the (PAY NOW) button below.',
                        link: 'https://venmo.com/code?user_id=1696790113943552886',
                      ),
                      PaymentOptionWidget(
                        title: 'Cash',
                        message: 'Pay with cash by agreed upon due date. Send a message to let shawna know.',
                        sendSms: '(951)295-0348',
                        sendEmail: 'vintageVibesPhotography@gmail.com',
                        messageTitle: 'Invoice Response - Pay by cash',
                        messageBody: 'Hi Shawna, i will be paying with cash. How would you like me to get the cash to you?',
                      ),
                      PaymentOptionWidget(
                        title: 'CashApp',
                        message: 'Please send funds to our CashApp account by selecting the (PAY NOW) button below.',
                        link: 'https://cash.app/\$jbinvestments15',
                      ),
                    ],
                  ),
                ) : SizedBox(),
                DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                  margin: EdgeInsets.only(top: 64, bottom: 64),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PaymentOptionWidget(
                        title: 'Apple Pay',
                        message: 'Please send funds to our Apple Pay account with the phone number provided below.',
                        phone: DeviceType.getDeviceTypeByContext(context) == Type.Website ? '(951)295-0348' : null,
                        sendSms: '(951)295-0348',
                        messageBody: 'Thank you! Here is the payment.',
                      ),
                      PaymentOptionWidget(
                        title: 'Zelle',
                        message: 'Please send funds to our bank account through Zelle by using our mobile phone number or email.',
                        phone: '(951)295-0348',
                        email: 'vintagevibesphotography@gmail.com',
                      ),
                    ],
                  ),
                ) : SizedBox(),
                DeviceType.getDeviceTypeByContext(context) != Type.Website ? Container(
                  margin: EdgeInsets.only(top: 64, bottom: 64),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PaymentOptionWidget(
                        title: 'Venmo',
                        message: 'Please send funds to our Venmo account by selecting the (PAY NOW) button below.',
                        link: 'https://venmo.com/code?user_id=1696790113943552886',
                      ),
                      DividerWidget(width: 438),
                      PaymentOptionWidget(
                        title: 'Zelle',
                        message: 'Please send funds to our bank account through Zelle by using our mobile phone number or email.',
                        phone: '(951)295-0348',
                        email: 'vintagevibesphotography@gmail.com',
                      ),
                      DividerWidget(width: 438),
                      PaymentOptionWidget(
                        title: 'CashApp',
                        message: 'Please send funds to our CashApp account by selecting the (PAY NOW) button below.',
                        link: 'https://cash.app/\$jbinvestments15',
                      ),
                      DividerWidget(width: 438),
                      PaymentOptionWidget(
                        title: 'Apple Pay',
                        message: 'Please send funds to our Apple Pay account with the phone number provided below.',
                        phone: DeviceType.getDeviceTypeByContext(context) == Type.Website ? '(951)295-0348' : null,
                        sendSms: '(951)295-0348',
                        messageBody: 'Thank you! Here is the payment.',
                      ),
                      DividerWidget(width: 438),
                      PaymentOptionWidget(
                        title: 'Cash',
                        message: 'Pay with cash by agreed upon due date. Send a message to let shawna know.',
                        sendSms: '(951)295-0348',
                        sendEmail: 'vintageVibesPhotography@gmail.com',
                        messageTitle: 'Invoice Response - Pay by cash',
                        messageBody: 'Hi Shawna, i will be paying with cash. How would you like me to get the cash to you?',
                      ),
                    ],
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
        ],
      ),
  );
}
