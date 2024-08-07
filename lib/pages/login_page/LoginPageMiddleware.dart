import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FireStoreSync.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/firebase/collections/UserCollection.dart';
import 'package:dandylight/data_layer/local_db/daos/AppSettingsDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractTemplateDao.dart';
import 'package:dandylight/data_layer/local_db/daos/LocationDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/data_layer/local_db/daos/QuestionnaireTemplateDao.dart';
import 'package:dandylight/data_layer/local_db/daos/QuestionnairesDao.dart';
import 'package:dandylight/data_layer/local_db/daos/ResponseDao.dart';
import 'package:dandylight/data_layer/repositories/FileStorage.dart';
import 'package:dandylight/data_layer/repositories/PendingEmailsRepository.dart';
import 'package:dandylight/models/FontTheme.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/SessionType.dart';
import 'package:http/http.dart' as http;
import 'package:dandylight/models/PoseLibraryGroup.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Question.dart';
import 'package:dandylight/models/Questionnaire.dart';
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
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redux/redux.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../../data_layer/api_clients/DandylightFunctionsClient.dart';
import '../../data_layer/local_db/SembastDb.dart';
import '../../data_layer/local_db/daos/ClientDao.dart';
import '../../data_layer/local_db/daos/JobDao.dart';
import '../../data_layer/local_db/daos/JobTypeDao.dart';
import '../../data_layer/local_db/daos/PoseLibraryGroupDao.dart';
import '../../data_layer/local_db/daos/PriceProfileDao.dart';
import '../../data_layer/local_db/daos/ReminderDao.dart';
import '../../data_layer/local_db/daos/SessionTypeDao.dart';
import '../../models/Client.dart';
import '../../models/ColorTheme.dart';
import '../../models/Job.dart';
import '../../models/JobStage.dart';
import '../../models/JobType.dart';
import '../../models/LineItem.dart';
import '../../models/LocationDandy.dart';
import '../../models/Pose.dart';
import '../../models/PriceProfile.dart';
import '../../models/Progress.dart';
import '../../models/Proposal.dart';
import '../../models/Response.dart';
import '../../utils/AppleSignInAvailable.dart';
import '../../utils/PushNotificationsManager.dart';
import '../new_reminder_page/WhenSelectionWidget.dart';
import 'LoginPageActions.dart';

class LoginPageMiddleware extends MiddlewareClass<AppState> {

  static const String EMAIL = 'email';
  static const String APPLE = 'apple';
  static const String GOOGLE = 'google';

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
    if(action is SignUpWithAppleAction) {
      _signUpWithAppleFlow(store, action, next);
    }
    if(action is SignUpWithGoogleAction) {
      _signUpWithGoogleFlow(store, action, next);
    }
  }

  void _signUpWithGoogleFlow(Store<AppState> store, SignUpWithGoogleAction action, next) async {
    store.dispatch(SetShowLoadingAnimationAction(store.state.loginPageState, true));
    final firebaseAuth = FirebaseAuth.instance;

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      Profile? existingProfile = await UserCollection().getUser(userCredential.user!.uid);

      if(existingProfile == null) {
        List<String> names = googleSignInAccount.displayName!.split(' ');
        String firstName = names.length > 0 ? names.elementAt(0) : '';
        String lastName = names.length >= 2 ? names.elementAt(1) : '';
        String email = userCredential.user!.email!;
        final user = userCredential.user;
        await user!.updateDisplayName(firstName);
        _createNewUserProfile(store, user, firstName, lastName, email, GOOGLE);
      } else {
        _loginAfterSignIn(store, existingProfile);
      }
    } catch(ex) {
      store.dispatch(SetShowLoadingAnimationAction(store.state.loginPageState, false));
      print(ex.toString());
    }
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _signUpWithAppleFlow(Store<AppState> store, SignUpWithAppleAction action, next) async {
    store.dispatch(SetShowLoadingAnimationAction(store.state.loginPageState, true));
    final firebaseAuth = FirebaseAuth.instance;
    List<AppleIDAuthorizationScopes> scopes = [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName];
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: scopes,
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      final userCredential = await firebaseAuth.signInWithCredential(oauthCredential);
      Profile? existingProfile = await UserCollection().getUser(userCredential.user!.uid);
      if(existingProfile == null) {
        String firstName = '';
        String lastName = '';
        String email = userCredential.user?.email ?? '';
        final user = userCredential.user;
        final displayName = '${appleCredential.givenName} ${appleCredential.familyName}';
        firstName = appleCredential.givenName ?? 'Photographer';
        lastName = appleCredential.familyName ?? '';
        await user!.updateDisplayName(displayName);
        _createNewUserProfile(store, user, firstName, lastName, email, APPLE);
      } else {
        _loginAfterSignIn(store, existingProfile);
      }
    } catch(ex) {
      store.dispatch(SetShowLoadingAnimationAction(store.state.loginPageState, false));
      print(ex.toString());
    }
  }

  void _loginAfterSignIn(Store<AppState> store, Profile existingProfile) async {
    UidUtil().setUid(existingProfile.uid!);
    await ProfileDao.insertLocal(existingProfile);
    await FireStoreSync().dandyLightAppInitializationSync(existingProfile.uid!);
    await PoseLibraryGroupDao.syncAllFromFireStore();
    await ContractTemplateDao.syncAllFromFireStore();
    await AppSettingsDao.syncAllFromFireStore();
    ProfileDao.updateUserLoginTime(existingProfile.uid!);
    String? token = await PushNotificationsManager().getToken();
    bool newDevice = false;
    if(token != null) {
      newDevice = existingProfile.addUniqueDeviceToken(token);
    }
    bool shouldShowRestoreSubscription = newDevice && !existingProfile.isFirstDevice();
    existingProfile.shouldShowRestoreSubscription = shouldShowRestoreSubscription;
    await ProfileDao.update(existingProfile);
    EventSender().setUserIdentity(existingProfile.uid!);
    setShouldShowOnBoarding(store, existingProfile);
  }

  void setShouldShowOnBoarding(Store<AppState> store, Profile existingProfile) async {
    if(existingProfile.onBoardingComplete! || (await JobDao.getAllJobs())!.length > 1) {
      store.dispatch(UpdateNavigateToOnBoardingAction(store.state.loginPageState, false));
      store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, true));
    } else {
      store.dispatch(UpdateNavigateToOnBoardingAction(store.state.loginPageState, true));
    }
  }
  
  void _resetPassword(Store<AppState> store, ResetPasswordAction action, next) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.sendPasswordResetEmail(email: store.state.loginPageState!.emailAddress!).then((authResult) async {
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
    final FirebaseAuth auth = FirebaseAuth.instance;
    Profile? profile;

    await SembastDb.instance.deleteAllLocalData();
    store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
    await auth.signInWithEmailAndPassword(
        email: store.state.loginPageState!.emailAddress!,
        password: store.state.loginPageState!.password!
    ).then((authResult) async {
      if (authResult.user != null) {
        UidUtil().setUid(authResult.user!.uid);
        EventSender().setUserIdentity(authResult.user!.uid);
        if(profile == null) {
          Profile fireStoreProfile = await UserCollection().getUser(authResult.user!.uid) ?? Profile(progress: Progress());
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
          await FireStoreSync().dandyLightAppInitializationSync(authResult.user!.uid);
          await PoseLibraryGroupDao.syncAllFromFireStore();
          await AppSettingsDao.syncAllFromFireStore();
        }
      }
      if (authResult.user != null && authResult.user!.emailVerified) {
        store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, false));
        profile = await ProfileDao.getMatchingProfile(authResult.user!.uid);
        String? token = await PushNotificationsManager().getToken();
        bool newDevice = false;
        if(token != null) {
          newDevice = profile!.addUniqueDeviceToken(token);
        }
        bool shouldShowRestoreSubscription = newDevice && !profile!.isFirstDevice();
        profile!.shouldShowRestoreSubscription = shouldShowRestoreSubscription;
        await ProfileDao.update(profile!);
        setShouldShowOnBoarding(store, profile!);
      } else if (authResult.user != null && !authResult.user!.emailVerified) {
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
            errorMessage = exception.message!;
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
  void _createNewUserProfile(Store<AppState> store, User? user, String firstName, String lastName, String email, String signInType) async {
    if(user != null) {
      UidUtil().setUid(user.uid);
      switch(signInType) {
        case EMAIL:
          EventSender().sendEvent(eventName: EventNames.API_CREATE_ACCOUNT_SUCCESS, properties: {
            EventNames.API_CREATE_ACCOUNT_SUCCESS_EMAIL_SIGN_UP : signInType,
          });
          break;
        case APPLE:
          EventSender().sendEvent(eventName: EventNames.API_CREATE_ACCOUNT_SUCCESS, properties: {
            EventNames.API_CREATE_ACCOUNT_SUCCESS_APPLE_SIGN_UP : signInType,
          });
          break;
        case GOOGLE:
          EventSender().sendEvent(eventName: EventNames.API_CREATE_ACCOUNT_SUCCESS, properties: {
            EventNames.API_CREATE_ACCOUNT_SUCCESS_GOOGLE_SIGN_UP : signInType,
          });
          break;
      }
      EventSender().setUserIdentity(user.uid);
      EventSender().setUserProfileData(EventNames.FIRST_NAME, firstName);
      EventSender().setUserProfileData(EventNames.LAST_NAME, lastName);
      EventSender().setUserProfileData(EventNames.EMAIL, email);
      EventSender().setUserProfileData(EventNames.BUSINESS_NAME, store.state.loginPageState!.businessName!);
      EventSender().setUserProfileData(EventNames.SUBSCRIPTION_STATE, ManageSubscriptionPage.FREE_TRIAL);
      EventSender().setUserProfileData(EventNames.BUILD_VERSION, (await PackageInfo.fromPlatform()).version);
      EventSender().setUserProfileData(EventNames.BUILD_NUMBER, (await PackageInfo.fromPlatform()).buildNumber);
    }
    if(user != null && (signInType == EMAIL && !user.emailVerified) || signInType != EMAIL){
      List<Profile>? userProfiles = await ProfileDao.getAll();
      if(userProfiles!.isNotEmpty) {
        for(Profile profile in userProfiles) {
          await ProfileDao.delete(profile);
        }
      }
      await ContractTemplateDao.syncAllFromFireStore();
      await QuestionnaireTemplateDao.syncAllFromFireStore();
      Profile newProfile = Profile(
        uid: user!.uid,
        referralUid: Uuid().v1().substring(0, 8),
        progress: Progress(),
        firstName: firstName,
        lastName: lastName,
        businessName: store.state.loginPageState!.businessName,
        email: email,
        calendarEnabled: false,
        pushNotificationsEnabled: false,
        accountCreatedDate: DateTime.now(),
        onBoardingComplete: false,
        isSubscribed: false,
        bannerImageSelected: true,
        previewBannerImageSelected: true,
        bannerMobileUrl: await FileStorage.fetchImagePathForExampleBannerMobile(),
        previewBannerMobileUrl: await FileStorage.fetchImagePathForExampleBannerMobile(),
        bannerWebUrl: await FileStorage.fetchImagePathForExampleBannerWeb(),
        previewBannerWebUrl: await FileStorage.fetchImagePathForExampleBannerWeb(),
        logoSelected: false,
        previewLogoSelected: false,
        logoCharacter: store.state.loginPageState!.businessName != null && store.state.loginPageState!.businessName!.length > 0 ? store.state.loginPageState!.businessName!.substring(0, 1) : 'A',
        previewLogoCharacter: store.state.loginPageState!.businessName != null && store.state.loginPageState!.businessName!.length > 0 ? store.state.loginPageState!.businessName!.substring(0, 1) : 'A',
        selectedColorTheme: ColorTheme(
          themeName: 'default',
          iconColor: ColorConstants.getString(ColorConstants.getBlueDark()),
          iconTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
          buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
          buttonTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
          bannerColor: ColorConstants.getString(ColorConstants.getPrimaryGreyDark()),
        ),
        previewColorTheme: ColorTheme(
          themeName: 'default',
          iconColor: ColorConstants.getString(ColorConstants.getBlueDark()),
          iconTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
          buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
          buttonTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
          bannerColor: ColorConstants.getString(ColorConstants.getPrimaryGreyDark()),
        ),
        selectedFontTheme: FontTheme(
            themeName: 'default',
            iconFont: FontTheme.Moredya,
            mainFont: FontTheme.OPEN_SANS,
        ),
        previewFontTheme: FontTheme(
          themeName: 'default',
          iconFont: FontTheme.Moredya,
          mainFont: FontTheme.OPEN_SANS,
        ),
        previewJsonContract: (await ContractTemplateDao.getAll())!.first.jsonTerms,
      );
      await ProfileDao.insertOrUpdate(newProfile);
      PendingEmailsRepository(functions: DandylightFunctionsApi(httpClient: http.Client())).sendAccountCreatedEmails();

      //Creating responses
      List<Response> defaultResponses = [];
      defaultResponses.add(Response(
        title: 'Reply to initial inquiry',
        message: '',
        parentGroup: Response.GROUP_TITLE_PRE_BOOKING,
      ));
      defaultResponses.add(Response(
        title: 'I am unavailable on that date',
        message: '',
        parentGroup: Response.GROUP_TITLE_PRE_BOOKING,
      ));
      defaultResponses.add(Response(
        title: 'Confirm deposit paid',
        message: '',
        parentGroup: Response.GROUP_TITLE_PRE_PHOTOSHOOT,
      ));
      defaultResponses.add(Response(
        title: 'What to expect',
        message: '',
        parentGroup: Response.GROUP_TITLE_PRE_PHOTOSHOOT,
      ));
      defaultResponses.add(Response(
        title: 'What to wear',
        message: '',
        parentGroup: Response.GROUP_TITLE_PRE_PHOTOSHOOT,
      ));
      defaultResponses.add(Response(
        title: 'Upcoming photoshoot reminder',
        message: '',
        parentGroup: Response.GROUP_TITLE_PRE_PHOTOSHOOT,
      ));
      defaultResponses.add(Response(
        title: 'Thank you',
        message: '',
        parentGroup: Response.GROUP_TITLE_POST_PHOTOSHOOT,
      ));
      defaultResponses.add(Response(
        title: 'Your photos are ready',
        message: '',
        parentGroup: Response.GROUP_TITLE_POST_PHOTOSHOOT,
      ));
      for(Response response in defaultResponses) {
        await ResponseDao.insertOrUpdate(response);
      }

      //Creating Reminders
      DateTime now = DateTime.now();
      ReminderDandyLight chargeCameraReminder = ReminderDandyLight(description: 'Charge Camera', when: WhenSelectionWidget.BEFORE, daysWeeksMonths: WhenSelectionWidget.DAYS, amount: 1, time: DateTime(now.year, now.month, now.day, 8, 30));
      ReminderDandyLight cleanCameraReminder = ReminderDandyLight(description: 'Clean Lenses', when: WhenSelectionWidget.BEFORE, daysWeeksMonths: WhenSelectionWidget.DAYS, amount: 1, time: DateTime(now.year, now.month, now.day, 8, 30));
      ReminderDandyLight oneWeekCheckInReminder = ReminderDandyLight(description: '1 Week Check-in', when: WhenSelectionWidget.BEFORE, daysWeeksMonths: WhenSelectionWidget.WEEKS, amount: 1, time: DateTime(now.year, now.month, now.day, 8, 30));
      await ReminderDao.insertOrUpdate(chargeCameraReminder);
      await ReminderDao.insertOrUpdate(cleanCameraReminder);
      await ReminderDao.insertOrUpdate(oneWeekCheckInReminder);

      //Create job types
      SessionType newSessionType = SessionType(
        id: null,
        documentId: '',
        title: 'Engagement - Example',
        createdDate: DateTime.now(),
        stages: JobStage.exampleJobStages(),
        reminders: await ReminderDao.getAll(),
        totalCost: 500,
        deposit: 150,
        salesTaxPercent: 6.5,
        durationHours: 1,
        durationMinutes: 0,
      );
      await SessionTypeDao.insertOrUpdate(newSessionType);

      //Create contacts
      Client client1 = Client(
          id: null,
          documentId: '',
          firstName: 'Client',
          lastName: 'Name',
          email: 'sampleuser@dandylight.com',
          phone: '(555)555-5555',
          instagramProfileUrl: 'https://www.instagram.com/dandy.light/',
          leadSource: Client.LEAD_SOURCE_WORD_OF_MOUTH,
          customLeadSourceName: '',
          createdDate: DateTime.now()
      );
      await ClientDao.insertOrUpdate(client1);

      //Create Sample Location
      LocationDandy location = LocationDandy.LocationDandy(
        id: null,
        documentId: '',
        locationName: "Santa Rosa",
        latitude: 33.509060,
        longitude: -117.293762,
        address: "exampleJob",
        imageUrl: "https://firebasestorage.googleapis.com/v0/b/clientsafe-21962.appspot.com/o/env%2Fprod%2Fimages%2FdandyLight%2FexampleLocation%2FScreen%20Shot%202023-05-20%20at%209.58.02%20AM.png?alt=media&token=5e5412b5-f27d-4c6c-b492-85984f3e0349",
      );
      await LocationDao.insertOrUpdate(location);

      //Create sample job
      DateTime currentTime = DateTime.now();
      Client client = (await ClientDao.getAll())!.first;
      Job jobToSave = Job(
        id: null,
        documentId: store.state.newJobPageState!.documentId,
        clientDocumentId: client.documentId,
        clientName: client.getClientFullName(),
        jobTitle: client.firstName! + ' - Example Job',
        selectedDate: DateTime.now().add(Duration(days: 3)),
        selectedTime: DateTime(currentTime.year, currentTime.month, currentTime.day, 18, 45),
        selectedEndTime: DateTime(currentTime.year, currentTime.month, currentTime.day, 19, 45),
        sessionType: (await SessionTypeDao.getAll())!.first,
        stage: JobStage.exampleJobStages().elementAt(1),
        completedStages: [JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED)],
        createdDate: DateTime.now(),
        client: client,
        depositAmount: 0,
        location: (await LocationDao.getAllSortedMostFrequent())!.first,
        proposal: Proposal(
          detailsMessage: "(Example client portal message)\n\nHi ${client.firstName},\nI wanted to thank you again for choosing our photography services. We're excited to work with you to capture your special moments.\n\nTo make things official, kindly review and sign the contract. It outlines our agreement's essential details.\n\nIf you have any questions, please don't hesitate to ask.\n\nBest regards,\n\n${newProfile.firstName ?? 'First name'} ${newProfile.lastName ?? 'Last name'}\n${newProfile.businessName ?? 'Business name'}",
        )
      );
      await JobDao.insertOrUpdate(jobToSave);

      await PoseLibraryGroupDao.syncAllFromFireStore();
      await ContractTemplateDao.syncAllFromFireStore();
      await AppSettingsDao.syncAllFromFireStore();
      List<PoseLibraryGroup> libraryGroups = (await PoseLibraryGroupDao.getAllSortedMostFrequent());
      List<Pose> posesToAdd = [];
      libraryGroups.forEach((group) {
        group.poses!.forEach((pose) {
          if(pose.documentId == 'b7381a00-ef76-11ed-bf2a-61f5f61596d7' || pose.documentId == 'cdfc7600-e9f4-11ed-a07e-d5fa14ffadc7'|| pose.documentId == 'cd8a7a50-e9f4-11ed-b398-2f4d404a1892' || pose.documentId == 'b2729860-e9f4-11ed-b73d-a9e7c5067fa2') {
            posesToAdd.add(pose);
          }
        });
      });
      _saveSelectedPoseToJob(store, (await JobDao.getAllJobs())!.first, posesToAdd);

      await QuestionnairesDao.syncAllFromFireStore();
      List<Questionnaire>? questionnaireTemplates = await QuestionnaireTemplateDao.getAll();
      int questionnairesCount = (await QuestionnairesDao.getAll()).where((item) => item.isTemplate == true).length;

      if(questionnaireTemplates != null && questionnaireTemplates.isNotEmpty && questionnairesCount == 0) {
        for(Questionnaire questionnaire in questionnaireTemplates) {
          QuestionnairesDao.insert(questionnaire);
        }
      }

      if(signInType == EMAIL) {
        await store.dispatch(SetShowAccountCreatedDialogAction(store.state.loginPageState, true, user));
      } else {
        store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
        UidUtil().setUid(user.uid);
        EventSender().setUserIdentity(user.uid);
        await FireStoreSync().dandyLightAppInitializationSync(user.uid).then((value) async {
          store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
          ProfileDao.updateUserLoginTime(user.uid);
          store.dispatch(UpdateNavigateToOnBoardingAction(store.state.loginPageState, true));
        });
        await PoseLibraryGroupDao.syncAllFromFireStore();
        await ContractTemplateDao.syncAllFromFireStore();
        await QuestionnaireTemplateDao.syncAllFromFireStore();
        await AppSettingsDao.syncAllFromFireStore();
        EventSender().sendEvent(eventName: EventNames.USER_SIGNED_IN_CHECK, properties: {
          EventNames.SIGN_IN_CHECKED_PARAM_USER_UID : user.uid,
          EventNames.SIGN_IN_CHECKED_PARAM_PROFILE_UID : newProfile.uid ?? "profile = null",
        });
      }
    }
  }

  void _saveSelectedPoseToJob(Store<AppState> store, Job job, List<Pose> poses) async {
    job.poses!.addAll(poses);
    await JobDao.update(job);
  }

  void _createAccount(Store<AppState> store, CreateAccountAction action, next) async {
    store.dispatch(UpdateShowCreateAccountAnimation(store.state.loginPageState, true));
    final FirebaseAuth auth = FirebaseAuth.instance;
    if(store.state.loginPageState!.firstName!.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'First name is required'));
      VibrateUtil.vibrateMultiple();
    } else if(store.state.loginPageState!.lastName!.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'Last name is required'));
      VibrateUtil.vibrateMultiple();
    } else if(store.state.loginPageState!.emailAddress!.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'Email Address is required'));
      VibrateUtil.vibrateMultiple();
    } else if(store.state.loginPageState!.password!.isEmpty) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, 'Password is required'));
      VibrateUtil.vibrateMultiple();
    } else if(!InputValidator.isValidPasswordMedium(store.state.loginPageState!.password!)) {
      store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, InputValidator.login_invalid_password_error_msg));
      VibrateUtil.vibrateMultiple();
    } else {
      User? user = await FirebaseAuthentication().registerFirebaseUser(store.state.loginPageState!.emailAddress!, store.state.loginPageState!.password!, auth)
          .catchError((error) {
        store.dispatch(SetCreateAccountErrorMessageAction(store.state.loginPageState, error.message));
        VibrateUtil.vibrateMultiple();
      });
      _createNewUserProfile(store, user, store.state.loginPageState!.firstName!, store.state.loginPageState!.lastName!, store.state.loginPageState!.emailAddress!, EMAIL);
    }
  }

  void _checkForCurrentUser(Store<AppState> store, CheckForCurrentUserAction action, next) async{
    await Future.delayed(Duration(seconds: 1));
    store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, false));
    store.dispatch(SetIsLoginWithAppleAvailableAction(store.state.loginPageState, (await AppleSignInAvailable.check()).isAvailable));
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    List<Profile>? deviceProfiles = await ProfileDao.getAll();
    Profile? profile;
    bool isFromProviderLogin = false;
    String providerEmail = '';

    if (user != null && user.emailVerified) {
      user.providerData.forEach((element) {
        if(element.email!.isNotEmpty) {
          isFromProviderLogin = true;
          providerEmail = element.email!;
        }
      });
      if(deviceProfiles!.isNotEmpty){
        profile = getMatchingProfile(deviceProfiles, user);
        if(profile != null) {
          store.dispatch(UpdateEmailAddressAction(store.state.loginPageState, isFromProviderLogin ? providerEmail : profile.email));
          EventSender().setUserIdentity(user.uid);
          EventSender().setUserProfileData(EventNames.FIRST_NAME, profile.firstName!);
          EventSender().setUserProfileData(EventNames.LAST_NAME, profile.lastName!);
          EventSender().setUserProfileData(EventNames.EMAIL, isFromProviderLogin ? providerEmail : profile.email!);
          EventSender().setUserProfileData(EventNames.BUSINESS_NAME, profile.businessName!);
          EventSender().setUserProfileData(EventNames.BUILD_VERSION, (await PackageInfo.fromPlatform()).version);
          EventSender().setUserProfileData(EventNames.BUILD_NUMBER, (await PackageInfo.fromPlatform()).buildNumber);

          UidUtil().setUid(user.uid);

          await ContractTemplateDao.syncAllFromFireStore();
          await QuestionnaireTemplateDao.syncAllFromFireStore();
          if(profile.selectedColorTheme == null) {
            profile.selectedColorTheme = ColorTheme(
              themeName: 'default',
              iconColor: ColorConstants.getString(ColorConstants.getBlueDark()),
              iconTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
              buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
              buttonTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
              bannerColor: ColorConstants.getString(ColorConstants.getPeachLight()),
            );
            profile.previewColorTheme = ColorTheme(
              themeName: 'default',
              iconColor: ColorConstants.getString(ColorConstants.getBlueDark()),
              iconTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
              buttonColor: ColorConstants.getString(ColorConstants.getPeachDark()),
              buttonTextColor: ColorConstants.getString(ColorConstants.getWhiteWhite()),
              bannerColor: ColorConstants.getString(ColorConstants.getPeachLight()),
            );
            profile.bannerImageSelected = true;
            profile.previewBannerImageSelected = true;
            profile.bannerMobileUrl = await FileStorage.fetchImagePathForExampleBannerMobile();
            profile.previewBannerMobileUrl = await FileStorage.fetchImagePathForExampleBannerMobile();
            profile.bannerWebUrl = await FileStorage.fetchImagePathForExampleBannerWeb();
            profile.previewBannerWebUrl = await FileStorage.fetchImagePathForExampleBannerWeb();
            profile.logoSelected = false;
            profile.previewLogoSelected = false;
            profile.logoCharacter = store.state.loginPageState!.businessName != null && store.state.loginPageState!.businessName!.length > 0 ? store.state.loginPageState!.businessName!.substring(0, 1) : 'A';
            profile.previewLogoCharacter = store.state.loginPageState!.businessName != null && store.state.loginPageState!.businessName!.length > 0 ? store.state.loginPageState!.businessName!.substring(0, 1) : 'A';
            profile.previewJsonContract = (await ContractTemplateDao.getAll())!.first.jsonTerms;
          }
          if(profile.selectedFontTheme == null) {
            profile.selectedFontTheme = FontTheme(
              themeName: 'default',
              iconFont: FontTheme.Moredya,
              mainFont: FontTheme.OPEN_SANS,
            );
            profile.previewFontTheme = FontTheme(
              themeName: 'default',
              iconFont: FontTheme.Moredya,
              mainFont: FontTheme.OPEN_SANS,
            );
          }
          if(profile.logoCharacter == null || profile.logoCharacter!.length == 0) {
            profile.logoCharacter = profile.businessName != null && profile.businessName!.length > 0 ? profile.businessName!.substring(0,1) : 'A';
          }
          if(profile.bannerMobileUrl == null) {
            profile.bannerMobileUrl = await FileStorage.fetchImagePathForExampleBannerMobile();
          }

          if(profile.bannerWebUrl == null) {
            profile.bannerWebUrl = await FileStorage.fetchImagePathForExampleBannerWeb();
          }

          List<JobType> jobTypes = (await JobTypeDao.getAll()) ?? [];
          List<PriceProfile> priceProfiles = (await PriceProfileDao.getAllSortedByName());
          if(jobTypes.isNotEmpty) {
            for(JobType jobType in jobTypes) {
              SessionTypeDao.insert(
                SessionType(
                    title: jobType.title ?? 'NA',
                    totalCost: 0.0,
                    createdDate: DateTime.now(),
                    stages: jobType.stages ?? [],
                    reminders: jobType.reminders ?? [],
                    deposit: 0.0,
                    salesTaxPercent: 0.0,
                    durationMinutes: 0,
                    durationHours: 0
                )
              );
              if(jobType.documentId != null) {
                JobTypeDao.delete(jobType.documentId!);
              }
            }
          }
          if(priceProfiles.isNotEmpty) {
            for(PriceProfile profile in priceProfiles) {
              PriceProfileDao.delete(profile);
            }
          }

          await QuestionnairesDao.syncAllFromFireStore();
          List<Questionnaire>? questionnaireTemplates = await QuestionnaireTemplateDao.getAll();
          int questionnairesCount = (await QuestionnairesDao.getAll()).where((item) => item.isTemplate == true).length;

          if(questionnaireTemplates != null && questionnaireTemplates.isNotEmpty && questionnairesCount == 0) {
            for(Questionnaire questionnaire in questionnaireTemplates) {
              QuestionnairesDao.insert(questionnaire);
            }
          }



          await JobDao.syncAllFromFireStore();
          List<Job> allJobs = await JobDao.getAllJobs();
          for(Job job in allJobs) {
            if(job.proposal?.contract != null) {
              job.proposal?.contracts ??= [];
              job.proposal?.contract!.documentId = const UuidV4().generate();
              job.proposal?.contracts?.add(job.proposal!.contract!);
              job.proposal?.contract = null;
              await JobDao.update(job);
            }

            //TODO remove this code after a few months.
            if(job.sessionType == null) {
              job.sessionType = SessionType.from(job.type, job.priceProfile);
              JobDao.update(job);
              profile.showSessionMigrationMessage = true;
            }
          }
          await ProfileDao.update(profile);

          store.dispatch(SetIsUserVerifiedAction(store.state.loginPageState, user.emailVerified));
          store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, false));
          store.dispatch(UpdateShowLoginAnimation(store.state.loginPageState, true));
          EventSender().setUserIdentity(user.uid);
          await FireStoreSync().dandyLightAppInitializationSync(user.uid).then((value) async {
            store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
            ProfileDao.updateUserLoginTime(user.uid);
            setShouldShowOnBoarding(store, profile!);
          });
          await PoseLibraryGroupDao.syncAllFromFireStore();
          await AppSettingsDao.syncAllFromFireStore();
          EventSender().sendEvent(eventName: EventNames.USER_SIGNED_IN_CHECK, properties: {
            EventNames.SIGN_IN_CHECKED_PARAM_USER_UID : user.uid,
            EventNames.SIGN_IN_CHECKED_PARAM_PROFILE_UID : profile.uid ?? "profile = null",
          });
          await ProfileDao.update(profile);
        } else {
          store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
          store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, true));
          auth.signOut();
          await SembastDb.instance.deleteAllLocalData();
        }
      } else {
        store.dispatch(SetCurrentUserCheckState(store.state.loginPageState, true));
        store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, true));
        auth.signOut();
        await SembastDb.instance.deleteAllLocalData();
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
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    _sendEmailVerification(user!, 'Email verification resent', store);
  }

  Profile? getMatchingProfile(List<Profile> profiles, User user) {
    Profile? result;
    for(Profile profile in profiles) {
      if(profile.uid == user.uid) {
        result = profile;
      }
    }
    return result;
  }
}