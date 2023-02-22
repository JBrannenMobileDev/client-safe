import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../models/Job.dart';
import 'DashboardPageState.dart';


class GoToJobPosesBottomSheet extends StatefulWidget {
  final Job job;

  GoToJobPosesBottomSheet(this.job);

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
           height: 200,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0),
             child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.only(top: 24, bottom: 32),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: job.jobTitle,
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.primary_black),
                       ),
                     ),
                     GestureDetector(
                       onTap: () {
                         pageState.onJobClicked(job);
                         Navigator.of(context).pop();
                         NavigationUtil.onJobPosesSelected(context);
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
                           text: 'GO TO JOB POSES',
                         ),
                       ),
                     ),
                   ],
           ),
         ),
    );
}