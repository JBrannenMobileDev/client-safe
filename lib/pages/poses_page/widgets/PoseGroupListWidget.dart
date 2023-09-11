

import 'package:dandylight/AppState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../models/Job.dart';
import '../../../utils/ColorConstants.dart';
import '../../../widgets/DandyLightNetworkImage.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../pose_group_page/PoseGroupPage.dart';
import '../PosesPageState.dart';

class PoseGroupListWidget extends StatelessWidget {
  final int index;
  final Job job;
  final bool comingFromDetails;

  PoseGroupListWidget(this.index, this.job, this.comingFromDetails);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
      InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => PoseGroupPage(pageState.poseGroups.elementAt(index), job, comingFromDetails)),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 108.0,
                      width: 108.0,
                      margin: EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        color: Color(ColorConstants.getPeachLight())
                      ),
                      child: DandyLightNetworkImage(
                        pageState.poseGroups.elementAt(index).poses.isNotEmpty ? pageState.poseGroups.elementAt(index).poses.elementAt(0)?.imageUrl : '',
                        borderRadius: 16,
                        resizeWidth: 350,
                        errorIconSize: 64,
                        errorType: DandyLightNetworkImage.ERROR_TYPE_NO_IMAGE,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 2.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.poseGroups.elementAt(index).groupName,
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ), Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.poseGroups.elementAt(index).poses?.length.toString(),
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPeachDark()),
                              ),
                            ),
                          ],
                        ),
                      ],
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
          ),
        ),
      ),
    );
  }
}
