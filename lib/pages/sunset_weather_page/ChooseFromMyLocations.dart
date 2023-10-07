import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherLocationListWidget.dart';
import 'package:dandylight/pages/sunset_weather_page/SunsetWeatherPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';


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
        insetPadding: EdgeInsets.only(left: 0.0, right: 0.0),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Color(ColorConstants.getPrimaryWhite()),
            borderRadius: BorderRadius.circular(16.0),
          ),
          alignment: Alignment.topCenter,
          child: pageState.locations.length > 0
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 0.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: "Select a Location",
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: pageState.selectedLocation != null
                      ? pageState.selectedLocation.locationName
                      : "",
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryColor()),
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height) - 202,
                child: GridView.builder(
                    padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 64.0),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 64),
                    itemCount: pageState.locations.length,
                    controller: _controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    key: _listKey,
                    shrinkWrap: true,
                    reverse: false,
                    itemBuilder: _buildItem),
              ),
              Padding(
                padding: EdgeInsets.only(left: 26.0, right: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      style: Styles.getButtonStyle(
                        color: Color(ColorConstants.getPrimaryWhite()),
                        textColor: Color(ColorConstants.primary_black),
                        left: 8.0,
                        top: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                      // disabledTextColor:
                      // Color(ColorConstants.primary_bg_grey),
                      // splashColor: Color(ColorConstants.getPrimaryColor()),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Cancel',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                    TextButton(
                      style: Styles.getButtonStyle(
                        color: Color(ColorConstants.getPrimaryWhite()),
                        textColor: Color(ColorConstants.primary_black),
                        left: 8.0,
                        top: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      // disabledColor: Color(ColorConstants.getPrimaryWhite()),
                      // disabledTextColor:
                      // Color(ColorConstants.primary_bg_grey),
                      // splashColor: Color(ColorConstants.getPrimaryColor()),
                      onPressed: () {
                        pageState.onLocationSaved();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Save',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.primary_black),
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
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: "Select a location for this job",
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0, top: 16.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: "You do not have any locations saved to your collection. Select the + Location button to create a new location.",
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.primary_black),
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
                      TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Location",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
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
