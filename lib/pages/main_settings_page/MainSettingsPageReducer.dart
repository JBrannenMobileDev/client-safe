import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';
import 'package:redux/redux.dart';

final mainSettingsPageReducer = combineReducers<MainSettingsPageState>([
  TypedReducer<MainSettingsPageState, UpdatePushNotificationEnabled>(_setPushNotificationsState),
  TypedReducer<MainSettingsPageState, UpdateCalendarEnabled>(_setCalendarState),
  TypedReducer<MainSettingsPageState, LoadUserProfileDataAction>(_setUserProfileInfo),
]);

MainSettingsPageState _setPushNotificationsState(MainSettingsPageState previousState, UpdatePushNotificationEnabled action){
  return previousState.copyWith(
    pushNotificationsEnabled: action.enabled,
  );
}

MainSettingsPageState _setCalendarState(MainSettingsPageState previousState, UpdateCalendarEnabled action){
  return previousState.copyWith(
    calendarEnabled: action.enabled,
  );
}

MainSettingsPageState _setUserProfileInfo(MainSettingsPageState previousState, LoadUserProfileDataAction action){
  return previousState.copyWith(
    firstName: action.profile.firstName,
    lastName: action.profile.lastName,
    businessName: action.profile.businessName,
    profile: action.profile,
  );
}
