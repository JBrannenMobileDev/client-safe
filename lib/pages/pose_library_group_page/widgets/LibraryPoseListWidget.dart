import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../pose_group_page/GroupImage.dart';
import '../LibraryPoseGroupPageState.dart';

class LibraryPoseListWidget extends StatelessWidget {
  final int index;

  LibraryPoseListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: pageState.poseImages.isNotEmpty ? FileImage(File(pageState.poseImages.elementAt(index).file.path))
                        : AssetImage("assets/images/backgrounds/image_background.png"),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Image.asset(
                        'assets/images/icons/plus.png',
                        color: Color(ColorConstants.getPrimaryWhite()),
                        height: 24,
                        width: 24,
                      )
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 8.0, top: 8.0),
                      child: Image.asset(
                        'assets/images/icons/ribbon.png',
                        color: Color(ColorConstants.getPrimaryWhite()),
                        height: 24,
                        width: 24,
                      )
                  ),
                ),
              ),
            ],
          ),
    );
  }

  isCurrentImageInSelectedImages(int index, PoseGroupPageState pageState) {
    GroupImage currentImage = pageState.poseImages.elementAt(index);
    return pageState.selectedImages.contains(currentImage);
  }
}
