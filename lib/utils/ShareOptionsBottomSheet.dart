import 'package:dandylight/models/Client.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import '../../widgets/TextDandyLight.dart';
import 'DandyToastUtil.dart';
import 'intentLauncher/IntentLauncherUtil.dart';

class ShareOptionsBottomSheet extends StatefulWidget {
  final Client client;
  final String message;
  final String emailTitle;

  ShareOptionsBottomSheet(this.client, this.message, this.emailTitle);


  @override
  State<StatefulWidget> createState() {
    return _ShareOptionsBottomSheetPageState(client, message, emailTitle);
  }
}

class _ShareOptionsBottomSheetPageState extends State<ShareOptionsBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  final Client client;
  final String message;
  final String emailTitle;

  _ShareOptionsBottomSheetPageState(this.client, this.message, this.emailTitle);


  @override
  Widget build(BuildContext context) =>
      Container(
        height: 208.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          color: Color(ColorConstants.getPrimaryWhite()),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 32),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Share with ${client.firstName}',
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (client.phone != null && client.phone!.length > 0) {
                        IntentLauncherUtil.sendSMSWithBody(client.phone!, message);
                      } else {
                        DandyToastUtil.showErrorToast('A phone number has not been saved for ${client.firstName}');
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 54.0,
                          width: 54.0,
                          child: Image.asset('assets/images/icons/chat_circle.png', color: Color(ColorConstants.getPeachDark())),
                        ),
                        TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'SMS'
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (client.email != null && client.email!.length! > 0) {
                        IntentLauncherUtil.sendEmail(client.email!, emailTitle, message);
                      } else {
                        DandyToastUtil.showErrorToast('An email has not been saved for ${client.firstName}');
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 54.0,
                          width: 54.0,
                          child: Image.asset('assets/images/icons/email_circle.png', color: Color(ColorConstants.getPeachDark())),
                        ),
                        TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Email'
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: message));
                      DandyToastUtil.showToast('Copied to Clipboard!', Color(ColorConstants.getPeachDark()));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 54.0,
                          width: 54.0,
                          child: Image.asset('assets/images/icons/link.png', color: Color(ColorConstants.getPeachDark())),
                        ),
                        TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Copy'
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Share.share(message);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 52.0,
                          width: 52.0,
                          margin: EdgeInsets.only(bottom: 2),
                          child: Image.asset('assets/images/icons/other.png', color: Color(ColorConstants.getPeachDark())),
                        ),
                        TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: 'Other'
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}