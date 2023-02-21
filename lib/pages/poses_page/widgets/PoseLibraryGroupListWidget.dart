

import 'package:dandylight/AppState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/ColorConstants.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../pose_group_page/PoseGroupPage.dart';
import '../../pose_library_group_page/LibraryPoseGroupPage.dart';
import '../PosesPageState.dart';

class PoseLibraryGroupListWidget extends StatelessWidget {
  final int index;

  PoseLibraryGroupListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
      InkWell(
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(builder: (context) => LibraryPoseGroupPage(pageState.libraryGroups.elementAt(index))),
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
                    pageState.libraryGroups.elementAt(index).poses.length == 0 || (pageState.libraryGroupImages.isNotEmpty && pageState.libraryGroupImages.length > index && pageState.libraryGroupImages.elementAt(index).path.isNotEmpty) ?
                    Container(
                      height: 108.0,
                      width: 108.0,
                      margin: EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: pageState.libraryGroupImages.isNotEmpty && pageState.libraryGroupImages.length > index && pageState.libraryGroupImages.elementAt(index).path.isNotEmpty
                              ? FileImage(pageState.libraryGroupImages.elementAt(index))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                    ) : Container(
                      height: 108.0,
                      width: 108.0,
                      margin: EdgeInsets.only(right: 16.0),
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getPeachLight()),
                        borderRadius: new BorderRadius.circular(16.0),
                      ),
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          size: 32,
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
                                text: pageState.libraryGroups.elementAt(index).groupName,
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ), Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: pageState.libraryGroups.elementAt(index).poses.length.toString(),
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