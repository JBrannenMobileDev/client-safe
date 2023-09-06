import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../utils/ColorConstants.dart';
import '../../../utils/IntentLauncherUtil.dart';
import '../../../widgets/DividerWidget.dart';
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
        alignment: Alignment.topCenter,
        width: 1080,
        color: Color(ColorConstants.getPrimaryWhite()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 32, bottom: 48),
              child: TextDandyLight(
                type: TextDandyLight.EXTRA_LARGE_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.titleFont,
                text: 'Details',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16, left: 32, right: 32),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.proposal?.detailsMessage,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
              ),
            ),
            DividerWidget(width: 1080),
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
        width: 360,
        margin: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.titleFont,
                text: 'PHOTOGRAPHER',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                text: pageState.profile.firstName + ' ' + pageState.profile.lastName,
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.profile.email,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.profile.phone,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 360,
        margin: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.titleFont,
                text: 'CLIENT',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                text: pageState.job.client.getClientFullName(),
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'email: ' + pageState.job.client.email,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                text: 'phone: ' + pageState.job.client.phone,
              ),
            ),
          ],
        ),
      ),
      Container(
        width: 360,
        margin: EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: DeviceType.getDeviceTypeByContext(context) == Type.Website ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0, bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.titleFont,
                text: 'JOB INFO',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                text: 'Date: ' + (pageState.job.selectedDate != null
                    ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.job.selectedDate)
                    : 'TBD'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                text: 'Time: ' + (pageState.job.selectedTime != null && pageState.job.selectedTime != null ? DateFormat('h:mma').format(pageState.job.selectedTime) + ' - ' + DateFormat('h:mma').format(pageState.job.selectedEndTime) : 'TBD'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                fontFamily: pageState.profile.selectedFontTheme.bodyFont,
                text: 'Where: ' + (pageState.job.location != null && pageState.job.location.address != null ? pageState.job.location.address : 'TBD'),
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            MouseRegion(
              child: GestureDetector(
                onTap: () {
                  if(pageState.job.location != null) {
                    IntentLauncherUtil.launchDrivingDirections(
                        pageState.job.location.latitude.toString(),
                        pageState.job.location.longitude.toString()
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
                      color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonColor)
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Driving directions',
                    fontFamily: pageState.profile.selectedFontTheme.titleFont,
                    color: ColorConstants.hexToColor(pageState.profile.selectedColorTheme.buttonTextColor),
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
            ),
          ],
        ),
      ),
    ];
  }
}