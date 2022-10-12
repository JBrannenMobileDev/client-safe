import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/common_widgets/LoginTextField.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/ImageUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/widgets/login_animations/TranslationImage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

class SuggestionsPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SuggestionsPageState();
  }
}

class _SuggestionsPageState extends State<SuggestionsPage>
    with TickerProviderStateMixin {
  TextEditingController suggestionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AppBar(
                    iconTheme: IconThemeData(
                      color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                    ),
                    brightness: Brightness.light,
                    backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                    centerTitle: true,
                    elevation: 0.0,
                    title: Text(
                      "Suggestions",
                      style: TextStyle(
                        fontSize: 26.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 16.0),
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Thank you for using DandyLight. We are always striving to improve what we offer to you.\n\n We would be happy to consider any feedback you might have. Thank you!',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  LoginTextField(
                    controller: suggestionTextController,
                    hintText: 'Suggestions',
                    labelText: 'Suggestions',
                    inputType: TextInputType.text,
                    height: 450.0,
                    inputTypeError: '',
                    onTextInputChanged: (firstNameText) =>
                        pageState.onFirstNameChanged(firstNameText),
                    onEditingCompleted: null,
                    keyboardAction: TextInputAction.done,
                    capitalization: TextCapitalization.sentences,
                    enabled: true,
                    obscureText: false,
                    maxLines: 500,
                  ),
                  GestureDetector(
                    onTap: () {
                      pageState.onSendSuggestionSelected(suggestionTextController.text);
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
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0, bottom: 32.0),
                      alignment: Alignment.center,
                      height: 48.0,
                      decoration: BoxDecoration(
                          color: Color(ColorConstants.getBlueDark()),
                          borderRadius: BorderRadius.circular(32.0)),
                      child: Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.getPrimaryWhite()),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ] ,
          ),
        ),
      );

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
