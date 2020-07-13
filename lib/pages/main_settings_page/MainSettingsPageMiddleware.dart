import 'package:dandylight/AppState.dart';
import 'package:dandylight/data_layer/local_db/daos/ProfileDao.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:redux/redux.dart';
import 'package:sembast/sembast.dart';

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
  }

  void loadSettings(Store<AppState> store, NextDispatcher next) async{
    (await ProfileDao.getProfileStream()).listen((snapshots) async {
        List<Profile> profiles = List();
        for(RecordSnapshot profileSnapshot in snapshots) {
          profiles.add(Profile.fromMap(profileSnapshot.value));
        }
        store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profiles.elementAt(0).pushNotificationsEnabled ?? false));
        store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profiles.elementAt(0).calendarEnabled ?? false));
        store.dispatch(LoadUserProfileDataAction(store.state.mainSettingsPageState, profiles.elementAt(0)));
      });
  }

  void savePushNotificationSetting(Store<AppState> store, SavePushNotificationSettingAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.pushNotificationsEnabled = action.enabled;
    await ProfileDao.update(profile);
    store.dispatch(UpdatePushNotificationEnabled(store.state.mainSettingsPageState, profile.pushNotificationsEnabled ?? false));
  }

  void saveCalendarSetting(Store<AppState> store, SaveCalendarSettingAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    profile.calendarEnabled = action.enabled;
    await ProfileDao.update(profile);
    store.dispatch(UpdateCalendarEnabled(store.state.mainSettingsPageState, profile.calendarEnabled ?? false));
    //TODO CalendarSyncUtil.syncDeviceToApp()
  }

  void saveUpdatedUserProfile(Store<AppState> store, SaveUpdatedUserProfileAction action, NextDispatcher next) async{
    Profile profile = (await ProfileDao.getAll()).elementAt(0);
    await ProfileDao.update(profile.copyWith(
      firstName: store.state.mainSettingsPageState.firstName,
      lastName: store.state.mainSettingsPageState.lastName,
      businessName: store.state.mainSettingsPageState.businessName,
    ));
  }
}