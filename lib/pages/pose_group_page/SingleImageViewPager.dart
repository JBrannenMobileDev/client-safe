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
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/Job.dart';
import '../../models/Pose.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/IntentLauncherUtil.dart';
import '../../utils/VibrateUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import 'GroupImage.dart';

class SingleImageViewPager extends StatefulWidget {
  final List<Pose> poses;
  final int index;
  final Function(Pose) onDelete;
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
  final List<Pose> poses;
  final Function(Pose) onDelete;
  final List<Container> pages = [];
  final String groupName;

  _SingleImageViewPagerState(this.poses, this.currentPageIndex, this.onDelete, this.pageCount, this.controller, this.groupName);

  @override
  void initState() {
    super.initState();
    for(Pose pose in poses) {
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
                          imageUrl: pose.imageUrl,
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
                      pose.isLibraryPose() ? Container(
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
                      pose.isLibraryPose() ? GestureDetector(
                        onTap: () {
                          IntentLauncherUtil.launchURL(pose.instagramUrl);
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          height: 48,
                          child: TextDandyLight(
                            type: TextDandyLight.SMALL_TEXT,
                            color: Color(ColorConstants.getPrimaryWhite()),
                            text: pose.instagramName,
                          ),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                  pose.prompt.isNotEmpty ? Container(
                    margin: EdgeInsets.only(top: 16, left: 16, bottom: 8),
                    width: double.infinity,
                    child:  TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      color: Color(ColorConstants.getPeachDark()),
                      textAlign: TextAlign.start,
                      text: 'PROMPT',
                    ),
                  ) : SizedBox(),
                  pose.prompt.isNotEmpty ? Container(
                    margin: EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    width: double.infinity,
                    child:  TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      color: Color(ColorConstants.getPeachDark()),
                      textAlign: TextAlign.start,
                      text: pose.prompt,
                    ),
                  ) : SizedBox(),
                  // GestureDetector(
                  //   onTap: () {
                  //     IntentLauncherUtil.launchURL(poses.elementAt(currentPageIndex).pose.instagramUrl);
                  //     EventSender().sendEvent(eventName: EventNames.BT_POSE_MORE_FROM_PHOTOG_PAGE);
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  //     height: 54,
                  //     width: double.infinity,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       color: Color(ColorConstants.getPeachDark()),
                  //       borderRadius: BorderRadius.circular(27),
                  //     ),
                  //     child: TextDandyLight(
                  //       type: TextDandyLight.MEDIUM_TEXT,
                  //       color: Color(ColorConstants.getPrimaryWhite()),
                  //       text: 'More from this photographer',
                  //     ),
                  //   ),
                  // ),
                  pose.isLibraryPose() ? GestureDetector(
                    onTap: () {
                      IntentLauncherUtil.launchURL(pose.instagramUrl);
                      EventSender().sendEvent(eventName: EventNames.BT_POSE_INSTAGRAM_PAGE);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                      height: 54,
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
                  ) : SizedBox(),
                  SizedBox(height: 128),
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
    return StoreConnector<AppState, PoseGroupPageState>(
      converter: (store) => PoseGroupPageState.fromStore(store),
      builder: (BuildContext context, PoseGroupPageState pageState) =>
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(ColorConstants.getPeachDark())),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0.0,
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: groupName,
                color: Color(ColorConstants.getPeachDark()),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    _showSaveToJobBottomSheet(context, currentPageIndex);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16.0),
                    height: 28.0,
                    width: 28.0,
                    child: Image.asset(
                      'assets/images/icons/plus.png',
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                  ),
                ),
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
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                  ),
                ),
              ],
            ),
            key: scaffoldKey,
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
