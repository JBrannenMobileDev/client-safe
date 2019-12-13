import 'dart:async';

import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/locations_page/LocationsActions.dart';
import 'package:client_safe/pages/locations_page/LocationsPageState.dart';

import 'package:client_safe/pages/locations_page/widgets/LocationListWidget.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:client_safe/utils/UserPermissionsUtil.dart';
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
          PermissionStatus locationStatus = await UserPermissionsUtil.getPermissionStatus(PermissionGroup.locationWhenInUse);
          if(locationStatus == PermissionStatus.denied || locationStatus == PermissionStatus.disabled
              || locationStatus == PermissionStatus.unknown){
            _checkPermissions(context, store.state.locationsPageState);
          }
        },
        converter: (Store<AppState> store) => LocationsPageState.fromStore(store),
        builder: (BuildContext context, LocationsPageState pageState) =>
            Scaffold(
              backgroundColor: Color(ColorConstants.primary_locations),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Color(ColorConstants.primary_black), //change your color here
                    ),
                    brightness: Brightness.light,
                    backgroundColor: Color(ColorConstants.primary_locations),
                    pinned: true,
                    centerTitle: true,
                    title: Center(
                      child: Text(
                        "Locations",
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          color: const Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        color: Color(ColorConstants.primary_black),
                        tooltip: 'Add',
                        onPressed: () {
                          UserOptionsUtil.showNewLocationDialog(context);
                        },
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        pageState.locations.length > 0 ? Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: pageState.locations.length,
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemBuilder: _buildItem,
                          ),
                        ) :
                        Padding(
                          padding: EdgeInsets.only(left: 32.0, top: 48.0, right: 32.0),
                          child: Text(
                            "You have not saved any locations yet. To create a new location, select the plus icon.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.w400,
                              color: const Color(ColorConstants.primary_black),
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
            height: _getItemWidthHeight(context) + 100,
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
