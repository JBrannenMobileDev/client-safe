import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfileTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';


class NewProfileName extends StatefulWidget {
  @override
  _NewProfileName createState() {
    return _NewProfileName();
  }
}

class _NewProfileName extends State<NewProfileName> with AutomaticKeepAliveClientMixin {
  final profileNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewPricingProfilePageState>(
      onInit: (store) {
        profileNameTextController.text = store.state.pricingProfilePageState.profileName;
      },
      converter: (store) => NewPricingProfilePageState.fromStore(store),
      builder: (BuildContext context, NewPricingProfilePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                "Enter a simple and descriptive name for this price profile. \n\ne.g. (One Hour Price) or (Fall Special Price)",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            NewPricingProfileTextField(
                profileNameTextController,
                "Price Profile Name",
                TextInputType.text,
                60.0,
                pageState.onProfileNameChanged,
                NewPricingProfilePageState.ERROR_PROFILE_NAME_MISSING,
                TextInputAction.done,
                null,
                null,
                TextCapitalization.words,
                null),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}