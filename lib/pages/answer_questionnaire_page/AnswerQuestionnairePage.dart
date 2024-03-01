import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:redux/redux.dart';

import '../../utils/InputDoneView.dart';
import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';
import 'AnswerQuestionnairePageState.dart';

class AnswerQuestionnairePage extends StatefulWidget {
  final Questionnaire questionnaire;
  const AnswerQuestionnairePage({Key key, this.questionnaire}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnswerQuestionnairePageState(questionnaire);
  }
}

class _AnswerQuestionnairePageState extends State<AnswerQuestionnairePage> with TickerProviderStateMixin {
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  bool isKeyboardVisible = false;
  OverlayEntry overlayEntry;
  final Questionnaire questionnaire;
  TextEditingController titleTextController = TextEditingController();
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  _AnswerQuestionnairePageState(this.questionnaire);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, AnswerQuestionnairePageState>(
        onInit: (store) {
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
          if(questionnaire != null) {
            titleTextController.text = questionnaire.title;
            messageController.text = questionnaire.message;
          }
        },
        onDidChange: (previous, current) {

        },
        converter: (Store<AppState> store) => AnswerQuestionnairePageState.fromStore(store),
        builder: (BuildContext context, AnswerQuestionnairePageState pageState) => Scaffold(
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
                  text: '1 out of 8',
                ),
              ),
              backgroundColor: Color(ColorConstants.getPrimaryGreyLight()),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    questionLayout(),
                    navigationButtons(),
                    statusLayout(),
                  ],
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

  Widget questionLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [

        ],
      ),
    );
  }

  Widget navigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {

            },
            child: Container(
              alignment: Alignment.center,
              height: 54,
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.only(left: 32, right: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(27), bottomRight: Radius.circular(27)),
                color: Color(ColorConstants.getBlueDark()),
                boxShadow: ElevationToShadow[4],
              ),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Back',
                textAlign: TextAlign.center,
                color: Color(ColorConstants.getPrimaryWhite()),
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {

            },
            child: Container(
              alignment: Alignment.center,
              height: 54,
              padding: const EdgeInsets.only(left: 32, right: 32),
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(27), bottomLeft: Radius.circular(27)),
                color: Color(ColorConstants.getBlueDark()),
                boxShadow: ElevationToShadow[4],
              ),
              child: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Next',
                textAlign: TextAlign.center,
                color: Color(ColorConstants.getPrimaryWhite()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget statusLayout() {
    return SizedBox();
  }
}
