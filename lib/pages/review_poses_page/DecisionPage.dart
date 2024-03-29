import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/review_poses_page/ReviewPosesPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/Pose.dart';
import '../../widgets/TextDandyLight.dart';
import '../pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import '../upload_pose_page/UploadPosePage.dart';

class DecisionPage extends StatefulWidget {
  final Pose pose;
  final int index;
  final Function setCurrentPage;

  DecisionPage(this.pose, this.index, this.setCurrentPage);

  @override
  _DecisionPageState createState() {
    return _DecisionPageState(pose, index, setCurrentPage);
  }
}

class _DecisionPageState extends State<DecisionPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Pose pose;

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

  final setCurrentPage;
  final int currentPageIndex;


  _DecisionPageState(this.pose, this.currentPageIndex, this.setCurrentPage);

  @override
  void initState() {
    super.initState();
    promptController.text = pose.prompt!;
    tagsController.text = pose.tags!.join(',');

    prompt = pose.prompt!;
    tags = tagsController.text;

    pose.categories!.forEach((category) {
      switch(category) {
        case UploadPosePage.FAMILIES:
          familiesSelected = true;
          break;
        case UploadPosePage.ENGAGEMENT:
          engagementsSelected = true;
          break;
        case UploadPosePage.COUPLES:
          couplesSelected = true;
          break;
        case UploadPosePage.PORTRAITS:
          portraitsSelected = true;
          break;
        case UploadPosePage.MATERNITY:
          maternitySelected = true;
          break;
        case UploadPosePage.WEDDINGS:
          weddingsSelected = true;
          break;
        case UploadPosePage.NEWBORN:
          newbornSelected = true;
          break;
        case UploadPosePage.PROPOSALS:
          proposalsSelected = true;
          break;
        case UploadPosePage.PETS:
          petsSelected = true;
          break;
      }
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
    return StoreConnector<AppState, ReviewPosesPageState>(
      converter: (store) => ReviewPosesPageState.fromStore(store),
      builder: (BuildContext context, ReviewPosesPageState pageState) =>
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:20, right: 20),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(16.0),
                          child: CachedNetworkImage(imageUrl: pose.imageUrl!, fit: BoxFit.contain,)
                        ),
                      ),
                      pose.reviewStatus == Pose.STATUS_REVIEWED ? Container(
                        height: 128,
                        alignment: Alignment.center,
                        child: Image.asset("assets/images/icons/rejected.png", color: Color(ColorConstants.getPrimaryWhite())),
                      ) : SizedBox(),
                      pose.reviewStatus == Pose.STATUS_FEATURED ? Container(
                        height: 128,
                        alignment: Alignment.center,
                        child: Icon(Icons.check,
                          color: Color(ColorConstants.getPrimaryWhite()),
                          size: 128,
                        ),
                      ) : SizedBox()
                    ],
                  ),
                  Container(
                    height: 54,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: pose.instagramName,
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
                      hintText: 'Add descriptive tags, separated with a comma. For example: couple, beach, romantic, sunset, windy',
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
                    margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0, bottom: 32.0),
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
                  SizedBox(height: 128,)
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      pageState.onRejectedSelected!(pose);
                      setCurrentPage(1 + currentPageIndex);
                      setState(() {
                        pose.reviewStatus = Pose.STATUS_REVIEWED;
                      });
                    },
                    child: Container(
                      height: 86,
                      margin: EdgeInsets.only(top: 0, left: 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(

                          color: Color(ColorConstants.getPeachDark())
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'REJECT',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      pageState.onApproveSelected!(pose, prompt, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected, maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected);
                      setCurrentPage(1 + currentPageIndex);
                      setState(() {
                        pose.reviewStatus = Pose.STATUS_FEATURED;
                      });
                    },
                    child: Container(
                      height: 86,
                      margin: EdgeInsets.only(top: 0, right: 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(

                          color: Color(ColorConstants.getBlueDark())
                      ),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'APPROVE',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
