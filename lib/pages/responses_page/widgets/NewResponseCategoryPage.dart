import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/responses_page/ResponsesPageState.dart';
import 'package:dandylight/pages/responses_page/widgets/NewRespnseCategoryTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/KeyboardUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../widgets/TextDandyLight.dart';

class NewResponseCategoryPage extends StatefulWidget {

  @override
  _NewResponseCategoryPageState createState() {
    return _NewResponseCategoryPageState();
  }
}

class _NewResponseCategoryPageState extends State<NewResponseCategoryPage> {
  _NewResponseCategoryPageState();
  final contractNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResponsesPageState>(
      converter: (store) => ResponsesPageState.fromStore(store),
      builder: (BuildContext context, ResponsesPageState pageState) =>
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
                            text: "New Response Category",
                            textAlign: TextAlign.start,
                            color: Color(ColorConstants.getPrimaryBlack()),
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
                                  text: "Enter a simple and descriptive name for this response category.",
                                  textAlign: TextAlign.start,
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              NewResponseCategoryTextField(
                                  contractNameTextController,
                                  "Category Name",
                                  TextInputType.text,
                                  64.0,
                                  pageState.onNewCategoryNameChanged!,
                                  'Category name is required',
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
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  textColor: Color(ColorConstants.getPrimaryBlack()),
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
                                  color: Color(ColorConstants.getPrimaryBlack()),
                                ),
                              ),
                              TextButton(
                                style: Styles.getButtonStyle(
                                  color: Color(ColorConstants.getPrimaryWhite()),
                                  textColor: Color(ColorConstants.getPrimaryBlack()),
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
                                  color: Color(ColorConstants.getPrimaryBlack()),
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

  void onNextPressed(ResponsesPageState pageState) {
    if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);

    showSuccessAnimation();
    pageState.onSaveNewCategorySelected!();

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

  void onBackPressed(ResponsesPageState pageState) {
    if(MediaQuery.of(context).viewInsets.bottom != 0) KeyboardUtil.closeKeyboard(context);
    pageState.onCancelSelected!();
    Navigator.of(context).pop();
  }
}
