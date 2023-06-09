import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/widgets/SaveSubmittedPoseToMyPosesBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:super_banners/super_banners.dart';

import '../../../models/Job.dart';
import '../../../widgets/TextDandyLight.dart';
import '../PosesPageState.dart';
import 'SaveSubmittedPoseToJobBottomSheet.dart';
import 'SaveToJobBottomSheet.dart';
import 'SaveToMyPosesBottomSheet.dart';

class SubmittedPoseListWidget extends StatelessWidget {
  final int index;
  final Job job;

  SubmittedPoseListWidget(this.index, this.job);

  void _showSaveToMyPosesBottomSheet(BuildContext context, selectedIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SaveSubmittedPoseToMyPosesBottomSheet(selectedIndex);
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
        return SaveSubmittedPoseToJobBottomSheet(selectedIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Stack(
            children: [
              pageState.submittedPoses.length > index ? Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: pageState.submittedPoses.isNotEmpty ? FileImage(File(pageState.submittedPoses.elementAt(index).file.path))
                        : AssetImage("assets/images/backgrounds/image_background.png"),
                  ),
                ),
              ) : SizedBox(),
              pageState.submittedPoses.length > index ? Container(
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
              Container(
                alignment: Alignment.bottomRight,
                child: CornerBanner(
                  bannerPosition: CornerBannerPosition.bottomRight,
                  bannerColor: Color(ColorConstants.getPeachDark()),
                  child: Text(
                    pageState.submittedPoses.elementAt(index).pose.reviewStatus,
                    style: TextStyle(
                      fontFamily: TextDandyLight.getFontFamily(),
                      fontSize: TextDandyLight.getFontSize(TextDandyLight.EXTRA_SMALL_TEXT),
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ),
              pageState.submittedPoses.length > index ? job == null ? GestureDetector(
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
              pageState.submittedPoses.length > index ?  job == null ? GestureDetector(
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
              pageState.submittedPoses.length <= index ? Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPeachLight()),
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  size: 32,
                ),
              ) : SizedBox()
            ],
          ),
    );
  }
}
