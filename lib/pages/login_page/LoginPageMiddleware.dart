import 'dart:ui';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FireStoreSync.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ResponseDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/ReminderDandyLight.dart';
import 'package:dandylight/pages/manage_subscription_page/ManageSubscriptionPage.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/InputValidator.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

import '../../models/Response.dart';
import '../../utils/PushNotificationsManager.dart';
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
    if(action is ResetPasswordAction) {
      _resetPassword(store, action, next);
    }
  }
  
  void _resetPassword(Store<AppState> store, ResetPasswordAction action, next) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.sendPasswordResetEmail(email: store.state.loginPageState.emailAddress).then((authResult) async {
      await store.dispatch(SetResetPasswordSentDialogAction(store.state.loginPageState, true));
    }).catchError((error) {
      if(error is FirebaseAuthException) {
        FirebaseAuthException exception = error;
        String errorMessage = '';
        switch (exception.code) {
          case 'invalid-email':
            errorMessage = "That is not a valid email address.";
            break;
          default:
            errorMessage = 'Are you sure that was the correct email address? Something went wrong.';
            break;
        }
        store.dispatch(SetSignInErrorMessageAction(store.state.loginPageState, errorMessage));
      } else {
        store.dispatch(SetSignInErrorMessageAction(store.state.loginPageState, "Something went wrong."));
      }
      VibrateUtil.vibrateHeavy();
    });
  }

  void _signIn(Store<AppState> store, LoginAction action, next) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = await _auth.currentUser;
    List<Profile> profiles = await ProfileDao.getAllSortedByFirstName();
    Profile profile;

    if (user != null && user.emailVerified && profile != null) {
      if(profiles != null && profiles.length > 0) {
        profile = getMatchingProfile(profiles, user.email);
      }
      ProfileDao.updateUserLoginTime(user.uid);
      store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
      bool shouldShowRestoreSubscription = profile.addUniqueDeviceToken(await PushNotificationsManager().getToken()) && !profile.isFirstDevice();
      profile.shouldShowRestoreSubscription = shouldShowRestoreSubscription;
      await ProfileDao.update(profile);
      await EventSender().setUserIdentity(user.uid);
    } else {
      store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
      await _auth.signInWithEmailAndPassword(
              email: store.state.loginPageState.emailAddress,
              password: store.state.loginPageState.password).then((authResult) async {
        if (authResult.user != null) {
          UidUtil().setUid(authResult.user.uid);
          EventSender().setUserIdentity(authResult.user.uid);
          if(profile == null) {
            Profile fireStoreProfile = await UserCollection().getUser(authResult.user.uid) ?? Profile();
            if (fireStoreProfile.clientsLastChangeDate != null)
              fireStoreProfile.clientsLastChangeDate = DateTime(1970);
            if (fireStoreProfile.invoicesLastChangeDate != null)
              fireStoreProfile.invoicesLastChangeDate = DateTime(1970);
            if (fireStoreProfile.jobsLastChangeDate != null)
              fireStoreProfile.jobsLastChangeDate = DateTime(1970);
            if (fireStoreProfile.locationsLastChangeDate != null)
              fireStoreProfile.locationsLastChangeDate = DateTime(1970);
            if (fireStoreProfile.mileageExpensesLastChangeDate != null)
              fireStoreProfile.mileageExpensesLastChangeDate = DateTime(1970);
            if (fireStoreProfile.priceProfilesLastChangeDate != null)
              fireStoreProfile.priceProfilesLastChangeDate = DateTime(1970);
            if (fireStoreProfile.recurringExpensesLastChangeDate != null)
              fireStoreProfile.recurringExpensesLastChangeDate = DateTime(1970);
            if (fireStoreProfile.singleExpensesLastChangeDate != null)
              fireStoreProfile.singleExpensesLastChangeDate = DateTime(1970);
            if (fireStoreProfile.nextInvoiceNumberLastChangeDate != null)
              fireStoreProfile.nextInvoiceNumberLastChangeDate = DateTime(1970);
            await ProfileDao.insertLocal(fireStoreProfile);
            await FireStoreSync().dandyLightAppInitializationSync(authResult.user.uid);
          }
        }
        if (authResult.user != null && authResult.user.emailVerified) {
          store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, false));
          profile = await ProfileDao.getMatchingProfile(authResult.user.uid);
          bool shouldShowRestoreSubscription = profile.addUniqueDeviceToken(await PushNotificationsManager().getToken()) && !profile.isFirstDevice();
          profile.shouldShowRestoreSubscription = shouldShowRestoreSubscription;
          await ProfileDao.update(profile);
          store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
        } else if (authResult.user != null && !authResult.user.emailVerified) {
          store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, true));
          VibrateUtil.vibrateHeavy();
          store.dispatch(AnimateLoginErrorMessageAction(store.state.loginPageState, true));
        }
        store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, false));
      }).catchError((error) {
        if(error is FirebaseAuthException) {
          FirebaseAuthException exception = error;
          String errorMessage = '';
          switch (exception.code) {
            case 'ERROR_USER_NOT_FOUND':
            case 'ERROR_WRONG_PASSWORD':
              errorMessage = 'Username or password is incorrect.';
              break;
            case 'ERROR_INVALID_EMAIL':
              errorMessage = exception.message;
              break;
            default:
              errorMessage = 'Username or password is incorrect.';
              break;
          }
          store.dispatch(SetSignInErrorMessageAction(store.state.loginPageState, errorMessage));
          VibrateUtil.vibrateHeavy();
          store.dispatch(
              UpdateShowLoginAnimation(store.state.loginPageState, false));
        } else {
          store.dispatch(SetSignInErrorMessageAction(store.state.loginPageState, 'Something went wrong.'));
          VibrateUtil.vibrateHeavy();
          store.dispatch(
              UpdateShowLoginAnimation(store.state.loginPageState, false));
        }
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
    } else if(store.state.loginPageState.emailAddress.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'Email Address is required'));
      VibrateUtil.vibrateMultiple();
    } else if(store.state.loginPageState.password.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'Password is required'));
      VibrateUtil.vibrateMultiple();
    } else if(!InputValidator.isValidPasswordMedium(store.state.loginPageState.password)) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, InputValidator.login_invalid_password_error_msg));
      VibrateUtil.vibrateMultiple();
    } else {
      User user = await FirebaseAuthentication().registerFirebaseUser(store.state.loginPageState.emailAddress, store.state.loginPageState.password, _auth)
          .catchError((error) {
        store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, error.message));
        VibrateUtil.vibrateMultiple();
      });
      if(user != null) {
        await EventSender().sendEvent(eventName: EventNames.API_CREATE_ACCOUNT_SUCCESS);
        await EventSender().setUserIdentity(user.uid);
        await EventSender().setUserProfileData(EventNames.FIRST_NAME, store.state.loginPageState.firstName);
        await EventSender().setUserProfileData(EventNames.LAST_NAME, store.state.loginPageState.lastName);
        await EventSender().setUserProfileData(EventNames.EMAIL, store.state.loginPageState.emailAddress);
        await EventSender().setUserProfileData(EventNames.BUSINESS_NAME, store.state.loginPageState.businessName);
        await EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.FREE_TRIAL);
      }
      if(user != null && !user.emailVerified){
        List<Profile> userProfiles = await ProfileDao.getAll();
        if(userProfiles.isNotEmpty) {
          for(Profile profile in userProfiles) {
            await ProfileDao.delete(profile);
          }
        }
        Profile newProfile = Profile(
            uid: user.uid,
            referralUid: Uuid().v1().substring(0, 8),
            firstName: store.state.loginPageState.firstName,
            lastName: store.state.loginPageState.lastName,
            businessName: store.state.loginPageState.businessName,
            email: store.state.loginPageState.emailAddress,
            calendarEnabled: false,
            pushNotificationsEnabled: false,
            accountCreatedDate: DateTime.now(),
          );
        await ProfileDao.insertOrUpdate(newProfile);
        await store.dispatch(SetShowAccountCreatedDialogAction(store.state.loginPageState, true, user));
      }
    }
  }

  void _checkForCurrentUser(Store<AppState> store, CheckForCurrentUserAction action, next) async{
    await Future.delayed(Duration(seconds: 1));
    store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, false));
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = await _auth.currentUser;

    List<Profile> deviceProfiles = await ProfileDao.getAll();
    Profile profile;

    if (user != null && user.emailVerified) {
      if(deviceProfiles.isNotEmpty){
        profile = getMatchingProfile(deviceProfiles, user.email);
        if(profile != null) {
          store.dispatch(UpdateEmailAddressAction(store.state.loginPageState, profile.email));
        }
        store.dispatch(SetIsUserVerifiedAction(store.state.loginPageState, user.emailVerified));
        store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
        store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
        UidUtil().setUid(user.uid);
        await EventSender().setUserIdentity(user.uid);
        await FireStoreSync().dandyLightAppInitializationSync(user.uid).then((value) async {
          store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
          ProfileDao.updateUserLoginTime(user.uid);
          store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
        });
      } else {
        store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
        _auth.signOut();
      }
    }else if(user != null && !user.emailVerified){
      store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
      store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, true));
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
    }else if(user == null){
      store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
      store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, true));
    }
  }

  void _sendEmailVerification(User user, String message, Store<AppState> store) {
    user.sendEmailVerification();
    DandyToastUtil.showToast(message, Color(ColorConstants.getPrimaryColor()));
    store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
  }

  void _resendEmailVerification(Store<AppState> store, ResendEmailVerificationAction action, next) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = await _auth.currentUser;
    _sendEmailVerification(user, 'Email verification resent', store);
  }

  Profile getMatchingProfile(List<Profile> profiles, String email) {
    Profile result = null;
    for(Profile profile in profiles) {
      if(profile.email == email) {
        result = profile;
      }
    }
    return result;
  }
}