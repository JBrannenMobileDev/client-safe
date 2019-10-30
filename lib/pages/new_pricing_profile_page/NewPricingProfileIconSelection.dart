import 'dart:ui';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/ImageUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewPricingProfileIconSelection extends StatefulWidget {
  @override
  _NewPricingProfileIconSelection createState() {
    return _NewPricingProfileIconSelection();
  }
}

class _NewPricingProfileIconSelection extends State<NewPricingProfileIconSelection>
    with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<String> pricingProfileIcons = ImageUtil.pricingProfileIcons;
    return StoreConnector<AppState, NewPricingProfilePageState>(
      converter: (store) => NewPricingProfilePageState.fromStore(store),
      builder: (BuildContext context, NewPricingProfilePageState pageState) =>
          Container(
        margin: EdgeInsets.only(left: 26.0, right: 26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 16.0),
              child: Text(
                "Select an icon that best represents this profile.",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: 8,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      pageState.onProfileIconSelected(pricingProfileIcons.elementAt(index));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 4.0, bottom: 4.0),
                      height: 24.0,
                      width: 24.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(pricingProfileIcons.elementAt(index)),
                          fit: BoxFit.contain,
                        ),
                      ),
                      child: pageState.profileIcon != null && getIconPosition(pageState, pricingProfileIcons) != index ? new Container(
                        decoration: new BoxDecoration(
                            color: Colors.white.withOpacity(0.5)),
                      ) : SizedBox(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  int getIconPosition(NewPricingProfilePageState pageState, List<String> icons) {
    return icons.indexOf(pageState.profileIcon);
  }
}
