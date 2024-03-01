import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:redux/redux.dart';

import '../../models/Question.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';
import 'AnswerQuestionnairePageState.dart';

class AnswerQuestionnairePage extends StatefulWidget {
  final Questionnaire questionnaire;
  final bool isPreview;
  const AnswerQuestionnairePage({Key key, this.questionnaire, this.isPreview}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnswerQuestionnairePageState(questionnaire, questionnaire.questions.length, isPreview);
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
  final bool isPreview;

  final int pageCount;
  int currentPageIndex;
  final PageController controller = PageController(initialPage: 0);
  final List<Container> pages = [];

  setCurrentPage(int page) {
    setState(() {
      currentPageIndex = page;
    });
  }


  @override
  void initState() {
    super.initState();
    for(Question question in questionnaire.questions) {
      pages.add(
          Container(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  question.showImage ? Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        child: CachedNetworkImage(
                          fadeOutDuration: Duration(milliseconds: 0),
                          fadeInDuration: Duration(milliseconds: 200),
                          imageUrl: question.mobileImageUrl,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => Container(
                              height: 116,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: new BorderRadius.circular(16),
                              )
                          ),
                        ),
                      ),
                      Container(
                        height: 264.0,
                        decoration: BoxDecoration(
                            color: Color(ColorConstants.getPrimaryWhite()),
                            gradient: LinearGradient(
                                begin: FractionalOffset.center,
                                end: FractionalOffset.topCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                stops: [
                                  0.2,
                                  1.0
                                ])),
                      ),
                    ],
                  ) : const SizedBox(),
                ],
              ),
            ),
          )
      );
    }
  }

  _AnswerQuestionnairePageState(this.questionnaire, this.pageCount, this.isPreview);

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
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                scrolledUnderElevation: 4,
                iconTheme: IconThemeData(
                  color: Color(ColorConstants.getPrimaryWhite()), //change your color here
                ),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0.0,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: '1 out of 8',
                  color: Color(ColorConstants.getPrimaryWhite()),
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
    return PageView.builder(
      controller: controller,
      onPageChanged: setCurrentPage,
      itemBuilder: (context, position) {
        if (position == pageCount) return null;
        return pages.elementAt(position);
      },
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
              height: 64,
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.only(left: 32, right: 32),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(27), bottomRight: Radius.circular(27)),
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
              height: 64,
              padding: const EdgeInsets.only(left: 32, right: 32),
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(27), bottomLeft: Radius.circular(27)),
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
}
