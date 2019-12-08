import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
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
                margin: EdgeInsets.only(left: 4.0, top: 8.0, right: 4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                       image: Image.file(File(pageState.locations.elementAt(locationIndex).imagePath ?? "")).image,
                      ),
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: 32.0, left: 4.0, right: 4.0),
                      child: Text(
                        pageState.locations.elementAt(locationIndex).imagePath == null ? "Long press to set an image." : "",
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
              pageState.locations.elementAt(locationIndex).imagePath != null ? Container(
                height: _getItemWidthHeight(context),
                margin: EdgeInsets.only(left: 4.0, top: 8.0, right: 4.0),
                decoration: BoxDecoration(
                    color: Colors.white,
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
              ) : SizedBox(),
              Container(
                height: _getItemWidthHeight(context),
                width: double.maxFinite,
                child: GestureDetector(
                  onLongPress: () {
                    VibrateUtil.vibrateHeavy();
                    getImage(pageState);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      iconSize: 24.0,
                      icon: const Icon(Icons.directions),
                      color: Color(ColorConstants.white),
                      tooltip: 'Driving Directions',
                      onPressed: () {
                        pageState.onDrivingDirectionsSelected(pageState.locations.elementAt(locationIndex));
                      },
                    ),
                    IconButton(
                      iconSize: 24.0,
                      icon: Icon(Device.get().isIos ? CupertinoIcons.share : Icons.share),
                      color: Color(ColorConstants.white),
                      tooltip: 'Share',
                      onPressed: () {
                        pageState.onShareLocationSelected(pageState.locations.elementAt(locationIndex));
                      },
                    ),
                    IconButton(
                      iconSize: 24.0,
                      icon: Icon(Device.get().isIos ? CupertinoIcons.delete_simple : Icons.delete),
                      color: Color(ColorConstants.white),
                      tooltip: 'Delete',
                      onPressed: () {
                        _ackAlert(context, pageState);
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
                  fontWeight: FontWeight.w600,
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
    pageState.saveImagePath(image.path, pageState.locations.elementAt(locationIndex));
  }

  _onLocationSelected(PriceProfile selectedProfile,
      LocationsPageState pageState, BuildContext context) {
//    pageState.onProfileSelected(selectedProfile);
//    UserOptionsUtil.showNewPriceProfileDialog(context);
  }

  Future<void> _ackAlert(BuildContext context, LocationsPageState pageState) {
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
                pageState.onDeleteLocationSelected(pageState.locations.elementAt(locationIndex));
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
                pageState.onDeleteLocationSelected(pageState.locations.elementAt(locationIndex));
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
