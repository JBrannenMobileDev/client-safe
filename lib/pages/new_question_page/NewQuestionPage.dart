import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Question.dart';
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
import '../../utils/Shadows.dart';
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewQuestionPageState.dart';

class NewQuestionPage extends StatefulWidget {
  final Question question;

  const NewQuestionPage({Key key, this.question}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewQuestionPageState(question);
  }
}

class _NewQuestionPageState extends State<NewQuestionPage> with TickerProviderStateMixin {
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController controllerTitle = TextEditingController();
  final bool hasUnsavedChanges = false;
  bool isKeyboardVisible = false;
  OverlayEntry overlayEntry;
  final Question question;
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

  _NewQuestionPageState(this.question);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewQuestionPageState>(
        onInit: (store) {
          store.dispatch(ClearNewQuestionnaireState(store.state.newQuestionnairePageState, isNew, title));
          if(questionnaire != null) {
            store.dispatch(SetQuestionnaireAction(store.state.newQuestionnairePageState, questionnaire, jobDocumentId));
            questions = questionnaire.questions;
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
        converter: (Store<AppState> store) => NewQuestionPageState.fromStore(store),
        builder: (BuildContext context, NewQuestionPageState pageState) => WillPopScope(
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
                        deleteFromJob(context);
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




                          SizedBox(),
                        ],
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
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Color(ColorConstants.getPeachDark()),
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

  Future<void> _ackDeleteAlert(BuildContext context, NewQuestionPageState pageState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Device.get().isIos ?
        CupertinoAlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this job will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                if(jobDocumentId != null) {
                  pageState.deleteFromJob();
                } else {
                  pageState.onDeleteSelected();
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: new Text('Yes'),
            ),
          ],
        ) : AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('All data for this job will be permanently deleted!'),
          actions: <Widget>[
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            TextButton(
              style: Styles.getButtonStyle(),
              onPressed: () {
                if(jobDocumentId != null) {
                  pageState.deleteFromJob();
                } else {
                  pageState.onDeleteSelected();
                }
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
}
