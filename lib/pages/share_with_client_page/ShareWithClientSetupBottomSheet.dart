import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'ShareWithClientPageState.dart';


class ShareWithClientSetupBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState();
  }
}

class _BottomSheetPageState extends State<ShareWithClientSetupBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  bool shouldPop = false;
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }


  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if(shouldPop) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ShareWithClientPageState>(
    onDidChange: (previous, current) {
      if(current.profile.hasSetupBrand && current.profile.isProfileComplete() && current.profile.paymentOptionsSelected()) {
        setState(() {
          shouldPop = true;
        });
      }
    },
    converter: (Store<AppState> store) => ShareWithClientPageState.fromStore(store),
    builder: (BuildContext context, ShareWithClientPageState pageState) =>
         Stack(
           alignment: Alignment.topRight,
           children: [
             Container(
               height: 300,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 32.0, right: 32.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(top: 24, bottom: 0.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Client Portal Setup',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                   Container(
                     margin: EdgeInsets.only(top: 0, bottom: 24.0),
                     child: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: '(required)',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       NavigationUtil.onEditProfileSelected(context, pageState.profile);
                     },
                     child: Container(
                       height: 48,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Container(
                                 margin: EdgeInsets.only(right: 16),
                                 height: 24,
                                 width: 24,
                                 child: Image.asset(
                                   'assets/images/job_progress/complete_check.png',
                                   color: Color(pageState.profile.isProfileComplete() ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryGreyMedium()),
                                 ),
                               ),
                               TextDandyLight(
                                   type: TextDandyLight.MEDIUM_TEXT,
                                   text: 'Setup Business Info'
                               ),
                             ],
                           ),
                           Container(
                             margin: EdgeInsets.only(),
                             child: Icon(
                               Icons.chevron_right,
                               color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       NavigationUtil.onEditBrandingSelected(context);
                       EventSender().sendEvent(eventName: EventNames.BRANDING_EDIT_FROM_SHARE);
                     },
                     child: Container(
                       height: 48,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Container(
                                 margin: EdgeInsets.only(right: 16),
                                 height: 24,
                                 width: 24,
                                 child: Image.asset(
                                   'assets/images/job_progress/complete_check.png',
                                   color: Color(pageState.profile.hasSetupBrand ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryGreyMedium()),
                                 ),
                               ),
                               TextDandyLight(
                                   type: TextDandyLight.MEDIUM_TEXT,
                                   text: 'Setup Branding'
                               ),
                             ],
                           ),
                           Container(
                             margin: EdgeInsets.only(),
                             child: Icon(
                               Icons.chevron_right,
                               color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       NavigationUtil.onPaymentRequestInfoSelected(context);
                     },
                     child: Container(
                       height: 48,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Container(
                                 margin: EdgeInsets.only(right: 16),
                                 height: 24,
                                 width: 24,
                                 child: Image.asset(
                                   'assets/images/job_progress/complete_check.png',
                                   color: Color(pageState.profile.paymentOptionsSelected() ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryGreyMedium()),
                                 ),
                               ),
                               TextDandyLight(
                                   type: TextDandyLight.MEDIUM_TEXT,
                                   text: 'Setup Payment Options'
                               ),
                             ],
                           ),
                           Container(
                             margin: EdgeInsets.only(),
                             child: Icon(
                               Icons.chevron_right,
                               color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                             ),
                           ),
                         ],
                       ),
                     ),
                   )
                 ],
               ),
             ),
             GestureDetector(
               onTap: () {
                 if(shouldPop) {
                   Navigator.of(context).pop();
                 } else {
                   Navigator.of(context).pop();
                   Navigator.of(context).pop();
                 }
               },
               child: Container(
                 height: 54,
                 width: 54,
                 margin: EdgeInsets.only(),
                 child: Icon(Icons.close, color: Color(ColorConstants.getPrimaryBlack(),)
               ),
               ),
             ),
           ],
         ),
    );
}