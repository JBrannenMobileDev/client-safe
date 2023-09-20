import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
import '../../models/Pose.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import '../pose_group_page/GroupImage.dart';
import 'JobDetailsPageState.dart';

class JobDetailsSingleImageViewPager extends StatefulWidget {
  final List<Pose> poses;
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
  final List<Pose> poses;
  final Function(int) onDelete;
  final List<Container> pages = [];
  final String groupName;

  _JobDetailsSingleImageViewPagerState(this.poses, this.currentPageIndex, this.onDelete, this.pageCount, this.controller, this.groupName);

  @override
  void initState() {
    super.initState();
    for(Pose image in poses) {
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
                        borderRadius: new BorderRadius.circular(16.0),
                        child: CachedNetworkImage(
                          fadeOutDuration: Duration(milliseconds: 0),
                          fadeInDuration: Duration(milliseconds: 200),
                          imageUrl: image.imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Container(
                              height: 116,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: new BorderRadius.circular(16),
                              )
                          ),
                        ),
                      ),
                      image.isLibraryPose() ? Container(
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
                      image.isLibraryPose() ? GestureDetector(
                        onTap: () {
                          IntentLauncherUtil.launchURL(poses.elementAt(currentPageIndex).instagramUrl);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          height: 48,
                          child: TextDandyLight(
                            type: TextDandyLight.SMALL_TEXT,
                            color: Color(ColorConstants.getPrimaryWhite()),
                            text: image.instagramName,
                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                  image.isLibraryPose() ? GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL(poses.elementAt(currentPageIndex).instagramUrl);
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
