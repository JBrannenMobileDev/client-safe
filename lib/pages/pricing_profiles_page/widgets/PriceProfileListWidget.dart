import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/client_details_page/ClientDetailsPage.dart';
import 'package:client_safe/pages/clients_page/ClientsPage.dart';
import 'package:client_safe/pages/clients_page/ClientsPageState.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PriceProfileListWidget extends StatelessWidget {
  final int profileIndex;

  PriceProfileListWidget(this.profileIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PricingProfilesPageState>(
      converter: (store) => PricingProfilesPageState.fromStore(store),
      builder: (BuildContext context, PricingProfilesPageState pageState) =>
          new FlatButton(
        onPressed: () {
          _onProfileTapped(getProfile(profileIndex, pageState), pageState, context);
        },
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getProfile(profileIndex, pageState).icon),
                  fit: BoxFit.contain,
                ),
                color: const Color(ColorConstants.primary_bg_grey),
                borderRadius: BorderRadius.all(Radius.circular(22.0)),
              ),
            ),
            Expanded(
              child: Container(
                height: 64.0,
                margin: EdgeInsets.only(right: 32.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        getProfile(profileIndex, pageState).profileName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: const Color(ColorConstants.primary_black),
                        ),
                      ),
                      Text(
                        _buildSubtitleText(pageState, profileIndex),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color:
                              const Color(ColorConstants.primary_bg_grey_dark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PriceProfile getProfile(int index, PricingProfilesPageState pageState) {
    return pageState.pricingProfiles.elementAt(index);
  }

  String _buildSubtitleText(PricingProfilesPageState pageState, int index) {
    PriceProfile profile = getProfile(index, pageState);
    int price = profile.price;
    int length = profile.timeInMin;
    int edits = profile.numOfEdits;
    String textToDisplay = "";
    textToDisplay = "Price:  \$$price  -  Length:  $length  -  Edits:  $edits";
    return textToDisplay;
  }

  _onProfileTapped(PriceProfile selectedProfile, PricingProfilesPageState pageState, BuildContext context) {
    pageState.onProfileSelected(selectedProfile);
    UserOptionsUtil.showNewPriceProfileDialog(context);
  }
}
