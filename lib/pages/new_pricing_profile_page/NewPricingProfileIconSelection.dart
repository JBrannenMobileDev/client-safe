import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
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
    List<String> pricingProfileIconsWhite = ImageUtil.pricingProfileIconsWhite;
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
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
                    child:
                    Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                              pageState.profileIcon != null && getIconPosition(pageState, pricingProfileIcons) == index ? new Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              height: 64.0,
                              width: 64.0,
                              decoration: new BoxDecoration(
                                color: Color(ColorConstants.getBlueLight()),
                                borderRadius: BorderRadius.circular(36.0),
                              ),
                            ) : SizedBox(
                              height: 72.0,
                              width: 72.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              height: 42.0,
                              width: 42.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(pageState.profileIcon != null && getIconPosition(pageState, pricingProfileIcons) == index ? pricingProfileIconsWhite.elementAt(index) : pricingProfileIcons.elementAt(index)),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              ),
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
