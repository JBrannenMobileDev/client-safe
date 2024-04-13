import 'dart:io';

import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';


class AddLibraryPhotoBottomSheet extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BottomSheetPageState();
  }
}

class _BottomSheetPageState extends State<AddLibraryPhotoBottomSheet> with TickerProviderStateMixin {
  final NameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  final tagsController = TextEditingController();
  final FocusNode _tagsFocusNode = FocusNode();
  List<XFile> images = [];
  String name = "";
  String url = "";
  String tags = "";

  Future getDeviceImage(LibraryPoseGroupPageState pageState) async {
    try{
      images = await ImagePicker().pickMultiImage();
      setState((){});
    } catch(ex) {
      print(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, LibraryPoseGroupPageState>(
    onInit: (store) {
      if(store.state.libraryPoseGroupPageState!.instagramName!.isNotEmpty) {
        NameController.text = store.state.libraryPoseGroupPageState!.instagramName!;
        urlController.text = store.state.libraryPoseGroupPageState!.instagramUrl!;
      }
    },
    converter: (Store<AppState> store) => LibraryPoseGroupPageState.fromStore(store),
    builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
         Container(
               height: MediaQuery.of(context).size.height - 64,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 16.0, right: 16.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(top: 24, bottom: 0.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Upload New Pose',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.primary_black),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       if(images.length == 0) {
                         getDeviceImage(pageState);
                       }
                     },
                     child: Container(
                       margin: EdgeInsets.only(bottom: 32, top: 24),
                       alignment: Alignment.center,
                       height: 48,
                       width: 216,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(24),
                         color: Color(images.length == 0 ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryGreyMedium()),
                       ),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: images.length == 0 ? 'Select Images' : images.length.toString() + " images selected",
                         textAlign: TextAlign.center,
                         color: Color(images.length == 0 ? ColorConstants.getPrimaryWhite() : ColorConstants.getPrimaryBlack()),
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
                       radius: 12,
                     ),
                   ),
                   Container(
                     margin: EdgeInsets.only(left: 20.0, right: 20.0),
                     child: DandyLightLibraryTextField(
                       controller: urlController,
                       hintText: 'Instagram URL',
                       inputType: TextInputType.text,
                       focusNode: _urlFocusNode,
                       onFocusAction: onAction2,
                       height: 84.0,
                       onTextInputChanged: onUrlChanged,
                       keyboardAction: TextInputAction.next,
                       capitalization: TextCapitalization.words,
                       radius: 12,
                     ),
                   ),
                   Container(
                     margin: EdgeInsets.only(left: 20.0, right: 20.0),
                     child: DandyLightLibraryTextField(
                       controller: tagsController,
                       hintText: 'Tags',
                       inputType: TextInputType.text,
                       focusNode: _tagsFocusNode,
                       onFocusAction: onAction3,
                       height: 84.0,
                       onTextInputChanged: onUrlChanged,
                       keyboardAction: TextInputAction.done,
                       capitalization: TextCapitalization.words,
                       radius: 12,
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       if(images.length > 0 && NameController.text.isNotEmpty && urlController.text.isNotEmpty && tagsController.text.isNotEmpty) {
                         tagsController.text.replaceAll(' ', '');
                         List<String> tags = tagsController.text.split(",");
                         if(tags.length > 0) {
                           pageState.onNewPoseImagesSelected!(images, NameController.text, urlController.text, tags);
                           Navigator.of(context).pop();
                         } else {
                           DandyToastUtil.showToastWithGravity('Invalid Tags!', Color(ColorConstants.error_red), ToastGravity.CENTER);
                           VibrateUtil.vibrateMultiple();
                         }
                       }
                     },
                     child: Container(
                       margin: EdgeInsets.only(top: 32),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: 'Submit',
                         textAlign: TextAlign.center,
                         color: Color(ColorConstants.getPeachDark()),
                       ),
                     ),
                   ),
                 ],
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