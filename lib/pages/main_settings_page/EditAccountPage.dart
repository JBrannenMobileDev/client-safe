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
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageState.dart';

class EditAccountPage extends StatefulWidget {
  final Profile profile;

  EditAccountPage(this.profile);

  @override
  State<StatefulWidget> createState() {
    return _EditAccountPageState(profile);
  }
}

class _EditAccountPageState extends State<EditAccountPage>
    with TickerProviderStateMixin {
  Profile profile;
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController businessNameTextController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final businessNameFocusNode = FocusNode();

  _EditAccountPageState(this.profile);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {
          if(store.state.mainSettingsPageState.firstName.isNotEmpty)firstNameTextController.text = store.state.mainSettingsPageState.firstName;
        },
        converter: (Store<AppState> store) => MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) => Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
          body: Container(
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(ColorConstants.getPrimaryBlack()), //change your color here
                  ),
                  brightness: Brightness.light,
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  centerTitle: true,
                  elevation: 0.0,
                  title: Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(
                    <Widget>[
                          SafeArea(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  LoginTextField(
                                    controller: firstNameTextController,
                                    hintText: 'First name',
                                    labelText: 'First name',
                                    inputType: TextInputType.text,
                                    height: 64.0,
                                    inputTypeError: 'First name is required',
                                    onTextInputChanged: (firstNameText) =>
                                        pageState.onFirstNameChanged(firstNameText),
                                    onEditingCompleted: null,
                                    keyboardAction: TextInputAction.next,
                                    focusNode: firstNameFocusNode,
                                    onFocusAction: () {
                                      firstNameFocusNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(lastNameFocusNode);
                                    },
                                    capitalization: TextCapitalization.words,
                                    enabled: true,
                                    obscureText: false,
                                  ),
                                  LoginTextField(
                                    controller: lastNameTextController,
                                    hintText: 'Last name',
                                    labelText: 'Last name',
                                    inputType: TextInputType.text,
                                    height: 64.0,
                                    inputTypeError: 'Last name is required',
                                    onTextInputChanged: (firstNameText) =>
                                        pageState.onLastNameChanged(firstNameText),
                                    onEditingCompleted: null,
                                    keyboardAction: TextInputAction.next,
                                    focusNode: lastNameFocusNode,
                                    onFocusAction: () {
                                      lastNameFocusNode.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(businessNameFocusNode);
                                    },
                                    capitalization: TextCapitalization.words,
                                    enabled: true,
                                    obscureText: false,
                                  ),
                                  LoginTextField(
                                    controller: businessNameTextController,
                                    hintText: 'Business name',
                                    labelText: 'Business name',
                                    inputType: TextInputType.text,
                                    height: 64.0,
                                    inputTypeError: '',
                                    onTextInputChanged: (firstNameText) => pageState.onBusinessNameChanged(firstNameText),
                                    onEditingCompleted: null,
                                    keyboardAction: TextInputAction.done,
                                    focusNode: businessNameFocusNode,
                                    onFocusAction: () {
                                      businessNameFocusNode.unfocus();
                                    },
                                    capitalization: TextCapitalization.words,
                                    enabled: true,
                                    obscureText: false,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      pageState.onSaveUpdatedProfile();
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 32.0, left: 84.0, right: 84.0),
                                      alignment: Alignment.center,
                                      height: 64.0,
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
                                  ),
                                ],
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
