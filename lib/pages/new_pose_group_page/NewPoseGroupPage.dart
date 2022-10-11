import 'dart:async';
import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'NewPoseGroupPageState.dart';
import 'NewPoseGroupTextField.dart';

class NewPoseGroupPage extends StatefulWidget {

  @override
  _NewPoseGroupPageState createState() {
    return _NewPoseGroupPageState();
  }
}

class _NewPoseGroupPageState extends State<NewPoseGroupPage> {
  _NewPoseGroupPageState();
  final contractNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewPoseGroupPageState>(
      converter: (store) => NewPoseGroupPageState.fromStore(store),
      builder: (BuildContext context, NewPoseGroupPageState pageState) =>
          Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 375.0,
                  padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                  decoration: new BoxDecoration(
                      color: Color(ColorConstants.white),
                      borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          "New Collection",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 26.0,
                            fontFamily: 'simple',
                            fontWeight: FontWeight.w600,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 26.0, right: 26.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 32.0),
                              child: Text(
                                "Enter a simple and descriptive name for this pose collection. ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            NewPoseGroupTextField(
                                contractNameTextController,
                                "Collection Name",
                                TextInputType.text,
                                64.0,
                                pageState.onNameChanged,
                                'Collection name is required',
                                TextInputAction.done,
                                null,
                                null,
                                TextCapitalization.words,
                                null),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 26.0, right: 26.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: Styles.getButtonStyle(
                                color: Colors.white,
                                textColor: Color(ColorConstants.primary_black),
                                left: 8.0,
                                top: 8.0,
                                right: 8.0,
                                bottom: 8.0,
                              ),
                              onPressed: () {
                                onBackPressed(pageState);
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            TextButton(
                              style: Styles.getButtonStyle(
                                color: Colors.white,
                                textColor: Color(ColorConstants.primary_black),
                                left: 8.0,
                                top: 8.0,
                                right: 8.0,
                                bottom: 8.0,
                              ),
                              onPressed: () {
                                onNextPressed(pageState);
                              },
                              child: Text(
                                'Save',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontFamily: 'simple',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  void onNextPressed(NewPoseGroupPageState pageState) {
    if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);

    showSuccessAnimation();
    pageState.onSaveSelected();

  }

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

  void onBackPressed(NewPoseGroupPageState pageState) {
    if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);
    pageState.onCanceledSelected();
    Navigator.of(context).pop();
  }
}