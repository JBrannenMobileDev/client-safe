import 'dart:async';
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart';
import 'package:dandylight/pages/new_location_page/NewLocationImage.dart';
import 'package:dandylight/pages/new_location_page/NewLocationMapViewPage.dart';
import 'package:dandylight/pages/new_location_page/NewLocationName.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/TextDandyLight.dart';

class NewLocationPage extends StatefulWidget {
  @override
  _NewLocationPageState createState() {
    return _NewLocationPageState();
  }
}

class _NewLocationPageState extends State<NewLocationPage> {
  final int pageCount = 2;
  bool showMapIcon = false;
  double lat = 0.0;
  double lon = 0.0;
  final controller = PageController(
    initialPage: 0,
  );
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      currentPageIndex = controller.page.toInt();
    });
    return StoreConnector<AppState, NewLocationPageState>(
      onInit: (store) async {
        if(store.state.newLocationPageState.newLocationLongitude == 0){
          showMapIcon = true;
          Position positionLastKnown = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          lat = positionLastKnown.latitude;
          lon = positionLastKnown.longitude;
          store.dispatch(SetLatLongAction(store.state.newLocationPageState, positionLastKnown.latitude, positionLastKnown.longitude));
        }
      },
        onWillChange: (previous, current) {
          if (!previous.locationUpdated && current.locationUpdated) {
            setState(() {
              currentPageIndex = 2;
              controller.animateToPage(
                  currentPageIndex, duration: Duration(milliseconds: 150),
                  curve: Curves.ease);
            });
          }
        },
      converter: (store) => NewLocationPageState.fromStore(store),
      builder: (BuildContext context, NewLocationPageState pageState) =>
          Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    width: 375,
                    padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                    decoration: new BoxDecoration(
                        color: Color(ColorConstants.white),
                        borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              !pageState.shouldClear ? GestureDetector(
                                onTap: () {
                                  _ackAlert(context, pageState);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 32.0),
                                  height: 24.0,
                                  width: 24.0,
                                  child: Image.asset(
                                      'assets/images/icons/trash_icon_blue.png'),
                                ),
                              ) : SizedBox(),
                              TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: pageState.shouldClear ? "New Location" : "Edit Location",
                                textAlign: TextAlign.start,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                              !pageState.shouldClear ? Container(
                                margin: EdgeInsets.only(right: 18.0),
                                child: IconButton(
                                  icon: const Icon(Icons.save),
                                  tooltip: 'Save',
                                  color: Color(ColorConstants.getBlueDark()),
                                  onPressed: () {
                                    showSuccessAnimation();
                                    pageState.onSaveLocationSelected();
                                  },
                                ),
                              ) : SizedBox(),
                            ],
                          ),
                        ),
                        Container(
                          height: 200.0,
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: controller,
                            pageSnapping: true,
                            children: <Widget>[
                              NewLocationName(),
                              NewLocationMapViewPage(showMapIcon),
                              NewLocationImage(),
                            ],
                          ),
                        ),
                        pageState.pageViewIndex == 2 && pageState.imagePath != null ? Container(
                          decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: new BorderRadius.circular(16.0),
                          ),
                          height: 150.0,
                          width: 200.0,

                          child: pageState.imagePath!= null ? Container(
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(16.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: getSavedImage(pageState),
                                ),
                              )
                          ) : SizedBox(),
                        ) : SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(left: 26.0, right: 26.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                style: Styles.getButtonStyle(
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  textColor: Color(ColorConstants.getPrimaryBlack()),
                                  left: 8.0,
                                  top: 8.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                                // disabledTextColor:
                                // Color(ColorConstants.primary_bg_grey),
                                // splashColor: Color(ColorConstants.getPrimaryColor()),
                                onPressed: () {
                                  onBackPressed(pageState);
                                },
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.pageViewIndex == 0 ? 'Cancel' : 'Back',
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              TextButton(
                                style: Styles.getButtonStyle(
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  textColor: Color(ColorConstants.getPrimaryBlack()),
                                  left: 8.0,
                                  top: 8.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                                // disabledTextColor:
                                // Color(ColorConstants.primary_bg_grey),
                                // splashColor: Color(ColorConstants.getPrimaryColor()),
                                onPressed: () {
                                  onNextPressed(pageState);
                                },
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: pageState.pageViewIndex == pageCount ? 'Save' : 'Next',
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  FileImage getSavedImage(NewLocationPageState pageState) {
    FileImage localImage = FileImage(File(pageState.imagePath));
    return localImage;
  }

  void onNextPressed(NewLocationPageState pageState) {
    if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);

    bool canProgress = false;

    switch(pageState.pageViewIndex){
      case 0:
        canProgress = pageState.locationName.isNotEmpty;
        break;
      case 1:
        canProgress = pageState.newLocationLongitude != lon && pageState.newLocationLatitude != lat;
        break;
      case 2:
        canProgress = false;
        break;
    }
    if (canProgress) {
      pageState.onNextPressed();
      controller.animateToPage(currentPageIndex + 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
      FocusScope.of(context).unfocus();
    }

    if (pageState.pageViewIndex == pageCount) {
      Navigator.of(context).pop();
      showSuccessAnimation();
      pageState.onSaveLocationSelected();
    }
  }

  Future<void> _ackAlert(BuildContext context, NewLocationPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This location will be gone for good!'),
          actions: <Widget>[
            TextButton(
            style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                Navigator.of(context).pop();
                pageState.onDeleteSelected();
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This location will be gone for good!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
  }

  void onBackPressed(NewLocationPageState pageState) {
    if (pageState.pageViewIndex == 0) {
      pageState.onCanceledSelected();
      Navigator.of(context).pop();
    } else {
      if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);
      pageState.onBackPressed();
      controller.animateToPage(currentPageIndex - 1,
          duration: Duration(milliseconds: 150), curve: Curves.ease);
    }
  }
}
