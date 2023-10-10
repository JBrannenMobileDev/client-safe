import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
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


class RequestPMFSurveyBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RequestPMFSurveyBottomSheetState();
  }
}

class _RequestPMFSurveyBottomSheetState extends State<RequestPMFSurveyBottomSheet> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>
         Container(
           height: 332,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
               color: Color(ColorConstants.getPrimaryWhite())),
           padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
             child: Column(
               children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 64),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: 'Please help us improve DandyLight!',
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 54,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: Color(ColorConstants.getPeachDark())
                    ),
                    child: TextDandyLight(
                      type: TextDandyLight.LARGE_TEXT,
                      text: '2 min survey',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                 Container(
                   child: Checkbox(
                     value: null,
                     onChanged: (checked) {

                     },
                   ),
                 )
               ],
             ),
         ),
    );
}