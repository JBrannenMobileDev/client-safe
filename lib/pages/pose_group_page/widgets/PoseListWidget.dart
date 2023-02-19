import 'dart:async';
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../GroupImage.dart';

class PoseListWidget extends StatelessWidget {
  final int index;

  PoseListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PoseGroupPageState>(
      converter: (store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
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
              isCurrentImageInSelectedImages(index, pageState) ? Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: Stack(
                      children: [
                        Icon(
                          Device.get().isIos ? CupertinoIcons.circle_fill : Icons.circle,
                          size: 26.0,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                        Icon(
                          Device.get().isIos ? CupertinoIcons.check_mark_circled_solid : Icons.check_circle,
                          size: 26.0,
                          color: Color(ColorConstants.getPeachDark()),
                        )
                      ],
                    ),
                  ),
                ),
              ) : SizedBox()
            ],
          ),
    );
  }

  isCurrentImageInSelectedImages(int index, PoseGroupPageState pageState) {
    GroupImage currentImage = pageState.poseImages.elementAt(index);
    return pageState.selectedImages.contains(currentImage);
  }
}
