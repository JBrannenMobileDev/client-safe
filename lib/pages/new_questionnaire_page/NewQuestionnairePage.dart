import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Question.dart';
import 'package:dandylight/models/Questionnaire.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:redux/redux.dart';

import '../../utils/ImageUtil.dart';
import '../../utils/InputDoneView.dart';
import '../../utils/NavigationUtil.dart';
import '../../utils/Shadows.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import '../common_widgets/TextFieldDandylight.dart';
import '../share_with_client_page/ShareWithClientTextField.dart';
import 'NewQuestionListWidget.dart';
import 'NewQuestionnaireActions.dart';
import 'NewQuestionnairePageState.dart';

class NewQuestionnairePage extends StatefulWidget {
  final Questionnaire questionnaire;
  final String title;
  final bool isNew;
  final String jobDocumentId;
  final Function(BuildContext, Questionnaire) deleteFromJob;

  const NewQuestionnairePage({Key key, this.questionnaire, this.title, this.isNew, this.jobDocumentId, this.deleteFromJob}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewQuestionnairePageState(questionnaire, title, isNew, jobDocumentId, deleteFromJob);
  }
}

class _NewQuestionnairePageState extends State<NewQuestionnairePage> with TickerProviderStateMixin {
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  final String title;
  final bool isNew;
  final bool hasUnsavedChanges = false;
  final String jobDocumentId;
  final Function(BuildContext, Questionnaire) deleteFromJob;
  bool isKeyboardVisible = false;
  OverlayEntry overlayEntry;
  final Questionnaire questionnaire;
  TextEditingController titleTextController = TextEditingController();
  final messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

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

  _NewQuestionnairePageState(this.questionnaire, this.title, this.isNew, this.jobDocumentId, this.deleteFromJob);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewQuestionnairePageState>(
        onInit: (store) {
          store.dispatch(ClearNewQuestionnaireState(store.state.newQuestionnairePageState, isNew, title));
          if(questionnaire != null) {
            store.dispatch(SetQuestionnaireAction(store.state.newQuestionnairePageState, questionnaire, jobDocumentId));
            questions = questionnaire.questions;
          } else {
            Questionnaire questionnaire = Questionnaire();
            questionnaire.questions = [];
            store.dispatch(SetQuestionnaireAction(store.state.newQuestionnairePageState, questionnaire, jobDocumentId));
            questions = [];
          }
          store.dispatch(FetchProfileForNewQuestionnaireAction(store.state.newQuestionnairePageState));

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
        converter: (Store<AppState> store) => NewQuestionnairePageState.fromStore(store),
        builder: (BuildContext context, NewQuestionnairePageState pageState) => WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              if(hasUnsavedChanges) {
                await showDialog(
                    context: context,
                    builder: (_) => Device.get().isIos ?
                    CupertinoAlertDialog(
                      title: new Text('Exit without saving changes?'),
                      content: new Text('If you continue any changes made will not be saved.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: new Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
                        ),
                      ],
                    ) : AlertDialog(
                      title: new Text('Exit without saving changes?'),
                      content: new Text('If you continue any changes made will not be saved.'),
                      actions: <Widget>[
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () {
                            willLeave = true;
                            Navigator.of(context).pop();
                          },
                          child: new Text('Yes'),
                        ),
                        TextButton(
                          style: Styles.getButtonStyle(),
                          onPressed: () => Navigator.of(context).pop(false),
                          child: new Text('No'),
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
                actions: <Widget>[
                  !isNew ? IconButton(
                    icon: ImageIcon(ImageUtil.getTrashIconWhite(), color: Color(ColorConstants.getPrimaryBlack()),),
                    tooltip: 'Delete Questionnaire',
                    onPressed: () {
                      if(jobDocumentId != null && jobDocumentId.isNotEmpty) {
                        deleteFromJob(context, questionnaire);
                      }else {
                        _ackDeleteAlert(context, pageState);
                      }
                    },
                  ) : const SizedBox(),
                ],
                centerTitle: true,
                elevation: 0.0,
                title: TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: isNew ? 'New Questionnaire' : 'Edit Questionnaire',
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
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 32, top: 16.0, bottom: 0),
                            alignment: Alignment.centerLeft,
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Questionnaire title',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          TextFieldDandylight(
                            maxLines: 1,
                            controller: titleTextController,
                            hintText: 'Title',
                            labelText: 'Title',
                            inputType: TextInputType.text,
                            height: 64.0,
                            inputTypeError: 'Title is required',
                            onTextInputChanged: (newTitle) => pageState.onNameChanged(newTitle),
                            onEditingCompleted: null,
                            keyboardAction: TextInputAction.next,
                            focusNode: titleFocusNode,
                            onFocusAction: () {
                              titleFocusNode.unfocus();
                            },
                            capitalization: TextCapitalization.words,
                            enabled: true,
                            obscureText: false,
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(left: 32, top: 16.0, bottom: 8),
                          //   alignment: Alignment.centerLeft,
                          //   child: TextDandyLight(
                          //     type: TextDandyLight.SMALL_TEXT,
                          //     text: 'Message to client',
                          //     color: Color(ColorConstants.getPrimaryBlack()),
                          //   ),
                          // ),
                          // Container(
                          //   height: 132,
                          //   margin: const EdgeInsets.only(left: 16, right: 16),
                          //   padding: const EdgeInsets.only(top: 16),
                          //   decoration: BoxDecoration(
                          //       color: Color(ColorConstants.getPrimaryWhite()),
                          //       borderRadius: BorderRadius.circular(16)
                          //   ),
                          //   child: Container(
                          //     margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          //     child: ShareWithClientTextField(
                          //       messageController,
                          //       'Write a message here for the client explaining the purpose of the questionnaire.',
                          //       TextInputType.multiline,
                          //       116.0,
                          //       pageState.onMessageChanged,
                          //       'noError',
                          //       TextInputAction.newline,
                          //       _messageFocusNode,
                          //       onAction,
                          //       TextCapitalization.sentences,
                          //       null,
                          //       true,
                          //       false,
                          //       false,
                          //     ),
                          //   ),
                          // ),
                          questions.isNotEmpty ? Container(
                            margin:
                            const EdgeInsets.only(left: 32, top: 20.0),
                            alignment: Alignment.centerLeft,
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: 'Questions',
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ) : const SizedBox(),
                          questions.isNotEmpty ? ReorderableListView.builder(
                            reverse: false,
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 16.0),
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: questions.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: Key(questions.elementAt(index).id.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Color(ColorConstants.getPeachDark()),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    questions.removeWhere((question) => question.id == questions.elementAt(index).id);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16, right: 16, top: 4.0, bottom: 4.0),
                                  child: NewQuestionListWidget(questions.elementAt(index), pageState, (index+1)),
                                ),
                              );
                            },
                            onReorder: reorderData,
                          ) :
                          pageState.questionnaire?.questions?.isEmpty ?? true ? Padding(
                            padding: const EdgeInsets.only(left: 64.0, top: 32.0, right: 64.0, bottom: 8),
                            child: TextDandyLight(
                              type: TextDandyLight.SMALL_TEXT,
                              text: "You have not added any questions yet.",
                              textAlign: TextAlign.center,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ) : const SizedBox(),
                          GestureDetector(
                            onTap: () {
                              NavigationUtil.onNewQuestionSelected(context, null, onQuestionSaved, (questions?.length ?? 0) +1);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 54,
                              width: 264,
                              margin: const EdgeInsets.only(bottom: 124),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: const Color(ColorConstants.grey_medium),
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Add Question',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              width: MediaQuery.of(context).size.width/2.25,
                              margin: const EdgeInsets.only(bottom: 32),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Color(ColorConstants.getBlueDark()),
                                boxShadow: ElevationToShadow[4],
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Preview',
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
                              pageState.onQuestionnaireSaved(jobDocumentId, questions);
                              showSuccessAnimation();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 54,
                              width: MediaQuery.of(context).size.width/2.25,
                              margin: const EdgeInsets.only(bottom: 32),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                color: Color(ColorConstants.getBlueDark()),
                                boxShadow: ElevationToShadow[4],
                              ),
                              child: TextDandyLight(
                                type: TextDandyLight.LARGE_TEXT,
                                text: 'Save changes',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryWhite()),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void onQuestionSaved(Question question) {
    setState(() {
      int index = getIndex(question);
      if(index >= 0) {
        questions.replaceRange(index, index, [question]);
      } else {
        questions.add(question);
      }
    });
  }

  void onQuestionDeleted(Question questionToDelete) {
    setState(() {
      questions.removeWhere((question) => question.id == questionToDelete.id);
    });
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

  Future<void> _ackDeleteAlert(BuildContext context, NewQuestionnairePageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this questionnaire will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this questionnaire will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                pageState.onDeleteSelected();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: new Text('Yes'),
            ),
          ],
        );
      },
    );
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

  int getIndex(Question questionToFind) {
    int index = -1;
    for(int i = 0; i < questions.length; i++) {
      if(questions.elementAt(i).id == questionToFind.id) {
        index = i;
      }
    }
    return index;
  }
}
