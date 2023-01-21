import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/models/Suggestion.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/EnvironmentUtil.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/PushNotificationsManager.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:purchases_flutter/purchases_flutter.dart' as purchases;
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import '../../data_layer/local_db/SembastDb.dart';
import '../../utils/CalendarUtil.dart';
import '../login_page/LoginPageActions.dart';
import 'MainSettingsPageActions.dart';

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
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    (await ProfileDao.getProfileStream()).listen((snapshots) async {
        List<Profile> profiles = List();
        for(RecordSnapshot profileSnapshot in snapshots) {
          profiles.add(Profile.fromMap(profileSnapshot.value));
        }
        if(profiles.length > 0) {
          store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profiles.elementAt(0)?.pushNotificationsEnabled ?? false));
          store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profiles.elementAt(0).calendarEnabled ?? false));
          store.dispatch(LoadUserProfileDataAction(store.state.mainSettingsPageState, profiles.elementAt(0)));
        }
      });
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