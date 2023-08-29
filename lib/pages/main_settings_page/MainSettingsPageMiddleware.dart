import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/ColorTheme.dart';
import 'package:dandylight/models/DiscountCodes.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Suggestion.dart';
import 'package:dandylight/utils/AdminCheckUtil.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/DandyToastUtil.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/PushNotificationsManager.dart';
import 'package:dandylight/utils/StringUtils.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/SembastDb.dart';
import '../../data_layer/repositories/DiscountCodesRepository.dart';
import '../../data_layer/repositories/FileStorage.dart';
import '../../utils/CalendarUtil.dart';
import '../../utils/UUID.dart';
import '../login_page/LoginPageActions.dart';
import 'MainSettingsPageActions.dart';
import 'package:image/image.dart' as img;

class MainSettingsPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadSettingsFromProfile){
      loadSettings(store, next);
    }
    if(action is SavePushNotificationSettingAction) {
      savePushNotificationSetting(store, action, next);
    }

    if(action is SaveCalendarSettingAction) {
      saveCalendarSetting(store, action, next);
    }
    if(action is SaveUpdatedUserProfileAction) {
      saveUpdatedUserProfile(store, action, next);
    }
    if(action is RemoveDeviceTokenAction){
      removeDeviceToken(store, action, next);
    }
    if(action is SendSuggestionAction) {
      sendSuggestion(store, action, next);
    }
    if(action is DeleteAccountAction) {
      deleteAccount(store, action);
    }
    if(action is Generate50DiscountCodeAction) {
      generate50DiscountCode(store, action, next);
    }
    if(action is GenerateFreeDiscountCodeAction) {
      generateFreeDiscountCode(store, action, next);
    }
    if(action is ResizeLogoImageAction) {
      _resizeImage(store, action, next);
    }
    if(action is SaveBrandingAction) {
      _saveBranding(store, action, next);
    }
    if(action is SaveBannerColorAction) {
      _saveBannerColor(store, action, next);
    }
    if(action is SaveColorThemeAction) {
      _saveColorTheme(store, action, next);
    }
    if(action is DeleteColorThemeAction) {
      _deleteColorTheme(store, action, next);
    }
  }

  void _deleteColorTheme(Store<AppState> store, DeleteColorThemeAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    ColorTheme themeToDelete = profile.savedColorThemes.elementAt(action.index);
    if(action.pageState.selectedColorTheme.id == themeToDelete.id) {

    }
    profile.savedColorThemes.removeAt(action.index);
    await ProfileDao.update(profile);
    store.dispatch(LoadUserProfileDataAction(store.state.mainSettingsPageState, profile));
    store.dispatch(SetColorThemeAction(store.state.mainSettingsPageState, null));
  }

  void _saveColorTheme(Store<AppState> store, SaveColorThemeAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    ColorTheme theme = ColorTheme(
      themeName: action.themeName,
      iconColor: ColorConstants.getHex(action.pageState.currentIconColor),
      iconTextColor: ColorConstants.getHex(action.pageState.currentIconTextColor),
      buttonColor: ColorConstants.getHex(action.pageState.currentButtonColor),
      buttonTextColor: ColorConstants.getHex(action.pageState.currentButtonTextColor),
      bannerColor: ColorConstants.getHex(action.pageState.currentBannerColor),
    );
    profile.selectedColorTheme = theme;
    profile.savedColorThemes.add(theme);
    await ProfileDao.update(profile);
    store.dispatch(SetColorThemeAction(store.state.mainSettingsPageState, theme));
    store.dispatch(LoadUserProfileDataAction(store.state.mainSettingsPageState, profile));
  }

  void _saveBannerColor(Store<AppState> store, SaveBannerColorAction action, NextDispatcher next) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());

    switch(action.id) {
      case 'banner':
        profile.bannerColor = ColorConstants.getHex(action.color);
        break;
      case 'button':
        profile.buttonColor = ColorConstants.getHex(action.color);
        break;
      case 'buttonText':
        profile.buttonTextColor = ColorConstants.getHex(action.color);
        break;
      case 'icon':
        profile.logoColor = ColorConstants.getHex(action.color);
        break;
      case 'iconText':
        profile.logoTextColor = ColorConstants.getHex(action.color);
        break;
    }

    await ProfileDao.update(profile);
    next(action);
  }

  void _saveBranding(Store<AppState> store, SaveBrandingAction action, NextDispatcher next) async {
    if(action.pageState.logoImageSelected) {
      await FileStorage.saveProfileIconImageFile(action.pageState.resizedLogoImage.path, action.pageState.profile);
    }

    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.logoSelected = action.pageState.logoImageSelected;

  }

  void _resizeImage(Store<AppState> store, ResizeLogoImageAction action, NextDispatcher next) async {
    final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    final String uniqueFileName = Uuid().generateV4();
    final cmdLarge = img.Command()
      ..decodeImageFile(action.image.path)
      ..copyResize(width: 300)
      ..writeToFile(appDocumentDirectory.path + '/$uniqueFileName' + 'logo.jpg');
    await cmdLarge.execute();
    XFile resizedImage = XFile(appDocumentDirectory.path + '/$uniqueFileName' + 'logo.jpg');
    store.dispatch(SetResizedLogoImageAction(store.state.mainSettingsPageState, resizedImage));
  }

  void generate50DiscountCode(Store<AppState> store, Generate50DiscountCodeAction action, NextDispatcher next) async{
    String newCode = await DiscountCodesRepository().generateAndSaveCode(DiscountCodes.FIFTY_PERCENT_TYPE, action.pageState.instaUrl);
    store.dispatch(SetDiscountCodeAction(store.state.mainSettingsPageState, newCode));
  }

  void generateFreeDiscountCode(Store<AppState> store, GenerateFreeDiscountCodeAction action, NextDispatcher next) async{
    String newCode = await DiscountCodesRepository().generateAndSaveCode(DiscountCodes.LIFETIME_FREE, action.pageState.instaUrl);
    store.dispatch(SetDiscountCodeAction(store.state.mainSettingsPageState, newCode));
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    bool isAdmin = AdminCheckUtil.isAdmin(profile);
    store.dispatch(SetIsAdminAction(store.state.mainSettingsPageState, isAdmin));

    (await ProfileDao.getProfileStream()).listen((snapshots) async {
        List<Profile> profiles = [];
        for(RecordSnapshot profileSnapshot in snapshots) {
          profiles.add(Profile.fromMap(profileSnapshot.value));
        }
        if(profiles.length > 0) {
          store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profiles.elementAt(0)?.pushNotificationsEnabled ?? false));
          store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profiles.elementAt(0).calendarEnabled ?? false));
          store.dispatch(LoadUserProfileDataAction(store.state.mainSettingsPageState, profiles.elementAt(0)));
        }
      }
    );

    if(profile.selectedColorTheme != null) {
      store.dispatch(SetColorThemeAction(store.state.mainSettingsPageState, profile.selectedColorTheme));
    }
  }

  void savePushNotificationSetting(Store<AppState> store, SavePushNotificationSettingAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.pushNotificationsEnabled = action.enabled;
    if(profile.pushNotificationsEnabled) {
      await PushNotificationsManager().init();
      NotificationHelper().createAndUpdatePendingNotifications();
    } else {
      NotificationHelper().clearAll();
      // profile.removeDeviceToken(await PushNotificationsManager().getToken());
    }
    await ProfileDao.update(profile);
    EventSender().setUserProfileData(EventNames.NOTIFICATIONS_ENABLED, action.enabled);
    store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profile.pushNotificationsEnabled ?? false));
  }

  void removeDeviceToken(Store<AppState> store, RemoveDeviceTokenAction action, NextDispatcher next) async{
    List<Profile> profiles = await ProfileDao.getAll();
    await purchases.Purchases.logIn(profiles.elementAt(0).uid);
    if(profiles != null && profiles.isNotEmpty) {
      Profile profile = profiles.elementAt(0);
      // profile.removeDeviceToken(await PushNotificationsManager().getToken());
      await ProfileDao.update(profile);
    }
  }

  void saveCalendarSetting(Store<AppState> store, SaveCalendarSettingAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.calendarEnabled = action.enabled;
    await ProfileDao.update(profile);
    EventSender().setUserProfileData(EventNames.CALENDAR_SYNC_ENABLED, action.enabled);
    store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profile.calendarEnabled ?? false));
    if(!action.enabled) {
      CalendarSyncUtil.removeJobsFromDeviceCalendars();
    }
  }

  void saveUpdatedUserProfile(Store<AppState> store, SaveUpdatedUserProfileAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    await ProfileDao.update(profile.copyWith(
      firstName: store.state.mainSettingsPageState.firstName,
      lastName: store.state.mainSettingsPageState.lastName,
      businessName: store.state.mainSettingsPageState.businessName,
    ));
  }

  void sendSuggestion(Store<AppState> store, SendSuggestionAction action, NextDispatcher next) async{
    Suggestion suggestion = Suggestion(message: action.suggestion, userId: UidUtil().getUid(), dateSubmitted: DateTime.now());
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection('env')
        .doc(EnvironmentUtil().getCurrentEnvironment())
        .collection('suggestions')
        .doc(suggestion.userId)
        .set(suggestion.toMap());
  }

  void deleteAccount(Store<AppState> store, DeleteAccountAction action) async {
    store.dispatch(SetDeleteProgressAction(store.state.mainSettingsPageState, true));
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    if(profile != null) {
      String email = profile.email;
      if(await FirebaseAuthentication().reAuthenticateUser(action.pageState.password, email)) {
        await CalendarSyncUtil.removeJobsFromDeviceCalendars();
        await SembastDb.instance.deleteAllLocalData();
        await FirebaseAuthentication().deleteFirebaseData();
        await FirebaseAuthentication().deleteAccount(action.pageState.password, email);
        store.dispatch(ResetLoginState(store.state.loginPageState));
        store.dispatch(SetDeleteProgressAction(store.state.mainSettingsPageState, false));
      } else {
        store.dispatch(SetPasswordErrorAction(store.state.mainSettingsPageState));
      }
    } else {
      store.dispatch(SetPasswordErrorAction(store.state.mainSettingsPageState));
    }
  }
}