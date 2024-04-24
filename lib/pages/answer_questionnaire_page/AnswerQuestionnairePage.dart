import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../models/Profile.dart';
import '../../models/Question.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';
import 'AnswerQuestionnaireActions.dart';
import 'AnswerQuestionnairePageState.dart';

class AnswerQuestionnairePage extends StatefulWidget {
  final Questionnaire questionnaire;
  final Profile profile;
  final bool isPreview;
  final bool isWebsite;
  const AnswerQuestionnairePage({Key? key,required this.questionnaire,required this.isPreview,required this.isWebsite, required this.profile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnswerQuestionnairePageState(questionnaire, questionnaire.questions!.length, isPreview, isWebsite, profile);
  }
}

class _AnswerQuestionnairePageState extends State<AnswerQuestionnairePage> with TickerProviderStateMixin {
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  bool isKeyboardVisible = false;
  OverlayEntry? overlayEntry;
  final Questionnaire questionnaire;
  final Profile profile;
  TextEditingController titleTextController = TextEditingController();
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final bool isPreview;
  final bool isWebsite;
  AnswerQuestionnairePageState? pageStateGlobal;

  final int pageCount;
  int currentPageIndex = 0;
  final PageController controller = PageController(initialPage: 0);
  late StreamSubscription<bool> keyboardSubscription;

  setCurrentPage(int page) {
    setState(() {
      currentPageIndex = page;
      Question question = pageStateGlobal!.questionnaire != null ? pageStateGlobal!.questionnaire!.questions!.elementAt(currentPageIndex) : questionnaire.questions!.elementAt(currentPageIndex);
      switch(question.type) {
        case Question.TYPE_SHORT_FORM_RESPONSE:
          if(question.isAnswered()) {
            print(question.shortAnswer);
            shortFormTextController.text = question.shortAnswer ?? '';
          }
          break;
        default: {
          shortFormTextController.text = '';
        }
      }
    });
  }

  _AnswerQuestionnairePageState(this.questionnaire, this.pageCount, this.isPreview, this.isWebsite, this.profile);

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          isKeyboardVisible = true;
        } else {
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
  Widget build(BuildContext context) =>
      StoreConnector<AppState, AnswerQuestionnairePageState>(
        onInit: (store) {
          titleTextController.text = questionnaire.title ?? '';
          messageController.text = questionnaire.message ?? '';
          store.dispatch(FetchProfileForAnswerAction(store.state.answerQuestionnairePageState!, questionnaire));
        },
        onDidChange: (previous, current) {
          setState(() {
            pageStateGlobal = current;
          });
        },
        converter: (Store<AppState> store) => AnswerQuestionnairePageState.fromStore(store),
        builder: (BuildContext context, AnswerQuestionnairePageState pageState) => Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                scrolledUnderElevation: 4,
                iconTheme: IconThemeData(
                  color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: questionnaire.title,
                ),
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon:const Icon(Icons.close),
                  //replace with our own icon data.
                )
              ),
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              body: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    questionLayout(pageState.questionnaire ?? questionnaire, pageState.profile ?? profile, pageState.onShortFormAnswerChanged!),
                    isKeyboardVisible ? const SizedBox() : navigationButtons(pageState.profile ?? profile, pageState.questionnaire ?? questionnaire),
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

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  Widget questionLayout(Questionnaire localQuestionnaire, Profile profile, Function(String, Question) onShortFormAnswerChanged) {
    return PageView.builder(
      controller: controller,
      itemCount: localQuestionnaire.questions?.length,
      onPageChanged: setCurrentPage,
      itemBuilder: (BuildContext context, int index){
        Question question = localQuestionnaire.questions!.elementAt(index);
        return Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                localQuestionnaire.questions!.elementAt(index).mobileImageUrl != null && localQuestionnaire.questions!.elementAt(index).webImageUrl != null && (localQuestionnaire.questions!.elementAt(index).showImage ?? false) ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ClipRRect(
                      child: CachedNetworkImage(
                        fadeOutDuration: const Duration(milliseconds: 0),
                        fadeInDuration: const Duration(milliseconds: 200),
                        imageUrl: localQuestionnaire.questions!.elementAt(index).mobileImageUrl ?? '',
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => Container(
                            height: 116,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
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
                              stops: const [
                                0.2,
                                1.0
                              ])),
                    ),
                  ],
                ) : const SizedBox(height: 264),
                getAnswerWidget(index+1, question, profile, onShortFormAnswerChanged)
              ],
            ),
          ),
        );
      }
    );
  }

  Widget navigationButtons(Profile localProfile, Questionnaire localQuestionnaire) {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: ElevationToShadow[4]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if(currentPageIndex > 0) {
                    currentPageIndex = currentPageIndex - 1;
                  }
                });
                controller.animateToPage(currentPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.ease);
              },
              child: Container(
                alignment: Alignment.center,
                height: 64,
                padding: const EdgeInsets.only(left: 32, right: 32),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                ),
                child: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Back',
                  textAlign: TextAlign.center,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  height: 64,
                  decoration: BoxDecoration(
                    color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!).withOpacity(0.5),
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    textAlign: TextAlign.center,
                    text: '(${(currentPageIndex + 1).toString()} of $pageCount)',
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if(isNextEnabled(localQuestionnaire.questions!.elementAt(currentPageIndex))) {
                  setState(() {
                    if(currentPageIndex < pageCount-1) {
                      currentPageIndex = currentPageIndex + 1;
                      shortFormTextController.text = '';
                    }
                  });
                  controller.animateToPage(currentPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.ease);
                } else {
                  DandyToastUtil.showToast('This question is required *', ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!));
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 64,
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                    color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                  ),
                  child: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: currentPageIndex == pageCount-1 ? 'Submit' : 'Next',
                    textAlign: TextAlign.center,
                    color: Color(ColorConstants.getPrimaryWhite()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool isNextEnabled(Question question) {
    bool isEnabled = false;
    if(isPreview) {
      isEnabled = !question.isRequired! || question.isRequired! && shortFormTextController.text.isNotEmpty;
    } else {
      isEnabled = !question.isRequired! || question.isRequired! && question.isAnswered();
    }
    return isEnabled;
  }

  Widget getAnswerWidget(int questionNumber, Question question, Profile profile, Function(String, Question) onShortFormAnswerChanged) {
    Widget result = const SizedBox();
    switch(question.type) {
      case Question.TYPE_SHORT_FORM_RESPONSE:
        result = buildShortFormResponseAnswerWidget(questionNumber, question, profile, onShortFormAnswerChanged);
        break;
    }
    return result;
  }

  Widget buildQuestionWidget(int questionNumber, Question question) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 32, top: 24, right: 32),
      child: TextDandyLight(
        type: TextDandyLight.LARGE_TEXT,
        text: '$questionNumber. ${question.question} ${question.isRequired! ? '*' : ''}',
      ),
    );
  }

  TextEditingController shortFormTextController = TextEditingController();
  final FocusNode shortFormFocusNode = FocusNode();
  Widget buildShortFormResponseAnswerWidget(int questionNumber, Question question, Profile localProfile, Function(String, Question) onShortFormAnswerChanged) {
    return isWebsite ? Container(

    ) : Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildQuestionWidget(questionNumber, question),
          Container(
            margin: const EdgeInsets.only(left: 32, right: 32, top: 32),
            child: TextFormField(
              cursorColor: Color(ColorConstants.getBlueDark()),
              focusNode: shortFormFocusNode,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              controller: shortFormTextController,
              onChanged: (text) {
                onShortFormAnswerChanged(text, question);
              },
              onFieldSubmitted: (term) {
                shortFormFocusNode.unfocus();
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Type your answer here...',
                fillColor: Color(ColorConstants.getPrimaryWhite()),
                hintStyle: TextStyle(
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.LARGE_TEXT),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!).withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.LARGE_TEXT),
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!)),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 32, right: 32, top: 8),
            color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
          )
        ],
      ),
    );
  }
}
