import 'package:dandylight/AppState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../widgets/TextDandyLight.dart';
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
          Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
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
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: "New Collection",
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.primary_black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 26.0, right: 26.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 32.0),
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: "Enter a simple and descriptive name for this pose collection. ",
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.primary_black),
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
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: 'Cancel',
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.primary_black),
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
                                child: TextDandyLight(
                                  type: TextDandyLight.MEDIUM_TEXT,
                                  text: 'Save',
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
