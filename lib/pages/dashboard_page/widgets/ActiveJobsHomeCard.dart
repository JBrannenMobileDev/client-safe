import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';

class ActiveJobsHomeCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) => GestureDetector(
          onTap: () {
            NavigationUtil.onStageStatsSelected(context, pageState, 'Active Jobs', null, true);
            EventSender().sendEvent(eventName: EventNames.NAV_TO_ACTIVE_JOBS);
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            height: 64.0,
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(24.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(right: 18.0, left: 16.0),
                      height: 28.0,
                      width: 28.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/icons/briefcase_icon_peach_dark.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Active Jobs',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.activeJobs != null ? pageState.activeJobs.length.toString() : '',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.chevron_right,
                        color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
  );
}

