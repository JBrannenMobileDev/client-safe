import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/intentLauncher/IntentLauncherUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/TextDandyLight.dart';


class HowToBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          color: Color(ColorConstants.getPrimaryWhite())),
      padding: EdgeInsets.only(left: 32.0, right: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 24, bottom: 16.0),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'HOW-TO Videos',
              textAlign: TextAlign.center,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
          GestureDetector(
            onTap: () {
              IntentLauncherUtil.launchURLInternalBrowser('https://youtu.be/V0IPCboZ-Lw?si=8FaV12fL7XBQVSMi');
            },
            child: Container(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        height: 24,
                        width: 24,
                        child: Icon(Icons.play_circle, color: Color(ColorConstants.getPrimaryGreyMedium())),
                      ),
                      TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'How to create a contract'
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(),
                    child: Icon(
                      Icons.chevron_right,
                      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              IntentLauncherUtil.launchURLInternalBrowser('https://youtu.be/xe_pArGptwA?si=0rRZrjNrhoP6j7-N');
            },
            child: Container(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 16),
                        height: 24,
                        width: 24,
                        child: Icon(Icons.play_circle, color: Color(ColorConstants.getPrimaryGreyMedium())),
                      ),
                      TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'How to add contract to job'
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(),
                    child: Icon(
                      Icons.chevron_right,
                      color: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}