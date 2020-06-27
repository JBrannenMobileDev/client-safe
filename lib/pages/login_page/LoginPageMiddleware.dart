import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

import 'LoginPageActions.dart';

class LoginPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is CreateAccountAction) {
      _createAccount(store, action, next);
    }
    if(action is CheckForCurrentUserAction){
      _checkForCurrentUser(store, action, next);
    }
    if(action is LoginAction){
      _signIn(store, action, next);
    }
    if(action is ResendEmailVerificationAction){
      _resendEmailVerification(store, action, next);
    }
  }

  void _signIn(Store<AppState> store, LoginAction action, next) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    if (user != null && user.isEmailVerified) {
      store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
    } else {
      store
          .dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
      await _auth
          .signInWithEmailAndPassword(
              email: store.state.loginPageState.emailAddress,
              password: store.state.loginPageState.password)
          .then((authResult) async {
        if (authResult.user != null && authResult.user.isEmailVerified) {
          Profile profile = await ProfileDao.getByUid(authResult.user.uid).then((profile) => profile.copyWith(
              firstName: store.state.loginPageState.firstName,
              lastName: store.state.loginPageState.lastName,
              businessName: store.state.loginPageState.businessName,
              email: store.state.loginPageState.emailAddress,
              signedIn: true,
            )
          );
          ProfileDao.update(profile);
          store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
        } else if (user != null && !user.isEmailVerified) {
          store.dispatch(
              UpdateShowResendMessageAction(store.state.loginPageState, true));
          VibrateUtil.vibrateHeavy();
          store.dispatch(
              AnimateLoginErrorMessageAction(store.state.loginPageState, true));
        }
        store.dispatch(
            UpdateShowLoginAnimation(store.state.loginPageState, false));
      }).catchError((error) {
        PlatformException exception = error;
        String errorMessage = '';
        switch (exception.code) {
          case 'FIRAuthErrorCodeInvalidEmail':
          case 'FIRAuthErrorCodeUserDisabled':
          case 'FIRAuthErrorCodeWrongPassword':
            errorMessage = exception.message;
            break;
          default:
            errorMessage = 'There was an error while attempting to sign in.';
            break;
        }
        store.dispatch(SetSignInErrorMessageAction(
            store.state.loginPageState, errorMessage));
        VibrateUtil.vibrateHeavy();
        store.dispatch(
            UpdateShowLoginAnimation(store.state.loginPageState, false));
      });
    }
  }

  void _createAccount(Store<AppState> store, CreateAccountAction action, next) async {
    store.dispatch(UpdateShowCreateAccountAnimation(store.state.loginPageState, true));
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if(store.state.loginPageState.firstName.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'First name is required'));
      VibrateUtil.vibrateMultiple();
    } else if(store.state.loginPageState.lastName.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'Last name is required'));
      VibrateUtil.vibrateMultiple();
    } else if(store.state.loginPageState.emailAddress.isNotEmpty && store.state.loginPageState.password.isNotEmpty){
      FirebaseUser user = await FirebaseAuthentication().registerFirebaseUser(store.state.loginPageState.emailAddress, store.state.loginPageState.password, _auth)
          .catchError((error) {
        store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, error.message));
        VibrateUtil.vibrateMultiple();
      });
      if(user != null && !user.isEmailVerified){
        await store.dispatch(SetShowAccountCreatedDialogAction(store.state.loginPageState, true, user));
        Profile profile = await ProfileDao.getByUid(user.uid).then((profile) => profile.copyWith(
          firstName: store.state.loginPageState.firstName,
          lastName: store.state.loginPageState.lastName,
          businessName: store.state.loginPageState.businessName,
          email: store.state.loginPageState.emailAddress,
          signedIn: false,
        )
        );
        ProfileDao.update(profile);
      }
    } else {
      String errorMessage = '';
      if(store.state.loginPageState.emailAddress.isEmpty) {
        errorMessage = 'Email address is required.';
      }

      if(store.state.loginPageState.lastName.isEmpty) {
        errorMessage = 'Password is required.';
      }
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, errorMessage));
      VibrateUtil.vibrateMultiple();
    }
  }

  void _checkForCurrentUser(Store<AppState> store, CheckForCurrentUserAction action, next) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();

    Profile profile;
    if(user != null){
      UidUtil().setUid(user.uid);
      profile = await ProfileDao.getByUid(user.uid);
      if(profile != null) {
        store.dispatch(UpdateEmailAddressAction(store.state.loginPageState, profile.email));
      }
    }

    if (user != null && user.isEmailVerified && profile != null && (profile.signedIn ?? false)) {
      store.dispatch(SetIsUserVerifiedAction(store.state.loginPageState, user.isEmailVerified));
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
      store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
      await Future.delayed(const Duration(milliseconds: 2500), () {
        UidUtil().setUid(profile.uid);
        store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
      });
    }else if(user != null && !user.isEmailVerified){
      store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, true));
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
    }else if(user != null && user.isEmailVerified && !profile.signedIn){
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
    }
  }

  void _sendEmailVerification(FirebaseUser user, String message, Store<AppState> store) {
    user.sendEmailVerification();
    DandyToastUtil.showToast(message, Color(ColorConstants.getPrimaryColor()));
    store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
  }

  void _resendEmailVerification(Store<AppState> store, ResendEmailVerificationAction action, next) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    _sendEmailVerification(user, 'Email verification resent', store);
  }
}