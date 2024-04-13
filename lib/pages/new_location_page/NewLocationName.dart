import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationPageState.dart';
import 'package:dandylight/pages/new_location_page/NewLocationTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';


class NewLocationName extends StatefulWidget {
  @override
  _NewLocationName createState() {
    return _NewLocationName();
  }
}

class _NewLocationName extends State<NewLocationName> with AutomaticKeepAliveClientMixin {
  final locationNameTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewLocationPageState>(
      onInit: (store) {
        locationNameTextController.text = store.state.newLocationPageState!.locationName!;
      },
      converter: (store) => NewLocationPageState.fromStore(store),
      builder: (BuildContext context, NewLocationPageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: TextDandyLight(
                type: TextDandyLight.MEDIUM_TEXT,
                text: "Enter a simple and descriptive name for this location. ",
                textAlign: TextAlign.start,
                color: Color(ColorConstants.getPrimaryBlack()),
              ),
            ),
            NewLocationTextField(
                locationNameTextController,
                "Location Name",
                TextInputType.text,
                64.0,
                pageState.onLocationNameChanged!,
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
