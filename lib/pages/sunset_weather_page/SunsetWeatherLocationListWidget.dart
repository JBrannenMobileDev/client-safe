import 'dart:async';
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
                  height: _getItemWidthHeight(context) - 72,
                  margin: EdgeInsets.only(top: 8.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: pageState.locationImages.isNotEmpty
                          ? FileImage(pageState.locationImages.elementAt(locationIndex))
                          : AssetImage("assets/images/backgrounds/image_background.png")
                    ),
                    color: Color(ColorConstants.primary_black),
                    borderRadius: new BorderRadius.circular(16.0),
                  ),
                ),
              pageState.selectedLocation != pageState.locations.elementAt(locationIndex)
                  ? SizedBox()
                  : Container(
                      height: _getItemWidthHeight(context) - 72,
                      margin:
                          EdgeInsets.only(top: 8.0),
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
                height: _getItemWidthHeight(context) - 72,
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

  double _getItemWidthHeight(BuildContext context){
    return (MediaQuery.of(context).size.width/2);
  }
}
