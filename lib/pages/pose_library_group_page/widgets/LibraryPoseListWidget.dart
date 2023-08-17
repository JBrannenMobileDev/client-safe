import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/widgets/DandyLightNetworkImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:super_banners/super_banners.dart';

import '../../../models/Job.dart';
import '../../../widgets/TextDandyLight.dart';
import '../LibraryPoseGroupPageState.dart';
import 'SaveToJobBottomSheet.dart';
import 'SaveToMyPosesBottomSheet.dart';

class LibraryPoseListWidget extends StatelessWidget {
  final int index;
  final Job job;

  LibraryPoseListWidget(this.index, this.job);

  void _showSaveToMyPosesBottomSheet(BuildContext context, selectedIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SaveToMyPosesBottomSheet(selectedIndex);
      },
    );
  }

  void _showSaveToJobBottomSheet(BuildContext context, selectedIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SaveToJobBottomSheet(selectedIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          Stack(
            children: [
              pageState.sortedPoses.length > index ? DandyLightNetworkImage(
                pageState.sortedPoses.elementAt(index).imageUrl
              ) : SizedBox(),
              pageState.sortedPoses.length > index ? Container(
                height: 150.0,
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                        begin: FractionalOffset.center,
                        end: FractionalOffset.topCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.05),
                        ],
                        stops: [
                          0.0,
                          1.0
                        ])),
              ) : SizedBox(),
              pageState.sortedPoses.length > index ? pageState.sortedPoses.elementAt(index).isNewPose() ? Container(
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
              ) : SizedBox() : SizedBox(),
              pageState.sortedPoses.length > index ? job == null ? GestureDetector(
                onTap: () {
                  _showSaveToJobBottomSheet(context, index);
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        height: 24,
                        width: 24,
                        margin: EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Image.asset(
                          'assets/images/icons/plus.png',
                          color: Color(ColorConstants.getPrimaryWhite()),
                          height: 24,
                          width: 24,
                        )
                    ),
                  ),
              ) : SizedBox() : SizedBox(),
              pageState.sortedPoses.length > index ?  job == null ? GestureDetector(
                onTap: () {
                  _showSaveToMyPosesBottomSheet(context, index);
                },
                child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 24,
                        width: 24,
                        margin: EdgeInsets.only(right: 8.0, top: 8.0),
                        child: Image.asset(
                          'assets/images/icons/ribbon.png',
                          color: Color(ColorConstants.getPrimaryWhite()),
                          height: 24,
                          width: 24,
                        )
                    ),
                  ),
              ) : SizedBox() : SizedBox(),
            ],
          ),
    );
  }
}
