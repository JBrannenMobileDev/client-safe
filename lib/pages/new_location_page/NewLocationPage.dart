import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:latlong/latlong.dart';
import 'package:redux/redux.dart';

class NewLocationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewLocationPage();
  }
}


class _NewLocationPage extends State<NewLocationPage> {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewLocationPageState>(
        onInit: (store) async{
          store.dispatch(FetchLocationsAction(store.state.newLocationPageState));
        },
        onDidChange: (pageState) async {

        },
        converter: (Store<AppState> store) =>
            NewLocationPageState.fromStore(store),
        builder: (BuildContext context, NewLocationPageState pageState) =>
            Scaffold(
          backgroundColor: Color(ColorConstants.getCollectionColor2()),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
//              GoogleMap(
//                initialCameraPosition: CameraPosition(
//                  target: LatLng(pageState.newLocationLatitude, pageState.newLocationLongitude),
//                  zoom: 15,
//                ),
//                onMapCreated: (GoogleMapController controller) {
//                  _controller.complete(controller);
//                },
//                mapToolbarEnabled: false,
//                myLocationEnabled: true,
//                compassEnabled: false,
//                onCameraIdle: () async{
//                  final GoogleMapController controller = await _controller.future;
//                  LatLng latLng = await controller.getLatLng(
//                    ScreenCoordinate(
//                      x: (MediaQuery.of(context).size.width/2).round(),
//                      y: (MediaQuery.of(context).size.height/2).round(),
//                    )
//                  );
//                  pageState.onLocationChanged(latLng);
//                },
//              ),
              FlutterMap(
                options: new MapOptions(
                  center: new LatLng(51.5, -0.09),
                  zoom: 13.0,
                ),
                layers: [
                  new TileLayerOptions(
                    urlTemplate: "https://api.tiles.mapbox.com/v4/"
                        "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                    additionalOptions: {
                      'accessToken': '<PUT_ACCESS_TOKEN_HERE>',
                      'id': 'mapbox.streets',
                    },
                  ),
                  new MarkerLayerOptions(
                    markers: [
                      new Marker(
                        width: 80.0,
                        height: 80.0,
                        point: new LatLng(51.5, -0.09),
                        builder: (ctx) =>
                        new Container(
                          child: new FlutterLogo(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 36.0),
                alignment: Alignment.center,
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageUtil.locationPin),
                    fit: BoxFit.contain,
                  ),
                  color: Colors.transparent,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 48.0),
                child: SizedBox(
                  width: 200.0,
                  height: 50.0,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        side: BorderSide(color: Color(ColorConstants.getPrimaryColor()))),
                    onPressed: (){
                      pageState.onSaveLocationSelected();
                      showSuccessAnimation();
                    },
                    color: Color(ColorConstants.getPrimaryColor()),
                    textColor: Color(ColorConstants.getPrimaryWhite()),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 48.0, left: 8.0),
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Device.get().isIos ? Icons.arrow_back_ios : Icons.arrow_back),
                  tooltip: 'Back',
                  color: Color(ColorConstants.primary_black),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ),
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
    Navigator.of(context).pop(true);
  }
}
