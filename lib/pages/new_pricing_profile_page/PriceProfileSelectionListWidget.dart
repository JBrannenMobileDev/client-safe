import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/PriceProfile.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/pricing_profiles_page/PricingProfilesPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PriceProfileSelectionListWidget extends StatelessWidget {
  final int profileIndex;

  PriceProfileSelectionListWidget(this.profileIndex);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewJobPageState>(
      converter: (store) => NewJobPageState.fromStore(store),
      builder: (BuildContext context, NewJobPageState pageState) =>
          new FlatButton(
        onPressed: () {
          _onProfileSelected(getProfile(profileIndex, pageState), pageState, context);
        },
            color: pageState.selectedPriceProfile == getProfile(profileIndex, pageState) ? Color(ColorConstants.getPrimaryColor()) : Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Color(ColorConstants.getPrimaryColor()),
                  width: 2.0,
                ),
                borderRadius: new BorderRadius.circular(32.0),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 4.0, right: 16.0),
              height: 40.0,
              width: 40.0,
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
                height: 88.0,
                margin: EdgeInsets.only(right: 8.0),
                child: Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        getProfile(profileIndex, pageState).profileName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          color: pageState.selectedPriceProfile == getProfile(profileIndex, pageState) ? Colors.white : Color(ColorConstants.primary_black),
                        ),
                      ),
                      Text(
                        _buildSubtitlePriceText(pageState, profileIndex),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w400,
                          color: pageState.selectedPriceProfile == getProfile(profileIndex, pageState) ? Colors.white : Color(ColorConstants.primary_black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _buildSubtitleLengthText(pageState, profileIndex),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              color: pageState.selectedPriceProfile == getProfile(profileIndex, pageState) ? Colors.white : Color(ColorConstants.primary_black),
                            ),
                          ),
                          Text(
                            _buildSubtitleEditsText(pageState, profileIndex),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              color: pageState.selectedPriceProfile == getProfile(profileIndex, pageState) ? Colors.white : Color(ColorConstants.primary_black),
                            ),
                          ),
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

  PriceProfile getProfile(int index, NewJobPageState pageState) {
    return pageState.pricingProfiles.elementAt(index);
  }

  String _buildSubtitlePriceText(NewJobPageState pageState, int index) {
    PriceProfile profile = getProfile(index, pageState);
    int price = profile.priceFives + profile.priceHundreds;
    String textToDisplay = "";
    textToDisplay = "PRICE:  \$$price" + ".00";
    return textToDisplay;
  }

  String _buildSubtitleLengthText(NewJobPageState pageState, int index) {
    PriceProfile profile = getProfile(index, pageState);
    int lengthHours = profile.timeInHours;
    int lengthInMin = profile.timeInMin;
    String hrText = profile.timeInHours != 0 ? profile.timeInHours == 1 ? "$lengthHours hr" : "$lengthHours hrs" : "";
    String minText = profile.timeInMin != null && profile.timeInMin != 0 ? "$lengthInMin min" : "";
    String textToDisplay = "";
    textToDisplay = "LENGTH:  $hrText $minText";
    return textToDisplay;
  }

  String _buildSubtitleEditsText(NewJobPageState pageState, int index) {
    PriceProfile profile = getProfile(index, pageState);
    int edits = profile.numOfEdits;
    String textToDisplay = "";
    textToDisplay = "EDITS:  $edits";
    return textToDisplay;
  }

  void _onProfileSelected(PriceProfile profile, NewJobPageState pageState, BuildContext context) {
    pageState.onPriceProfileSelected(profile);
  }
}
