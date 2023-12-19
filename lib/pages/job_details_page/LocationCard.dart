import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/permissions/UserPermissionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../AppState.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import 'JobDetailsPageState.dart';

class LocationCard extends StatefulWidget {
  const LocationCard({Key key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _LocationCard();
  }
}

class _LocationCard extends State<LocationCard> {
  DateTime newDateTimeHolder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      onInit: (store) {
        newDateTimeHolder = store.state.jobDetailsPageState.job.selectedTime;
      },
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
            height: 352,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Location',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            bool isGranted = (await UserPermissionsUtil.showPermissionRequest(permission: Permission.locationWhenInUse, context: context));
                            if(isGranted) {
                              pageState.onDrivingDirectionsSelected(pageState.selectedLocation);
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            height: 96,
                            width: 96,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(ColorConstants.getBlueLight()).withOpacity(0.25)
                            ),
                            child: Image.asset("assets/images/icons/directions.png", color: Color(ColorConstants.getBlueDark()),),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Directions',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            String message = 'Hi ${pageState.job.clientName.split(' ')[0]}, here are the driving directions to the location we discussed. \n${pageState.selectedLocation.locationName}\n\nhttps://www.google.com/maps/search/?api=1&query=${pageState.selectedLocation.latitude},${pageState.selectedLocation.longitude}';
                            UserOptionsUtil.showShareOptionsSheet(context, pageState.client, message, 'Location details');
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            height: 96,
                            width: 96,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(ColorConstants.getBlueLight()).withOpacity(0.25)
                            ),
                            child: Image.asset("assets/images/icons/file_upload.png", color: Color(ColorConstants.getBlueDark()),),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Share',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        GestureDetector(
                          onTap: () {
                            UserOptionsUtil.showLocationSelectionDialog(context);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: pageState.selectedLocation != null ? Container(
                            height: 235,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(ColorConstants.getBlueLight()).withOpacity(0.25)
                            ),
                            child: DandyLightNetworkImage(
                              pageState.selectedLocation.imageUrl,
                              color: Color(ColorConstants.getBlueLight()).withOpacity(0.25),
                              errorType: pageState.selectedLocation.imageUrl != null && pageState.selectedLocation.imageUrl.isNotEmpty ? DandyLightNetworkImage.ERROR_TYPE_INTERNET : DandyLightNetworkImage.ERROR_TYPE_NO_IMAGE,
                              errorIconSize: pageState.selectedLocation.imageUrl != null && pageState.selectedLocation.imageUrl.isNotEmpty ? 44 : 96,
                              errorIconColor: Color(ColorConstants.getBlueDark()),
                              borderRadius: 12,
                            ),
                          ) : Container(
                            padding: const EdgeInsets.all(72),
                            height: 235,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(ColorConstants.getBlueLight()).withOpacity(0.25)
                            ),
                            child: Image.asset("assets/images/icons/plus.png", color: Color(ColorConstants.getBlueDark())),
                          ),
                        ),
                        Container(
                          width: 200,
                          margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: pageState.job.location == null ? 'Location not selected' :
                            pageState.job.location.locationName,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }
}
