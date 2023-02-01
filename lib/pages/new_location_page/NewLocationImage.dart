import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';

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
        locationNameTextController.text = store.state.newLocationPageState.locationName;
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
                text: "Take a picture of this location to help you remember what it looks like.",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.primary_black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    getCameraImage(pageState);
                  },
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    height: MediaQuery.of(context).size.width/4,
                    width: MediaQuery.of(context).size.width/4,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueDark()),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/icons/camera_icon_white.png'),
                  ),

                ),
                GestureDetector(
                  onTap: () {
                    getDeviceImage(pageState);
                  },
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    height: MediaQuery.of(context).size.width/4,
                    width: MediaQuery.of(context).size.width/4,
                    decoration: BoxDecoration(
                      color: Color(ColorConstants.getBlueDark()),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset('assets/images/icons/image_icon_white.png'),
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
    XFile image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final filePath = "${image.path}";
    pageState.saveImagePath(filePath);
  }

  Future getCameraImage(NewLocationPageState pageState) async {
    XFile image = await ImagePicker().pickImage(source: ImageSource.camera);
    final filePath = "${image.path}";
    pageState.saveImagePath(filePath);
  }

  @override
  bool get wantKeepAlive => true;
}
