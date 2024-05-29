

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Pose.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:super_banners/super_banners.dart';

import '../../../models/Job.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../pose_group_page/PoseGroupPage.dart';
import '../../pose_library_group_page/LibraryPoseGroupPage.dart';
import '../PosesPageState.dart';

class PoseLibraryGroupListWidget extends StatelessWidget {
  final int? index;
  final Job? job;
  final bool? comingFromDetails;

  PoseLibraryGroupListWidget(this.index, this.job, this.comingFromDetails);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
      InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => LibraryPoseGroupPage(pageState.libraryGroups!.elementAt(index!), job, comingFromDetails)),
          );
          EventSender().sendEvent(eventName: EventNames.NAV_TO_POSE_LIBRARY_GROUP);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: pageState.libraryGroups!.elementAt(index!).poses!.length > 0 ? Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 108.0,
                          width: 108.0,
                          margin: EdgeInsets.only(right: 16.0),
                          child: DandyLightNetworkImage(
                            pageState.libraryGroups!.elementAt(index!).poses!.first.imageUrl ?? '',
                            borderRadius: 16,
                            resizeWidth: 350,
                            errorIconSize: 24,
                          ),
                        ),
                        containsNewPoses(pageState.libraryGroups!.elementAt(index!).poses ?? []) ? Container(
                          margin: EdgeInsets.only(right: 16),
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
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: pageState.libraryGroups!.elementAt(index!).groupName,
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 132,
                alignment: Alignment.centerRight,
                width: double.infinity,
                child: Icon(
                  Icons.chevron_right,
                  color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                ),
              ),
            ],
          ) : SizedBox(),
        ),
      ),
    );
  }

  bool containsNewPoses(List<Pose> poses) {
    for(Pose pose in poses) {
      if(pose.isNewPose()) return true;
    }
    return false;
  }
}
