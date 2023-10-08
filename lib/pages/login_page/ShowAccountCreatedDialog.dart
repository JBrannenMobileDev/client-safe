import 'package:dandylight/utils/ColorConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';

class ShowAccountCreatedDialog extends StatelessWidget {
  final User user;

  ShowAccountCreatedDialog(this.user,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(

        child: Container(
          alignment: Alignment.center,
          height: 324.0,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          padding: EdgeInsets.only(left: 32.0, right: 32.0),
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.circular(16.0),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                  text: 'Success!',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPeachDark()),
                ),
              ),
              Container(
                height: 96.0,
                width: 96.0,
                child: Icon(
                  Icons.check,
                  color: Color(ColorConstants.getPeachDark()),
                  size: 96,
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'VERIFY THROUGH EMAIL',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'After verification is complete you will be able to sign in to DandyLight.',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'OK',
                    textAlign: TextAlign.end,
                    color: Color(ColorConstants.getPeachDark()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
