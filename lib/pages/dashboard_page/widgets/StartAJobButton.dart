import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';

class StartAJobButton extends StatelessWidget {
  StartAJobButton({this.pageState});

  final DashboardPageState pageState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserOptionsUtil.showNewJobDialog(context, false);
        EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Start a Job Button On Dashboard"});
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        height: 64.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            color: Color(ColorConstants.getBlueDark()),
            borderRadius: new BorderRadius.all(Radius.circular(16.0))),
        child: TextDandyLight(
          type: TextDandyLight.LARGE_TEXT,
          text: 'START NEW JOB',
          textAlign: TextAlign.center,
          color: Color(ColorConstants.getPrimaryWhite()),
        ),
      ),
    );
  }
}
