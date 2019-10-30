import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
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
          _onProfileSelected(getProfile(profileIndex, pageState), pageState, context);
        },
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(32.0),
            ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 4.0, right: 16.0, top: 4.0),
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getProfile(profileIndex, pageState).icon),
                  fit: BoxFit.contain,
                ),
                color: Colors.transparent,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _buildSubtitlePriceText(pageState, profileIndex),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              color:
                              const Color(ColorConstants.primary_black),
                            ),
                          ),
                          Text(
                            _buildSubtitleLengthText(pageState, profileIndex),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              color:
                              const Color(ColorConstants.primary_black),
                            ),
                          ),
                          Text(
                            _buildSubtitleEditsText(pageState, profileIndex),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              color:
                              const Color(ColorConstants.primary_black),
                            ),
                          )
                        ],
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

  String _buildSubtitlePriceText(PricingProfilesPageState pageState, int index) {
    PriceProfile profile = getProfile(index, pageState);
    int price = profile.priceFives + profile.priceHundreds;
    String textToDisplay = "";
    textToDisplay = "Price:  \$$price" + ".00";
    return textToDisplay;
  }

  String _buildSubtitleLengthText(PricingProfilesPageState pageState, int index) {
    PriceProfile profile = getProfile(index, pageState);
    int lengthHours = profile.timeInHours;
    String hrText = profile.timeInHours != 0 && profile.timeInHours == 1 ? "hr" : "hrs";
    String textToDisplay = "";
    textToDisplay = "Shoot length:  $lengthHours $hrText";
    return textToDisplay;
  }

  String _buildSubtitleEditsText(PricingProfilesPageState pageState, int index) {
    PriceProfile profile = getProfile(index, pageState);
    int edits = profile.numOfEdits;
    String textToDisplay = "";
    textToDisplay = "Edits:  $edits";
    return textToDisplay;
  }

  _onProfileSelected(PriceProfile selectedProfile, PricingProfilesPageState pageState, BuildContext context) {
    pageState.onProfileSelected(selectedProfile);
    UserOptionsUtil.showNewPriceProfileDialog(context);
  }
}
