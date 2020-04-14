import 'dart:async';
import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationActions.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: new BorderRadius.circular(8.0),
                ),
                height: _getItemWidthHeight(context),
                width: 200.0,
                margin: EdgeInsets.only(left: 4.0, top: 8.0, right: 4.0),
                  child: pageState.locations.elementAt(locationIndex).imagePath != null && pageState.locations.elementAt(locationIndex).imagePath.isNotEmpty ?
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(8.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: getSavedImage(pageState),
                          ),
                        )
                      )
                      : SizedBox()
              ),
              pageState.locations.elementAt(locationIndex).imagePath != null && pageState.locations.elementAt(locationIndex).imagePath.isNotEmpty ? Container(
                height: _getItemWidthHeight(context),
                margin: EdgeInsets.only(left: 4.0, top: 8.0, right: 4.0),
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.circular(8.0),
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
              pageState.locations.elementAt(locationIndex).imagePath == null || pageState.locations.elementAt(locationIndex).imagePath.isEmpty ? Container(
                height: _getItemWidthHeight(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(top: 4.0, bottom: 0.0),
                      height: 64.0,
                      width: 64.0,
                      child: Image(
                        image: AssetImage('assets/images/icons/image_icon_blue.png'),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      width: 124.0,
                      child: Text(
                        'Select an image for this location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'simple',
                          color: Color(ColorConstants.getBlueDark()),
                        ),
                      ),
                    ),
                  ],
                ),
              ) : SizedBox(),
              Container(
                height: _getItemWidthHeight(context),
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () async{
                    await getDeviceImage(pageState);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      iconSize: 24.0,
                      icon: const Icon(Icons.directions),
                      color: Color(pageState.locations.elementAt(locationIndex).imagePath != null && pageState.locations.elementAt(locationIndex).imagePath.isNotEmpty ? ColorConstants.white : ColorConstants.getBlueDark()),
                      tooltip: 'Driving Directions',
                      onPressed: () {
                        pageState.onDrivingDirectionsSelected(pageState.locations.elementAt(locationIndex));
                      },
                    ),
                    IconButton(
                      iconSize: 24.0,
                      icon: Icon(Device.get().isIos ? CupertinoIcons.share_solid : Icons.share),
                      color: Color(pageState.locations.elementAt(locationIndex).imagePath != null && pageState.locations.elementAt(locationIndex).imagePath.isNotEmpty ? ColorConstants.white : ColorConstants.getBlueDark()),
                      tooltip: 'Share',
                      onPressed: () {
                        pageState.onShareLocationSelected(pageState.locations.elementAt(locationIndex));
                      },
                    ),
                    IconButton(
                      iconSize: 24.0,
                      icon: Icon(Device.get().isIos ? CupertinoIcons.pen : Icons.edit),
                      color: Color(pageState.locations.elementAt(locationIndex).imagePath != null && pageState.locations.elementAt(locationIndex).imagePath.isNotEmpty ? ColorConstants.white : ColorConstants.getBlueDark()),
                      tooltip: 'Edit',
                      onPressed: () {
                        pageState.onLocationSelected(pageState.locations.elementAt(locationIndex));
                        UserOptionsUtil.showNewLocationDialog(context);
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
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'simple',
                  color: Color(ColorConstants.getPrimaryWhite()),
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

  Future getDeviceImage(LocationsPageState pageState) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    String key = UniqueKey().toString();
    await image.copy('$path/' + key);
    pageState.saveImagePath(key, pageState.locations.elementAt(locationIndex));
  }

  FileImage getSavedImage(LocationsPageState pageState) {
    FileImage localImage = FileImage(File(pageState.documentFilePath + '/' + pageState.locations.elementAt(locationIndex).imagePath));
    return localImage;
  }
}

class FullScreenImageView extends StatelessWidget{
  final LocationsPageState pageState;
  final int locationIndex;
  FullScreenImageView(this.pageState, this.locationIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocationsPageState>(
    converter: (store) => LocationsPageState.fromStore(store),
    builder: (BuildContext context, LocationsPageState pageState) =>
    Scaffold(
        body: Stack(

          children: <Widget>[
            Image(
                image: Image.file(File(pageState.locations.elementAt(locationIndex).imagePath)).image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.center,
                    colors: [
                      Colors.black.withOpacity(0.65),
                      Colors.transparent,
                    ],
                    stops: [
                      0.0,
                      0.5,
                    ]),
              ),
            ),
            Positioned(
              child: AppBar(
                title: Text(pageState.locations.elementAt(locationIndex).locationName, style: TextStyle(color: Colors.white),),
                centerTitle: true,
                automaticallyImplyLeading: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: <Widget>[
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
                    icon: Icon(Device.get().isIos ? CupertinoIcons.pen : Icons.edit),
                    color: Color(ColorConstants.white),
                    tooltip: 'Edit',
                    onPressed: () {
                      pageState.onLocationSelected(pageState.locations.elementAt(locationIndex));
                      UserOptionsUtil.showNewLocationDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
