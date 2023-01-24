import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'GroupImage.dart';

class SingleImageViewPager extends StatefulWidget {
  final List<GroupImage> poses;
  final int index;
  final Function(GroupImage) onDelete;
  final String groupName;

  SingleImageViewPager(this.poses, this.index, this.onDelete, this.groupName);

  @override
  _SingleImageViewPagerState createState() {
    return _SingleImageViewPagerState(poses, index, onDelete, poses.length, PageController(initialPage: index), groupName);
  }
}

class _SingleImageViewPagerState extends State<SingleImageViewPager> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount;
  int currentPageIndex;
  final PageController controller;
  final List<GroupImage> poses;
  final Function(GroupImage) onDelete;
  final List<Container> pages = [];
  final String groupName;

  _SingleImageViewPagerState(this.poses, this.currentPageIndex, this.onDelete, this.pageCount, this.controller, this.groupName);

  @override
  void initState() {
    super.initState();
    for(GroupImage image in poses) {
      pages.add(
          Container(
            margin: EdgeInsets.only(top: 86.0),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(16.0),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: image.file.path.isNotEmpty ? FileImage(File(image.file.path))
                  : AssetImage("assets/images/backgrounds/image_background.png"),
            ),
          ),
        )
      );
    }
  }

  Future<bool> _onDeleteSelected() {
    return showDialog(
          context: context,
          builder: (context) => new CupertinoAlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('This pose will be permanently deleted.'),
            actions: <Widget>[
              TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                style: Styles.getButtonStyle(),
                onPressed: () {
                  onDelete(poses.elementAt(currentPageIndex));
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  getCurrentPage(int page) {
    setState(() {
      currentPageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PoseGroupPageState>(
      converter: (store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: Container(
                    child: PageView.builder(
                      controller: controller,
                      onPageChanged: getCurrentPage,
                      // itemCount: pageCount,
                      itemBuilder: (context, position) {
                        if (position == pageCount) return null;
                        return pages.elementAt(position);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 36.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        groupName,
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'simple',
                          color: Color(ColorConstants.getPeachLight()),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              List<String> pathList = [];
                              pathList.add( poses.elementAt(currentPageIndex).file.path);
                              Share.shareFiles(
                                  pathList,
                                  subject: 'Example Pose');
                              EventSender().sendEvent(eventName: EventNames.BT_SHARE_POSE);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 22.0),
                              height: 28.0,
                              width: 28.0,
                              child: Icon(
                                (Device.get().isIos ? CupertinoIcons.share : Icons.share),
                                size: 28.0,
                                color: Color(ColorConstants.getPeachLight()),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _onDeleteSelected();
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 26.0),
                              height: 28.0,
                              width: 28.0,
                              child: Image.asset(
                                'assets/images/icons/trashcan.png',
                                color: Color(ColorConstants.getPeachLight()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AppBar(
                    title: Text(''),// You can add title here
                    leading: new IconButton(
                      icon: new Icon((Device.get().isIos ? CupertinoIcons.back : Icons.arrow_back), color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: Colors.transparent, //You can make this transparent
                    elevation: 0.0, //No shadow
                  ),
                ),
              ],
            ),
        ),
    );
  }

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
