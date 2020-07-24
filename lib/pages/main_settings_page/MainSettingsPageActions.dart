import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageState.dart';

class UpdatePushNotificationEnabled{
  final MainSettingsPageState pageState;
  final bool enabled;
  UpdatePushNotificationEnabled(this.pageState, this.enabled);
}

class UpdateCalendarEnabled{
  final MainSettingsPageState pageState;
  final bool enabled;
  UpdateCalendarEnabled(this.pageState, this.enabled);
}

class LoadUserProfileDataAction{
  final MainSettingsPageState pageState;
  final Profile profile;
  LoadUserProfileDataAction(this.pageState, this.profile);
}

class LoadSettingsFromProfile{
  final MainSettingsPageState pageState;
  LoadSettingsFromProfile(this.pageState);
}

class SavePushNotificationSettingAction{
  final MainSettingsPageState pageState;
  final bool enabled;
  SavePushNotificationSettingAction(this.pageState, this.enabled);
}

class SaveCalendarSettingAction{
  final MainSettingsPageState pageState;
  final bool enabled;
  SaveCalendarSettingAction(this.pageState, this.enabled);
}

class SetFirstNameAction{
  final MainSettingsPageState pageState;
  final String name;
  SetFirstNameAction(this.pageState, this.name);
}

class SetLastNameAction{
  final MainSettingsPageState pageState;
  final String name;
  SetLastNameAction(this.pageState, this.name);
}

class SetBusinessNameAction{
  final MainSettingsPageState pageState;
  final String name;
  SetBusinessNameAction(this.pageState, this.name);
}

class SaveUpdatedUserProfileAction{
  final MainSettingsPageState pageState;
  SaveUpdatedUserProfileAction(this.pageState);
}

class RemoveDeviceTokenAction{
  final MainSettingsPageState pageState;
  RemoveDeviceTokenAction(this.pageState);
}

