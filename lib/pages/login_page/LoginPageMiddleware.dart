import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FireStoreSync.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

import 'LoginPageActions.dart';

class LoginPageMiddleware extends MiddlewareClass<AppState> {
  bool _syncFinished = false;
  bool _animationFinished = false;

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
    List<Profile> profiles = await ProfileDao.getAllSortedByFirstName();
    Profile profile;
    if(profiles != null && profiles.length > 0) {
      profile = profiles.elementAt(0);
    }
    if (user != null && user.isEmailVerified && profile != null && profile.signedIn) {
      ProfileDao.updateUserLoginTime(user.uid);
      store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
    } else {
      store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
      await _auth.signInWithEmailAndPassword(
              email: store.state.loginPageState.emailAddress,
              password: store.state.loginPageState.password).then((authResult) async {
        if (authResult.user != null) {
          UidUtil().setUid(authResult.user.uid);
          if(profile == null){
            ProfileDao.insertLocal(await UserCollection().getUser(user.uid));
            await FireStoreSync().dandyLightAppInitializationSync();
            //TODO it worked. but now it is not copying everything from cloud. i need a new function to just copy all of cloud to local.
          }
        }
        if (authResult.user != null && authResult.user.isEmailVerified) {
          List<Profile> userProfiles = await ProfileDao.getAll();
          if (userProfiles.isNotEmpty) {
            Profile updatedProfile = userProfiles.elementAt(0).copyWith(
                firstName: store.state.loginPageState.firstName,
                lastName: store.state.loginPageState.lastName,
                businessName: store.state.loginPageState.businessName,
                email: store.state.loginPageState.emailAddress,
                signedIn: true,
                lastSignIn: DateTime.now());
            ProfileDao.insertOrUpdate(updatedProfile);
          }
          store.dispatch(
              UpdateNavigateToHomeAction(store.state.loginPageState, true));
        } else if (user != null && !user.isEmailVerified) {
          store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, true));
          VibrateUtil.vibrateHeavy();
          store.dispatch(AnimateLoginErrorMessageAction(store.state.loginPageState, true));
          ProfileDao.updateUserLoginTime(user.uid);
        }
        store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, false));
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
        List<Profile> userProfiles = await ProfileDao.getAll();
        if(userProfiles.isNotEmpty) {
          Profile updatedProfile = userProfiles.elementAt(0).copyWith(
            uid: user.uid,
            firstName: store.state.loginPageState.firstName,
            lastName: store.state.loginPageState.lastName,
            businessName: store.state.loginPageState.businessName,
            email: store.state.loginPageState.emailAddress,
            signedIn: false,
          );
          ProfileDao.insertOrUpdate(updatedProfile);
        } else {
          Profile newProfile = Profile(
            uid: user.uid,
            firstName: store.state.loginPageState.firstName,
            lastName: store.state.loginPageState.lastName,
            businessName: store.state.loginPageState.businessName,
            email: store.state.loginPageState.emailAddress,
            signedIn: false,
          );
          ProfileDao.insertOrUpdate(newProfile);
        }
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
    List<Profile> userProfiles = await ProfileDao.getAll();
    Profile profile;
    if(userProfiles.isNotEmpty){
      profile = userProfiles.elementAt(0);
      store.dispatch(UpdateEmailAddressAction(store.state.loginPageState, profile.email));
    }

    final FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseUser user = await _auth.currentUser();
    if (user != null && user.isEmailVerified && profile != null && (profile.signedIn ?? false)) {
      store.dispatch(SetIsUserVerifiedAction(store.state.loginPageState, user.isEmailVerified));
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
      store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
      UidUtil().setUid(user.uid);
      await FireStoreSync().dandyLightAppInitializationSync().then((value) {
        _syncFinished = true;
        if(_animationFinished) {
          ProfileDao.updateUserLoginTime(user.uid);
          store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
        }
      });
      await Future.delayed(const Duration(milliseconds: 2500), () {
        _animationFinished = true;
        if(_syncFinished) {
          ProfileDao.updateUserLoginTime(user.uid);
          store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
        }
      });
    }else if(user != null && !user.isEmailVerified){
      store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, true));
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
    }else if(user != null && user.isEmailVerified && !profile.signedIn){
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
    }else {

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