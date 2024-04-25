import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Question.dart';
import 'package:dandylight/pages/new_question_page/AddCheckboxOptionBottomSheet.dart';
import 'package:dandylight/pages/new_questionnaire_page/NewQuestionListWidget.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../utils/InputDoneView.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/Shadows.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/DandyLightNetworkImage.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewQuestionActions.dart';
import 'NewQuestionPageState.dart';
import 'TypeSelectionBottomSheet.dart';

class NewQuestionPage extends StatefulWidget {
  final Question? question;
  final int? number;
  final Function(Question)? onQuestionSaved;

  const NewQuestionPage({Key? key, this.question, this.onQuestionSaved, this.number}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewQuestionPageState(question, onQuestionSaved, number);
  }
}

class _NewQuestionPageState extends State<NewQuestionPage> with TickerProviderStateMixin {
  final Function(Question)? onQuestionSaved;
  final TextEditingController controllerTitle = TextEditingController();
  final bool hasUnsavedChanges = false;
  bool isKeyboardVisible = false;
  OverlayEntry? overlayEntry;
  final Question? question;
  final int? number;
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  late StreamSubscription<bool> keyboardSubscription;

  TextEditingController questionTextController = TextEditingController();
  final FocusNode questionFocusNode = FocusNode();

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

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          showOverlay(context);
          isKeyboardVisible = true;
        } else {
          removeOverlay();
          isKeyboardVisible = false;
        }
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  _NewQuestionPageState(this.question, this.onQuestionSaved, this.number);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewQuestionPageState>(
        onInit: (store) {
          store.dispatch(ClearNewQuestionState(store.state.newQuestionPageState!));
          if(question != null) {
            store.dispatch(SetQuestionAction(store.state.newQuestionPageState!, question!));

            if(question!.question != null && question!.question!.isNotEmpty) {
              questionTextController.text = question!.question!;
            }
          }
        },
        converter: (Store<AppState> store) => NewQuestionPageState.fromStore(store),
        builder: (BuildContext context, NewQuestionPageState pageState) => WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              if(true) {
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
                surfaceTintColor: Color(ColorConstants.getPrimaryWhite()),
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
                          selectedTypeView(pageState),
                          showImageSwitch(pageState),
                          isRequiredSwitch(pageState),
                          pageState.question!.type == Question.TYPE_ADDRESS ? isAddressItemRequiredSwitch(pageState, 'Address required', pageState.onAddressRequiredChanged!, pageState.question!.addressRequired ?? false) : const SizedBox(),
                          pageState.question!.type == Question.TYPE_ADDRESS ? isAddressItemRequiredSwitch(pageState, 'City/Town required', pageState.onCityTownRequiredChanged!, pageState.question!.cityTownRequired ?? false) : const SizedBox(),
                          pageState.question!.type == Question.TYPE_ADDRESS ? isAddressItemRequiredSwitch(pageState, 'State/Region/Province required', pageState.onStateRegionProvinceRequiredChanged!, pageState.question!.stateRegionProvinceRequired ?? false) : const SizedBox(),
                          pageState.question!.type == Question.TYPE_ADDRESS ? isAddressItemRequiredSwitch(pageState, 'Zip/Post code required', pageState.onZipPostCodeRequiredChanged!, pageState.question!.zipPostCodeRequired ?? false) : const SizedBox(),
                          pageState.question!.type == Question.TYPE_ADDRESS ? isAddressItemRequiredSwitch(pageState, 'Country required', pageState.onCountryRequiredChanged!, pageState.question!.countryRequired ?? false) : const SizedBox(),
                          pageState.question!.type == Question.TYPE_CONTACT_INFO ? contactInfoSettings(pageState) : const SizedBox(),
                          pageState.question!.type == Question.TYPE_CHECK_BOXES ? multipleSelectionView(pageState) : const SizedBox(),
                          Container(
                            margin: const EdgeInsets.only(top: 32),

                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Question preview',
                            ),
                          ),
                          exampleQuestionView(pageState),
                          settingsView(),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          onQuestionSaved!(pageState.question!);
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
                            text: question == null ? 'Add to questionnaire' : 'Save changes',
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

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  Widget exampleQuestionView(NewQuestionPageState pageState) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: (pageState.question!.showImage! ? 240 : 16), bottom: 164),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(16),
                bottomLeft: const Radius.circular(16),
                topRight: Radius.circular(pageState.question!.showImage! ? 0 : 16),
                topLeft: Radius.circular(pageState.question!.showImage! ? 0 : 16),
              ),
              color: Color(ColorConstants.getPrimaryWhite()),
            ),
            child: buildQuestion(pageState),
          ),
          pageState.question!.showImage! ? GestureDetector(
            onTap: () {
              selectAPhoto(pageState);
            },
            child: pageState.question!.mobileImageUrl != null ? Container(
              margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
              height: 224,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
                child: DandyLightNetworkImage(
                  pageState.question!.mobileImageUrl!,
                  color: Color(ColorConstants.getPrimaryWhite()),
                  borderRadius: 0,
                ),
              ),
            ) : Container(
              margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
              alignment: Alignment.center,
              height: 224,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
            ),
          ) : const SizedBox(),
          pageState.question!.showImage! ? GestureDetector(
            onTap: () {
              selectAPhoto(pageState);
            },
            child: pageState.question!.mobileImageUrl == null ? Container(
              alignment: Alignment.center,
              height: 224,
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
          ) : const SizedBox(),
          pageState.question!.showImage! ? (pageState.webImage != null || pageState.question!.webImageUrl != null && pageState.question!.webImageUrl!.isNotEmpty) ?
          GestureDetector(
            onTap: () {
              selectAPhoto(pageState);
            },
            child: Container(
              alignment: Alignment.topRight,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 32, right: 42),
              child: Image.asset(
                'assets/images/icons/select_photo.png',
                color: Color(ColorConstants.getPrimaryWhite()),
                width: 32,
              ),
            ),
          ) : const SizedBox() : const SizedBox(),
        ],
      ),
    );
  }

  Widget showImageSwitch(NewQuestionPageState pageState) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 20, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: 'Show Image:',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          Device.get().isIos?
          CupertinoSwitch(
            trackColor: Color(ColorConstants.getPeachDark()),
            activeColor: Color(ColorConstants.getBlueDark()),
            thumbColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (showImage) async {
              pageState.onShowImageChanged!(showImage);
            },
            value: pageState.question!.showImage!,
          ) : Switch(
            activeTrackColor: Color(ColorConstants.getBlueDark()),
            inactiveTrackColor: Color(ColorConstants.getPeachDark()),
            inactiveThumbColor: Color(ColorConstants.getPrimaryWhite()),
            activeColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (showImage) async {
              pageState.onShowImageChanged!(showImage);
            },
            value: pageState.question!.showImage!,
          ),
        ],
      ),
    );
  }
  Widget isRequiredSwitch(NewQuestionPageState pageState) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 20, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: 'Is Required:',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          Device.get().isIos?
          CupertinoSwitch(
            trackColor: Color(ColorConstants.getPeachDark()),
            activeColor: Color(ColorConstants.getBlueDark()),
            thumbColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (required) async {
              pageState.isRequiredChanged!(required);
            },
            value: pageState.question!.isRequired!,
          ) : Switch(
            activeTrackColor: Color(ColorConstants.getBlueDark()),
            inactiveTrackColor: Color(ColorConstants.getPeachDark()),
            inactiveThumbColor: Color(ColorConstants.getPrimaryWhite()),
            activeColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (required) async {
              pageState.isRequiredChanged!(required);
            },
            value: pageState.question!.isRequired!,
          ),
        ],
      ),
    );
  }

  Widget isAddressItemRequiredSwitch(NewQuestionPageState pageState, String title, Function(bool) onRequiredChanged, bool isRequired) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 20, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: '$title:',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          Device.get().isIos?
          CupertinoSwitch(
            trackColor: Color(ColorConstants.getPeachDark()),
            activeColor: Color(ColorConstants.getBlueDark()),
            thumbColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (required) async {
              onRequiredChanged(required);
            },
            value: isRequired,
          ) : Switch(
            activeTrackColor: Color(ColorConstants.getBlueDark()),
            inactiveTrackColor: Color(ColorConstants.getPeachDark()),
            inactiveThumbColor: Color(ColorConstants.getPrimaryWhite()),
            activeColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (required) async {
              onRequiredChanged(required);
            },
            value: isRequired,
          ),
        ],
      ),
    );
  }

  void showTypeSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const TypeSelectionBottomSheet();
      },
    );
  }

  void showAddCheckboxChoiceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.5),
      builder: (context) {
        return const AddCheckboxOptionBottomSheet();
      },
    );
  }

  Widget selectedTypeView(NewQuestionPageState pageState) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: 'Type:',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          GestureDetector(
            onTap: () {
              showTypeSelectionBottomSheet(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Color(ColorConstants.getPrimaryWhite())
              ),
              child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 16, left: 8),
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(26), bottomLeft: Radius.circular(26)),
                      ),
                      child: NewQuestionListWidget.getIconFromType(pageState.question!.type!),
                    ),
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: pageState.question!.type,
                      color: Color(ColorConstants.getBlueDark()),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      width: 48,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(ColorConstants.getPrimaryGreyMedium()),
                        size: 32,
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsView() {
    return const SizedBox();
  }

  void selectAPhoto(NewQuestionPageState pageState) {
    NavigationUtil.onSelectAPhotoSelected(context, pageState.onUploadedImageSelected!);
  }

  Widget buildQuestion(NewQuestionPageState pageState) {
    Widget result = const SizedBox();

    switch(pageState.question!.type) {
      case Question.TYPE_ADDRESS:
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
                      text: '$number.  ',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 87,
                      child: TextFormField(
                        cursorColor: Color(ColorConstants.getBlueDark()),
                        focusNode: questionFocusNode,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        controller: questionTextController,
                        onChanged: (text) {
                          pageState.onQuestionChanged!(text);
                        },
                        onFieldSubmitted: (term) {
                          questionFocusNode.unfocus();
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
              addressItem('Address', '1234 Jefferson Way', pageState.question!.addressRequired ?? false),
              addressItem('Address line 2', 'apartment 42', false),
              addressItem('City/Town', 'Temecula', pageState.question!.cityTownRequired ?? false),
              addressItem('State/Region/Province', 'California', pageState.question!.stateRegionProvinceRequired ?? false),
              addressItem('ZIP/Post code', '92591', pageState.question!.zipPostCodeRequired ?? false),
              addressItem('Country', 'United States', pageState.question!.countryRequired ?? false),
            ],
          ),
        );
        break;
      case Question.TYPE_DATE:
        result = Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '$number.  ',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 97,
                      child: TextFormField(
                        cursorColor: Color(ColorConstants.getBlueDark()),
                        focusNode: questionFocusNode,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        controller: questionTextController,
                        onChanged: (text) {
                          pageState.onQuestionChanged!(text);
                        },
                        onFieldSubmitted: (term) {
                          questionFocusNode.unfocus();
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
                margin: const EdgeInsets.only(bottom: 72),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Month',
                          color: Color(ColorConstants.getBlueDark()),
                        ),
                        const SizedBox(height: 8),
                        TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: 'MM',
                          color: Color(ColorConstants.getBlueLight()),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 1,
                          width: 64,
                          color: Color(ColorConstants.getBlueLight()),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 26, left: 8, right: 8),
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                        text: '/',
                        color: Color(ColorConstants.getBlueDark()),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Day',
                          color: Color(ColorConstants.getBlueDark()),
                        ),
                        const SizedBox(height: 8),
                        TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: 'DD',
                          color: Color(ColorConstants.getBlueLight()),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 1,
                          width: 64,
                          color: Color(ColorConstants.getBlueLight()),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 26, left: 8, right: 8),
                      child: TextDandyLight(
                        type: TextDandyLight.EXTRA_LARGE_TEXT,
                        text: '/',
                        color: Color(ColorConstants.getBlueDark()),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Year',
                          color: Color(ColorConstants.getBlueDark()),
                        ),
                        const SizedBox(height: 8),
                        TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: 'YYYY',
                          color: Color(ColorConstants.getBlueLight()),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 1,
                          width: 64,
                          color: Color(ColorConstants.getBlueLight()),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case Question.TYPE_RATING:
        result = Container(
          margin: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 8, bottom: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: '$number.  ',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 87,
                      child: TextFormField(
                        cursorColor: Color(ColorConstants.getBlueDark()),
                        focusNode: questionFocusNode,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        controller: questionTextController,
                        onChanged: (text) {
                          pageState.onQuestionChanged!(text);
                        },
                        onFieldSubmitted: (term) {
                          questionFocusNode.unfocus();
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
                margin: const EdgeInsets.only(bottom: 72),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: [
                          Icon(Icons.star_border, color: Color(ColorConstants.getBlueDark()), size: 48),
                          TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: '1',
                            color: Color(ColorConstants.getBlueDark()),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: [
                          Icon(Icons.star_border, color: Color(ColorConstants.getBlueDark()), size: 48),
                          TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: '2',
                            color: Color(ColorConstants.getBlueDark()),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: [
                          Icon(Icons.star_border, color: Color(ColorConstants.getBlueDark()), size: 48),
                          TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: '3',
                            color: Color(ColorConstants.getBlueDark()),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: [
                          Icon(Icons.star_border, color: Color(ColorConstants.getBlueDark()), size: 48),
                          TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: '4',
                            color: Color(ColorConstants.getBlueDark()),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      child: Column(
                        children: [
                          Icon(Icons.star_border, color: Color(ColorConstants.getBlueDark()), size: 48),
                          TextDandyLight(
                            type: TextDandyLight.MEDIUM_TEXT,
                            text: '5',
                            color: Color(ColorConstants.getBlueDark()),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      case Question.TYPE_NUMBER:
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
                      text: '$number.  ',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 87,
                      child: TextFormField(
                        cursorColor: Color(ColorConstants.getBlueDark()),
                        focusNode: questionFocusNode,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        controller: questionTextController,
                        onChanged: (text) {
                          pageState.onQuestionChanged!(text);
                        },
                        onFieldSubmitted: (term) {
                          questionFocusNode.unfocus();
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
                margin: const EdgeInsets.only(bottom: 32),
                alignment: Alignment.center,
                height: 54,
                width: 224,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      width: 2,
                      color: Color(ColorConstants.getBlueDark())
                  ),
                ),
                child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Enter a number here',
                    color: Color(ColorConstants.getBlueLight())
                ),
              )
            ],
          ),
        );
        break;
      case Question.TYPE_YES_NO:
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
                      text: '$number.  ',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 87,
                      child: TextFormField(
                        cursorColor: Color(ColorConstants.getBlueDark()),
                        focusNode: questionFocusNode,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        controller: questionTextController,
                        onChanged: (text) {
                          pageState.onQuestionChanged!(text);
                        },
                        onFieldSubmitted: (term) {
                          questionFocusNode.unfocus();
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
                margin: const EdgeInsets.only(bottom: 16),
                alignment: Alignment.center,
                height: 54,
                width: 224,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 2,
                    color: Color(ColorConstants.getBlueDark())
                  ),
                  color: Color(ColorConstants.getBlueDark())
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Image.asset('assets/images/icons/checkbox.png', color: Color(ColorConstants.getBlueLight()), height: 26, width: 26),
                    const SizedBox(width: 16),
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Yes',
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                    const SizedBox(width: 100),
                    Icon(Icons.check, color: Color(ColorConstants.getPrimaryWhite()),)
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                alignment: Alignment.center,
                height: 54,
                width: 224,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      width: 2,
                      color: Color(ColorConstants.getBlueDark())
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Image.asset('assets/images/icons/checkbox.png', color: Color(ColorConstants.getBlueLight()), height: 26, width: 26),
                    const SizedBox(width: 16),
                    TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'No',
                      color: Color(ColorConstants.getBlueDark()),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
        break;
      case Question.TYPE_CHECK_BOXES:
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
                      text: '$number.  ',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 96,
                      child: TextFormField(
                        cursorColor: Color(ColorConstants.getBlueDark()),
                        focusNode: questionFocusNode,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        controller: questionTextController,
                        onChanged: (text) {
                          pageState.onQuestionChanged!(text);
                        },
                        onFieldSubmitted: (term) {
                          questionFocusNode.unfocus();
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
              buildCheckboxOptions(pageState),
              GestureDetector(
                onTap: () {
                  showAddCheckboxChoiceBottomSheet(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  alignment: Alignment.center,
                  height: 48,
                  width: 164,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Color(ColorConstants.getBlueDark())
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Add choice',
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              )
            ],
          ),
        );
        break;
      case Question.TYPE_CONTACT_INFO:
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
                      text: '$number.  ',
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 87,
                      child: TextFormField(
                        cursorColor: Color(ColorConstants.getBlueDark()),
                        focusNode: questionFocusNode,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        controller: questionTextController,
                        onChanged: (text) {
                          pageState.onQuestionChanged!(text);
                        },
                        onFieldSubmitted: (term) {
                          questionFocusNode.unfocus();
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
              pageState.question!.includeFirstName ?? false ? contactItem('First name', 'Jane') : const SizedBox(),
              pageState.question!.includeLastName ?? false ? contactItem('Last name', 'Smith') : const SizedBox(),
              pageState.question!.includePhone ?? false ? contactItem('Phone number', '(888)-888-8888') : const SizedBox(),
              pageState.question!.includeEmail ?? false ? contactItem('Email', 'name@example.com') : const SizedBox(),
              pageState.question!.includeInstagramName ?? false ? contactItem('Instagram name', 'yourInstagramNameHere') : const SizedBox(),
            ],
          ),
        );
        break;
      case Question.TYPE_SHORT_FORM_RESPONSE:
      case Question.TYPE_LONG_FORM_RESPONSE:
        result = Container(
          height: 432,
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
                          text: '$number.  ',
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 87,
                        child: TextFormField(
                          cursorColor: Color(ColorConstants.getBlueDark()),
                          focusNode: questionFocusNode,
                          textInputAction: TextInputAction.done,
                          maxLines: 3,
                          controller: questionTextController,
                          onChanged: (text) {
                            pageState.onQuestionChanged!(text);
                          },
                          onFieldSubmitted: (term) {
                            questionFocusNode.unfocus();
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

  Widget contactInfoSettings(NewQuestionPageState pageState) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'First name',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  GestureDetector(
                    onTap: () {
                      pageState.onIncludeFirstNameChanged!(!(pageState.question!.includeFirstName ?? false));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: Icon(pageState.question!.includeFirstName ?? true ? Icons.visibility : Icons.visibility_off, color: Color(ColorConstants.getPrimaryBlack())),
                    ),
                  ),
                ]
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Last name',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  GestureDetector(
                    onTap: () {
                      pageState.onIncludeLastNameChanged!(!(pageState.question!.includeLastName ?? false));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: Icon(pageState.question!.includeLastName ?? true ? Icons.visibility : Icons.visibility_off, color: Color(ColorConstants.getPrimaryBlack())),
                    ),
                  ),
                ]
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Phone number',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  GestureDetector(
                    onTap: () {
                      pageState.onIncludePhoneChanged!(!(pageState.question!.includePhone ?? false));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: Icon(pageState.question!.includePhone ?? true ? Icons.visibility : Icons.visibility_off, color: Color(ColorConstants.getPrimaryBlack())),
                    ),
                  ),
                ]
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'Email',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  GestureDetector(
                    onTap: () {
                      pageState.onIncludeEmailChanged!(!(pageState.question!.includeEmail ?? false));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: Icon(pageState.question!.includeEmail ?? true ? Icons.visibility : Icons.visibility_off, color: Color(ColorConstants.getPrimaryBlack())),
                    ),
                  ),
                ]
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'InstagramName',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  GestureDetector(
                    onTap: () {
                      pageState.onIncludeInstagramNameChanged!(!(pageState.question!.includeInstagramName ?? false));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 24),
                      child: Icon(pageState.question!.includeInstagramName ?? true ? Icons.visibility : Icons.visibility_off, color: Color(ColorConstants.getPrimaryBlack())),
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }

  Widget contactItem(String title, String hint) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 38, bottom: 8),
          alignment: Alignment.topLeft,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: title,
            color: Color(ColorConstants.getBlueDark()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 38, bottom: 8),
          alignment: Alignment.topLeft,
          child: TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: hint,
            color: Color(ColorConstants.getBlueLight()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 38, right: 32, bottom: 64),
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(ColorConstants.getBlueDark()),
        ),
      ],
    );
  }

  Widget addressItem(String title, String hint, bool required) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 38, bottom: 8),
          alignment: Alignment.topLeft,
          child: TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: title + (required ? ' *' : ''),
            color: Color(ColorConstants.getBlueDark()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 38, bottom: 8),
          alignment: Alignment.topLeft,
          child: TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: hint,
            color: Color(ColorConstants.getBlueLight()),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 38, right: 32, bottom: 64),
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(ColorConstants.getBlueDark()),
        ),
      ],
    );
  }

  Widget buildCheckboxOptions(NewQuestionPageState pageState) {
    Widget result = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pageState.question!.choicesCheckBoxes?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return pageState.question!.choicesCheckBoxes != null && pageState.question!.choicesCheckBoxes!.isNotEmpty ? ListTile(
          horizontalTitleGap: 4,
          dense: true,
          title: Text(pageState.question!.choicesCheckBoxes![index]),
          leading: Image.asset('assets/images/icons/checkbox.png', color: Color(ColorConstants.getPeachDark()), height: 26, width: 26),
          trailing: GestureDetector(
            onTap: () {
              pageState.onCheckBoxChoiceRemoved!(pageState.question!.choicesCheckBoxes![index]);
            },
            child: Icon(Icons.delete, color: Color(ColorConstants.getPrimaryGreyMedium()), size: 26),
          )
        ) : const SizedBox();
      },
    );
    return result;
  }

  Widget multipleSelectionView(NewQuestionPageState pageState) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 20, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: 'Multiple selection:',
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
          Device.get().isIos?
          CupertinoSwitch(
            trackColor: Color(ColorConstants.getPeachDark()),
            activeColor: Color(ColorConstants.getBlueDark()),
            thumbColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (required) async {
              pageState.onMultipleSelectionChanged!(required);
            },
            value: pageState.question!.multipleSelection ?? false,
          ) : Switch(
            activeTrackColor: Color(ColorConstants.getBlueDark()),
            inactiveTrackColor: Color(ColorConstants.getPeachDark()),
            inactiveThumbColor: Color(ColorConstants.getPrimaryWhite()),
            activeColor: Color(ColorConstants.getPrimaryWhite()),
            onChanged: (required) async {
              pageState.onMultipleSelectionChanged!(required);
            },
            value: pageState.question!.multipleSelection!,
          ),
        ],
      ),
    );
  }
}
