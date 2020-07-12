import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class MainSettingsPageState{
  final bool pushNotificationsEnabled;
  final bool calendarEnabled;
  final String firstName;
  final String lastName;
  final String businessName;
  final Profile profile;
  final Function() onSignOutSelected;
  final Function(bool) onPushNotificationsChanged;
  final Function(bool) onCalendarChanged;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onBusinessNameChanged;
  final Function() onSaveUpdatedProfile;

  MainSettingsPageState({
    @required this.pushNotificationsEnabled,
    @required this.calendarEnabled,
    @required this.onSignOutSelected,
    @required this.onPushNotificationsChanged,
    @required this.onCalendarChanged,
    @required this.firstName,
    @required this.lastName,
    @required this.businessName,
    @required this.onFirstNameChanged,
    @required this.onLastNameChanged,
    @required this.onBusinessNameChanged,
    @required this.onSaveUpdatedProfile,
    @required this.profile,
  });

  MainSettingsPageState copyWith({
    bool pushNotificationsEnabled,
    bool calendarEnabled,
    String firstName,
    String lastName,
    String businessName,
    Profile profile,
    Function(String) onFirstNameChanged,
    Function(String) onLastNameChanged,
    Function(String) onBusinessNameChanged,
    Function() onSignOutSelected,
    Function(bool) onPushNotificationsChanged,
    Function(bool) onCalendarChanged,
    Function() onSaveUpdatedProfile,
  }){
    return MainSettingsPageState(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      onSignOutSelected: onSignOutSelected?? this.onSignOutSelected,
      onPushNotificationsChanged: onPushNotificationsChanged ?? this.onPushNotificationsChanged,
      onCalendarChanged: onCalendarChanged ?? this.onCalendarChanged,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      onFirstNameChanged: onFirstNameChanged ?? this.onFirstNameChanged,
      onLastNameChanged: onLastNameChanged ?? this.onLastNameChanged,
      onBusinessNameChanged: onBusinessNameChanged ?? this.onBusinessNameChanged,
      onSaveUpdatedProfile: onSaveUpdatedProfile ?? this.onSaveUpdatedProfile,
      profile: profile ?? this.profile,
    );
  }

  factory MainSettingsPageState.initial() => MainSettingsPageState(
    onSignOutSelected: null,
    onPushNotificationsChanged: null,
    onCalendarChanged: null,
    pushNotificationsEnabled: false,
    calendarEnabled: false,
    firstName: '',
    lastName: '',
    businessName: '',
    onFirstNameChanged: null,
    onLastNameChanged: null,
    onBusinessNameChanged: null,
    onSaveUpdatedProfile: null,
    profile: null,
  );

  factory MainSettingsPageState.fromStore(Store<AppState> store) {
    return MainSettingsPageState(
      pushNotificationsEnabled: store.state.mainSettingsPageState.pushNotificationsEnabled,
      calendarEnabled: store.state.mainSettingsPageState.calendarEnabled,
      firstName: store.state.mainSettingsPageState.firstName,
      lastName: store.state.mainSettingsPageState.lastName,
      businessName: store.state.mainSettingsPageState.businessName,
      profile: store.state.mainSettingsPageState.profile,
      onSignOutSelected: () {
        store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, false));
        store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, true));
      },
      onPushNotificationsChanged: (enabled) => store.dispatch(SavePushNotificationSettingAction(store.state.mainSettingsPageState, enabled)),
      onCalendarChanged: (enabled) => store.dispatch(SaveCalendarSettingAction(store.state.mainSettingsPageState, enabled)),
      onFirstNameChanged: (firstName) => store.dispatch(SetFirstNameAction(store.state.mainSettingsPageState, firstName)),
      onLastNameChanged: (lastName) => store.dispatch(SetLastNameAction(store.state.mainSettingsPageState, lastName)),
      onBusinessNameChanged: (businessName) => store.dispatch(SetBusinessNameAction(store.state.mainSettingsPageState, businessName)),
      onSaveUpdatedProfile: () => store.dispatch(SaveUpdatedUserProfileAction(store.state.mainSettingsPageState)),
    );
  }

  @override
  int get hashCode =>
      pushNotificationsEnabled.hashCode ^
      calendarEnabled.hashCode ^
      onPushNotificationsChanged.hashCode ^
      onCalendarChanged.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      businessName.hashCode ^
      onFirstNameChanged.hashCode ^
      onLastNameChanged.hashCode ^
      onBusinessNameChanged.hashCode ^
      onSaveUpdatedProfile.hashCode ^
      profile.hashCode ^
      onSignOutSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MainSettingsPageState &&
              pushNotificationsEnabled == other.pushNotificationsEnabled &&
              calendarEnabled == other.calendarEnabled &&
              onPushNotificationsChanged == other.onPushNotificationsChanged &&
              onCalendarChanged == other.onCalendarChanged &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              businessName == other.businessName &&
              onFirstNameChanged == other.onFirstNameChanged &&
              onLastNameChanged == other.onLastNameChanged &&
              onBusinessNameChanged == other.onBusinessNameChanged &&
              onSaveUpdatedProfile == other.onSaveUpdatedProfile &&
              profile == other.profile &&
              onSignOutSelected == other.onSignOutSelected;
}