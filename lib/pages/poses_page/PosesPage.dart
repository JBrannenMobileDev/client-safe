import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/widgets/PoseGroupListWidget.dart';

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

import 'PosesActions.dart';
import 'PosesPageState.dart';

class PosesPage extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PosesPageState>(
        onInit: (store)  async {
          store.dispatch(FetchPoseGroupsAction(store.state.posesPageState));
        },
        converter: (Store<AppState> store) => PosesPageState.fromStore(store),
        builder: (BuildContext context, PosesPageState pageState) =>
            Scaffold(
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    iconTheme: IconThemeData(
                      color: Color(ColorConstants.getPeachDark()), //change your color here
                    ),
                    brightness: Brightness.light,
                    backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                    pinned: true,
                    centerTitle: true,
                    title: Center(
                      child: Text(
                        "Poses",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'simple',
                          color: Color(ColorConstants.getPeachDark()),
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          UserOptionsUtil.showNewPoseGroupDialog(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 26.0),
                          height: 24.0,
                          width: 24.0,
                          child: Image.asset('assets/images/icons/plus.png', color: Color(ColorConstants.getPeachDark()),),
                        ),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: new SliverChildListDelegate(
                      <Widget>[
                        pageState.poseGroups.length > 0 ? Container(
                            height: (MediaQuery.of(context).size.height),
                            child: ListView.builder(
                              padding: new EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 250.0),
                              itemCount: pageState.poseGroups.length,
                              controller: _controller,
                              physics: AlwaysScrollableScrollPhysics(),
                              key: _listKey,
                              shrinkWrap: true,
                              reverse: false,
                              itemBuilder: _buildItem),
                        ) :
                        Padding(
                          padding: EdgeInsets.only(left: 32.0, top: 48.0, right: 32.0),
                          child: Text(
                            "Save your poses here. \nSelect the plus icon to create a new collection.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'simple',
                              fontWeight: FontWeight.w400,
                              color: Color(ColorConstants.getPeachDark()),
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
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
      PoseGroupListWidget(index),
    );
  }

  Future<void> _checkPermissions(BuildContext context, PosesPageState pageState){
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
