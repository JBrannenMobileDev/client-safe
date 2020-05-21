import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationMapPage.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class NewLocationMapViewPage extends StatefulWidget {
  final bool showMapIcon;

  NewLocationMapViewPage(this.showMapIcon);

  @override
  _NewLocationMapViewPage createState() {
    return _NewLocationMapViewPage(showMapIcon);
  }
}

class _NewLocationMapViewPage extends State<NewLocationMapViewPage> with AutomaticKeepAliveClientMixin {
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
        locationNameTextController.text = store.state.newLocationPageState.locationName;
      },
      onDidChange: (pageState) {
        animateTo(pageState.newLocationLatitude, pageState.newLocationLongitude);
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
              child: Text(
                "Select a map location to use for driving directions.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewLocationMapPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all((!pageState.locationUpdated) ? 24.0 : 0.0),
                height: 116.0,
                width: 116.0,
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getBlueDark()),
                  shape: BoxShape.circle,
                ),
                child: (!pageState.locationUpdated) ? Image.asset('assets/images/collection_icons/location_icon_white.png')
                : ClipRRect(
                  borderRadius: BorderRadius.circular(58.0),
                  child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pageState.newLocationLatitude, pageState.newLocationLongitude),
                    zoom: 12,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onTap: (latLng) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => NewLocationMapPage()),
                    );
                  },
                  mapToolbarEnabled: false,
                  myLocationEnabled: false,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
