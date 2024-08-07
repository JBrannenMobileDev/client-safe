import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/TextDandyLight.dart';


class LocationOptionsMileageExpenseDialog extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  final double initLat;
  final double initLng;

  LocationOptionsMileageExpenseDialog(this.onLocationSelected, this.initLat, this.initLng);

  @override
  _LocationOptionsMileageExpenseDialogState createState() {
    return _LocationOptionsMileageExpenseDialogState(onLocationSelected, initLat, initLng);
  }
}

class _LocationOptionsMileageExpenseDialogState extends State<LocationOptionsMileageExpenseDialog> with AutomaticKeepAliveClientMixin {
  final Function(LatLng) onLocationSelected;
  final double initLat;
  final double initLng;

  _LocationOptionsMileageExpenseDialogState(this.onLocationSelected, this.initLat, this.initLng);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewMileageExpensePageState>(
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            surfaceTintColor: Colors.transparent,
            child: Container(
              color: Color(ColorConstants.getPrimaryWhite()),
              height: 272.0,
              margin: EdgeInsets.only(left: 26.0, right: 26.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 24.0, top: 32.0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: "Select from your collection of locations or select a new location from a map.",
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                          UserOptionsUtil.showChooseFromMyLocationsMileageDialog(context, onLocationSelected);
                        },
                        child: Column(

                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              padding: EdgeInsets.all(24.0),
                              height: 96,
                              width: 96,
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getBlueDark()),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset('assets/images/menu/collections_icon.png', color: Color(ColorConstants.getPrimaryWhite())),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'My Locations',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),

                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(true);
                          NavigationUtil.onSelectMapLocation(
                              context,
                              onLocationSelected,
                              initLat,
                              initLng,
                              null
                          );
                        },
                        child: Column(

                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 8.0),
                              padding: EdgeInsets.all(24.0),
                              height: 96,
                              width: 96,
                              decoration: BoxDecoration(
                                color: Color(ColorConstants.getBlueDark()),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                  'assets/images/icons/pin_white.png'),
                            ),
                            TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Map Location',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
