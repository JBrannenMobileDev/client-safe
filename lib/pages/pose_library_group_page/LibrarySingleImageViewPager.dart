import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/SaveToJobBottomSheet.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/SaveToMyPosesBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/Job.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import '../pose_group_page/GroupImage.dart';
import 'LibraryPoseGroupPageState.dart';

class LibrarySingleImageViewPager extends StatefulWidget {
  final List<GroupImage> poses;
  final int index;
  final String groupName;
  final Job job;

  LibrarySingleImageViewPager(this.poses, this.index, this.groupName, this.job);

  @override
  _LibrarySingleImageViewPagerState createState() {
    return _LibrarySingleImageViewPagerState(poses, index, poses.length, PageController(initialPage: index), groupName, job);
  }
}

class _LibrarySingleImageViewPagerState extends State<LibrarySingleImageViewPager> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount;
  int currentPageIndex;
  final PageController controller;
  final List<GroupImage> poses;
  final List<Container> pages = [];
  final String groupName;
  final Job job;

  _LibrarySingleImageViewPagerState(this.poses, this.currentPageIndex, this.pageCount, this.controller, this.groupName, this.job);

  void _showSaveToMyPosesBottomSheet(BuildContext context, imageIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SaveToMyPosesBottomSheet(imageIndex);
      },
    );
  }

  void _showSaveToJobBottomSheet(BuildContext context, imageIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return SaveToJobBottomSheet(imageIndex);
      },
    );
  }

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
                      Container(
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
                      ),
                      GestureDetector(
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
                      ),
                    ],
                  ),
                  GestureDetector(
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
                  ),
                ],
              ),
            ),
        )
      );
    }
  }

  getCurrentPage(int page) {
    setState(() {
      currentPageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LibraryPoseGroupPageState>(
      converter: (store) => LibraryPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.black,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(ColorConstants.getPeachLight())),
              centerTitle: true,
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: groupName,
                color: Color(ColorConstants.getPeachLight()),
              ),
              backgroundColor: Colors.black,
              actions: [
                GestureDetector(
                  onTap: () {
                    if(job == null) {
                      _showSaveToJobBottomSheet(context, currentPageIndex);
                    } else {
                      pageState.onImageAddedToJobSelected(pageState.poseImages.elementAt(currentPageIndex).pose, job);
                      VibrateUtil.vibrateMedium();
                      DandyToastUtil.showToastWithGravity('Pose Added!', Color(ColorConstants.getPeachDark()), ToastGravity.BOTTOM);
                    }
                  },
                  child: Container(
                      child: Image.asset(
                        'assets/images/icons/plus.png',
                        color: Color(ColorConstants.getPeachLight()),
                        height: 24,
                        width: 24,
                      )
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showSaveToMyPosesBottomSheet(context, currentPageIndex);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16.0, left: 16),
                    height: 28.0,
                    width: 28.0,
                    child: Image.asset(
                      'assets/images/icons/ribbon.png',
                      color: Color(ColorConstants.getPeachLight()),
                    ),
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Container(
                    child: PageView.builder(
                      controller: controller,
                      onPageChanged: getCurrentPage,
                      itemBuilder: (context, position) {
                        if (position == pageCount) return null;
                        return pages.elementAt(position);
                      },
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
