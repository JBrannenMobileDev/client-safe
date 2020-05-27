import 'dart:io';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_job_page/widgets/JobLocationListWidget.dart';
import 'package:client_safe/pages/new_location_page/NewLocationPageState.dart';
import 'package:client_safe/pages/new_location_page/NewLocationTextField.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherLocationListWidget.dart';
import 'package:client_safe/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class ChooseFromMyLocations extends StatefulWidget {
  @override
  _ChooseFromMyLocationsState createState() {
    return _ChooseFromMyLocationsState();
  }
}

class _ChooseFromMyLocationsState extends State<ChooseFromMyLocations>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, SunsetWeatherPageState>(
      converter: (store) => SunsetWeatherPageState.fromStore(store),
      builder: (BuildContext context, SunsetWeatherPageState pageState) => Dialog(
        insetPadding: EdgeInsets.only(left: 16.0, right: 16.0),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.circular(16.0),
          ),
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: pageState.locations.length > 0
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                    FlatButton(
                      color: Colors.white,
                      textColor: Color(ColorConstants.primary_black),
                      disabledColor: Colors.white,
                      disabledTextColor:
                      Color(ColorConstants.primary_bg_grey),
                      padding: EdgeInsets.all(8.0),
                      splashColor: Color(ColorConstants.getPrimaryColor()),
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
                    FlatButton(
                      color: Colors.white,
                      textColor: Color(ColorConstants.primary_black),
                      disabledColor: Colors.white,
                      disabledTextColor:
                      Color(ColorConstants.primary_bg_grey),
                      padding: EdgeInsets.all(8.0),
                      splashColor: Color(ColorConstants.getPrimaryColor()),
                      onPressed: () {
                        pageState.onLocationSaved();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
                  "You do ot have any locations saved to your collection. Select the + Location button to create a new location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w600,
                    color: Color(ColorConstants.primary_black),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  UserOptionsUtil.showNewLocationDialog(context);
                },
                color: Color(ColorConstants.getPrimaryColor()),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(24.0),
                ),
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
    return StoreConnector<AppState, SunsetWeatherPageState>(
      converter: (store) => SunsetWeatherPageState.fromStore(store),
      builder: (BuildContext context, SunsetWeatherPageState pageState) => Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: SunsetWeatherLocationListWidget(index),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
