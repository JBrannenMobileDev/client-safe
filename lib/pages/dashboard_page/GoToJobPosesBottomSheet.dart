import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Job.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'DashboardPageState.dart';


class GoToJobPosesBottomSheet extends StatefulWidget {
  final Job job;

  const GoToJobPosesBottomSheet(this.job, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GoToJobPosesBottomSheetState(job);
  }
}

class _GoToJobPosesBottomSheetState extends State<GoToJobPosesBottomSheet> with TickerProviderStateMixin {
  final Job job;

  _GoToJobPosesBottomSheetState(this.job);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Container(
           height: 332,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: const EdgeInsets.only(left: 16.0, right: 16.0),
             child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: const EdgeInsets.only(top: 24, bottom: 0),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: 'Current Photoshoot',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.getPrimaryBlack()),
                       ),
                     ),
                     Container(
                       margin: const EdgeInsets.only(top: 8, bottom: 32),
                       child: TextDandyLight(
                         type: TextDandyLight.MEDIUM_TEXT,
                         text: job.jobTitle,
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.getPrimaryBlack()),
                       ),
                     ),
                     GestureDetector(
                       onTap: () {
                         pageState.onJobClicked!(job.documentId!);
                         Navigator.of(context).pop();
                         NavigationUtil.onJobPosesSelected(context);
                         EventSender().sendEvent(eventName: EventNames.NAV_TO_JOB_POSES_FROM_BOTTOM_SHEET);
                       },
                       child: Container(
                         height: 48,
                         width: 250,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(32),
                           color: Color(ColorConstants.getPeachDark()),
                         ),
                         child: TextDandyLight(
                           type: TextDandyLight.MEDIUM_TEXT,
                           color: Color(ColorConstants.getPrimaryWhite()),
                           text: 'Job Poses',
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap: () {
                         pageState.onJobClicked!(job.documentId!);
                         Navigator.of(context).pop();
                         NavigationUtil.onJobTapped(context, false);
                         EventSender().sendEvent(eventName: EventNames.NAV_TO_JOB_POSES_FROM_BOTTOM_SHEET);
                       },
                       child: Container(
                         margin: const EdgeInsets.only(top: 16),
                         height: 48,
                         width: 250,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(32),
                           color: Color(ColorConstants.getPeachDark()),
                         ),
                         child: TextDandyLight(
                           type: TextDandyLight.MEDIUM_TEXT,
                           color: Color(ColorConstants.getPrimaryWhite()),
                           text: 'Job Details',
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap: () {
                         if(job.location != null) {
                           pageState.drivingDirectionsSelected!(job.location!);
                         } else {
                            DandyToastUtil.showErrorToast('No location set for this job.');
                         }
                       },
                       child: Container(
                         margin: const EdgeInsets.only(top: 16),
                         height: 48,
                         width: 250,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(32),
                           color: job.location != null ? Color(ColorConstants.getPeachDark()) : Color(ColorConstants.getPrimaryGreyMedium()),
                         ),
                         child: TextDandyLight(
                           type: TextDandyLight.MEDIUM_TEXT,
                           color: Color(ColorConstants.getPrimaryWhite()),
                           text: 'Driving Directions',
                         ),
                       ),
                     ),
                   ],
           ),
         ),
    );
}