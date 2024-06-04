import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import '../../../AppState.dart';
import '../../../utils/DeviceType.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/Shadows.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/TextDandyLight.dart';

class ProfileAndJobsCard extends StatelessWidget {
  const ProfileAndJobsCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>  Container(
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
            height: 72.0,
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: const BorderRadius.all(Radius.circular(12.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    NavigationUtil.onStageStatsSelected(context, pageState, 'Jobs This Week', null, false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryWhite()),
                        borderRadius: const BorderRadius.all(Radius.circular(42.0))),
                    width: (MediaQuery.of(context).size.width - 32) / 3  - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: pageState.jobsThisWeek != null ? pageState.jobsThisWeek!.length.toString() : '',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                        TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'This week',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                  width: (MediaQuery.of(context).size.width - 72) / 3,
                ),
                GestureDetector(
                  onTap: () {
                    NavigationUtil.onStageStatsSelected(context, pageState, 'Active Jobs', null, true);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryWhite()),
                        borderRadius: const BorderRadius.all(Radius.circular(42.0))),
                    width: (MediaQuery.of(context).size.width - 32) / 3 - (DeviceType.getDeviceType() == Type.Tablet ? 150 : 0),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.activeJobs != null ? pageState.activeJobs!.length.toString() : '',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: 'Active',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
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
                  EventSender().sendEvent(eventName: EventNames.BRANDING_EDIT_FROM_DASHBOARD);
                },
                child:  pageState.profile!.hasSetupBrand! ? pageState.profile!.logoSelected! ? Container(
                  child: pageState.profile!.logoUrl != null && pageState.profile!.logoUrl!.isNotEmpty && pageState.profile!.hasSetupBrand! ? ClipRRect(
                    borderRadius: BorderRadius.circular(82.0),
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
                        ),
                        width: 96,
                        height: 96,
                        child: DandyLightNetworkImage(
                          pageState.profile!.logoUrl ?? '',
                          color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!),
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
                            color: Color(ColorConstants.getPeachDark())),
                      ),
                      Container(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          size: 48,
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
                          color: pageState.profile!.logoSelected!
                              ? Color(ColorConstants.getPrimaryGreyMedium())
                              : ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconColor!)),
                    ),
                    TextDandyLight(
                      type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                      fontFamily: pageState.profile!.selectedFontTheme!.iconFont!,
                      textAlign: TextAlign.center,
                      text: pageState.profile!.logoCharacter!.substring(0, 1),
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.iconTextColor!),
                    )
                  ],
                ) : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(ColorConstants.getPeachDark())),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          alignment: Alignment.center,
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/file_upload.png', color: Color(ColorConstants.getPeachLight()),),
                        ),
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          textAlign: TextAlign.center,
                          text: 'Upload\nLogo',
                          color: Color(ColorConstants.getPeachLight()),
                        ),
                      ],
                    ),
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

