import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:redux/redux.dart';

class SunsetWeatherMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SunsetWeatherMapPage();
  }
}


class _SunsetWeatherMapPage extends State<SunsetWeatherMapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SunsetWeatherPageState>(
      onInit: (store) async{
        store.dispatch(FetchLocationsAction(store.state.newLocationPageState));
      },
      onDidChange: (pageState) async {

      },
      converter: (Store<AppState> store) => SunsetWeatherPageState.fromStore(store),
      builder: (BuildContext context, SunsetWeatherPageState pageState) =>
          Scaffold(
            backgroundColor: Color(ColorConstants.getBlueDark()),
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pageState.selectedLocation.latitude, pageState.selectedLocation.longitude),
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  mapToolbarEnabled: false,
                  myLocationEnabled: true,
                  compassEnabled: false,
                  onCameraIdle: () async{
                    final GoogleMapController controller = await _controller.future;
                    LatLng latLng = await controller.getLatLng(
                        ScreenCoordinate(
                          x: (MediaQuery.of(context).size.width/2).round(),
                          y: (MediaQuery.of(context).size.height/2).round(),
                        )
                    );
                    pageState.onMapLocationChanged(latLng);
                  },
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
                        Navigator.of(context).pop(true);
                      },
                      color: Color(ColorConstants.getPrimaryColor()),
                      textColor: Color(ColorConstants.getPrimaryWhite()),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 26.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
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
}
