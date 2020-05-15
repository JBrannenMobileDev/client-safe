import 'dart:async';
import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';

class SunsetWeatherLocationListWidget extends StatelessWidget {
  final int locationIndex;

  SunsetWeatherLocationListWidget(this.locationIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SunsetWeatherPageState>(
      converter: (store) => SunsetWeatherPageState.fromStore(store),
      builder: (BuildContext context, SunsetWeatherPageState pageState) => Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: _getItemWidthHeight(context),
                margin: EdgeInsets.only(left: 64.0, top: 8.0, right: 64.0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: pageState.locations
                                  .elementAt(locationIndex)
                                  .imagePath !=
                              null
                          ? getSavedImage(pageState)
                          : AssetImage(
                              "assets/images/backgrounds/image_background.png"),
                    ),
                    color: Color(ColorConstants.primary_black),
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: 32.0, left: 64.0, right: 64.0),
                  ),
                ),
              ),
              pageState.selectedLocation != pageState.locations.elementAt(locationIndex)
                  ? Container(
                      height: _getItemWidthHeight(context),
                      margin:
                          EdgeInsets.only(left: 64.0, top: 8.0, right: 64.0),
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.primary_black),
                          borderRadius: new BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                              begin: FractionalOffset.center,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                    )
                  : Container(
                      height: _getItemWidthHeight(context),
                      margin:
                          EdgeInsets.only(left: 64.0, top: 8.0, right: 64.0),
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.primary_black),
                          borderRadius: new BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                              begin: FractionalOffset.center,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Color(ColorConstants.getPrimaryColor()).withOpacity(0.5),
                                Color(ColorConstants.getPrimaryColor()).withOpacity(0.5),
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                    ),
              Container(
                height: _getItemWidthHeight(context),
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () async {
                    pageState.onLocationSelected(pageState.locations.elementAt(locationIndex));
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 4.0),
              child: Text(
                pageState.locations.elementAt(locationIndex).locationName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'simple',
                  color: pageState.selectedLocation != pageState.locations.elementAt(locationIndex)
                      ? const Color(ColorConstants.primary_black)
                      : Color(ColorConstants.getPrimaryColor()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getItemWidthHeight(BuildContext context) {
    return (MediaQuery.of(context).size.width - 110) / 2.0;
  }

  FileImage getSavedImage(SunsetWeatherPageState pageState) {
    FileImage localImage = FileImage(File(pageState.documentPath + '/' + pageState.locations.elementAt(locationIndex).imagePath));
    return localImage;
  }
}
