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
                text: 'Details',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16, left: 32, right: 32),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.proposal?.detailsMessage,
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
                text: 'PHOTOGRAPHER',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.proposal.profile.firstName + ' ' + pageState.proposal.profile.lastName,
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.proposal.profile.email,
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.proposal.profile.phone,
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
                text: 'CLIENT',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: pageState.proposal.job.client.getClientFullName(),
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'email: ' + pageState.proposal.job.client.email,
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'phone: ' + pageState.proposal.job.client.phone,
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
                text: 'JOB INFO',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Date: ' + (pageState.proposal.job.selectedDate != null
                    ? DateFormat('EEE, MMMM dd, yyyy').format(pageState.proposal.job.selectedDate)
                    : 'TBD'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Time: ' + (pageState.proposal.job.selectedTime != null && pageState.proposal.job.selectedTime != null ? DateFormat('h:mma').format(pageState.proposal.job.selectedTime) + ' - ' + DateFormat('h:mma').format(pageState.proposal.job.selectedEndTime) : 'TBD'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Where: ' + (pageState.proposal.job.location != null && pageState.proposal.job.location.address != null ? pageState.proposal.job.location.address : 'TBD'),
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            MouseRegion(
              child: GestureDetector(
                onTap: () {
                  if(pageState.proposal.job.location != null) {
                    IntentLauncherUtil.launchDrivingDirections(
                        pageState.proposal.job.location.latitude.toString(),
                        pageState.proposal.job.location.longitude.toString()
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
                      color: Color(ColorConstants.getPeachDark())
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Driving directions',
                    color: Color(ColorConstants.getPrimaryWhite()),
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