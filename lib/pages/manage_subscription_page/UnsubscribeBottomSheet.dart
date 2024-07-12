import 'dart:async';

import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../AppState.dart';
import '../../utils/KeyboardUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';

class UnsubscribeBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UnsubscribeBottomSheetState();
  }
}

class _UnsubscribeBottomSheetState extends State<UnsubscribeBottomSheet> with TickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  bool hasPopped = false;

  bool? check1 = false;
  bool? check2 = false;
  bool? check3 = false;
  bool? check4 = false;
  bool? check5 = false;
  bool? check6 = false;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ManageSubscriptionPageState>(
    onDidChange: (previous, current) {
      if(previous!.discountType!.isEmpty && current.discountType!.isNotEmpty && !hasPopped) {
        hasPopped = true;
        Navigator.of(context).pop();
      }
    },
    converter: (Store<AppState> store) => ManageSubscriptionPageState.fromStore(store),
    builder: (BuildContext context, ManageSubscriptionPageState pageState) =>
         Container(
           height: 600,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0),
             child:
             Column(
               children: [
                 Container(
                   margin: const EdgeInsets.only(top: 16),
                   child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Cancel Subscription',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getBlueDark())
                   ),
                 ),
                 Container(
                   margin: const EdgeInsets.only(top: 16),
                   child: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: 'What is the primary reason for canceling your subscription?',
                       textAlign: TextAlign.center,
                   ),
                 ),
                 Container(
                  alignment: Alignment.center,
                   margin: const EdgeInsets.only(top: 16, bottom: 0),
                   child: ListView(
                     physics: const NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                     children: [
                       CheckboxListTile( //checkbox positioned at right
                         value: check1,
                         activeColor: Color(ColorConstants.getPeachDark()),
                         onChanged: (bool? value) {
                           setState(() {
                             check1 = value;
                           });
                         },
                         title: const Text("Lack of features"),
                       ),
                       CheckboxListTile( //checkbox positioned at right
                         value: check2,
                         activeColor: Color(ColorConstants.getPeachDark()),
                         onChanged: (bool? value) {
                           setState(() {
                             check2 = value;
                           });
                         },
                         title: const Text("Poor user experience"),
                       ),
                       CheckboxListTile( //checkbox positioned at right
                         value: check3,
                         activeColor: Color(ColorConstants.getPeachDark()),
                         onChanged: (bool? value) {
                           setState(() {
                             check3 = value;
                           });
                         },
                         title: const Text("Poor value for money"),
                       ),
                       CheckboxListTile( //checkbox positioned at right
                         value: check4,
                         activeColor: Color(ColorConstants.getPeachDark()),
                         onChanged: (bool? value) {
                           setState(() {
                             check4 = value;
                           });
                         },
                         title: const Text("Found a better alternative"),
                       ),
                       CheckboxListTile( //checkbox positioned at right
                         value: check5,
                         activeColor: Color(ColorConstants.getPeachDark()),
                         onChanged: (bool? value) {
                           setState(() {
                             check5 = value;
                           });
                         },
                         title: const Text("Don\'t need it at the moment"),
                       ),
                       CheckboxListTile( //checkbox positioned at right
                         value: check6,
                         activeColor: Color(ColorConstants.getPeachDark()),
                         onChanged: (bool? value) {
                           setState(() {
                             check6 = value;
                           });
                         },
                         title: const Text("Other"),
                       ),
                       GestureDetector(
                         onTap: () {
                           if(canProgress()) {
                             if(Device.get().isIos) {
                               launchUrl(Uri.parse("https://apps.apple.com/account/subscriptions"));
                             } else {
                               launchUrl(Uri.parse('https://play.google.com/store/account/subscriptions?sku=pro.monthly.testsku&package=com.dandylight.mobile'));
                             }
                             EventSender().sendEvent(eventName: EventNames.SUBSCRIPTION_CANCELED, properties: {
                               EventNames.SUBSCRIPTION_CANCELED_PARAM : getReason(),
                             });
                           }
                         },
                         child: Container(
                           alignment: Alignment.center,
                           margin: EdgeInsets.only(top: 16),
                           height: 54,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(27),
                             color: Color(canProgress() ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryGreyMedium()),
                           ),
                           child: TextDandyLight(
                             type: TextDandyLight.LARGE_TEXT,
                             text: 'Cancel Subscription',
                             color: Color(ColorConstants.getPrimaryWhite()),
                           ),
                         ),
                       ),
                     ],
                   )
                 ),
               ],
             ),
         ),
    );

  bool canProgress() {
    return check1 == true || check2 == true || check3 == true || check4 == true || check5 == true || check6 == true;
  }

  String getReason() {
    if(check1 == true) return 'Lack of features';
    if(check1 == true) return 'Poor user experience';
    if(check1 == true) return 'Poor value for money';
    if(check1 == true) return 'Found a better alternative';
    if(check1 == true) return 'Don\'t need it at the moment';
    if(check1 == true) return 'Other';
    return '';
  }
}