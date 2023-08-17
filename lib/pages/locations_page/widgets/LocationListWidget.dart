import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/widgets/DandyLightNetworkImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/analytics/EventNames.dart';
import '../../../utils/analytics/EventSender.dart';
import '../../../widgets/TextDandyLight.dart';

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
              pageState.locations.length > 0 ?
           Container(
             width: double.infinity,
                margin: EdgeInsets.only(bottom: 28.0),
                decoration: BoxDecoration(
                  color: Color(ColorConstants.getPeachLight()),
                  borderRadius: new BorderRadius.circular(8.0),
                ),
             child: DandyLightNetworkImage(
               pageState.locations.elementAt(index).imageUrl,
               errorType: pageState.locations.elementAt(index).imageUrl != null && pageState.locations.elementAt(index).imageUrl.isNotEmpty ? DandyLightNetworkImage.ERROR_TYPE_INTERNET : DandyLightNetworkImage.ERROR_TYPE_NO_IMAGE,
               errorIconSize: pageState.locations.elementAt(index).imageUrl != null && pageState.locations.elementAt(index).imageUrl.isNotEmpty ? 44 : 96,
             ),
              ) : SizedBox(),
              pageState.locations.length > 0 && pageState.locations.elementAt(index).imageUrl != null && pageState.locations.elementAt(index).imageUrl.isNotEmpty ? Container(
                height: 96.0,
                margin: EdgeInsets.only(bottom: 28.0),
                decoration: BoxDecoration(
                    color: Color(ColorConstants.getPrimaryWhite()),
                    borderRadius: new BorderRadius.circular(8.0),
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
              pageState.locations.length > 0 ? Container(
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
                child: TextDandyLight(
                  type: TextDandyLight.SMALL_TEXT,
                  text: pageState.locations.elementAt(index).locationName,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getBlueDark()),
                ),
              ),
            ],
          ),
    );
  }
}
