import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/TextDandyLight.dart';


class NewLocationImage extends StatefulWidget {
  @override
  _NewLocationImage createState() {
    return _NewLocationImage();
  }
}

class _NewLocationImage extends State<NewLocationImage> with AutomaticKeepAliveClientMixin {
  final locationNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewLocationPageState>(
      onInit: (store) {
        locationNameTextController.text = store.state.newLocationPageState!.locationName!;
      },
      converter: (store) => NewLocationPageState.fromStore(store),
      builder: (BuildContext context, NewLocationPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 26.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "Take or select a picture of this location.",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    bool isGranted = (await UserPermissionsUtil.showPermissionRequest(permission: Permission.camera, context: context, callOnGranted: null));
                    if(isGranted) {
                      getCameraImage(pageState);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    height: MediaQuery.of(context).size.width/4,
                    width: MediaQuery.of(context).size.width/4,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueDark()),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/icons/camera.png', color: Color(ColorConstants.getPrimaryWhite()),),
                  ),

                ),
                GestureDetector(
                  onTap: () async {
                    bool isGranted = await UserPermissionsUtil.showPermissionRequest(permission: Permission.photos, context: context, callOnGranted: null);
                    if(isGranted) {
                      getDeviceImage(pageState);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    height: MediaQuery.of(context).size.width/4,
                    width: MediaQuery.of(context).size.width/4,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueDark()),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/icons/photo.png', color: Color(ColorConstants.getPrimaryWhite()),),
                  ),

                )
              ],
            )
          ],
        ),
          ),
    );
  }

  Future getDeviceImage(NewLocationPageState pageState) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final filePath = "${image!.path}";
    pageState.saveImagePath!(filePath);
  }

  Future getCameraImage(NewLocationPageState pageState) async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    final filePath = "${image!.path}";
    pageState.saveImagePath!(filePath);
  }

  @override
  bool get wantKeepAlive => true;
}
