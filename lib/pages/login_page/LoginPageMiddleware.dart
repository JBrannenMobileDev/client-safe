import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/GlobalKeyUtil.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
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
      //go to home
    } else {
      await _auth.signInWithEmailAndPassword(email: store.state.loginPageState.emailAddress, password: store.state.loginPageState.password)
          .then((authResult) => {
        if(authResult.user != null && user.isEmailVerified) {
          //go to home
        }
      }).catchError((error) {
        print(error);
      });
    }
  }

  void _createAccount(Store<AppState> store, CreateAccountAction action, next) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    if (user != null && user.isEmailVerified) {
      NavigationUtil.onSuccessfulLogin(GlobalKeyUtil.instance.navigatorKey.currentContext);
    } else if(user != null && !user.isEmailVerified){
      _sendEmailVerification(user, 'Email verification sent');
    } else {
      FirebaseUser user = await FirebaseAuthentication()
          .registerFirebaseUser(store.state.loginPageState.emailAddress, store.state.loginPageState.password, _auth)
          .catchError((error) => print(error));
      if(user.isEmailVerified){
        NavigationUtil.onSuccessfulLogin(GlobalKeyUtil.instance.navigatorKey.currentContext);
      } else {
        _sendEmailVerification(user, 'Email verification sent');
      }
    }
  }

  void _checkForCurrentUser(Store<AppState> store, CheckForCurrentUserAction action, next) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    if (user != null && user.isEmailVerified) {
      NavigationUtil.onSuccessfulLogin(GlobalKeyUtil.instance.navigatorKey.currentContext);
    }else if(user != null && !user.isEmailVerified){
      //TODO show resend UI message by changing the mainButtonsVisible flag.
    }
  }

  void _sendEmailVerification(FirebaseUser user, String message) {
    user.sendEmailVerification();
    DandyToastUtil.showToast(message, Color(ColorConstants.getPrimaryColor()));
    //TODO show login view  move mainButtonsVisible to pageState;
  }

  void _resendEmailVerification(Store<AppState> store, ResendEmailVerificationAction action, next) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    _sendEmailVerification(user, 'Email verification resent');
  }
}