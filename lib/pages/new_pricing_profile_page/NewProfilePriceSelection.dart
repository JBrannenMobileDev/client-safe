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


class NewProfilePriceSelection extends StatefulWidget {
  @override
  _NewProfilePriceSelection createState() {
    return _NewProfilePriceSelection();
  }
}

class _NewProfilePriceSelection extends State<NewProfilePriceSelection> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewPricingProfilePageState>(
      converter: (store) => NewPricingProfilePageState.fromStore(store),
      builder: (BuildContext context, NewPricingProfilePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "\$" + (pageState.priceFives+pageState.priceHundreds).toString() + ".00",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 54.0,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w600,
                color: Color(ColorConstants.primary_black),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 16.0, top: 24.0),
              child: Text(
                "Select the price for this profile.",
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
                    "\$5 increments",
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
                  width: 350.0,
                  child: CupertinoSlider(
                    value: pageState.priceFives.toDouble(),
                    min: 0.0,
                    max: 95.0,
                    divisions: 95~/5,
                    onChanged: (double price) {
                      vibrate();
                      pageState.onPriceFivesChanged(price.round());
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
                    "\$100 increments",
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
                  width: 350.0,
                  child: CupertinoSlider(
                    value: pageState.priceHundreds.toDouble(),
                    min: 0.0,
                    max: 1000.0,
                    divisions: 1000~/100,
                    onChanged: (double price) {
                      vibrate();
                      pageState.onPriceHundredsChanged(price.round());
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
