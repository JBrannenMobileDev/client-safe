import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/Shadows.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/DandyLightPainter.dart';
import '../../../widgets/TextDandyLight.dart';

class ProfileAndJobsCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>  Container(
      margin: EdgeInsets.only(bottom: 32, top: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
            height: 72.0,
            decoration: new BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: new BorderRadius.all(Radius.circular(42.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    NavigationUtil.onStageStatsSelected(context, pageState, 'Jobs This Week', null, false);
                    EventSender().sendEvent(eventName: EventNames.NAV_TO_JOBS_THIS_WEEK);
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Color(ColorConstants.getPrimaryWhite()),
                        borderRadius: new BorderRadius.all(Radius.circular(42.0))),
                    width: (MediaQuery.of(context).size.width - 32) / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: pageState.jobsThisWeek != null ? pageState.jobsThisWeek.length.toString() : '',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.primary_black),
                        ),
                        TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'This week',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: (MediaQuery.of(context).size.width - 72) / 3,
                ),
                GestureDetector(
                  onTap: () {
                    NavigationUtil.onStageStatsSelected(context, pageState, 'Active Jobs', null, true);
                    EventSender().sendEvent(eventName: EventNames.NAV_TO_ACTIVE_JOBS);
                  },
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Color(ColorConstants.getPrimaryWhite()),
                        borderRadius: new BorderRadius.all(Radius.circular(42.0))),
                    width: (MediaQuery.of(context).size.width - 32) / 3,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.activeJobs != null ? pageState.activeJobs.length.toString() : '',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.primary_black),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Active',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: ElevationToShadow[2],
                  shape: BoxShape.circle,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
                width: 108,
                height: 108,
              ),
              GestureDetector(
                onTap: () {
                  NavigationUtil.onEditBrandingSelected(context);
                },
                child: pageState.profile.logoSelected ? Container(
                  child: pageState.profile.logoUrl != null && pageState.profile.logoUrl.isNotEmpty ? ClipRRect(
                    borderRadius: new BorderRadius.circular(82.0),
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                        ),
                        width: 96,
                        height: 96,
                        child: DandyLightNetworkImage(
                          pageState.profile.logoUrl,
                          color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor),
                        )
                    ),
                  ) : Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(ColorConstants.getPrimaryWhite())),
                      ),
                      CustomPaint(
                        size: Size(96, 96),
                        foregroundPainter: DandyLightPainter(
                            completeColor: Color(ColorConstants.getPrimaryGreyMedium()),
                            width: 2
                        ),
                      ),
                      Container(
                        child: TextDandyLight(
                          type: TextDandyLight
                              .MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          text: 'Upload\nimage\n( .jpg or .png )',
                          color: Color(ColorConstants
                              .getPrimaryGreyMedium()),
                        ),
                      ),
                    ],
                  ),
                ) : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: pageState.profile.logoSelected
                              ? Color(ColorConstants.getPrimaryGreyMedium())
                              : ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconColor)),
                    ),
                    TextDandyLight(
                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                      fontFamily: pageState.profile.selectedFontTheme.iconFont,
                      textAlign: TextAlign.center,
                      text: pageState.profile.logoCharacter.substring(0, 1),
                      color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.iconTextColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

