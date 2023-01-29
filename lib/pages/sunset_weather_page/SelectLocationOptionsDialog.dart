import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherMapPage.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';


class SelectLocationOptionsDialog extends StatefulWidget {
  @override
  _SelectLocationOptionsDialog createState() {
    return _SelectLocationOptionsDialog();
  }
}

class _SelectLocationOptionsDialog extends State<SelectLocationOptionsDialog> with AutomaticKeepAliveClientMixin {
  final locationNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, SunsetWeatherPageState>(
      onInit: (store) {
        locationNameTextController.text = store.state.newLocationPageState.locationName;
      },
      converter: (store) => SunsetWeatherPageState.fromStore(store),
      builder: (BuildContext context, SunsetWeatherPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "Select from your collection of locations or select a new location from a map.",
                textAlign: TextAlign.center,
                color: Color(ColorConstants.primary_black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    UserOptionsUtil.showChooseFromMyLocationsDialog(context);
                  },
                  child: Column(

                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.all(24.0),
                        height: MediaQuery.of(context).size.width/4,
                        width: MediaQuery.of(context).size.width/4,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getBlueDark()),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/icons/collections_icon_white.png'),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'My Locations',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ],
                  ),

                ),
                GestureDetector(
                  onTap: () {
                    pageState.onSearchInputChanged('');
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SunsetWeatherMapPage()),
                    );
                  },
                  child: Column(

                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 8.0),
                        padding: EdgeInsets.all(24.0),
                        height: MediaQuery.of(context).size.width/4,
                        width: MediaQuery.of(context).size.width/4,
                        decoration: BoxDecoration(
                          color: Color(ColorConstants.getBlueDark()),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                            'assets/images/icons/location_icon_white.png'),
                      ),
                      TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Map Location',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
