import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/DandyLightNetworkImage.dart';
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
                child: pageState.myPoseGroups.elementAt(index).poses.length > 0 ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 76.0,
                      width: 76.0,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.myPoseGroups.elementAt(index).poses.elementAt(0).imageUrl,
                        resizeWidth: 250,
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
                ) : SizedBox(),
              ),
            ],
          )
    );
  }
}
