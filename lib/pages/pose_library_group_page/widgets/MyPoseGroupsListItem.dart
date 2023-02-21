import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../pose_group_page/GroupImage.dart';
import '../LibraryPoseGroupPageState.dart';

class MyPoseGroupsListItemWidget extends StatelessWidget {
  final int index;

  MyPoseGroupsListItemWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 101,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    pageState.myPoseGroups.elementAt(index).poses.length == 0 || (pageState.myPoseGroupImages.isNotEmpty && pageState.myPoseGroupImages.length > index && pageState.myPoseGroupImages.elementAt(index).path.isNotEmpty) ?
                    Container(
                      height: 76.0,
                      width: 76.0,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.myPoseGroupImages.isNotEmpty && pageState.myPoseGroupImages.length > index && pageState.myPoseGroupImages.elementAt(index).path.isNotEmpty
                              ? FileImage(pageState.myPoseGroupImages.elementAt(index))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : Container(
                      height: 76.0,
                      width: 76.0,
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getPeachLight()),
                        borderRadius: new BorderRadius.circular(16.0),
                      ),
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Color(ColorConstants.getPrimaryWhite()),
                        size: 32,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: pageState.myPoseGroups.elementAt(index).groupName,
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
    );
  }
}
