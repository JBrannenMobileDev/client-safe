import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/SessionType.dart';
import '../../utils/ColorConstants.dart';
import '../../widgets/TextDandyLight.dart';

class SessionTypesListWidget extends StatelessWidget {
  final SessionType sessionType;
  final pageState;
  final Function onSessionTypeSelected;
  final Color backgroundColor;
  final Color textColor;
  final int index;

  SessionTypesListWidget(this.sessionType, this.pageState, this.onSessionTypeSelected, this.backgroundColor, this.textColor, this.index);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: Styles.getButtonStyle(
          color: backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          onSessionTypeSelected(sessionType, pageState, context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 56.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(

                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 16.0, left: 16.0),
                        height: 36.0,
                        width: 36.0,
                        child: Image.asset('assets/images/icons/job_type.png', color: Color(ColorConstants.getPrimaryGreyDark()),),
                      ),
                      Container(
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: sessionType.title,
                          textAlign: TextAlign.start,
                          color: textColor,
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
}
