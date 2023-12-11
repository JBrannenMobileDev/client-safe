import 'package:flutter/material.dart';
import '../../widgets/TextDandyLight.dart';

class DeleteAccountInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'Steps for deleting your Dandylight account and all related data',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 64),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '1. Login to your dandylight account on the Dandylight mobile app.',
              textAlign: TextAlign.center,
            ),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '2. Select the gear icon in the top right corner of the main page to navigate to the "Main Settings" page of the app.',
              textAlign: TextAlign.center,
            ),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '3. Sroll down to the bottom of the "Main Settings" page until you see the "Delete Account" option.',
              textAlign: TextAlign.center,
            ),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '4. Select the "Delete Account" option.',
              textAlign: TextAlign.center,
            ),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '5. Select the "Yes i want to delete my account" check box.',
              textAlign: TextAlign.center,
            ),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '6. Enter your password in the provided password field.',
              textAlign: TextAlign.center,
            ),
            TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: '7. Select the "Delete Account" button at the bottom of the page.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}