import 'dart:io';

import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import 'UploadPoseActions.dart';
import 'UploadPosePageState.dart';


class UploadPosePage extends StatefulWidget {
  static const String ENGAGEMENT = "Engagement";
  static const String FAMILIES = "Families";
  static const String COUPLES = "Couples";
  static const String PORTRAITS = "Portraits";
  static const String MATERNITY = "Maternity";
  static const String WEDDINGS = "Weddings";
  static const String NEWBORN = "Newborn";
  static const String PROPOSALS = "Proposals";
  static const String PETS = "Pets";

  @override
  State<StatefulWidget> createState() {
    return _UploadPosePageState();
  }
}

class _UploadPosePageState extends State<UploadPosePage> with TickerProviderStateMixin {
  final NameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final tagsController = TextEditingController();
  final FocusNode _tagsFocusNode = FocusNode();
  final promptController = TextEditingController();
  final FocusNode _promptFocusNode = FocusNode();
  XFile image;
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

  Future getDeviceImage(UploadPosePageState pageState) async {
    try{
      image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState((){});
    } catch(ex) {
      print(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, UploadPosePageState>(
    onInit: (store) {
      store.dispatch(SetInstagramNameAction(store.state.uploadPosePageState, ''));
      NameController.text = '@';
    },
    onDidChange: (previous, current){
      if((previous.instagramName == '@') && (current.instagramName.isNotEmpty && current.instagramName != '@')) {
        NameController.text = current.instagramName;
      }
    },
    converter: (Store<AppState> store) => UploadPosePageState.fromStore(store),
    builder: (BuildContext context, UploadPosePageState pageState) =>
         Scaffold(
           appBar: AppBar(
             iconTheme: IconThemeData(
               color: Color(ColorConstants.getPrimaryBlack())
             ),
             title: TextDandyLight(
               type: TextDandyLight.LARGE_TEXT,
               text: 'Submit Pose',
               textAlign: TextAlign.center,
               color: Color(ColorConstants.primary_black),
             ),
             backgroundColor: Color(ColorConstants.getPrimaryWhite()),
             elevation: 0,
           ),
           backgroundColor: Color(ColorConstants.getPrimaryWhite()),
           body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  image == null ? GestureDetector(
                    onTap: () {
                      getDeviceImage(pageState);
                    },
                    child: Container(
                        height: 96,
                        width: 96,
                        margin: EdgeInsets.only(top: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          color: Color(ColorConstants.getPeachDark()),
                          boxShadow: ElevationToShadow[4],
                        ),
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/icons/add_photo.png',
                          color: Color(ColorConstants.getPrimaryWhite()),
                          width: 64,
                        )
                    ),
                  ) : Padding(
                    padding: EdgeInsets.only(left:20, right: 20),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(16.0),
                      child: Image(
                        fit: BoxFit.contain,
                        image: image != null ? FileImage(File(image.path))
                            : AssetImage("assets/images/backgrounds/image_background.png"),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getDeviceImage(pageState);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 16, bottom: 32, left: 32, right: 32),
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Select a photo',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
                    child: DandyLightLibraryTextField(
                      labelText: 'Instagram Name',
                      controller: NameController,
                      hintText: 'Instagram Name',
                      inputType: TextInputType.text,
                      focusNode: _nameFocusNode,
                      onFocusAction: onAction1,
                      height: 54.0,
                      onTextInputChanged: onNameChanged,
                      keyboardAction: TextInputAction.next,
                      capitalization: TextCapitalization.words,
                      radius: 16,
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
                      onFocusAction: onAction2,
                      height: 84.0,
                      onTextInputChanged: onTagsChanged,
                      keyboardAction: TextInputAction.done,
                      capitalization: TextCapitalization.words,
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
                      onFocusAction: onAction3,
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
                      if(image != null) {
                        if(NameController.text.isNotEmpty) {
                          if(isAtLeastOneCategorySelected()) {
                            if(tagsController.text.isNotEmpty) {
                              tagsController.text.replaceAll(' ', '');
                              List<String> tags = tagsController.text.split(",");
                              if(tags.length > 0) {
                                pageState.onPoseSubmitted(image, NameController.text, tags, engagementsSelected, familiesSelected, couplesSelected, portraitsSelected
                                   , maternitySelected, newbornSelected, proposalsSelected, petsSelected, weddingsSelected);
                                showSuccessAnimation();
                              } else {
                                DandyToastUtil.showToastWithGravity('At least 3 tags are required', Color(ColorConstants.error_red), ToastGravity.CENTER);
                                VibrateUtil.vibrateMultiple();
                              }
                            }else {
                              DandyToastUtil.showToastWithGravity('At least 3 tags are required', Color(ColorConstants.error_red), ToastGravity.CENTER);
                              VibrateUtil.vibrateMultiple();
                            }
                          } else {
                            DandyToastUtil.showToastWithGravity('Select at least 1 category', Color(ColorConstants.error_red), ToastGravity.CENTER);
                            VibrateUtil.vibrateMultiple();
                          }
                        } else {
                          DandyToastUtil.showToastWithGravity('Instagram name is required', Color(ColorConstants.error_red), ToastGravity.CENTER);
                          VibrateUtil.vibrateMultiple();
                        }
                      } else {
                        DandyToastUtil.showToastWithGravity('Please select an image', Color(ColorConstants.error_red), ToastGravity.CENTER);
                        VibrateUtil.vibrateMultiple();
                      }
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
                        text: 'Submit Pose',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ),
                  SizedBox(height: 128,)
                ],
              ),
           ),
         ),
    );

  void onNameChanged(String enteredName) {
    setState(() {
      name = enteredName;
    });
  }

  void onTagsChanged(String enteredTags) {
    setState(() {
      tags = enteredTags;
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
    _nameFocusNode.unfocus();
  }

  void onAction2(){
    _promptFocusNode.unfocus();
  }

  void onAction3(){
    _tagsFocusNode.unfocus();
  }

  bool isAtLeastOneCategorySelected() {
    return engagementsSelected || familiesSelected || couplesSelected || portraitsSelected
        || maternitySelected || newbornSelected || proposalsSelected || petsSelected || weddingsSelected;
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