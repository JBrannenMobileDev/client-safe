import 'dart:ui';

import 'package:dandylight/AppState.dart';
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
import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';
import 'NewQuestionnaireActions.dart';
import 'NewQuestionnairePageState.dart';

class NewQuestionnairePage extends StatefulWidget {
  final Questionnaire questionnaire;
  final String title;
  final bool isNew;
  final String jobDocumentId;
  final Function(BuildContext) deleteFromJob;

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
  final Function(BuildContext) deleteFromJob;
  bool isKeyboardVisible = false;
  OverlayEntry overlayEntry;
  final Questionnaire questionnaire;

  _NewQuestionnairePageState(this.questionnaire, this.title, this.isNew, this.jobDocumentId, this.deleteFromJob);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, NewQuestionnairePageState>(
        onInit: (store) {
          store.dispatch(ClearNewQuestionnaireState(store.state.newQuestionnairePageState, isNew, title));
          if(questionnaire != null) {
            store.dispatch(SetQuestionnaireAction(store.state.newQuestionnairePageState, questionnaire));
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
                iconTheme: IconThemeData(
                  color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                ),
                backgroundColor: Color(ColorConstants.getPrimaryWhite()),
                actions: <Widget>[
                  !isNew ? IconButton(
                    icon: ImageIcon(ImageUtil.getTrashIconWhite(), color: Color(ColorConstants.getPeachDark()),),
                    tooltip: 'Delete Job',
                    onPressed: () {
                      if(jobDocumentId != null && jobDocumentId.isNotEmpty) {
                        deleteFromJob(context);
                      }else {
                        _ackDeleteAlert(context, pageState);
                      }
                    },
                  ) : SizedBox(),
                ],
                centerTitle: true,
                elevation: 0.0,
                title: Container(
                  width: 250,
                  child: TextFormField(
                      focusNode: titleFocusNode,
                      initialValue: !isNew ? questionnaire.title : 'Questionnaire name',
                      enabled: true,
                      cursorColor: Color(ColorConstants.getPrimaryBlack()),
                      onChanged: (text) {
                        setState(() {});
                        pageState.onNameChanged(text);
                      },
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                            fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                            fontFamily: TextDandyLight.getFontFamily(),
                            fontWeight: TextDandyLight.getFontWeight(),
                            color: Color(ColorConstants.getPrimaryBlack())
                        ),
                        hintText: 'Questionnaire Name',
                        fillColor: Color(ColorConstants.getPrimaryWhite()),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(ColorConstants.getPrimaryBlack()),
                              width: 4.0,
                            )),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(ColorConstants.getPrimaryBlack()),
                            width: 4.0,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(16),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: TextDandyLight.getFontSize(TextDandyLight.MEDIUM_TEXT),
                          fontFamily: TextDandyLight.getFontFamily(),
                          fontWeight: TextDandyLight.getFontWeight(),
                          color: Color(ColorConstants.getPrimaryBlack()))
                  ),
                ),
              ),
              backgroundColor: Color(ColorConstants.getPrimaryWhite()),
              body: Stack(
                children: [

                ],
              ),
            ),
        ),
      );

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
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
