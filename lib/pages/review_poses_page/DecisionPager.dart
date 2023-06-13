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
import '../../utils/IntentLauncherUtil.dart';
import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import '../../widgets/TextDandyLight.dart';
import '../pose_group_page/GroupImage.dart';
import '../pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import '../upload_pose_page/UploadPosePage.dart';

class DecisionPager extends StatefulWidget {
  final List<GroupImage> poses;
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
  final List<GroupImage> poses;
  final List<Container> pages = [];
  GroupImage poseGroup;

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
    poseGroup = poses.elementAt(currentPageIndex);
    promptController.text = poseGroup.pose.prompt;
    tagsController.text = poseGroup.pose.tags.join(',');
    for(GroupImage image in poses) {
      pages.add(
          Container(
            margin: EdgeInsets.only(top: 16),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left:20, right: 20),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(16.0),
                      child: Image(
                        fit: BoxFit.contain,
                        image: image != null ? FileImage(File(image.file.path))
                            : AssetImage("assets/images/backgrounds/image_background.png"),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: poseGroup.pose.instagramName,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: DandyLightLibraryTextField(
                      labelText: 'Prompt',
                      controller: promptController,
                      hintText: 'Add prompt',
                      inputType: TextInputType.text,
                      focusNode: _promptFocusNode,
                      onFocusAction: onAction1,
                      height: 84.0,
                      onTextInputChanged: onPromptChanged,
                      keyboardAction: TextInputAction.next,
                      capitalization: TextCapitalization.sentences,
                      radius: 16,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: DandyLightLibraryTextField(
                      labelText: 'Tags',
                      controller: tagsController,
                      hintText: 'Add descriptive tags, separated with a comma.\nFor example: couple, beach, romantic, sunset, windy',
                      inputType: TextInputType.text,
                      focusNode: _tagsFocusNode,
                      onFocusAction: onAction2,
                      height: 84.0,
                      onTextInputChanged: onTagsChanged,
                      keyboardAction: TextInputAction.done,
                      capitalization: TextCapitalization.words,
                      radius: 16,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 32),
                    alignment: Alignment.center,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Select categories',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Engagements',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: engagementsSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.ENGAGEMENT, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Families',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: familiesSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.FAMILIES, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Couples',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: couplesSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.COUPLES, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Portraits',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: portraitsSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.PORTRAITS, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Maternity',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: maternitySelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.MATERNITY, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Weddings',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: weddingsSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.WEDDINGS, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Newborn',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: newbornSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.NEWBORN, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Proposals',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: proposalsSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.PROPOSALS, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 0.0),
                    alignment: Alignment.center,
                    height: 44.0,
                    child: CheckboxListTile(
                      title: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Pets',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      value: petsSelected,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        onCategorySelected(UploadPosePage.PETS, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 72, bottom: 16, left: 32, right: 32),
                    child: TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      text: 'By submitting a pose you are entering it for an opportunity to be featured in the public DandyLight pose library and on the DandyLight Instagram page.',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 0, left: 24, right: 24),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          color: Color(ColorConstants.getPeachDark())
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'YES',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                  SizedBox(height: 128,)
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
      poseGroup = poses.elementAt(currentPageIndex);
    });
  }

  void onTagsChanged(String enteredTags) {
    setState(() {
      tags = enteredTags;
    });
  }

  void onPromptChanged(String enteredPrompt) {
    setState(() {
      prompt = enteredPrompt;
    });
  }

  void onCategorySelected(String category, isSelected) {
    setState(() {
      switch(category) {
        case UploadPosePage.ENGAGEMENT:
          engagementsSelected = isSelected;
          break;
        case UploadPosePage.FAMILIES:
          familiesSelected = isSelected;
          break;
        case UploadPosePage.COUPLES:
          couplesSelected = isSelected;
          break;
        case UploadPosePage.PORTRAITS:
          portraitsSelected = isSelected;
          break;
        case UploadPosePage.MATERNITY:
          maternitySelected = isSelected;
          break;
        case UploadPosePage.NEWBORN:
          newbornSelected = isSelected;
          break;
        case UploadPosePage.PROPOSALS:
          proposalsSelected = isSelected;
          break;
        case UploadPosePage.PETS:
          petsSelected = isSelected;
          break;
        case UploadPosePage.WEDDINGS:
          weddingsSelected = isSelected;
          break;
      }
    });
  }

  void onAction1(){
    _promptFocusNode.unfocus();
  }

  void onAction2(){
    _tagsFocusNode.unfocus();
  }

  bool isAtLeastOneCategorySelected() {
    return engagementsSelected || familiesSelected || couplesSelected || portraitsSelected
        || maternitySelected || newbornSelected || proposalsSelected || petsSelected || weddingsSelected;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PosesPageState>(
      converter: (store) => PosesPageState.fromStore(store),
      builder: (BuildContext context, PosesPageState pageState) =>
          Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Color(ColorConstants.getPeachDark())),
              centerTitle: true,
              elevation: 0.0,
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: (currentPageIndex + 1).toString() + ' out of ' + pageCount.toString(),
                color: Color(ColorConstants.getPeachDark()),
              ),
              backgroundColor: Colors.white,
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
