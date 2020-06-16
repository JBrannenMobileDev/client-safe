import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationTextField.dart';
import 'package:client_safe/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherMapPage.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class LocationOptionsMileageExpenseDialog extends StatefulWidget {
  @override
  _LocationOptionsMileageExpenseDialogState createState() {
    return _LocationOptionsMileageExpenseDialogState();
  }
}

class _LocationOptionsMileageExpenseDialogState extends State<LocationOptionsMileageExpenseDialog> with AutomaticKeepAliveClientMixin {
  final locationNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewMileageExpensePageState>(
      onInit: (store) {
        locationNameTextController.text = store.state.newLocationPageState.locationName;
      },
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                "Select from your collection of locations or select a new location from a map.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
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
                      Text(
                        'My Locations',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                    ],
                  ),

                ),
                GestureDetector(
                  onTap: () {
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
                      Text(
                        'Map Location',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
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
