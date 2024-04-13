import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/DividerWidget.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../../utils/Shadows.dart';
import '../../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../ClientPortalPageState.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailsPagePageState();
  }
}

class _DetailsPagePageState extends State<DetailsPage> {
  bool isHoveredDirections = false;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, ClientPortalPageState>(
      converter: (Store<AppState> store) => ClientPortalPageState.fromStore(store),
      builder: (BuildContext context, ClientPortalPageState pageState) =>
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.topCenter,
            width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DeviceType.getDeviceTypeByContext(context) == Type.Website ? Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 32, bottom: 48),
                  child: TextDandyLight(
                    type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.EXTRA_LARGE_TEXT : TextDandyLight.LARGE_TEXT,
                    fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                    text: 'Details',
                  ),
                ) : Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top:16, bottom: 0, left: 16, right: 16),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            margin: EdgeInsets.only(left: 0, right: 8),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                            ),
                            child: Image.asset("icons/calendar_white.png"),
                          ),
                          TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                              text: (pageState.job!.selectedDate != null
                                  ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.job!.selectedDate!)
                                  : 'Date (TBD)'),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            margin: EdgeInsets.only(left: 0, right: 8, top: 6),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                            ),
                            child: Image.asset("icons/clock_white.png"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                              text: (pageState.job!.selectedTime != null ? DateFormat('h:mma').format(pageState.job!.selectedTime!) + ' - ' +( pageState.job!.selectedEndTime != null ? DateFormat('h:mma').format(pageState.job!.selectedEndTime!) : 'Time (TBD)') : 'Time (TBD)'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6),
                            margin: EdgeInsets.only(left: 0, right: 8, top: 6),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                            ),
                            child: Image.asset("icons/pin_white.png"),
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if(pageState.job!.location != null && pageState.job!.location!.address != null) {
                                    IntentLauncherUtil.launchDrivingDirections(pageState.job!.location!.latitude.toString(), pageState.job!.location!.longitude.toString());
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: TextDandyLight(
                                    type: TextDandyLight.SMALL_TEXT,
                                    fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                                    text: (pageState.job!.location != null && pageState.job!.location!.address != null ? pageState.job!.location!.address : 'Location (TBD)'),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                DividerWidget(width: DeviceType.getDeviceTypeByContext(context) != Type.Website ? 1080 : 0),
                Container(
                  margin: EdgeInsets.only(bottom: 16, top: 0, left: 16, right: 16),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: pageState.proposal?.detailsMessage,
                    fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                  ),
                ),
                DividerWidget(width: DeviceType.getDeviceTypeByContext(context) == Type.Website ? 1080 : MediaQuery.of(context).size.width,),
                Container(
                  margin: EdgeInsets.only(bottom: 64),
                  alignment: Alignment.topCenter,
                  child: DeviceType.getDeviceTypeByContext(context) == Type.Website ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _infoItems(pageState),
                  ) : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _infoItems(pageState),
                  ),
                ),
              ],
            ),
          ),
      );

  List<Widget> _infoItems(ClientPortalPageState pageState) {
    return [
      Container(
        width: 324,
        margin: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: 'PHOTOGRAPHER',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: pageState.profile!.firstName != null ? pageState.profile!.firstName : ' ' + pageState.profile!.lastName!,
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.profile!.email != null ? pageState.profile!.email : 'Photographer email',
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.profile!.phone != null ? pageState.profile!.phone : 'Photographer phone',
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 324,
        margin: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: 'CLIENT',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: pageState.job!.client?.getClientFullName(),
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'email: ' + pageState.job!.client!.email!,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: 'phone: ' + pageState.job!.client!.phone!,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 400,
        margin: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: 'JOB INFO',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: 'Date: ' + (pageState.job!.selectedDate != null
                    ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.job!.selectedDate!)
                    : 'Date (TBD)'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                text: 'Time: ' + (pageState.job!.selectedTime != null ? DateFormat('h:mma').format(pageState.job!.selectedTime!) + ' - ' +( pageState.job!.selectedEndTime != null ? DateFormat('h:mma').format(pageState.job!.selectedEndTime!) : 'Time (TBD)') : 'TIme (TBD)'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                  text: 'Where: ' + (pageState.job!.location != null && pageState.job!.location!.address != null ? pageState.job!.location!.address! : 'Location (TBD)'),
                  textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
                ),
              ),
            DeviceType.getDeviceTypeByContext(context) == Type.Website ? MouseRegion(
              child: GestureDetector(
                onTap: () {
                  if(pageState.job!.location != null) {
                    IntentLauncherUtil.openDrivingDirectionsFromWebsite(
                        pageState.job!.location!.latitude.toString(),
                        pageState.job!.location!.longitude.toString()
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 48,
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonColor!)
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Driving directions',
                    fontFamily: pageState.profile!.selectedFontTheme!.mainFont,
                    color: ColorConstants.hexToColor(pageState.profile!.selectedColorTheme!.buttonTextColor!),
                    isBold: isHoveredDirections,
                  ),
                ),
              ),
              cursor: SystemMouseCursors.click,
              onHover: (event) {
                setState(() {
                  isHoveredDirections = true;
                });
              },
              onExit: (event) {
                setState(() {
                  isHoveredDirections = false;
                });
              },
            ) : SizedBox(),
          ],
        ),
      ),
    ];
  }
}