import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/dandylightTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';


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
        profileNameTextController.text = store.state.pricingProfilePageState!.profileName!;
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
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "Enter a simple and descriptive name for this price profile. \n\n(Example: One Hour Price, Fall Special Price)",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            DandyLightTextField(
                controller: profileNameTextController,
                hintText: "Price Profile Name",
                inputType: TextInputType.text,
                height: 64.0,
                onTextInputChanged: pageState.onProfileNameChanged!,
                keyboardAction: TextInputAction.done,
                capitalization: TextCapitalization.words,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
