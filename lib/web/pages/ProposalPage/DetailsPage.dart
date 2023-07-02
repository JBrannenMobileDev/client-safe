import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/widgets/TextDandyLight.dart';
import 'package:flutter/material.dart';

import '../../../utils/ColorConstants.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DetailsPagePageState();
  }
}

class _DetailsPagePageState extends State<DetailsPage> {

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
              margin: EdgeInsets.only(top: 16, bottom: 32),
              child: TextDandyLight(
                type: TextDandyLight.EXTRA_LARGE_TEXT,
                text: 'Details',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 64),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: 'Hi Jason, \nI\'m so excited to book in your photoshoot! Let\'s make this official.\n\nTo lock in your date, please review and sign the contract and pay the deposit.\n\nChat soon,\nShawna Brannen',
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'PHOTOGRAPHER:',
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'CLIENT:',
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
                ],
              ),
            ),
          ],
        ),
      );
}