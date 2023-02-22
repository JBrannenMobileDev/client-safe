import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_group_page/PoseGroupPageState.dart';
import 'package:dandylight/pages/pose_group_page/widgets/SaveToJobBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/Job.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import '../pose_group_page/GroupImage.dart';
import 'JobDetailsPageState.dart';

class JobDetailsSingleImageViewPager extends StatefulWidget {
  final List<GroupImage> poses;
  final int index;
  final Function(int) onDelete;
  final String groupName;

  JobDetailsSingleImageViewPager(this.poses, this.index, this.onDelete, this.groupName);

  @override
  _JobDetailsSingleImageViewPagerState createState() {
    return _JobDetailsSingleImageViewPagerState(poses, index, onDelete, poses.length, PageController(initialPage: index), groupName);
  }
}

class _JobDetailsSingleImageViewPagerState extends State<JobDetailsSingleImageViewPager> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount;
  int currentPageIndex;
  final PageController controller;
  final List<GroupImage> poses;
  final Function(int) onDelete;
  final List<Container> pages = [];
  final String groupName;

  _JobDetailsSingleImageViewPagerState(this.poses, this.currentPageIndex, this.onDelete, this.pageCount, this.controller, this.groupName);

  @override
  void initState() {
    super.initState();
    for(GroupImage image in poses) {
      pages.add(
          Container(
            margin: EdgeInsets.only(top: 16),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: new BorderRadius.circular(8.0),
                        child: Image(
                          fit: BoxFit.contain,
                          image: image.file.path.isNotEmpty ? FileImage(File(image.file.path))
                              : AssetImage("assets/images/backgrounds/image_background.png"),
                        ),
                      ),
                      image.pose.isLibraryPose() ? Container(
                        height: 116.0,
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            borderRadius: new BorderRadius.circular(8.0),
                            gradient: LinearGradient(
                                begin: FractionalOffset.center,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ])),
                      ) : SizedBox(),
                      image.pose.isLibraryPose() ? GestureDetector(
                        onTap: () {
                          IntentLauncherUtil.launchURL(poses.elementAt(currentPageIndex).pose.instagramUrl);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          height: 48,
                          child: TextDandyLight(
                            type: TextDandyLight.SMALL_TEXT,
                            color: Color(ColorConstants.getPrimaryWhite()),
                            text: image.pose.instagramName,
                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                  image.pose.isLibraryPose() ? GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL(poses.elementAt(currentPageIndex).pose.instagramUrl);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      height: 48,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        color: Color(ColorConstants.getPeachLight()),
                        text: 'Follow on Instagram',
                      ),
                    ),
                  ) : SizedBox(),
                ],
              ),
            ),
          ),
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
                  onDelete(currentPageIndex);
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

  void _showSaveToJobBottomSheet(BuildContext context, selectedIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SaveToJobBottomSheet(selectedIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JobDetailsPageState>(
      converter: (store) => JobDetailsPageState.fromStore(store),
      builder: (BuildContext context, JobDetailsPageState pageState) =>
          Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(ColorConstants.getPeachLight())),
              backgroundColor: Colors.black,
              centerTitle: true,
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: groupName,
                color: Color(ColorConstants.getPeachLight()),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    _onDeleteSelected();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16.0),
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
            key: scaffoldKey,
            backgroundColor: Colors.black,
            body: Container(
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
    );
  }
}
