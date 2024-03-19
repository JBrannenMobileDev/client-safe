import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/pages/pose_group_page/widgets/SaveToJobBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../models/Job.dart';
import '../../../widgets/DandyLightNetworkImage.dart';

class PoseListWidget extends StatelessWidget {
  final int? index;
  final Job? job;

  PoseListWidget(this.index, this.job);

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
    return StoreConnector<AppState, PoseGroupPageState>(
      converter: (store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
          Stack(
            children: [
              pageState.poseImages!.length > index! ? DandyLightNetworkImage(
                  pageState.poseImages!.elementAt(index!).imageUrl!
              ) : SizedBox(),
              pageState.poseImages!.length > index! ? Container(
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
              pageState.poseImages!.length > index! ? job == null ? GestureDetector(
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
              pageState.poseImages!.length > index! ? job == null? GestureDetector(
                onTap: () {
                  pageState.onDeletePoseSelected!(pageState.poseImages!.elementAt(index!));
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: 24,
                      width: 24,
                      margin: EdgeInsets.only(right: 8.0, top: 8.0),
                      child: Image.asset(
                        'assets/images/icons/trash.png',
                        color: Color(ColorConstants.getPrimaryWhite()),
                        height: 24,
                        width: 24,
                      )
                  ),
                ),
              ) : SizedBox() : SizedBox(),
              pageState.poseImages!.length <= index! ? Container(
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
