import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';


class NewProfileNumberOfEditsSelection extends StatefulWidget {
  @override
  _NewProfileNumberOfEditsSelection createState() {
    return _NewProfileNumberOfEditsSelection();
  }
}

class _NewProfileNumberOfEditsSelection extends State<NewProfileNumberOfEditsSelection> with AutomaticKeepAliveClientMixin {
  int maxEdits = 50;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewPricingProfilePageState>(
      converter: (store) => NewPricingProfilePageState.fromStore(store),
      builder: (BuildContext context, NewPricingProfilePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  pageState.numOfEdits.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 54.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Text(
                  pageState.numOfEdits == 1 ? " edit" : " edits",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.primary_black),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16.0, top: 24.0),
              child: Text(
                "Select the number of edit you will provide for this profile.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            Container(
              width: 350.0,
              child: CupertinoSlider(
                value: pageState.numOfEdits.toDouble(),
                min: 0.0,
                max: maxEdits.toDouble(),
                divisions: maxEdits,
                onChanged: (double num) {
                  if(num % 1 == 0){
                    vibrate();
                  }
                  if(num == maxEdits){
                    sleep(const Duration(milliseconds: 500));
                    setState(() {
                      maxEdits = maxEdits + 10;
                    });
                  }
                  pageState.onNumOfEditsChanged(num.toInt());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }

  @override
  bool get wantKeepAlive => true;
}
