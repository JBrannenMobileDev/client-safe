import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/locations_page/LocationsActions.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';

import 'package:dandylight/pages/locations_page/widgets/LocationListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/UserPermissionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

class LocationsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, LocationsPageState>(
        onInit: (store)  async {
          store.dispatch(FetchLocationsAction(store.state.locationsPageState));
          PermissionStatus locationStatus = await UserPermissionsUtil.getPermissionStatus(Permission.locationWhenInUse);
          if(locationStatus == PermissionStatus.denied || locationStatus == PermissionStatus.denied
              || locationStatus == PermissionStatus.undetermined){
            _checkPermissions(context, store.state.locationsPageState);
          }
        },
        converter: (Store<AppState> store) => LocationsPageState.fromStore(store),
        builder: (BuildContext context, LocationsPageState pageState) =>
            Scaffold(
              backgroundColor: Color(ColorConstants.getBlueDark()),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Color(ColorConstants.getPrimaryWhite()), //change your color here
                    ),
                    brightness: Brightness.light,
                    backgroundColor: Color(ColorConstants.getBlueDark()),
                    pinned: true,
                    centerTitle: true,
                    title: Center(
                      child: Text(
                        "Locations",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'simple',
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          UserOptionsUtil.showNewLocationDialog(context);
                          pageState.clearNewLocationState();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 26.0),
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/plus_icon_white.png'),
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        pageState.locations.length > 0 ? Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Container(
                            height: (MediaQuery.of(context).size.height),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: pageState.locations.length,
                              itemBuilder: _buildItem,
                            ),
                          ),
                        ) :
                        Padding(
                          padding: EdgeInsets.only(left: 32.0, top: 48.0, right: 32.0),
                          child: Text(
                            "You have not saved any locations yet. To create a new location, select the plus icon.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConstants.getPrimaryWhite()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      );

  Widget _buildItem(BuildContext context, int index) {
    return StoreConnector<AppState, LocationsPageState>(
      converter: (store) => LocationsPageState.fromStore(store),
      builder: (BuildContext context, LocationsPageState pageState) =>
      Container(
            margin: EdgeInsets.only(bottom: pageState.locations.length == (index + 1) ? 256.0 : 32.0),
            child: LocationListWidget(index),
          ),
    );
  }

  double _getItemWidthHeight(BuildContext context){
    return (MediaQuery.of(context).size.width - 94) / 2.0;
  }

  Future<void> _checkPermissions(BuildContext context, LocationsPageState pageState){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Request Location Permission'),
          content: new Text('This permission will be used for saving session locations.'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () async {
                await UserPermissionsUtil.requestPermission(Permission.locationWhenInUse);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Request Location Permission'),
          content: new Text('This permission will be used for saving session locations.'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new FlatButton(
              onPressed: () async{
                await UserPermissionsUtil.requestPermission(Permission.locationWhenInUse);
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
