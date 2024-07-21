import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import 'package:super_banners/super_banners.dart';
import '../../../AppState.dart';
import '../../../models/Contract.dart';
import '../../../models/Job.dart';
import '../../../models/Pose.dart';
import '../../../models/PoseLibraryGroup.dart';
import '../../../models/Questionnaire.dart';
import '../../../utils/DeviceType.dart';
import '../../../utils/NavigationUtil.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../pose_library_group_page/LibraryPoseGroupPage.dart';

class PoseLibraryCard extends StatelessWidget {
  const PoseLibraryCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, DashboardPageState>(
    converter: (Store<AppState> store) => DashboardPageState.fromStore(store),
    builder: (BuildContext context, DashboardPageState pageState) =>  Container(
      height: 134,
      margin: const EdgeInsets.only(bottom: 16, top: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: buildGroupItems(pageState, context),
      ),
    ),
  );

  List<Widget> buildGroupItems(DashboardPageState pageState, BuildContext context) {
    List<Widget> widgets = List.filled(9, Padding(
        padding: EdgeInsets.only(left: 16.0, right: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 108.0,
              width: 96.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(ColorConstants.getPeachLight())
              ),
              child: LoadingAnimationWidget.fourRotatingDots(
                color: Color(ColorConstants.getPrimaryWhite()),
                size: 32,
              ),
            )
          ],
        )));

    if(pageState.poseGroups?.isNotEmpty ?? false) {
      widgets = [];
      List<PoseLibraryGroup> groups = pageState.poseGroups ?? [];
      for(int index = 0; index < groups.length; index++) {
        widgets.add(
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LibraryPoseGroupPage(pageState.poseGroups!.elementAt(index), null, false)),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 0.0),
                child: pageState.poseGroups!.elementAt(index).poses!.length > 0 ? Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 108.0,
                                width: 96.0,
                                child: DandyLightNetworkImage(
                                  pageState.poseGroups!.elementAt(index).poses!.first.imageUrl ?? '',
                                  borderRadius: 8,
                                  resizeWidth: 350,
                                  errorIconSize: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              containsNewPoses(pageState.poseGroups!.elementAt(index).poses ?? []) ? Container(
                                margin: EdgeInsets.only(right: 0),
                                alignment: Alignment.bottomRight,
                                child: CornerBanner(
                                  bannerPosition: CornerBannerPosition.bottomRight,
                                  bannerColor: Color(ColorConstants.getPeachDark()),
                                  child: Text(
                                    "NEW",
                                    style: TextStyle(
                                      fontFamily: TextDandyLight.getFontFamily(),
                                      fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
                                      color: Color(ColorConstants.getPrimaryWhite()),
                                    ),
                                  ),
                                ),
                              ) : const SizedBox()
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.0),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: pageState.poseGroups!.elementAt(index).groupName,
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ) : SizedBox(),
              ),
            )
        );
    }}
    return widgets;
  }

  bool containsNewPoses(List<Pose> poses) {
    for(Pose pose in poses) {
      if(pose.isNewPose()) return true;
    }
    return false;
  }

  bool areContractResultsNew(List<Contract> contracts) {
    bool result = false;
    for(Contract contract in contracts) {
      if(!(contract.isReviewed ?? false)) result = true;
    }
    return result;
  }

  bool areQuestionnaireResultsNew(List<Questionnaire> questionnaires) {
    bool result = false;
    for(Questionnaire questionnaire in questionnaires) {
      if(!(questionnaire.isReviewed ?? false)) result = true;
    }
    return result;
  }
}

