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


class NewProfileLengthSelection extends StatefulWidget {
  @override
  _NewProfileLengthSelection createState() {
    return _NewProfileLengthSelection();
  }
}

class _NewProfileLengthSelection extends State<NewProfileLengthSelection> with AutomaticKeepAliveClientMixin {

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
                  (pageState.lengthInHours).toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 54.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                Text(
                  pageState.lengthInHours == 1 ? "hr " : "hrs  ",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
                pageState.lengthInMinutes > 0 ? Text(
                    pageState.lengthInMinutes.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 54.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ) : SizedBox(),
                pageState.lengthInMinutes > 0 ? Text(
                  "min",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.primary_black),
                  ),
                ) : SizedBox(),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16.0, top: 24.0),
              child: Text(
                "Select the session length for this profile.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 42.0),
                  child: Text(
                    "5min increments",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w300,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Container(
                  width: 250.0,
                  child: CupertinoSlider(
                    value: pageState.lengthInMinutes.toDouble(),
                    min: 0.0,
                    max: 55.0,
                    divisions: 11,
                    onChanged: (double min) {
                      if(min % 1 == 0){
                        vibrate();
                      }
                      pageState.onLengthInMinutesChanged(min.round());
                    },
                  ),
                )
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 42.0),
                  child: Text(
                    "1hr increments",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w300,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                ),
                Container(
                  width: 250.0,
                  child: CupertinoSlider(
                    value: pageState.lengthInHours.toDouble(),
                    min: 0.0,
                    max: 24.0,
                    divisions: 24,
                    onChanged: (double hours) {
                      if(hours % 1 == 0){
                        vibrate();
                      }
                      pageState.onLengthInHoursChanged(hours.round());
                    },
                  ),
                ),
              ],
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
