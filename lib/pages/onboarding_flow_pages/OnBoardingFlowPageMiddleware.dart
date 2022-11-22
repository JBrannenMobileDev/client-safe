import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/firebase/FirebaseAuthentication.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/utils/CalendarSyncUtil.dart';
import 'package:dandylight/utils/NotificationHelper.dart';
import 'package:dandylight/utils/PushNotificationsManager.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

import 'OnBoardingFlowPageActions.dart';

class OnBoardingFlowPageMiddleware extends MiddlewareClass<AppState> {

  @override
  void call(Store<AppState> store, action, NextDispatcher next){
    if(action is LoadSettingsFromProfileOnBoarding){
      loadSettings(store, action, next);
      setTermsAndPrivacyState(store);
    }
    if(action is SavePushNotificationSettingActionOnBoarding) {
      savePushNotificationSetting(store, action, next);
    }

    if(action is SaveCalendarSettingActionOnBoarding) {
      saveCalendarSetting(store, action, next);
    }
    if(action is SaveTermsAndPrivacyStateAction) {
      updateProfileWithTermsAndPrivacyState(store, action, next);
    }
  }

  void setTermsAndPrivacyState(Store<AppState> store) async {
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    store.dispatch(SaveTermsAndPrivacyStateAction(store.state.onBoardingFlowPageState, profile?.termsOfServiceAndPrivacyPolicyChecked));
  }

  void updateProfileWithTermsAndPrivacyState(Store<AppState> store, SaveTermsAndPrivacyStateAction action, NextDispatcher next) async{
    next(action);
    Profile profile = await ProfileDao.getMatchingProfile(UidUtil().getUid());
    profile.termsOfServiceAndPrivacyPolicyChecked = action.isChecked;
    await ProfileDao.update(profile);
  }

  void loadSettings(Store<AppState> store, LoadSettingsFromProfileOnBoarding action, NextDispatcher next) async{
    (await ProfileDao.getProfileStream()).listen((snapshots) async {
        List<Profile> profiles = [];
        for(RecordSnapshot profileSnapshot in snapshots) {
          profiles.add(Profile.fromMap(profileSnapshot.value));
        }
        if(profiles.length > 0) {
          store.dispatch(UpdatePushNotificationEnabled(store.state.onBoardingFlowPageState, profiles.elementAt(0)?.pushNotificationsEnabled ?? false));
          store.dispatch(UpdateCalendarEnabled(store.state.onBoardingFlowPageState, profiles.elementAt(0)?.calendarEnabled ?? false));
        }
      });
  }

  void savePushNotificationSetting(Store<AppState> store, SavePushNotificationSettingActionOnBoarding action, NextDispatcher next) async{
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
    store.dispatch(UpdatePushNotificationEnabled(store.state.onBoardingFlowPageState, profile.pushNotificationsEnabled ?? false));
  }

  void saveCalendarSetting(Store<AppState> store, SaveCalendarSettingActionOnBoarding action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.calendarEnabled = action.enabled;
    await ProfileDao.update(profile);
    store.dispatch(UpdateCalendarEnabled(store.state.onBoardingFlowPageState, profile.calendarEnabled ?? false));
    if(!action.enabled) {
      CalendarSyncUtil.removeJobsFromDeviceCalendars();
    }
  }
}