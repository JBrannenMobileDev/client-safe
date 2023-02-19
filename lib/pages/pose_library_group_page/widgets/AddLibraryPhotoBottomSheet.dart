import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/pages/pose_library_group_page/LibraryPoseGroupPageState.dart';
import 'package:dandylight/pages/pose_library_group_page/widgets/DandyLightLibraryTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';

import '../../../AppState.dart';
import '../../../widgets/TextDandyLight.dart';
import '../../new_contact_pages/NewContactPageState.dart';


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
  List<XFile> images = [];
  String name = "";
  String url = "";

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
    converter: (Store<AppState> store) => LibraryPoseGroupPageState.fromStore(store),
    builder: (BuildContext context, LibraryPoseGroupPageState pageState) =>
         Container(
               height: 375,
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                   color: Color(ColorConstants.getPrimaryWhite())),
               padding: EdgeInsets.only(left: 16.0, right: 16.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(top: 24, bottom: 24.0),
                     child: TextDandyLight(
                       type: TextDandyLight.LARGE_TEXT,
                       text: 'Upload New Pose',
                       textAlign: TextAlign.center,
                       color: Color(ColorConstants.primary_black),
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       getDeviceImage(pageState);
                     },
                     child: Container(
                       margin: EdgeInsets.only(bottom: 16),
                       child: TextDandyLight(
                         type: TextDandyLight.LARGE_TEXT,
                         text: images.length == 0 ? 'Select Images' : images.length.toString() + " Selected",
                         textAlign: TextAlign.center,
                         color: Color(images.length == 0 ? ColorConstants.getPeachDark() : ColorConstants.getPrimaryGreyMedium()),
                       ),
                     ),
                   ),
                   Container(
                     margin: EdgeInsets.only(left: 20.0, right: 20.0),
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
                       height: 64.0,
                       onTextInputChanged: onUrlChanged,
                       keyboardAction: TextInputAction.next,
                       capitalization: TextCapitalization.words,
                     ),
                   ),
                   GestureDetector(
                     onTap: () {
                       if(images.length > 0 && NameController.text.isNotEmpty && urlController.text.isNotEmpty) {
                         pageState.onNewPoseImagesSelected(images, NameController.text, urlController.text);
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

  void onAction1(){
    _nameFocusNode.unfocus();
  }

  void onAction2(){
    _urlFocusNode.unfocus();
  }
}