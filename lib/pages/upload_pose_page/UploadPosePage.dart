import 'dart:io';

import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/Shadows.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import 'UploadPosePageState.dart';


class UploadPosePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _UploadPosePageState();
  }
}

class _UploadPosePageState extends State<UploadPosePage> with TickerProviderStateMixin {
  final NameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  final tagsController = TextEditingController();
  final FocusNode _tagsFocusNode = FocusNode();
  XFile image;
  String name = "";
  String url = "";
  String tags = "";

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
      if(store.state.libraryPoseGroupPageState.instagramName.isNotEmpty) {
        NameController.text = store.state.libraryPoseGroupPageState.instagramName;
        urlController.text = store.state.libraryPoseGroupPageState.instagramUrl;
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
                  ) : ClipRRect(
                    borderRadius: new BorderRadius.circular(16.0),
                    child: Image(
                      fit: BoxFit.contain,
                      image: image != null ? FileImage(File(image.path))
                          : AssetImage("assets/images/backgrounds/image_background.png"),
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
                        text: 'Select a photo to get featured in the app',
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 0),
                    child: DandyLightLibraryTextField(
                      controller: NameController,
                      hintText: 'Instagram Name',
                      inputType: TextInputType.text,
                      focusNode: _nameFocusNode,
                      onFocusAction: onAction1,
                      height: 64.0,
                      onTextInputChanged: onNameChanged,
                      keyboardAction: TextInputAction.next,
                      capitalization: TextCapitalization.words,
                      radius: 16,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: DandyLightLibraryTextField(
                      controller: tagsController,
                      hintText: 'Add descriptive tags, separated with a comma.\nFor example: couple, beach, sunset, windy',
                      inputType: TextInputType.text,
                      focusNode: _tagsFocusNode,
                      onFocusAction: onAction3,
                      height: 84.0,
                      onTextInputChanged: onUrlChanged,
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
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
                      value: false,
                      activeColor: Color(ColorConstants.getPeachDark()),
                      onChanged: (selected) {
                        // pageState.onFeatureSelected(OnBoardingPageState.JOB_TRACKING, selected);
                      },
                      controlAffinity: ListTileControlAffinity.trailing,  //  <-- leading Checkbox
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(image != null && NameController.text.isNotEmpty && urlController.text.isNotEmpty && tagsController.text.isNotEmpty) {
                        tagsController.text.replaceAll(' ', '');
                        List<String> tags = tagsController.text.split(",");
                        if(tags.length > 0) {
                          pageState.onNewPoseImagesSelected(image, NameController.text, urlController.text, tags);
                          Navigator.of(context).pop();
                        } else {
                          DandyToastUtil.showToastWithGravity('Invalid Tags!', Color(ColorConstants.error_red), ToastGravity.CENTER);
                          VibrateUtil.vibrateMultiple();
                        }
                      }
                    },
                    child: Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 54, left: 24, right: 24),
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

  void onUrlChanged(String enteredUrl) {
    setState(() {
      url = enteredUrl;
    });
  }

  void onTagsChanged(String enteredTags) {
    setState(() {
      tags = enteredTags;
    });
  }

  void onAction1(){
    _nameFocusNode.unfocus();
  }

  void onAction2(){
    _urlFocusNode.unfocus();
  }

  void onAction3(){
    _urlFocusNode.unfocus();
  }
}