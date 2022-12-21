import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/locations_page/LocationsActions.dart';
import 'package:dandylight/pages/locations_page/LocationsPageState.dart';

import 'package:dandylight/pages/locations_page/widgets/LocationListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/UserPermissionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

class LocationsPage extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, LocationsPageState>(
        onInit: (store)  async {
          store.dispatch(FetchLocationsAction(store.state.locationsPageState));
          PermissionStatus locationStatus = await UserPermissionsUtil.getPermissionStatus(Permission.locationWhenInUse);
          if(locationStatus == PermissionStatus.denied || locationStatus == PermissionStatus.denied){
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
                      // GestureDetector(
                      //   onTap: () {
                      //
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(right: 22.0),
                      //     height: 24.0,
                      //     width: 24.0,
                      //     child: Icon(
                      //       Device.get().isIos
                      //           ? CupertinoIcons.share
                      //           : Icons.share,
                      //       size: 24.0,
                      //     ),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          UserOptionsUtil.showNewLocationDialog(context);
                          pageState.clearNewLocationState();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 26.0),
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPrimaryWhite()),),
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
                            child: GridView.builder(
                                padding: new EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 250.0),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 2.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16),
                              itemCount: pageState.locations.length,
                              controller: _controller,
                              physics: AlwaysScrollableScrollPhysics(),
                              key: _listKey,
                              shrinkWrap: true,
                              reverse: false,
                              itemBuilder: _buildItem),
                          ),
                        ) :
                        Padding(
                          padding: EdgeInsets.only(left: 32.0, top: 48.0, right: 32.0),
                          child: Text(
                            "Save locations you regularly use here. \n\nThese locations can be added to your jobs to help make mileage tracking easier and enabling you to share the driving directions with your clients.\n\nYour locations will never be shared with other photographers. They will remain private to you.",
                            // \n\nYou can also share your saved locations with a client to help them decide what location they want.
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
          GestureDetector(
            onTap: () {
              pageState.onLocationSelected(pageState.locations.elementAt(index));
              UserOptionsUtil.showNewLocationDialog(context);
            },
            child: LocationListWidget(index),
          ),
    );
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
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
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
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
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
