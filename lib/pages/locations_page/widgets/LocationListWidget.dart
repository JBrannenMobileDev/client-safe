import 'dart:async';
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationActions.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';

class LocationListWidget extends StatelessWidget {
  final int index;

  LocationListWidget(this.index);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocationsPageState>(
      converter: (store) => LocationsPageState.fromStore(store),
      builder: (BuildContext context, LocationsPageState pageState) =>
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              !pageState.isLoadingImages || pageState.locations.length == 0 || (pageState.locationImages.isNotEmpty && pageState.locationImages.length > index && pageState.locationImages.elementAt(index) != null && pageState.locationImages.elementAt(index).path.isNotEmpty) ?
           Container(
                margin: EdgeInsets.only(bottom: 28.0),
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: new BorderRadius.circular(16.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: pageState.locationImages.isNotEmpty && pageState.locationImages.length > index && pageState.locationImages.elementAt(index).path.isNotEmpty
                        ? FileImage(pageState.locationImages.elementAt(index))
                        : AssetImage("assets/images/backgrounds/image_background.png"),
                  ),
                ),
              ) : Container(
                  margin: EdgeInsets.only(bottom: 28.0),
                  height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Color(ColorConstants.getBlueDark()),
                  size: 32,
                ),
              ),
              pageState.locations.length == 0 || (pageState.locationImages.isNotEmpty && pageState.locationImages.length > index && pageState.locationImages.elementAt(index) != null && pageState.locationImages.elementAt(index).path.isNotEmpty)  ? Container(
                height: 96.0,
                margin: EdgeInsets.only(bottom: 28.0),
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.circular(16.0),
                    gradient: LinearGradient(
                        begin: FractionalOffset.center,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.75),
                        ],
                        stops: [
                          0.0,
                          1.0
                        ])),
              ) : SizedBox(),
              pageState.locations.length == 0 || (pageState.locationImages.isNotEmpty && pageState.locationImages.length > index && pageState.locationImages.elementAt(index) != null && pageState.locationImages.elementAt(index).path.isNotEmpty) ? Container(
                margin: EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      iconSize: 26.0,
                      icon: const Icon(Icons.directions),
                      color: Color(pageState.locations.elementAt(index) != null ? ColorConstants.white : ColorConstants.getBlueDark()),
                      tooltip: 'Driving Directions',
                      onPressed: () {
                        pageState.onDrivingDirectionsSelected(pageState.locations.elementAt(index));
                        EventSender().sendEvent(eventName: EventNames.BT_DRIVING_DIRECTIONS);
                      },
                    ),
                    IconButton(
                      iconSize: 26.0,
                      icon: Icon(Device.get().isIos ? CupertinoIcons.share_solid : Icons.share),
                      color: Color(pageState.locations.elementAt(index) != null ? ColorConstants.white : ColorConstants.getBlueDark()),
                      tooltip: 'Share',
                      onPressed: () {
                        pageState.onShareLocationSelected(pageState.locations.elementAt(index));
                        EventSender().sendEvent(eventName: EventNames.BT_SHARE_LOCATION);
                      },
                    ),
                    IconButton(
                      iconSize: 26.0,
                      icon: Icon(Device.get().isIos ? CupertinoIcons.pen : Icons.edit),
                      color: Color(pageState.locations.elementAt(index) != null ? ColorConstants.white : ColorConstants.getBlueDark()),
                      tooltip: 'Edit',
                      onPressed: () {
                        pageState.onLocationSelected(pageState.locations.elementAt(index));
                        UserOptionsUtil.showNewLocationDialog(context);
                      },
                    ),
                  ],
                ),
              ) : SizedBox(),
              Container(
                child: Text(
                  pageState.locations.elementAt(index).locationName,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'simple',
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
