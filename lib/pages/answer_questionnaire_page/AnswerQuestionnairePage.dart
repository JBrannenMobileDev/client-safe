import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../models/Profile.dart';
import '../../models/Question.dart';
import '../../utils/DeviceType.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/PlatformInfo.dart';
import '../../utils/Shadows.dart';
import '../../widgets/TextDandyLight.dart';
import 'AnswerQuestionnaireActions.dart';
import 'AnswerQuestionnairePageState.dart';

class AnswerQuestionnairePage extends StatefulWidget {
  final Questionnaire? questionnaire;
  final Profile? profile;
  final bool isPreview;
  final bool isWebsite;
  final String? userId;
  final String? jobId;
  final String? questionnaireId;
  final Function? updateQuestionnaireForPortal;
  const AnswerQuestionnairePage({Key? key,required this.questionnaire,required this.isPreview, required this.profile, this.userId, this.jobId, required this.isWebsite, this.questionnaireId, this.updateQuestionnaireForPortal}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AnswerQuestionnairePageState(questionnaire, questionnaire?.questions?.length ?? 0, isPreview, profile, userId, jobId, isWebsite, questionnaireId, updateQuestionnaireForPortal);
  }
}

class _AnswerQuestionnairePageState extends State<AnswerQuestionnairePage> with TickerProviderStateMixin {
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  bool isKeyboardVisible = false;
  OverlayEntry? overlayEntry;
  final Questionnaire? initialQuestionnaire;
  final Profile? initialProfile;
  TextEditingController titleTextController = TextEditingController();
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final bool isPreview;
  final bool isWebsite;
  final String? userId;
  final String? jobId;
  final String? questionnaireId;
  AnswerQuestionnairePageState? pageStateGlobal;
  bool submitted = false;
  final Function? updateQuestionnaireForPortal;

  int pageCount;
  int currentPageIndex = 0;
  final PageController controller = PageController(initialPage: 0);
  late StreamSubscription<bool> keyboardSubscription;

  setCurrentPage(int page) {
    setState(() {
      currentPageIndex = page;
      Question? question = pageStateGlobal!.questionnaire?.questions?.elementAt(currentPageIndex);
      if(question != null) {
        switch(question.type) {
          case Question.TYPE_SHORT_FORM_RESPONSE:
            if(shouldShowAnswers(question.isAnswered(), pageStateGlobal!.questionnaire)) {
              shortFormTextController.text = question.shortAnswer ?? '';
            } else {
              shortFormTextController.text = '';
            }
            break;
          case Question.TYPE_LONG_FORM_RESPONSE:
            if(shouldShowAnswers(question.isAnswered(), pageStateGlobal!.questionnaire)) {
              longFormTextController.text = question.longAnswer ?? '';
            } else {
              longFormTextController.text = '';
            }
            break;
          case Question.TYPE_CONTACT_INFO:
            if(shouldShowAnswers(question.isAnswered(), pageStateGlobal!.questionnaire)) {
              firstNameTextController.text = question.firstName ?? '';
              lastNameTextController.text = question.lastName ?? '';
              phoneNumberTextController.text = question.phone ?? '';
              emailTextController.text = question.email ?? '';
              instagramNameTextController.text = question.instagramName ?? '';
            } else {
              firstNameTextController.text = '';
              lastNameTextController.text = '';
              phoneNumberTextController.text = '';
              emailTextController.text = '';
              instagramNameTextController.text = '';
            }
            break;
          case Question.TYPE_NUMBER:
            if(shouldShowAnswers(question.isAnswered(), pageStateGlobal!.questionnaire)) {
              numberTextController.text = question.number?.toString() ?? '';
            } else {
              numberTextController.text = '';
            }
            break;
          case Question.TYPE_ADDRESS:
            if(shouldShowAnswers(question.isAnswered(), pageStateGlobal!.questionnaire)) {
              addressTextController.text = question.address ?? '';
              addressLine2TextController.text = question.addressLine2 ?? '';
              cityTownTextController.text = question.cityTown ?? '';
              stateRegionTextController.text = question.stateRegionProvince ?? '';
              zipTextController.text = question.zipPostCode ?? '';
              countryTextController.text = question.country ?? '';
            } else {
              addressTextController.text = '';
              addressLine2TextController.text = '';
              cityTownTextController.text = '';
              stateRegionTextController.text = '';
              zipTextController.text = '';
              countryTextController.text = '';
            }
            break;
          case Question.TYPE_DATE:
            if(shouldShowAnswers(question.isAnswered(), pageStateGlobal!.questionnaire)) {
              monthTextController.text = question.month.toString();
              dayTextController.text = question.day.toString();
              yearTextController.text = question.year.toString();
            } else {
              monthTextController.text = '';
              dayTextController.text = '';
              yearTextController.text = '';
            }
            break;
        }
      }
    });
  }

  _AnswerQuestionnairePageState(this.initialQuestionnaire, this.pageCount, this.isPreview, this.initialProfile, this.userId, this.jobId, this.isWebsite, this.questionnaireId, this.updateQuestionnaireForPortal);

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          isKeyboardVisible = true;
          showOverlay(context);
        } else {
          isKeyboardVisible = false;
          removeOverlay();
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
          titleTextController.text = initialQuestionnaire?.title ?? '';
          messageController.text = initialQuestionnaire?.message ?? '';
          Question? local = initialQuestionnaire?.questions?.elementAt(0);
          if(local != null) {
            switch(local.type) {
              case Question.TYPE_SHORT_FORM_RESPONSE:
                if(shouldShowAnswers(local.isAnswered(), initialQuestionnaire)) {
                  shortFormTextController.text = local.shortAnswer ?? '';
                } else {
                  shortFormTextController.text = '';
                }
                break;
              case Question.TYPE_LONG_FORM_RESPONSE:
                if(shouldShowAnswers(local.isAnswered(), initialQuestionnaire)) {
                  longFormTextController.text = local.longAnswer ?? '';
                } else {
                  longFormTextController.text = '';
                }
                break;
              case Question.TYPE_CONTACT_INFO:
                if(shouldShowAnswers(local.isAnswered(), initialQuestionnaire)) {
                  firstNameTextController.text = local.firstName ?? '';
                  lastNameTextController.text = local.lastName ?? '';
                  phoneNumberTextController.text = local.phone ?? '';
                  emailTextController.text = local.email ?? '';
                  instagramNameTextController.text = local.instagramName ?? '';
                } else {
                  firstNameTextController.text = '';
                  lastNameTextController.text = '';
                  phoneNumberTextController.text = '';
                  emailTextController.text = '';
                  instagramNameTextController.text = '';
                }
                break;
              case Question.TYPE_NUMBER:
                if(shouldShowAnswers(local.isAnswered(), initialQuestionnaire)) {
                  numberTextController.text = local.number?.toString() ?? '';
                } else {
                  numberTextController.text = '';
                }
                break;
              case Question.TYPE_ADDRESS:
                if(shouldShowAnswers(local.isAnswered(), initialQuestionnaire)) {
                  addressTextController.text = local.address ?? '';
                  addressLine2TextController.text = local.addressLine2 ?? '';
                  cityTownTextController.text = local.cityTown ?? '';
                  stateRegionTextController.text = local.stateRegionProvince ?? '';
                  zipTextController.text = local.zipPostCode ?? '';
                  countryTextController.text = local.country ?? '';
                } else {
                  addressTextController.text = '';
                  addressLine2TextController.text = '';
                  cityTownTextController.text = '';
                  stateRegionTextController.text = '';
                  zipTextController.text = '';
                  countryTextController.text = '';
                }
                break;
              case Question.TYPE_DATE:
                if(shouldShowAnswers(local.isAnswered(), initialQuestionnaire)) {
                  monthTextController.text = local.month.toString();
                  dayTextController.text = local.day.toString();
                  yearTextController.text = local.year.toString();
                } else {
                  monthTextController.text = '';
                  dayTextController.text = '';
                  yearTextController.text = '';
                }
                break;
            }
          }
          store.dispatch(FetchProfileForAnswerAction(store.state.answerQuestionnairePageState!, initialQuestionnaire, isPreview, userId, jobId, initialProfile, questionnaireId));
          },
        onDidChange: (previous, current) {
          setState(() {
            pageStateGlobal = current;
          });
          if(initialQuestionnaire == null && current.questionnaire != null && previous?.questionnaire == null) {
            setState(() {
              pageCount = current.questionnaire?.questions?.length ?? 0;
            });
            titleTextController.text = current.questionnaire?.title ?? '';
            messageController.text = current.questionnaire?.message ?? '';
            Question? local = current.questionnaire?.questions?.elementAt(0);
            if(local != null) {
              switch(local.type) {
                case Question.TYPE_SHORT_FORM_RESPONSE:
                  if(shouldShowAnswers(local.isAnswered(), current.questionnaire)) {
                    shortFormTextController.text = local.shortAnswer ?? '';
                  } else {
                    shortFormTextController.text = '';
                  }
                  break;
                case Question.TYPE_LONG_FORM_RESPONSE:
                  if(shouldShowAnswers(local.isAnswered(), current.questionnaire)) {
                    longFormTextController.text = local.longAnswer ?? '';
                  } else {
                    longFormTextController.text = '';
                  }
                  break;
                case Question.TYPE_CONTACT_INFO:
                  if(shouldShowAnswers(local.isAnswered(), current.questionnaire)) {
                    firstNameTextController.text = local.firstName ?? '';
                    lastNameTextController.text = local.lastName ?? '';
                    phoneNumberTextController.text = local.phone ?? '';
                    emailTextController.text = local.email ?? '';
                    instagramNameTextController.text = local.instagramName ?? '';
                  } else {
                    firstNameTextController.text = '';
                    lastNameTextController.text = '';
                    phoneNumberTextController.text = '';
                    emailTextController.text = '';
                    instagramNameTextController.text = '';
                  }
                  break;
                case Question.TYPE_NUMBER:
                  if(shouldShowAnswers(local.isAnswered(), current.questionnaire)) {
                    numberTextController.text = local.number?.toString() ?? '';
                  } else {
                    numberTextController.text = '';
                  }
                  break;
                case Question.TYPE_ADDRESS:
                  if(shouldShowAnswers(local.isAnswered(), current.questionnaire)) {
                    addressTextController.text = local.address ?? '';
                    addressLine2TextController.text = local.addressLine2 ?? '';
                    cityTownTextController.text = local.cityTown ?? '';
                    stateRegionTextController.text = local.stateRegionProvince ?? '';
                    zipTextController.text = local.zipPostCode ?? '';
                    countryTextController.text = local.country ?? '';
                  } else {
                    addressTextController.text = '';
                    addressLine2TextController.text = '';
                    cityTownTextController.text = '';
                    stateRegionTextController.text = '';
                    zipTextController.text = '';
                    countryTextController.text = '';
                  }
                  break;
                case Question.TYPE_DATE:
                  if(shouldShowAnswers(local.isAnswered(), current.questionnaire)) {
                    monthTextController.text = local.month.toString();
                    dayTextController.text = local.day.toString();
                    yearTextController.text = local.year.toString();
                  } else {
                    monthTextController.text = '';
                    dayTextController.text = '';
                    yearTextController.text = '';
                  }
                  break;
              }
            }
          }
        },
        converter: (Store<AppState> store) => AnswerQuestionnairePageState.fromStore(store),
        builder: (BuildContext context, AnswerQuestionnairePageState pageState) => Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                scrolledUnderElevation: 4,
                iconTheme: IconThemeData(
                  color: (pageState.questionnaire?.questions?.elementAt(currentPageIndex).hasImage() ?? false) && !(DeviceType.getDeviceTypeByContext(context) == Type.Website) ? Color(ColorConstants.getPrimaryWhite()) : Color(ColorConstants.getPrimaryBlack()), //change your color here
                ),
                backgroundColor: (pageState.questionnaire?.questions?.elementAt(currentPageIndex).hasImage() ?? false) && !(DeviceType.getDeviceTypeByContext(context) == Type.Website) ? Colors.transparent : Color(ColorConstants.getPrimaryWhite()),
                elevation: 0.0,
                title: TextDandyLight(
                  type: DeviceType.getDeviceTypeByContext(context) == Type.Website ? TextDandyLight.EXTRA_LARGE_TEXT : TextDandyLight.LARGE_TEXT,
                  text: submitted ? '' : pageState.questionnaire?.title,
                  color: (pageState.questionnaire?.questions?.elementAt(currentPageIndex).hasImage() ?? false) && !(DeviceType.getDeviceTypeByContext(context) == Type.Website) ? Color(ColorConstants.getPrimaryWhite()) : Color(ColorConstants.getPrimaryBlack()),
                ),
                leading: !(pageState.isDirectSend ?? false) ? IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon:const Icon(Icons.close),
                  //replace with our own icon data.
                ) : const SizedBox(),
              ),
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              body: submitted ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: TextDandyLight(
                  textAlign: TextAlign.center,
                  type: TextDandyLight.EXTRA_LARGE_TEXT,
                  text: 'Submitted!\nThank you ${pageState.questionnaire?.clientName ?? ''}',
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ) : pageState.questionnaire != null && pageState.profile != null ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    questionLayout(pageState.questionnaire, pageState.profile, pageState),
                    isKeyboardVisible ? const SizedBox() : navigationButtons(pageState.profile, pageState.questionnaire),
                  ],
                ),
              ) : Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 56.0,
                  width: 56.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Color(ColorConstants.getPeachDark()),
                    size: 32,
                  ),
                ),
              ),
            ),
      );

  void onAction(){
    _messageFocusNode.unfocus();
  }
  // /questionnaire/ICUeVNh1gAcElqBowOL24lPC1Sm1+a7ee9c00-99e3-1faf-b2ac-41d011e80686
  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(DeviceType.getDeviceTypeByContext(context) == Type.Website ? 216.0 : 96),
          child: FlareActor(
            PlatformInfo().isWeb() ? "animations/success_check.flr" : "assets/animations/success_check.flr",
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
    if(updateQuestionnaireForPortal != null ) updateQuestionnaireForPortal!();
    setState(() {
      submitted = true;
    });
    Navigator.of(context).pop();
    if(!(pageStateGlobal?.isDirectSend ?? false)) {
      Navigator.of(context).pop();
    }
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

  Widget questionLayout(
      Questionnaire? localQuestionnaire,
      Profile? profile,
      AnswerQuestionnairePageState pageState,
  ) {
    return PageView.builder(
      controller: controller,
      itemCount: pageCount,
      onPageChanged: setCurrentPage,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index){
        Question? question = localQuestionnaire?.questions?.elementAt(index);
        return Container(
          margin: DeviceType.getDeviceTypeByContext(context) == Type.Website ? EdgeInsets.only(top: 96, left: 132, right: 132) : EdgeInsets.only(top: 0),
          alignment: Alignment.topCenter,
          child: DeviceType.getDeviceTypeByContext(context) != Type.Website ? SingleChildScrollView(
            child: Column(
              children: [
                localQuestionnaire?.questions!.elementAt(index).mobileImageUrl != null && (localQuestionnaire?.questions?.elementAt(index).showImage ?? false) ? Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ClipRRect(
                      child: CachedNetworkImage(
                        fadeOutDuration: const Duration(milliseconds: 0),
                        fadeInDuration: const Duration(milliseconds: 200),
                        imageUrl: localQuestionnaire?.questions?.elementAt(index).mobileImageUrl ?? '',
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
                ) : const SizedBox(height: 96),
                getAnswerWidget(index+1, question, profile, pageState)
              ],
            ),
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              localQuestionnaire?.questions?.elementAt(index).mobileImageUrl != null && (localQuestionnaire?.questions?.elementAt(index).showImage ?? false) ? Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16)
                    ),
                    width: MediaQuery.of(context).size.width/2 - 132,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16), // Image border
                      child: Image.network(
                        localQuestionnaire?.questions?.elementAt(index).mobileImageUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ) : const SizedBox(height: 96),
              getAnswerWidget(index+1, question, profile, pageState)
            ],
          ),
        );
      }
    );
  }

  Widget navigationButtons(Profile? localProfile, Questionnaire? localQuestionnaire) {
    return Container(
      width: getPageWidth(context),
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
                  color: ColorConstants.hexToColor(localProfile?.selectedColorTheme?.buttonColor),
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
                    color: ColorConstants.hexToColor(localProfile?.selectedColorTheme?.buttonColor).withOpacity(0.5),
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
                if(isNextEnabled(localQuestionnaire?.questions?.elementAt(currentPageIndex))) {
                  setState(() {
                    if(currentPageIndex < pageCount-1) {
                      currentPageIndex = currentPageIndex + 1;
                      shortFormTextController.text = '';
                      pageStateGlobal!.saveProgress!();
                    } else if(currentPageIndex == pageCount-1) {
                      pageStateGlobal?.onSubmitSelected!();
                      showSuccessAnimation();
                    }
                  });
                  controller.animateToPage(currentPageIndex, duration: const Duration(milliseconds: 250), curve: Curves.ease);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: TextDandyLight(
                      textAlign: TextAlign.center,
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'This question is required *',
                        color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                    backgroundColor: Color(ColorConstants.error_red),
                  ));
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
                    color: ColorConstants.hexToColor(localProfile?.selectedColorTheme?.buttonColor),
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
  bool isNextEnabled(Question? question) {
    return isPreview || !(question?.isRequired ?? false) || ((question?.isRequired ?? false) && (question?.isAnswered() ?? false));
  }

  Widget getAnswerWidget(
      int questionNumber,
      Question? question,
      Profile? profile,
      AnswerQuestionnairePageState pageState,
  ) {
    Widget result = const SizedBox();
    if(question != null && profile != null) {
      switch(question.type) {
        case Question.TYPE_SHORT_FORM_RESPONSE:
          result = buildShortFormResponseAnswerWidget(questionNumber, question, profile, pageState.onShortFormAnswerChanged!);
          break;
        case Question.TYPE_LONG_FORM_RESPONSE:
          result = buildLongFormResponseAnswerWidget(questionNumber, question, profile, pageState.onLongFormAnswerChanged!);
          break;
        case Question.TYPE_CONTACT_INFO:
          result = buildContactInfoResponseAnswerWidget(questionNumber, question, profile, pageState);
          break;
        case Question.TYPE_ADDRESS:
          result = buildAddressResponseAnswerWidget(questionNumber, question, profile, pageState);
          break;
        case Question.TYPE_NUMBER:
          result = buildNumberResponseAnswerWidget(questionNumber, question, profile, pageState.onNumberAnswerChanged!);
          break;
        case Question.TYPE_YES_NO:
          result = buildYesNoResponseAnswerWidget(questionNumber, question, profile, pageState.onYesNoAnswerChanged!);
          break;
        case Question.TYPE_CHECK_BOXES:
          result = buildCheckBoxesResponseAnswerWidget(questionNumber, question, profile, pageState.onCheckboxItemSelected!);
          break;
        case Question.TYPE_RATING:
          result = buildRatingResponseAnswerWidget(questionNumber, question, profile, pageState.onRatingSelected!);
          break;
        case Question.TYPE_DATE:
          result = buildDateResponseAnswerWidget(
            questionNumber,
            question,
            profile,
            pageState.onDateChanged!,
          );
          break;
      }
    }
    return result;
  }

  Widget buildQuestionWidget(int questionNumber, Question question) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(left: 32, top: 32, right: 32),
      child: TextDandyLight(
        type: TextDandyLight.LARGE_TEXT,
        text: '$questionNumber. ${question.question} ${question.isRequired! ? '*' : ''}',
      ),
    );
  }

  TextEditingController shortFormTextController = TextEditingController();
  final FocusNode shortFormFocusNode = FocusNode();
  Widget buildShortFormResponseAnswerWidget(int questionNumber, Question question, Profile localProfile, Function(String, Question) onShortFormAnswerChanged) {
    return Container(
      width: getPageWidth(context),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildQuestionWidget(questionNumber, question),
          Container(
            margin: const EdgeInsets.only(left: 32, right: 32, top: 32),
            child: TextFormField(
              enabled: !(pageStateGlobal?.questionnaire?.isComplete ?? false),
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
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

  TextEditingController numberTextController = TextEditingController();
  final FocusNode numberFocusNode = FocusNode();
  Widget buildNumberResponseAnswerWidget(int questionNumber, Question question, Profile localProfile, Function(String, Question) onShortFormAnswerChanged) {
    return Container(
      width: getPageWidth(context),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildQuestionWidget(questionNumber, question),
          Container(
            alignment: Alignment.center,
            height: 84,
            width: 216,
            margin: const EdgeInsets.only(top: 64),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                  width: 2,
                )
            ),
            child: TextFormField(
              enabled: !(pageStateGlobal?.questionnaire?.isComplete ?? false),
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              focusNode: numberFocusNode,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              controller: numberTextController,
              onChanged: (text) {
                onShortFormAnswerChanged(text, question);
              },
              onFieldSubmitted: (term) {
                numberFocusNode.unfocus();
              },
              decoration: InputDecoration.collapsed(
                hintText: 'Enter a number',
                fillColor: Color(ColorConstants.getPrimaryWhite()),
                hintStyle: TextStyle(
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.LARGE_TEXT),
                  fontWeight: TextDandyLight.getFontWeight(),
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!).withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.LARGE_TEXT),
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!)),
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController longFormTextController = TextEditingController();
  final FocusNode longFormFocusNode = FocusNode();
  Widget buildLongFormResponseAnswerWidget(int questionNumber, Question question, Profile localProfile, Function(String, Question) onLongFormAnswerChanged) {
    return Container(
      width: getPageWidth(context),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildQuestionWidget(questionNumber, question),
          Container(
            margin: const EdgeInsets.only(left: 32, right: 32, top: 32),
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
            height: 432,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                width: 1,
              )
            ),
            child: TextFormField(
              enabled: !(pageStateGlobal?.questionnaire?.isComplete ?? false),
              cursorColor: Color(ColorConstants.getPrimaryBlack()),
              focusNode: longFormFocusNode,
              textInputAction: TextInputAction.done,
              controller: longFormTextController,
              maxLines: 1000,
              onChanged: (text) {
                onLongFormAnswerChanged(text, question);
              },
              onFieldSubmitted: (term) {
                longFormFocusNode.unfocus();
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
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                  fontFamily: TextDandyLight.getFontFamily(),
                  fontSize: TextDandyLight.getFontSize(TextDandyLight.LARGE_TEXT),
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!)),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController instagramNameTextController = TextEditingController();
  FocusNode? firstNameFocusNode = FocusNode();
  FocusNode? lastNameFocusNode = FocusNode();
  FocusNode? phoneNumberFocusNode = FocusNode();
  FocusNode? emailFocusNode = FocusNode();
  FocusNode? instagramNameFocusNode = FocusNode();

  Widget buildContactInfoResponseAnswerWidget(
      int questionNumber,
      Question question,
      Profile localProfile,
      AnswerQuestionnairePageState pageState,
  ) {
    firstNameFocusNode = (question.includeFirstName ?? false) ? FocusNode() : null;
    lastNameFocusNode = (question.includeLastName ?? false) ? FocusNode() : null;
    phoneNumberFocusNode = (question.includePhone ?? false) ? FocusNode() : null;
    emailFocusNode = (question.includeEmail ?? false) ? FocusNode() : null;
    instagramNameFocusNode = (question.includeInstagramName ?? false) ? FocusNode() : null;

    return Container(
      width: getPageWidth(context),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildQuestionWidget(questionNumber, question),
          (question.includeFirstName ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'First name', TextInputType.text, firstNameFocusNode!, lastNameFocusNode, firstNameTextController, pageState.onFirstNameAnswerChanged!) : const SizedBox(),
          (question.includeLastName ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'Last name', TextInputType.text, lastNameFocusNode!, phoneNumberFocusNode, lastNameTextController, pageState.onLastNameAnswerChanged!) : const SizedBox(),
          (question.includePhone ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'Phone number', TextInputType.number, phoneNumberFocusNode!, emailFocusNode, phoneNumberTextController, pageState.onPhoneNumberAnswerChanged!) : const SizedBox(),
          (question.includeEmail ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'Email', TextInputType.emailAddress, emailFocusNode!, instagramNameFocusNode, emailTextController, pageState.onEmailAnswerChanged!) : const SizedBox(),
          (question.includeInstagramName ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'Instagram name', TextInputType.text, instagramNameFocusNode!, null, instagramNameTextController, pageState.onInstagramNameAnswerChanged!) : const SizedBox(),
          const SizedBox(height: 264)
        ],
      ),
    );
  }

  double getPageWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(DeviceType.getDeviceTypeByContext(context) == Type.Website) {
      return MediaQuery.of(context).size.width/2 - 132;
    } else if(DeviceType.getDeviceTypeByContext(context) == Type.Tablet) {
      return 840;
    }
    return width;
  }

  TextEditingController addressTextController = TextEditingController();
  TextEditingController addressLine2TextController = TextEditingController();
  TextEditingController cityTownTextController = TextEditingController();
  TextEditingController stateRegionTextController = TextEditingController();
  TextEditingController zipTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  FocusNode? addressFocusNode = FocusNode();
  FocusNode? addressLine2FocusNode = FocusNode();
  FocusNode? cityTownFocusNode = FocusNode();
  FocusNode? stateRegionFocusNode = FocusNode();
  FocusNode? zipFocusNode = FocusNode();
  FocusNode? countryFocusNode = FocusNode();

  Widget buildAddressResponseAnswerWidget(
      int questionNumber,
      Question question,
      Profile localProfile,
      AnswerQuestionnairePageState pageState,
      ) {
    addressFocusNode = (question.addressRequired ?? false) ? FocusNode() : null;
    addressLine2FocusNode = (question.addressRequired ?? false) ? FocusNode() : null;
    cityTownFocusNode = (question.cityTownRequired ?? false) ? FocusNode() : null;
    stateRegionFocusNode = (question.stateRegionProvinceRequired ?? false) ? FocusNode() : null;
    zipFocusNode = (question.zipPostCodeRequired ?? false) ? FocusNode() : null;
    countryFocusNode = (question.countryRequired ?? false) ? FocusNode() : null;

    return SingleChildScrollView(
      child: Container(
        width: getPageWidth(context),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildQuestionWidget(questionNumber, question),
            (question.addressRequired ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'Address *', TextInputType.streetAddress, addressFocusNode!, addressLine2FocusNode, addressTextController, pageState.onAddressAnswerChanged!) : const SizedBox(),
            (question.addressRequired ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'Address line 2', TextInputType.streetAddress, addressLine2FocusNode!, cityTownFocusNode, addressLine2TextController, pageState.onAddressLine2AnswerChanged!) : const SizedBox(),
            (question.cityTownRequired ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'City/Town *', TextInputType.text, cityTownFocusNode!, stateRegionFocusNode, cityTownTextController, pageState.onCityTownAnswerChanged!) : const SizedBox(),
            (question.stateRegionProvinceRequired ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'State/Region/Province *', TextInputType.text, stateRegionFocusNode!, zipFocusNode, stateRegionTextController, pageState.onStateRegionAnswerChanged!) : const SizedBox(),
            (question.zipPostCodeRequired ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'ZIP/Post code *', TextInputType.number, zipFocusNode!, null, zipTextController, pageState.onZipAnswerChanged!) : const SizedBox(),
            (question.countryRequired ?? false) ? singleLineInputField(questionNumber, question, localProfile, 'Country *', TextInputType.text, countryFocusNode!, null, countryTextController, pageState.onCountryAnswerChanged!) : const SizedBox(),

            const SizedBox(height: 264)
          ],
        ),
      ),
    );
  }

  Widget singleLineInputField(
      int questionNumber,
      Question question,
      Profile localProfile,
      String questionLabel,
      TextInputType inputType,
      FocusNode contactItemFocusNode,
      FocusNode? nextFocus,
      TextEditingController contactItemTextController,
      Function(String, Question) onAnswerInputChanged,
  ) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 32, top: 32),
          child: TextDandyLight(
              text: questionLabel,
              type: TextDandyLight.MEDIUM_TEXT
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 32, right: 32, top: 0),
          child: TextFormField(
            enabled: !(pageStateGlobal?.questionnaire?.isComplete ?? false),
            cursorColor: Color(ColorConstants.getPrimaryBlack()),
            textInputAction: TextInputAction.next,
            maxLines: 1,
            controller: contactItemTextController,
            onChanged: (text) {
              onAnswerInputChanged(text, question);
            },
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
            keyboardType: inputType,
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
    );
  }

  Widget buildYesNoResponseAnswerWidget(int questionNumber, Question question, Profile localProfile, Function(bool, Question) onYesNoAnswerChanged) {
    return Container(
      width: getPageWidth(context),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildQuestionWidget(questionNumber, question),
          Container(
            margin: const EdgeInsets.only(bottom: 32, top: 32),
            alignment: Alignment.center,
            height: 64,
            width: 224,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 2,
                color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
              ),
              color: question.yesSelected ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!).withOpacity(0.5) : Color(ColorConstants.getPrimaryWhite()),
            ),
            child: CheckboxListTile(
              enabled: !(pageStateGlobal?.questionnaire?.isComplete ?? false),
              activeColor: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
              checkColor: Color(ColorConstants.getPrimaryWhite()),
              fillColor: MaterialStateProperty.resolveWith((states) {
                // If the button is pressed, return green, otherwise blue
                if (states.contains(MaterialState.selected)) {
                  return ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!);
                }
                return Color(ColorConstants.getPrimaryWhite());
              }),
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: 'Yes',
                isBold: question.yesSelected,
                color: question.yesSelected ? Color(ColorConstants.getPrimaryWhite()) : ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
              ),
              value: question.yesSelected,
              onChanged: (newValue) {
                setState(() {
                  onYesNoAnswerChanged(newValue ?? false, question);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 32),
            alignment: Alignment.center,
            height: 64,
            width: 224,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  width: 2,
                  color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
              ),
              color: !question.yesSelected ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!).withOpacity(0.5) : Color(ColorConstants.getPrimaryWhite()),
            ),
            child: CheckboxListTile(
              enabled: !(pageStateGlobal?.questionnaire?.isComplete ?? false),
              checkColor: Color(ColorConstants.getPrimaryWhite()),
              fillColor: MaterialStateProperty.resolveWith((states) {
                // If the button is pressed, return green, otherwise blue
                if (states.contains(MaterialState.selected)) {
                  return ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!);
                }
                return Color(ColorConstants.getPrimaryWhite());
              }),
              title: TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                isBold: !question.yesSelected,
                text: 'No',
                color: question.yesSelected ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryWhite()),
              ),
              value: question.yesSelected ? false : true,
              onChanged: (newValue) {
                setState(() {
                  onYesNoAnswerChanged(!(newValue ?? false), question);
                });
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            ),
          )
        ],
      ),
    );
  }

  Widget buildCheckBoxesResponseAnswerWidget(int questionNumber, Question question, Profile localProfile, Function(int index, bool, Question) onCheckboxItemSelected) {
    return SingleChildScrollView(
      child: SizedBox(
        width: getPageWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildQuestionWidget(questionNumber, question),
            Container(
              alignment: Alignment.topLeft,
              child: question.choicesCheckBoxes != null ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: question.choicesCheckBoxes?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                      alignment: Alignment.center,
                      height: 64,
                      width: 224,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 2,
                          color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                        ),
                        color: question.hasItemChecked(question.choicesCheckBoxes?.elementAt(index)) ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!).withOpacity(0.5) : Color(ColorConstants.getPrimaryWhite()),
                      ),
                      child: CheckboxListTile(
                        enabled: !(pageStateGlobal?.questionnaire?.isComplete ?? false),
                        checkColor: Color(ColorConstants.getPrimaryWhite()),
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          // If the button is pressed, return green, otherwise blue
                          if (states.contains(MaterialState.selected)) {
                            return ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!);
                          }
                          return Color(ColorConstants.getPrimaryWhite());
                        }),
                        title: TextDandyLight(
                          type: TextDandyLight.LARGE_TEXT,
                          isBold: question.hasItemChecked(question.choicesCheckBoxes?.elementAt(index)),
                          text: question.choicesCheckBoxes?.elementAt(index),
                          color: !question.hasItemChecked(question.choicesCheckBoxes?.elementAt(index)) ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryWhite()),
                        ),
                        value: question.hasItemChecked(question.choicesCheckBoxes?.elementAt(index)) ? true : false,
                        onChanged: (newValue) {
                          setState(() {
                            onCheckboxItemSelected(index, !(newValue ?? false), question);
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      ),
                    );
                  }
              ) : const SizedBox(),
            ),
            const SizedBox(height: 132)
          ],
        ),
      ),
    );
  }

  Widget buildRatingResponseAnswerWidget(int questionNumber, Question question, Profile localProfile, Function(int rating, Question) onRatingSelected) {
    return SizedBox(
      width: getPageWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildQuestionWidget(questionNumber, question),
          Container(
            margin: const EdgeInsets.only(top: 48),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    if(!(pageStateGlobal?.questionnaire?.isComplete ?? false)) {
                      onRatingSelected(1, question);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Column(
                      children: [
                        Icon((question.ratingAnswer ?? 0) >= 1 ? Icons.star : Icons.star_border, color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!), size: 48),
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '1',
                          color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(!(pageStateGlobal?.questionnaire?.isComplete ?? false)) {
                      onRatingSelected(2, question);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Column(
                      children: [
                        Icon((question.ratingAnswer ?? 0) >= 2 ? Icons.star : Icons.star_border, color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!), size: 48),
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '2',
                          color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(!(pageStateGlobal?.questionnaire?.isComplete ?? false)) {
                      onRatingSelected(3, question);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Column(
                      children: [
                        Icon((question.ratingAnswer ?? 0) >= 3 ? Icons.star : Icons.star_border, color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!), size: 48),
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '3',
                          color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(!(pageStateGlobal?.questionnaire?.isComplete ?? false)) {
                      onRatingSelected(4, question);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Column(
                      children: [
                        Icon((question.ratingAnswer ?? 0) >= 4 ? Icons.star : Icons.star_border, color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!), size: 48),
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '4',
                          color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(!(pageStateGlobal?.questionnaire?.isComplete ?? false)) {
                      onRatingSelected(5, question);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Column(
                      children: [
                        Icon(question.ratingAnswer == 5 ? Icons.star : Icons.star_border, color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!), size: 48),
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '5',
                          color: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController monthTextController = TextEditingController();
  TextEditingController dayTextController = TextEditingController();
  TextEditingController yearTextController = TextEditingController();
  FocusNode? monthFocusNode = FocusNode();
  FocusNode? dayFocusNode = FocusNode();
  FocusNode? yearFocusNode = FocusNode();
  Widget buildDateResponseAnswerWidget(
      int questionNumber,
      Question question,
      Profile localProfile,
      Function(DateTime?, Question) onDateChanged,
  ) {
    return SizedBox(
      width: getPageWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildQuestionWidget(questionNumber, question),
          GestureDetector(
            onTap: () async {
              if(!(pageStateGlobal?.questionnaire?.isComplete ?? false)) {
                onDateChanged((await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // Refer step 1
                  firstDate: DateTime(2024),
                  lastDate: DateTime((DateTime.now().year + 10)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!),
                          onPrimary: Color(ColorConstants.getPrimaryWhite()),
                          onSurface: Color(ColorConstants.getPrimaryBlack()),
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                                color: Color(ColorConstants.getPrimaryBlack())
                            ),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                )), question);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 64,
                        alignment: Alignment.center,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Month',
                          color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        alignment: Alignment.center,
                        width: 64,
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: question.month != null ? question.month.toString() : 'MM',
                          color: question.month != null ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 1,
                        width: 64,
                        color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 26, left: 8, right: 8),
                    child: TextDandyLight(
                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                      text: '/',
                      color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 64,
                        alignment: Alignment.center,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Day',
                          color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        alignment: Alignment.center,
                        width: 64,
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: question.day != null ? question.day.toString() : 'DD',
                          color: question.day != null ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 1,
                        width: 64,
                        color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 26, left: 8, right: 8),
                    child: TextDandyLight(
                      type: TextDandyLight.EXTRA_LARGE_TEXT,
                      text: '/',
                      color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 96,
                        alignment: Alignment.center,
                        child: TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Year',
                          color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        alignment: Alignment.center,
                        width: 96,
                        child: TextDandyLight(
                          type: TextDandyLight.EXTRA_LARGE_TEXT,
                          text: question.year != null ? question.year.toString() : 'YYYY',
                          color: question.year != null ? ColorConstants.hexToColor(localProfile.selectedColorTheme!.buttonColor!) : Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 1,
                        width: 96,
                        color: Color(ColorConstants.getPrimaryBlack()).withOpacity(0.25),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool shouldShowAnswers(bool answered, Questionnaire? questionnaire) {
    bool result = false;
    if(questionnaire?.isComplete ?? false) {
      result = true;
    } else {
      result = !isPreview;
    }
    print("Should show answers = $result");
    return result;
  }
}
