import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Question.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:redux/redux.dart';

import '../../utils/DandyToastUtil.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/Shadows.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import '../common_widgets/TextFieldDandylight.dart';
import 'NewQuestionActions.dart';
import 'NewQuestionPageState.dart';

class NewQuestionPage extends StatefulWidget {
  final Question question;
  final int number;
  final Function(Question) onQuestionSaved;

  const NewQuestionPage({Key key, this.question, this.onQuestionSaved, this.number}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewQuestionPageState(question, onQuestionSaved, number);
  }
}

class _NewQuestionPageState extends State<NewQuestionPage> with TickerProviderStateMixin {
  final Function(Question) onQuestionSaved;
  final TextEditingController controllerTitle = TextEditingController();
  final bool hasUnsavedChanges = false;
  bool isKeyboardVisible = false;
  OverlayEntry overlayEntry;
  final Question question;
  final int number;
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  TextEditingController shortFormQuestionTextController = TextEditingController();
  final FocusNode shortFormQuestionFocusNode = FocusNode();

  List<Question> questions = [];

  void reorderData(int oldIndex, int newIndex){
    setState(() {
      if(newIndex > oldIndex){
        newIndex -= 1;
      }
      final items = questions.removeAt(oldIndex);
      questions.insert(newIndex, items);
    });
  }

  _NewQuestionPageState(this.question, this.onQuestionSaved, this.number);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewQuestionPageState>(
        onInit: (store) {
          store.dispatch(ClearNewQuestionState(store.state.newQuestionPageState));
          if(question != null) {
            store.dispatch(SetQuestionAction(store.state.newQuestionPageState, question));
          }

          KeyboardVisibilityNotification().addNewListener(
              onShow: () {
                showOverlay(context);
                setState(() {
                  isKeyboardVisible = true;
                });
              },
              onHide: () {
                removeOverlay();
                setState(() {
                  isKeyboardVisible = false;
                });
              }
          );
        },
        converter: (Store<AppState> store) => NewQuestionPageState.fromStore(store),
        builder: (BuildContext context, NewQuestionPageState pageState) => WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              if(hasUnsavedChanges) {
                await showDialog(
                    context: context,
                    builder: (_) => Device.get().isIos ?
                    CupertinoAlertDialog(
                      title: const Text('Exit without saving changes?'),
                      content: const Text('If you continue any changes made will not be saved.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                      ],
                    ) : AlertDialog(
                      title: const Text('Exit without saving changes?'),
                      content: const Text('If you continue any changes made will not be saved.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                      ],
                    ));
            } else {
                willLeave = true;
              };
              return willLeave;
            },
            child: Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 4,
                iconTheme: IconThemeData(
                  color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                ),
                backgroundColor: Color(ColorConstants.getPrimaryGreyLight()),
                centerTitle: true,
                elevation: 0.0,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: question != null ? 'Edit Question' : 'New Question',
                ),
              ),
              backgroundColor: Color(ColorConstants.getPrimaryGreyLight()),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          exampleQuestionView(pageState),
                          ShowImageSwitch(),
                          SelectedTypeView(),
                          SettingsView(),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          onQuestionSaved(pageState.question);
                          showSuccessAnimation();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 54,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Color(ColorConstants.getPeachDark()),
                            boxShadow: ElevationToShadow[4],
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'Add to questionnaire',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      );

  void onAction(){
    _messageFocusNode.unfocus();
  }

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(96.0),
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

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  Widget exampleQuestionView(NewQuestionPageState pageState) {
    return Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 24, right: 24, top: 180),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
            child: buildQuestion(pageState),
          ),
          GestureDetector(
          onTap: () {
            getDeviceImage(pageState);
          },
          child: pageState.webImage != null ? Container(
            margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
            height: 164,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
              ),
              child: Image(
                fit: BoxFit.cover,
                width: double.infinity,
                height: 164,
                image: FileImage(File(pageState.webImage.path)),
              ),
            ),
          ): pageState.question.webImageUrl != null ? Container(
            margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
            height: 164,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              child: DandyLightNetworkImage(
                pageState.question.webImageUrl,
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: 0,
              ),
            ),
          ) : Container(
            margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
            alignment: Alignment.center,
            height: 164,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryWhite()),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
              ),
            ),
          ),
          ),
              GestureDetector(
              onTap: () {
                getDeviceImage(pageState);
              },
              child: pageState.webImage == null && pageState.question.webImageUrl == null ? Container(
                  alignment: Alignment.center,
                  height: 164,
                  margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(ColorConstants.getBlueDark()),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        'assets/images/icons/file_upload.png',
                        color: Color(ColorConstants.getPrimaryWhite()),
                        width: 48,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        alignment: Alignment.center,
                        child: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          textAlign: TextAlign.center,
                          text: 'Upload Image',
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ],
                  ),
                ) : const SizedBox(),
              ),
          (pageState.webImage != null || pageState.question.webImageUrl != null && pageState.question.webImageUrl.isNotEmpty) ? Container(
            alignment: Alignment.topRight,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 32, right: 42),
            child: Image.asset(
              'assets/images/icons/select_photo.png',
              color: Color(ColorConstants.getPrimaryWhite()),
              width: 32,
            ),
          ) : const SizedBox(),
        ],
    );
  }

  Widget ShowImageSwitch() {
    return const SizedBox();
  }

  Widget SelectedTypeView() {
    return const SizedBox();
  }

  Widget SettingsView() {
    return const SizedBox();
  }

  Future getDeviceImage(NewQuestionPageState pageState) async {
    try {
      XFile localImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      XFile localWebImage = XFile((await CropImageForWeb(localImage.path)).path);
      XFile localMobileImage = XFile((await CropImageForMobile(localImage.path)).path);

      if(localWebImage != null && localMobileImage != null && localImage != null) {
        pageState.onWebImageUploaded(localWebImage);
        pageState.onMobileImageUploaded(localMobileImage);
      } else {
        DandyToastUtil.showErrorToast('Image not loaded');
      }
    } catch (ex) {
      print(ex.toString());
      DandyToastUtil.showErrorToast('Image not loaded');
    }
  }

  Future<CroppedFile> CropImageForWeb(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 1920,
      maxHeight: 664,
      aspectRatio: const CropAspectRatio(ratioX: 3.8, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop to fit desktop',
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop to fit desktop',
          aspectRatioPickerButtonHidden: true,
          doneButtonTitle: 'Next',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
  }

  Future<CroppedFile> CropImageForMobile(String path) async {
    return await ImageCropper().cropImage(
      sourcePath: path,
      maxWidth: 1080,
      maxHeight: 810,
      aspectRatio: const CropAspectRatio(ratioX: 1.33, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop to fit mobile',
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop to fit mobile',
          aspectRatioPickerButtonHidden: true,
          doneButtonTitle: 'Save',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
  }

  Widget buildQuestion(NewQuestionPageState pageState) {
    Widget result = const SizedBox();

    switch(pageState.question.type) {
      case Question.TYPE_SHORT_FORM_RESPONSE:
        result = Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '${number+1}.  ',
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 86,
                        child: TextFormField(
                          cursorColor: Color(ColorConstants.getBlueDark()),
                          focusNode: shortFormQuestionFocusNode,
                          textInputAction: TextInputAction.done,
                          maxLines: 3,
                          controller: shortFormQuestionTextController,
                          onChanged: (text) {
                            pageState.onQuestionChanged(text);
                          },
                          onFieldSubmitted: (term) {
                            shortFormQuestionFocusNode.unfocus();
                          },
                          decoration: InputDecoration.collapsed(
                            hintText: 'Your question here.',
                            fillColor: Color(ColorConstants.getPrimaryWhite()),
                            hintStyle: TextStyle(
                              fontFamily: TextDandyLight.getFontFamily(),
                              fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                              fontWeight: TextDandyLight.getFontWeight(),
                              color: Color(ColorConstants.getPrimaryGreyMedium()),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                              fontFamily: TextDandyLight.getFontFamily(),
                              fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                              fontWeight: TextDandyLight.getFontWeight(),
                              color: Color(ColorConstants.getPrimaryBlack())),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      )
                    ],
                  ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 38),
                alignment: Alignment.topLeft,
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Type your answer here...',
                  color: Color(ColorConstants.getBlueDark()),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 38, right: 32, bottom: 64),
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Color(ColorConstants.getBlueDark()),
              )
            ],
          ),
        );
        break;
    }

    return result;
  }
}
