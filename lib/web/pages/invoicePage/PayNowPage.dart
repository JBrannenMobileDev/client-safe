import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/TextFormatterUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
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
            padding: DeviceType.getDeviceTypeByContext(context) == Type.Website ? EdgeInsets.only(left: 72, right: 72) : EdgeInsets.only(left: 16, right: 16),
            width: DeviceType.getDeviceTypeByContext(context) != Type.Website ? MediaQuery.of(context).size.width : null,
            decoration: new BoxDecoration(
                color: Color(ColorConstants.white),
                borderRadius: new BorderRadius.all(Radius.circular(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 16 : 0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: DeviceType.getDeviceTypeByContext(context) == Type.Website ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 32, bottom: 32),
                      child: TextDandyLight(
                        type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.EXTRA_LARGE_TEXT : TextDandyLight.LARGE_TEXT,
                        fontFamily: pageState.profile.selectedFontTheme.mainFont,
                        text: 'Payment Options',
                        isBold: true,
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
                          width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 438 : MediaQuery.of(context).size.width,
                          child: Icon(Icons.close_sharp, color: Color(ColorConstants.getPrimaryBlack()), size: 32,),
                        ),
                      ),
                      cursor: SystemMouseCursors.click,
                    ) : SizedBox(),
                  ],
                ),
                DeviceType.getDeviceTypeByContext(context) == Type.Website ?
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: getBalanceAndMarkItems(pageState),
                ) : Column(
                  children: getBalanceAndMarkItems(pageState),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 48),
                  child: TextDandyLight(
                    type: TextDandyLight.SMALL_TEXT,
                    textAlign: TextAlign.center,
                    fontFamily: pageState.profile.selectedFontTheme.mainFont,
                    text: 'Please mark as paid once payment is complete.',
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

  getBalanceAndMarkItems(ClientPortalPageState pageState) {
    return [
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
    ];
  }

  Widget BuildPaymentOptionsWidget(ClientPortalPageState pageState) {
    List<Widget> enabledOptions = [];
    
    if(pageState.profile.venmoEnabled) enabledOptions.add(buildVenmoWidget(pageState));
    if(pageState.profile.wireEnabled) enabledOptions.add(buildWireWidget(pageState));
    if(pageState.profile.cashEnabled) enabledOptions.add(buildCashWidget(pageState));
    if(pageState.profile.cashAppEnabled) enabledOptions.add(buildCashAppWidget(pageState));
    if(pageState.profile.zelleEnabled) enabledOptions.add(buildZelleWidget(pageState));
    if(pageState.profile.otherEnabled) enabledOptions.add(buildOtherWidget(pageState));
    
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
      case 6:
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

    if(result.length == 0) {
      result.add(buildErrorWidget(pageState));
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
      name: pageState.profile.zelleFullName,
      email: pageState.profile.zellePhoneEmail,
      type: type,
    );
  }

  Widget buildOtherWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: '',
      message: pageState.profile.otherMessage,
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
      message: pageState.profile.cashMessage != null && pageState.profile.cashMessage.isNotEmpty ? pageState.profile.cashMessage : 'Please send me a message to coordinate a cash payment.',
      sendSms: pageState.profile.phone,
      sendEmail: pageState.profile.email,
      messageTitle: 'Invoice Response - Pay by cash',
      messageBody: 'Hi ' + pageState.profile.firstName + ', i will be paying with cash. How would you like me to get the cash to you?',
      type: type,
    );
  }

  Widget buildWireWidget(ClientPortalPageState pageState) {
    return PaymentOptionWidget(
      title: 'Wire/E-Transfer',
      message: pageState.profile.wireMessage != null && pageState.profile.wireMessage.isNotEmpty ? pageState.profile.wireMessage : 'Please contact me for wire transfer details.',
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
