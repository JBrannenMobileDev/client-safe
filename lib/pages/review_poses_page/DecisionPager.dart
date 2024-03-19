import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/poses_page/PosesPageState.dart';
import 'package:dandylight/pages/poses_page/widgets/SaveToJobBottomSheet.dart';
import 'package:dandylight/pages/poses_page/widgets/SaveToMyPosesBottomSheet.dart';
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
import '../../models/Pose.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import '../pose_group_page/GroupImage.dart';
import '../pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import '../upload_pose_page/UploadPosePage.dart';
import 'DecisionPage.dart';

class DecisionPager extends StatefulWidget {
  final List<Pose> poses;
  final int index;

  DecisionPager(this.poses, this.index);

  @override
  _DecisionPagerState createState() {
    return _DecisionPagerState(poses, index, poses.length, PageController(initialPage: index));
  }
}

class _DecisionPagerState extends State<DecisionPager> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final int pageCount;
  int currentPageIndex;
  final PageController controller;
  final List<Pose> poses;
  final List<Widget> pages = [];
  Pose? pose;

  final tagsController = TextEditingController();
  final FocusNode _tagsFocusNode = FocusNode();
  final promptController = TextEditingController();
  final FocusNode _promptFocusNode = FocusNode();
  String name = "";
  String tags = "";
  String prompt = "";
  bool engagementsSelected = false;
  bool familiesSelected = false;
  bool couplesSelected = false;
  bool portraitsSelected = false;
  bool maternitySelected = false;
  bool weddingsSelected = false;
  bool newbornSelected = false;
  bool proposalsSelected = false;
  bool petsSelected = false;


  _DecisionPagerState(this.poses, this.currentPageIndex, this.pageCount, this.controller);

  @override
  void initState() {
    super.initState();

    for(int index = 0; index < poses.length; index++) {
      pages.add(DecisionPage(poses.elementAt(index), index, setCurrentPage));
    }
  }

  void setCurrentPage(int index) {
    controller.animateToPage(index, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  getCurrentPage(int page) {
    setState(() {
      currentPageIndex = page;
      pose = poses.elementAt(currentPageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.getPrimaryWhite()),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(ColorConstants.getPeachDark())),
              centerTitle: true,
              elevation: 0.0,
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: (currentPageIndex + 1).toString() + ' out of ' + pageCount.toString(),
                color: Color(ColorConstants.getPeachDark()),
              ),
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              actions: [

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
