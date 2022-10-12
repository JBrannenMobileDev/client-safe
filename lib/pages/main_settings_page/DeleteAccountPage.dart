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
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

class DeleteAccountPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _DeleteAccountPageState();
  }
}

class _DeleteAccountPageState extends State<DeleteAccountPage>
    with TickerProviderStateMixin {
  TextEditingController passwordTextController = TextEditingController();


  bool isChecked = false;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
        onDidChange: (prevState, currentState) {
          if(!prevState.isDeleteFinished && currentState.isDeleteFinished) {
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
            NavigationUtil.onSignOutSelected(context);
          }

          if(currentState.password.isNotEmpty && passwordTextController.text != currentState.password)passwordTextController.text = currentState.password;
        },
        builder: (BuildContext context, MainSettingsPageState pageState) =>
            WillPopScope(
                onWillPop: () async{
                  return !pageState.isDeleteInProgress;
                },
                child: Scaffold(
                  backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppBar(
                                iconTheme: IconThemeData(
                                  color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                                ),
                                brightness: Brightness.light,
                                backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                                centerTitle: true,
                                elevation: 0.0,
                                title: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                    fontSize: 26.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0, top: 16.0),
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'Deleting your DandyLight account will remove all data stored on your device and in our database.   '
                                      'Once your account is deleted you will not be able to recover your data. '
                                      '\n\nDeleting your account will not cancel your subscription.   '
                                      'You will still need to go to your app store settings to cancel your subscription. '
                                      '\n\nPlease select the check-box to confirm that you want to delete your account.',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w600,
                                    color: Color(ColorConstants.getPrimaryBlack()),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Yes i want to delete my account.',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'simple',
                                      fontWeight: FontWeight.w700,
                                      color: Color(ColorConstants.error_red),
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Checkbox(
                                    value: isChecked,
                                    activeColor: Color(ColorConstants.error_red),
                                    onChanged: (bool value) { // This is where we update the state when the checkbox is tapped
                                      setState(() {
                                        isChecked = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              pageState.passwordErrorMessage.isNotEmpty ? Container(
                                padding: EdgeInsets.only(left: 54.0),
                                alignment: Alignment.bottomLeft,
                                height: 48.0,
                                child: Text(
                                  'Invalid Password',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'simple',
                                    fontWeight: FontWeight.w700,
                                    color: Color(ColorConstants.error_red),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ) : SizedBox(height: 48.0,),
                              LoginTextField(
                                maxLines: 1,
                                controller: passwordTextController,
                                hintText: 'Password',
                                labelText: 'Password',
                                inputType: TextInputType.visiblePassword,
                                height: 64.0,
                                inputTypeError: 'Valid Password is required',
                                onTextInputChanged: (password) {
                                  pageState.onPasswordChanged(password);
                                },
                                onEditingCompleted: null,
                                keyboardAction: TextInputAction.done,
                                onFocusAction: null,
                                capitalization: TextCapitalization.none,
                                enabled: true,
                                obscureText: true,
                              )
                            ],
                          ),
                          pageState.isDeleteInProgress ? Container(
                            alignment: Alignment.center,
                            child: LoadingAnimationWidget.fourRotatingDots(
                              color: Color(ColorConstants.getBlueDark()),
                              size: 32,
                            ),
                          ) : SizedBox(),
                          GestureDetector(
                            onTap: () {
                              if(isChecked && !pageState.isDeleteInProgress && !pageState.isDeleteFinished) {
                                pageState.onDeleteAccountSelected();
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0, bottom: 32.0),
                              alignment: Alignment.center,
                              height: 48.0,
                              decoration: BoxDecoration(
                                  color: Color(isChecked  && !pageState.isDeleteInProgress && !pageState.isDeleteFinished ? ColorConstants.getBlueDark() : ColorConstants.getPrimaryGreyMedium()),
                                  borderRadius: BorderRadius.circular(32.0)),
                              child: Text(
                                'Delete Account',
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
            ),
      );

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
