import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationMapPage.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/permissions/UserPermissionsUtil.dart';
import '../../widgets/TextDandyLight.dart';


class NewLocationMapViewPage extends StatefulWidget {
  final bool showMapIcon;

  NewLocationMapViewPage(this.showMapIcon);

  @override
  _NewLocationMapViewPage createState() {
    return _NewLocationMapViewPage(showMapIcon);
  }
}

class _NewLocationMapViewPage extends State<NewLocationMapViewPage> with AutomaticKeepAliveClientMixin{
  final locationNameTextController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  bool showMapIcon;

  _NewLocationMapViewPage(this.showMapIcon);

  Future<void> animateTo(double lat, double lng) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 15);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewLocationPageState>(
      onInit: (store) {
        locationNameTextController.text = store.state.newLocationPageState!.locationName!;
      },
      onDidChange: (prev, pageState) {
        animateTo(pageState.newLocationLatitude!, pageState.newLocationLongitude!);
      },
      converter: (store) => NewLocationPageState.fromStore(store),
      builder: (BuildContext context, NewLocationPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "Select a map location to use for driving directions.",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            GestureDetector(
              onTap: () {
                UserPermissionsUtil.showPermissionRequest(
                  permission: Permission.locationWhenInUse,
                  context: context,
                  customMessage: "Location permission is required to select a pin for this location.",
                  callOnGranted: callOnGranted,
                );
              },
              child: pageState.selectedLatLng == null ? Container(
                padding: EdgeInsets.all(24),
                height: 116.0,
                width: 116.0,
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getBlueDark()),
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/images/icons/location_icon_black.png', color: Color(ColorConstants.getPrimaryWhite())),
              ) : Container(
                height: 116.0,
                width: 116.0,
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getBlueDark()),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(

                  child: Image.asset('assets/images/google_placeholder.jpeg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void callOnGranted() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NewLocationMapPage()),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
