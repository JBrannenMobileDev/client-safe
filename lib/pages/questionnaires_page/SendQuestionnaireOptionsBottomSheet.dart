import 'dart:async';

import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';
import '../../AppState.dart';
import '../../models/Profile.dart';
import '../../utils/DandyToastUtil.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/intentLauncher/IntentLauncherUtil.dart';
import '../../widgets/TextDandyLight.dart';
import '../share_with_client_page/ChooseShareMessageBottomSheet.dart';
import '../share_with_client_page/ShareWithClientTextField.dart';
import 'QuestionnairesPageState.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


class SendQuestionnaireOptionsBottomSheet extends StatefulWidget {
  final Questionnaire? questionnaire;

  const SendQuestionnaireOptionsBottomSheet(this.questionnaire, {Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _ShareClientPortalOptionsBottomSheetPageState(questionnaire);
  }
}

class _ShareClientPortalOptionsBottomSheetPageState extends State<SendQuestionnaireOptionsBottomSheet> with TickerProviderStateMixin, WidgetsBindingObserver {
  final Questionnaire? questionnaire;
  OverlayEntry? overlayEntry;
  bool isKeyboardVisible = false;
  final messageController = TextEditingController();
  final nameController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  late StreamSubscription<bool> keyboardSubscription;

  _ShareClientPortalOptionsBottomSheetPageState(this.questionnaire);

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

  void _setSelectedMessage(String message) {
    setState(() {
      messageController.value = messageController.value.copyWith(text: message);
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


  @override
  Widget build(BuildContext context) => StoreConnector<AppState, QuestionnairesPageState>(
    onInit: (store) {

    },
  converter: (Store<AppState> store) => QuestionnairesPageState.fromStore(store),
  builder: (BuildContext context, QuestionnairesPageState pageState) =>
  Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          color: Color(ColorConstants.getPrimaryWhite()),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 16, bottom: 32),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Send questionnaire',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 4, left: 48, right: 48),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'To:',
                  ),
                ),
                Container(
                  height: 48,
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  padding: const EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: BorderRadius.circular(24)
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: ShareWithClientTextField(
                          nameController,
                          'Name',
                          TextInputType.name,
                          264.0,
                          pageState.onShareMessageChanged,
                          'noError',
                          TextInputAction.next,
                          _nameFocusNode,
                          onAction,
                          TextCapitalization.words,
                          null,
                          true,
                          true,
                          true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 4, left: 48, right: 48),
                  child: TextDandyLight(
                    type: TextDandyLight.MEDIUM_TEXT,
                    text: 'SMS/Email message:',
                  ),
                ),
                Container(
                  height: 216,
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  padding: const EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      borderRadius: BorderRadius.circular(24)
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: ShareWithClientTextField(
                          messageController,
                          '',
                          TextInputType.multiline,
                          264.0,
                          pageState.onShareMessageChanged,
                          'noError',
                          TextInputAction.newline,
                          _messageFocusNode,
                          onAction,
                          TextCapitalization.sentences,
                          null,
                          true,
                          true,
                          true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                if(nameController.text.isNotEmpty) {
                  pageState.createNewJoblessQuestionnaire!(nameController.text, messageController.text, questionnaire!);
                  Navigator.of(context).pop();
                } else {
                  DandyToastUtil.showErrorToast('Please enter a name.');
                }
              },
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 32),
                child: Container(
                  height: 54,
                  width: 196,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: Color(ColorConstants.getPeachDark()),
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Save & Send',
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
  );

  void onAction(){
    _messageFocusNode.unfocus();
  }
}