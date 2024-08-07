import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';

class StartAJobButton extends StatelessWidget {
  const StartAJobButton({Key? key, this.pageState}) : super(key: key);

  final DashboardPageState? pageState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationUtil.showNewJobPage(context);
        EventSender().sendEvent(eventName: EventNames.BT_START_NEW_JOB, properties: {EventNames.JOB_PARAM_COMING_FROM : "Start a Job Button On Dashboard"});
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        height: 64.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryGreyDark()),
            borderRadius: const BorderRadius.all(Radius.circular(12.0))),
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
