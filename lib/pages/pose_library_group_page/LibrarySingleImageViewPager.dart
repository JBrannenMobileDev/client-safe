import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/SaveToJobBottomSheet.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/SaveToMyPosesBottomSheet.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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

  LibrarySingleImageViewPager(this.poses, this.index, this.groupName);

  @override
  _LibrarySingleImageViewPagerState createState() {
    return _LibrarySingleImageViewPagerState(poses, index, poses.length, PageController(initialPage: index), groupName);
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

  _LibrarySingleImageViewPagerState(this.poses, this.currentPageIndex, this.pageCount, this.controller, this.groupName);

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
                        borderRadius: new BorderRadius.circular(16.0),
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
                            borderRadius: new BorderRadius.circular(16.0),
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
                          IntentLauncherUtil.launchURL(image.pose.instagramUrl);
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
                  image.pose.prompt.isNotEmpty ? Container(
                    margin: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                    width: double.infinity,
                    child:  TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      color: Color(ColorConstants.getPeachDark()),
                      textAlign: TextAlign.start,
                      text: 'PROMPT',
                    ),
                  ) : SizedBox(),
                  image.pose.prompt.isNotEmpty ? Container(
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    width: double.infinity,
                    child:  TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      color: Color(ColorConstants.getPeachDark()),
                      textAlign: TextAlign.start,
                      text: image.pose.prompt,
                    ),
                  ) : SizedBox(),
                  GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL(image.pose.instagramUrl);
                      EventSender().sendEvent(eventName: EventNames.BT_POSE_INSTAGRAM_PAGE);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                      height: 54,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(ColorConstants.getPeachDark()),
                        borderRadius: BorderRadius.circular(27),
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        color: Color(ColorConstants.getPrimaryWhite()),
                        text: 'Follow on Instagram',
                      ),
                    ),
                  ),
                  SizedBox(height: 128),
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(ColorConstants.getPeachDark())),
              centerTitle: true,
              elevation: 0.0,
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: groupName,
                color: Color(ColorConstants.getPeachDark()),
              ),
              backgroundColor: Colors.white,
              actions: [
                GestureDetector(
                  onTap: () {
                    IntentLauncherUtil.launchURL(poses.elementAt(currentPageIndex).pose.instagramUrl);
                    EventSender().sendEvent(eventName: EventNames.BT_POSE_INSTAGRAM_PAGE);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 16.0, left: 16),
                      child: Image.asset(
                        'assets/images/icons/instagram_icon.png',
                        color: Color(ColorConstants.getPeachDark()),
                        height: 26,
                        width: 26,
                      )
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showSaveToJobBottomSheet(context, currentPageIndex);
                  },
                  child: Container(
                      child: Image.asset(
                        'assets/images/icons/plus.png',
                        color: Color(ColorConstants.getPeachDark()),
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
                      color: Color(ColorConstants.getPeachDark()),
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
}
