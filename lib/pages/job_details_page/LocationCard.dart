import 'package:dandylight/pages/client_details_page/ClientDetailsPageState.dart';
import 'package:dandylight/widgets/DandyLightTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../AppState.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import '../new_contact_pages/NewContactPageState.dart';
import 'JobDetailsPageState.dart';

class LocationCard extends StatefulWidget {

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
            margin: EdgeInsets.only(left: 16, top: 26, right: 16, bottom: 0),
            height: 338,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Location',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {

                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(18),
                            height: 96,
                            width: 96,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: Image.asset("assets/images/icons/driving_directions_icon_white.png", color: Color(ColorConstants.getPrimaryBlack()),),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Directions',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Share.share('Hi ${pageState.job.clientName.split(' ')[0]}, here are the driving directions to the shoot location. \nLocation: ${pageState.selectedLocation.locationName}\n\nhttps://www.google.com/maps/search/?api=1&query=${pageState.selectedLocation.latitude},${pageState.selectedLocation.longitude}');
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.all(28),
                            height: 96,
                            width: 96,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(ColorConstants.getPrimaryBackgroundGrey())
                            ),
                            child: Image.asset("assets/images/icons/file_upload.png", color: Color(ColorConstants.getPrimaryBlack()),),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Share Location',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.primary_black),
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
                          child: Container(
                            height: 228,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(ColorConstants.getBlueDark()),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: pageState.locationImage != null ? FileImage(pageState.locationImage)
                                    : AssetImage("assets/images/backgrounds/image_background.png"),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: pageState.job.location == null ? 'Location not selected' :
                            pageState.job.location.locationName,
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.primary_black),
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
