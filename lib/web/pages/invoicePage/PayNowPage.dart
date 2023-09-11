import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/TextFormatterUtil.dart';
import '../../../widgets/DividerWidget.dart';
import '../ClientPortalPageState.dart';
import 'PaymentOptionWidget.dart';

class PayNowPage extends StatefulWidget {
  static const String TYPE_RETAINER = 'type_retainer';
  static const String TYPE_BALANCE = 'type_balance';
  final double amount;
  final String type;

  PayNowPage({this.amount, this.type});

  @override
  State<StatefulWidget> createState() {
    return _PayNowPageState(amount, type);
  }
}

class _PayNowPageState extends State<PayNowPage> {
  bool isHoveredDownloadPDF = false;
  bool isHoveredPayDeposit = false;
  bool isHoveredPayFull = false;
  double amount;
  String type;

  _PayNowPageState(this.amount, this.type);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ClientPortalPageState>(
  converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
  builder: (BuildContext context, ClientPortalPageState pageState) => Center(
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
                        fontFamily: pageState.profile.selectedFontTheme.mainFont,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 32, right: 32),
                      height: 72,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Balance due',
                              fontFamily: pageState.profile.selectedFontTheme.mainFont,
                              color: Color(ColorConstants.getPrimaryBlack())
                          ),
                          TextDandyLight(
                              type: TextDandyLight.EXTRA_LARGE_TEXT,
                              fontFamily: pageState.profile.selectedFontTheme.mainFont,
                              text: TextFormatterUtil.formatDecimalCurrency(amount),
                              color: Color(ColorConstants.getPrimaryBlack())
                          )
                        ],
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
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 175,
                          height: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(ColorConstants.getPrimaryBackgroundGrey())
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            fontFamily: pageState.profile.selectedFontTheme.mainFont,
                            text: 'MARK AS PAID',
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      cursor: SystemMouseCursors.click,
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 48),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    fontFamily: pageState.profile.selectedFontTheme.mainFont,
                    text: 'Please mark as paid above once payment is complete.',
                    color: Color(ColorConstants.getPrimaryBlack()),
                    isBold: true,
                  ),
                ),
                BuildPaymentOptionsWidget(pageState),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget BuildPaymentOptionsWidget(ClientPortalPageState pageState) {
    List<Widget> enabledOptions = [];
    
    if(pageState.profile.venmoEnabled) enabledOptions.add(buildVenmoWidget(pageState));
    if(pageState.profile.cashEnabled) enabledOptions.add(buildCashWidget(pageState));
    if(pageState.profile.cashAppEnabled) enabledOptions.add(buildCashAppWidget(pageState));
    if(pageState.profile.applePayEnabled) enabledOptions.add(buildApplePayWidget(pageState));
    if(pageState.profile.zelleEnabled) enabledOptions.add(buildZelleWidget(pageState));
    
    if(DeviceType.getDeviceTypeByContext(context) != Type.Website) {
      return getMobileList(pageState, enabledOptions);
    } else {
      return getWebWidget(pageState, enabledOptions);
    }
  }

  Widget getWebWidget(ClientPortalPageState pageState, List<Widget> enabledOptions) {
    switch(enabledOptions.length) {
      case 0:
        return buildWebRow1(pageState, [buildErrorWidget(pageState)], true);
        break;
      case 1:
      case 2:
      case 3:
      return buildWebRow1(pageState, enabledOptions, true);
        break;
      case 4:
      case 5:
        return buildBothRowsWeb(pageState, enabledOptions);
        break;
      default:
        return SizedBox();
    }
  }

  Widget buildBothRowsWeb(ClientPortalPageState pageState, List<Widget> enabledOptions) {
    return Column(
      children: [
        buildWebRow1(pageState, enabledOptions.sublist(0, 2), false),
        buildWebRow2(pageState, enabledOptions.sublist(3, enabledOptions.length-1))
      ],
    );
  }

  Widget buildWebRow1(ClientPortalPageState pageState, List<Widget> row1Options, bool isOnlyRow) {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: isOnlyRow ? 64 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: row1Options,
      ),
    );
  }

  Widget buildWebRow2(ClientPortalPageState pageState, List<Widget> row2Options) {
    return Container(
      margin: EdgeInsets.only(top: 64, bottom: 64),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: row2Options,
      ),
    );
  }
  
  Widget getMobileList(ClientPortalPageState pageState, List<Widget> enabledOptions) {
    List<Widget> result = [];

    for(int index = 0; index < enabledOptions.length; index++) {
      result.add(enabledOptions.elementAt(index));
      if(index < enabledOptions.length-1) {
        result.add(DividerWidget(width: 438));
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 64, bottom: 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: result,
      ),
    );
  }
  
  Widget buildZelleWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: 'Zelle',
      message: 'Please send funds to our bank account through Zelle by using our mobile phone number or email then mark as paid above.',
      phone: pageState.profile.phone,
      email: pageState.profile.email,
      type: type,
    );
  }

  Widget buildVenmoWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: 'Venmo',
      message: 'Please send funds to our Venmo account by selecting the (PAY NOW) button below then mark as paid above.',
      link: pageState.profile.venmoLink,
      type: type,
    );
  }

  Widget buildCashAppWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: 'CashApp',
      message: 'Please send funds to our CashApp account by selecting the (PAY NOW) button below then mark as paid above.',
      link: pageState.profile.cashAppLink,
      type: type,
    );
  }

  Widget buildApplePayWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: 'Apple Pay',
      message: 'Please send funds to our Apple Pay account with the phone number provided below then mark as paid above.',
      phone: DeviceType.getDeviceTypeByContext(context) == Type.Website ? pageState.profile.phone : null,
      sendSms: pageState.profile.phone,
      messageBody: 'Thank you! Here is the payment.',
      type: type,
    );
  }

  Widget buildCashWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: 'Cash',
      message: 'Pay with cash by agreed upon due date. Send a message to let ' + pageState.profile.firstName + ' know, then mark as paid above.',
      sendSms: pageState.profile.phone,
      sendEmail: pageState.profile.email,
      messageTitle: 'Invoice Response - Pay by cash',
      messageBody: 'Hi ' + pageState.profile.firstName + ', i will be paying with cash. How would you like me to get the cash to you?',
      type: type,
    );
  }

  Widget buildErrorWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: 'Payment Options Not Setup',
      message: pageState.profile.businessName + ' has not setup any payment options yet. Please contact ' + pageState.profile.firstName + ' to discuss payment.',
      sendSms: pageState.profile.phone,
      sendEmail: pageState.profile.email,
      messageTitle: 'Payment',
      messageBody: 'Hi ' + pageState.profile.firstName + ', how would you like me to pay?',
      type: type,
    );
  }
}
