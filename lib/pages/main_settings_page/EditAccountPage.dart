import 'dart:async';
import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/common_widgets/LoginTextField.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../../utils/DeviceType.dart';
import '../../utils/NavigationUtil.dart';
import '../../widgets/TextDandyLight.dart';
import 'MainSettingsPageActions.dart';

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
  TextEditingController businessEmailTextController = TextEditingController();
  TextEditingController businessPhoneTextController = TextEditingController();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final businessNameFocusNode = FocusNode();
  final businessEmailFocusNode = FocusNode();
  final businessPhoneFocusNode = FocusNode();

  _EditAccountPageState(this.profile);

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, MainSettingsPageState>(
        onInit: (store) {
          store.dispatch(LoadUserProfileDataAction(
              store.state.mainSettingsPageState, profile));
          if (profile.firstName != null && profile.firstName!.isNotEmpty) {
            firstNameTextController.text = profile.firstName ?? '';
          }
          if (profile.lastName != null && profile.lastName!.isNotEmpty) {
            lastNameTextController.text = profile.lastName ?? '';
          }
          if (profile.businessName != null && profile.businessName!.isNotEmpty) {
            businessNameTextController.text = profile.businessName ?? '';
          }
          if (profile.phone != null && profile.phone!.isNotEmpty) {
            businessPhoneTextController.text = profile.phone ?? '';
          }
          if (profile.email != null && profile.email!.isNotEmpty) {
            businessEmailTextController.text = profile.email ?? '';
          }
        },
        converter: (Store<AppState> store) =>
            MainSettingsPageState.fromStore(store),
        builder: (BuildContext context, MainSettingsPageState pageState) =>
            Scaffold(
          backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
          body: Container(
            decoration: BoxDecoration(
              color: Color(ColorConstants.getPrimaryBackgroundGrey()),
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: Color(ColorConstants
                        .getPrimaryBlack()), //change your color here
                  ),
                  backgroundColor:
                      Color(ColorConstants.getPrimaryBackgroundGrey()),
                  pinned: true,
                  centerTitle: true,
                  elevation: 2.0,
                  title: TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: "My Profile",
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
                SliverPadding(
                  padding: DeviceType.getDeviceType() == Type.Tablet
                      ? const EdgeInsets.only(left: 150, right: 150)
                      : const EdgeInsets.only(left: 0, right: 0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 56.0),
                              alignment: Alignment.centerLeft,
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'First name',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            LoginTextField(
                              maxLines: 1,
                              controller: firstNameTextController,
                              hintText: 'First name',
                              labelText: 'First name',
                              inputType: TextInputType.text,
                              height: 64.0,
                              inputTypeError: 'First name is required',
                              onTextInputChanged: (firstNameText) =>
                                  pageState.onFirstNameChanged!(firstNameText),
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
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 56.0, top: 8.0),
                              alignment: Alignment.centerLeft,
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'Last name',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            LoginTextField(
                              maxLines: 1,
                              controller: lastNameTextController,
                              hintText: 'Last name',
                              labelText: 'Last name',
                              inputType: TextInputType.text,
                              height: 64.0,
                              inputTypeError: 'Last name is required',
                              onTextInputChanged: (firstNameText) =>
                                  pageState.onLastNameChanged!(firstNameText),
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
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 56.0, top: 8.0),
                              alignment: Alignment.centerLeft,
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'Business name',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            LoginTextField(
                              maxLines: 1,
                              controller: businessNameTextController,
                              hintText: 'Business name',
                              labelText: 'Business name',
                              inputType: TextInputType.text,
                              height: 64.0,
                              inputTypeError: '',
                              onTextInputChanged: (firstNameText) => pageState
                                  .onBusinessNameChanged!(firstNameText),
                              onEditingCompleted: null,
                              keyboardAction: TextInputAction.next,
                              focusNode: businessNameFocusNode,
                              onFocusAction: () {
                                businessNameFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(businessEmailFocusNode);
                              },
                              capitalization: TextCapitalization.words,
                              enabled: true,
                              obscureText: false,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 56.0, top: 8.0),
                              alignment: Alignment.centerLeft,
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'Business email',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            LoginTextField(
                              maxLines: 1,
                              controller: businessEmailTextController,
                              hintText: 'Business name',
                              labelText: 'Business name',
                              inputType: TextInputType.emailAddress,
                              height: 64.0,
                              inputTypeError: '',
                              onTextInputChanged: (firstNameText) => pageState
                                  .onBusinessEmailChanged!(firstNameText),
                              onEditingCompleted: null,
                              keyboardAction: TextInputAction.next,
                              focusNode: businessEmailFocusNode,
                              onFocusAction: () {
                                businessEmailFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(businessPhoneFocusNode);
                              },
                              enabled: true,
                              obscureText: false,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 56.0, top: 8.0),
                              alignment: Alignment.centerLeft,
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'Business phone',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            LoginTextField(
                              maxLines: 1,
                              controller: businessPhoneTextController,
                              hintText: 'Business phone',
                              labelText: 'Business phone',
                              inputType: TextInputType.phone,
                              height: 64.0,
                              inputTypeError: '',
                              onTextInputChanged: (phone) =>
                                  pageState.onBusinessPhoneChanged!(phone),
                              onEditingCompleted: null,
                              keyboardAction: TextInputAction.done,
                              focusNode: businessPhoneFocusNode,
                              onFocusAction: () {
                                businessPhoneFocusNode.unfocus();
                              },
                              capitalization: TextCapitalization.words,
                              enabled: true,
                              obscureText: false,
                            ),
                            Container(
                              margin:
                              const EdgeInsets.only(left: 56.0, top: 8.0),
                              alignment: Alignment.centerLeft,
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'Home location',
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                NavigationUtil.onSelectMapLocation(
                                    context,
                                    null,
                                    0.0,
                                    0.0,
                                    pageState.onHomeLocationChanged
                                );
                              },
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 8.0),
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Color(ColorConstants.getPrimaryWhite()),
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                  child: TextDandyLight(
                                    type: TextDandyLight.MEDIUM_TEXT,
                                    text: pageState.homeAddressName,
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                pageState.onSaveUpdatedProfile!();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 32.0, left: 84.0, right: 84.0),
                                alignment: Alignment.center,
                                height: 54.0,
                                decoration: BoxDecoration(
                                    color: Color(ColorConstants.getBlueDark()),
                                    borderRadius: BorderRadius.circular(32.0)),
                                child: TextDandyLight(
                                  type: TextDandyLight.LARGE_TEXT,
                                  text: 'Save',
                                  textAlign: TextAlign.center,
                                  color:
                                      Color(ColorConstants.getPrimaryWhite()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
