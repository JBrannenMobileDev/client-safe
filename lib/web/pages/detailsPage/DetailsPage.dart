import 'package:dandylight/utils/DeviceType.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';

import '../../../utils/ColorConstants.dart';
import '../../../widgets/DividerWidget.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailsPagePageState();
  }
}

class _DetailsPagePageState extends State<DetailsPage> {
  bool isHoveredDirections = false;

  @override
  Widget build(BuildContext context) =>
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
                text: 'Hi Jason, \nI\'m so excited to book in your photoshoot! Let\'s make this official.\n\nTo lock in your date, please review and sign the contract and pay the deposit.\n\nChat soon,\nShawna Brannen',
              ),
            ),
            DividerWidget(width: 1080),
            Container(
              margin: EdgeInsets.only(bottom: 64),
              alignment: Alignment.topCenter,
              child: DeviceType.getDeviceTypeByContext(context) == Type.Website ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _infoItems(),
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _infoItems(),
              ),
            ),
          ],
        ),
      );

  List<Widget> _infoItems() {
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
                text: 'Shawna Brannen',
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'email: vintagevibesphotography@gmail.com',
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'phone: (760)691-0685',
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
                text: 'Jason Bent',
                isBold: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'email: jbent@gmail.com',
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'phone: (760)691-0685',
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
                text: 'Date: June 22, 2023',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 8),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Time: 6:45pm - 7:45pm',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Where: 42161 Delmonte St. Temecula CA 92591',
                textAlign: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextAlign.start : TextAlign.center,
              ),
            ),
            MouseRegion(
              child: GestureDetector(
                onTap: () {

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