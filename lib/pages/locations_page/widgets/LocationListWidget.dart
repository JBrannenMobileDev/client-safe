import 'dart:async';
import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';

class LocationListWidget extends StatelessWidget {
  final int locationIndex;

  LocationListWidget(this.locationIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocationsPageState>(
      converter: (store) => LocationsPageState.fromStore(store),
      builder: (BuildContext context, LocationsPageState pageState) =>
      Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                height: _getItemWidthHeight(context),
                margin: EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0),
                child: GestureDetector(
                  onLongPress: () {
                    VibrateUtil.vibrateHeavy();
                    getImage(pageState);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(top: 32.0),
                      child: Text(
                        "Long press to set an image.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          color: const Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      iconSize: 36.0,
                      icon: const Icon(Icons.directions),
                      color: Color(ColorConstants.primary),
                      tooltip: 'Driving Directions',
                      onPressed: () {
                        UserOptionsUtil.showCollectionOptionsSheet(context);
                      },
                    ),
                    IconButton(
                      iconSize: 36.0,
                      icon: Icon(Device.get().isIos ? CupertinoIcons.share : Icons.share),
                      color: Color(ColorConstants.primary),
                      tooltip: 'Share',
                      onPressed: () {
                        UserOptionsUtil.showCollectionOptionsSheet(context);
                      },
                    ),
                  ],
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
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  color: const Color(ColorConstants.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
   double _getItemWidthHeight(BuildContext context){
    return (MediaQuery.of(context).size.width - 110) / 2.0;
   }

  Future getImage(LocationsPageState pageState) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    pageState.saveImagePath(image.path);
  }

  _onLocationSelected(PriceProfile selectedProfile,
      LocationsPageState pageState, BuildContext context) {
//    pageState.onProfileSelected(selectedProfile);
//    UserOptionsUtil.showNewPriceProfileDialog(context);
  }
}
