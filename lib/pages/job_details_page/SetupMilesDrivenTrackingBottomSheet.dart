import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../widgets/TextDandyLight.dart';
import 'JobDetailsPageState.dart';


class SetupMilesDrivenTrackingBottomSheet extends StatefulWidget {
  const SetupMilesDrivenTrackingBottomSheet({Key key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState();
  }
}

class _BottomSheetPageState extends State<SetupMilesDrivenTrackingBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
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
  Widget build(BuildContext context) => StoreConnector<AppState, JobDetailsPageState>(
    onDidChange: (previous, current) {
      // if(current.profile.hasSetupBrand && current.profile.isProfileComplete() && current.profile.paymentOptionsSelected()) {
      //   setState(() {
      //     shouldPop = true;
      //   });
      // }
    },
    converter: (Store<AppState> store) => JobDetailsPageState.fromStore(store),
    builder: (BuildContext context, JobDetailsPageState pageState) =>
         Stack(
           alignment: Alignment.topRight,
           children: [
             Container(
               height: 400,
               decoration: BoxDecoration(
                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: const EdgeInsets.only(left: 32.0, right: 32.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     margin: const EdgeInsets.only(top: 24, bottom: 0.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Track your miles Setup',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                   Container(
                     margin: const EdgeInsets.only(top: 0, bottom: 24.0),
                     child: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: '(required)',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                   Container(
                     margin: const EdgeInsets.only(top: 0, bottom: 24.0),
                     child: TextDandyLight(
                       type: TextDandyLight.MEDIUM_TEXT,
                       text: 'To automatically track your miles driven you must setup a home location, a job location, and a session date.',
                       textAlign: TextAlign.start,
                       color: Color(ColorConstants.getPrimaryBlack()),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       NavigationUtil.onSelectMapLocation(
                           context,
                           pageState.onStartLocationChanged,
                           0.0,
                           0.0,
                           null,
                       );
                     },
                     child: SizedBox(
                       height: 48,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Container(
                                 margin: const EdgeInsets.only(right: 16),
                                 height: 24,
                                 width: 24,
                                 child: Image.asset(
                                   'assets/images/job_progress/complete_check.png',
                                   color: Color(pageState.profile.hasDefaultHome() ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium()),
                                 ),
                               ),
                               TextDandyLight(
                                   type: TextDandyLight.MEDIUM_TEXT,
                                   text: 'Select a home location'
                               ),
                             ],
                           ),
                           Container(
                             margin: const EdgeInsets.only(),
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
                       UserOptionsUtil.showLocationSelectionDialog(context);
                     },
                     child: SizedBox(
                       height: 48,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Container(
                                 margin: const EdgeInsets.only(right: 16),
                                 height: 24,
                                 width: 24,
                                 child: Image.asset(
                                   'assets/images/job_progress/complete_check.png',
                                   color: Color(pageState.selectedLocation != null ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium()),
                                 ),
                               ),
                               TextDandyLight(
                                   type: TextDandyLight.MEDIUM_TEXT,
                                   text: 'Select a job location'
                               ),
                             ],
                           ),
                           Container(
                             margin: const EdgeInsets.only(),
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
                       UserOptionsUtil.showDateSelectionCalendarDialog(context);
                     },
                     child: SizedBox(
                       height: 48,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               Container(
                                 margin: const EdgeInsets.only(right: 16),
                                 height: 24,
                                 width: 24,
                                 child: Image.asset(
                                   'assets/images/job_progress/complete_check.png',
                                   color: Color(pageState.selectedDate != null ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium()),
                                 ),
                               ),
                               TextDandyLight(
                                   type: TextDandyLight.MEDIUM_TEXT,
                                   text: 'Set a session date'
                               ),
                             ],
                           ),
                           Container(
                             margin: const EdgeInsets.only(),
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
                 Navigator.of(context).pop();
                 // if(shouldPop) {
                 //   Navigator.of(context).pop();
                 // } else {
                 //   Navigator.of(context).pop();
                 //   Navigator.of(context).pop();
                 // }
               },
               child: Container(
                 height: 54,
                 width: 54,
                 margin: const EdgeInsets.only(),
                 child: Icon(Icons.close, color: Color(ColorConstants.getPrimaryBlack(),)
               ),
               ),
             ),
           ],
         ),
    );
}