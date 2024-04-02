import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/DandyLightNetworkImage.dart';


class PosesMyPoseGroupsListItem extends StatelessWidget {
  final int? index;

  PosesMyPoseGroupsListItem(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 104,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 76.0,
                      width: 76.0,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        color: Color(ColorConstants.getPeachLight()),
                      ),
                      child: DandyLightNetworkImage(
                        pageState.poseGroups!.elementAt(index!).poses!.isNotEmpty ? pageState.poseGroups!.elementAt(index!).poses?.first.imageUrl ?? '' : '',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: TextDandyLight(
                        type: TextDandyLight.SMALL_TEXT,
                        text: pageState.poseGroups!.elementAt(index!).groupName,
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
