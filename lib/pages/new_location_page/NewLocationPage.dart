import 'dart:async';
import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/pages/new_location_page/NewLocationImage.dart';
import 'package:client_safe/pages/new_location_page/NewLocationMapPage.dart';
import 'package:client_safe/pages/new_location_page/NewLocationMapViewPage.dart';
import 'package:client_safe/pages/new_location_page/NewLocationName.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/KeyboardUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';

class NewLocationPage extends StatefulWidget {
  @override
  _NewLocationPageState createState() {
    return _NewLocationPageState();
  }
}

class _NewLocationPageState extends State<NewLocationPage> {
  final int pageCount = 2;
  bool showMapIcon = false;
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
          Position positionLastKnown = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
          store.dispatch(SetLatLongAction(store.state.newLocationPageState, positionLastKnown.latitude, positionLastKnown.longitude));
        }
      },
      converter: (store) => NewLocationPageState.fromStore(store),
      builder: (BuildContext context, NewLocationPageState pageState) =>
          Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 375.0,
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
                                    'assets/images/icons/trash_icon_peach.png'),
                              ),
                            ) : SizedBox(),
                            Text(
                              pageState.shouldClear ? "New Location" : "Edit Location",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 26.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                            !pageState.shouldClear ? Container(
                              margin: EdgeInsets.only(right: 18.0),
                              child: IconButton(
                                icon: const Icon(Icons.save),
                                tooltip: 'Save',
                                color: Color(ColorConstants.getPeachDark()),
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
                      pageState.pageViewIndex == 2 && pageState.imagePath.isNotEmpty ? Container(
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getPrimaryWhite()),
                          borderRadius: new BorderRadius.circular(16.0),
                        ),
                        height: 150.0,
                        width: 200.0,

                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(16.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: getSavedImage(pageState),
                              ),
                            )
                        ),
                      ) : SizedBox(),
                      Padding(
                        padding: EdgeInsets.only(left: 26.0, right: 26.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              color: Colors.white,
                              textColor: Color(ColorConstants.primary_black),
                              disabledColor: Colors.white,
                              disabledTextColor:
                              Color(ColorConstants.primary_bg_grey),
                              padding: EdgeInsets.all(8.0),
                              splashColor: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                onBackPressed(pageState);
                              },
                              child: Text(
                                pageState.pageViewIndex == 0 ? 'Cancel' : 'Back',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            FlatButton(
                              color: Colors.white,
                              textColor: Color(ColorConstants.primary_black),
                              disabledColor: Colors.white,
                              disabledTextColor:
                              Color(ColorConstants.primary_bg_grey),
                              padding: EdgeInsets.all(8.0),
                              splashColor: Color(ColorConstants.getPrimaryColor()),
                              onPressed: () {
                                onNextPressed(pageState);
                              },
                              child: Text(
                                pageState.pageViewIndex == pageCount ? 'Save' : 'Next',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  FileImage getSavedImage(NewLocationPageState pageState) {
    FileImage localImage = FileImage(File(pageState.documentFilePath + '/' + pageState.imagePath));
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
        canProgress = pageState.newLocationLongitude != 0;
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
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('This location will be gone for good!'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
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
