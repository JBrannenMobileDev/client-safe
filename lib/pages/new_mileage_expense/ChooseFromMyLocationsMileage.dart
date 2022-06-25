import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_mileage_expense/MileageLocationListWidget.dart';
import 'package:dandylight/pages/new_mileage_expense/NewMileageExpensePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ChooseFromMyLocationsMileage extends StatefulWidget {
  final Function(LatLng) onLocationSaved;

  ChooseFromMyLocationsMileage(this.onLocationSaved);

  @override
  _ChooseFromMyLocationsMileageState createState() {
    return _ChooseFromMyLocationsMileageState(onLocationSaved);
  }
}

class _ChooseFromMyLocationsMileageState extends State<ChooseFromMyLocationsMileage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Function(LatLng) onLocationSaved;

  _ChooseFromMyLocationsMileageState(this.onLocationSaved);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewMileageExpensePageState>(
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) => Dialog(
        insetPadding: EdgeInsets.only(left: 16.0, right: 16.0),
        backgroundColor: Colors.transparent,
        child: Container(
          height: pageState.locations.length == 0 ? 300.0 : pageState.locations.length == 1 ? 400.0 : pageState.locations.length == 2 ? 600.0 : MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.circular(16.0),
          ),
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: pageState.locations.length > 0
              ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 0.0),
                child: Text(
                  "Select a Location",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  pageState.selectedLocation != null
                      ? pageState.selectedLocation.locationName
                      : "",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.getPrimaryColor()),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 65.0,
                  maxHeight: MediaQuery.of(context).size.height - 208,
                ),
                child: ListView.builder(
                  reverse: false,
                  padding: new EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 64.0),
                  shrinkWrap: true,
                  controller: _controller,
                  physics: ClampingScrollPhysics(),
                  key: _listKey,
                  itemCount: pageState.locations.length,
                  itemBuilder: _buildItem,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 26.0, right: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      style: Styles.getButtonStyle(
                        color: Colors.white,
                        textColor: Color(ColorConstants.primary_black),
                        left: 8.0,
                        top: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      // disabledColor: Colors.white,
                      // disabledTextColor:
                      // Color(ColorConstants.primary_bg_grey),
                      // splashColor: Color(ColorConstants.getPrimaryColor()),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    TextButton(
                      style: Styles.getButtonStyle(
                        color: Colors.white,
                        textColor: Color(ColorConstants.primary_black),
                        left: 8.0,
                        top: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      // disabledColor: Colors.white,
                      // disabledTextColor:
                      // Color(ColorConstants.primary_bg_grey),
                      // splashColor: Color(ColorConstants.getPrimaryColor()),
                      onPressed: () {
                        if(pageState.selectedLocation != null){
                          onLocationSaved(LatLng(pageState.selectedLocation.latitude, pageState.selectedLocation.longitude));
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Save',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
                child: Text(
                  "Select a location for this job",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0, top: 16.0),
                child: Text(
                  "You do ot have any locations saved to your collection.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              TextButton(
                style: Styles.getButtonStyle(
                  color: Color(ColorConstants.getPrimaryColor()),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(24.0),
                  ),
                ),
                onPressed: () {
                  UserOptionsUtil.showNewLocationDialog(context);
                },
                child: Container(
                  width: 150.0,
                  child: Row(

                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: Color(ColorConstants.white),
                        tooltip: 'Add',
                        onPressed: () {
                          UserOptionsUtil.showNewPriceProfileDialog(context);
                        },
                      ),
                      Text(
                        "Location",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w400,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, NewMileageExpensePageState>(
      converter: (store) => NewMileageExpensePageState.fromStore(store),
      builder: (BuildContext context, NewMileageExpensePageState pageState) => Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: MileageLocationListWidget(index),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
