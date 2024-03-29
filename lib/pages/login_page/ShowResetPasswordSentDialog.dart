import 'package:dandylight/utils/ColorConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/TextDandyLight.dart';

class ShowResetPasswordSentDialog extends StatelessWidget {
  final User user;

  ShowResetPasswordSentDialog(this.user,);

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.EXTRA_EXTRA_LARGE_TEXT,
                  text: 'Email Sent!',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryColor()),
                ),
              ),
              Container(
                height: 96.0,
                width: 96.0,
                child: Image.asset('assets/images/icons/confirm_icon_gold.png'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Please come back and sign in after resetting your password.',
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
