import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/data_layer/local_db/daos/ContractDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseDao.dart';
import 'package:dandylight/data_layer/local_db/daos/PoseGroupDao.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfileActions.dart';
import 'package:dandylight/pages/pricing_profiles_page/PricingProfilesActions.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../data_layer/local_db/daos/ClientDao.dart';
import '../../data_layer/local_db/daos/InvoiceDao.dart';
import '../../data_layer/local_db/daos/JobDao.dart';
import '../../data_layer/local_db/daos/JobReminderDao.dart';
import '../../data_layer/local_db/daos/JobTypeDao.dart';
import '../../data_layer/local_db/daos/LocationDao.dart';
import '../../data_layer/local_db/daos/MileageExpenseDao.dart';
import '../../data_layer/local_db/daos/NextInvoiceNumberDao.dart';
import '../../data_layer/local_db/daos/PriceProfileDao.dart';
import '../../data_layer/local_db/daos/ProfileDao.dart';
import '../../data_layer/local_db/daos/RecurringExpenseDao.dart';
import '../../data_layer/local_db/daos/ReminderDao.dart';
import '../../data_layer/local_db/daos/SingleExpenseDao.dart';

class MainSettingsPageState{
  final bool pushNotificationsEnabled;
  final bool calendarEnabled;
  final String firstName;
  final String lastName;
  final String businessName;
  final Profile profile;
  final bool isDeleteInProgress;
  final bool isDeleteFinished;
  final Function() onSignOutSelected;
  final Function(bool) onPushNotificationsChanged;
  final Function(bool) onCalendarChanged;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onBusinessNameChanged;
  final Function() onSaveUpdatedProfile;
  final Function(String) onSendSuggestionSelected;
  final Function() onDeleteAccountSelected;

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
    @required this.onSendSuggestionSelected,
    @required this.onDeleteAccountSelected,
    @required this.isDeleteInProgress,
    @required this.isDeleteFinished,
  });

  MainSettingsPageState copyWith({
    bool pushNotificationsEnabled,
    bool calendarEnabled,
    String firstName,
    String lastName,
    String businessName,
    Profile profile,
    bool isDeleteInProgress,
    bool isDeleteFinished,
    Function(String) onFirstNameChanged,
    Function(String) onLastNameChanged,
    Function(String) onBusinessNameChanged,
    Function() onSignOutSelected,
    Function(bool) onPushNotificationsChanged,
    Function(bool) onCalendarChanged,
    Function() onSaveUpdatedProfile,
    Function(String) onSendSuggestionSelected,
    Function() onDeleteAccountSelected,
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
      onSendSuggestionSelected: onSendSuggestionSelected ?? this.onSendSuggestionSelected,
      onDeleteAccountSelected: onDeleteAccountSelected ?? this.onDeleteAccountSelected,
      isDeleteFinished: isDeleteFinished ?? this.isDeleteFinished,
      isDeleteInProgress: isDeleteInProgress ?? this.isDeleteInProgress
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
    onSendSuggestionSelected: null,
    onDeleteAccountSelected: null,
    isDeleteInProgress: false,
    isDeleteFinished: false,
  );

  factory MainSettingsPageState.fromStore(Store<AppState> store) {
    return MainSettingsPageState(
      pushNotificationsEnabled: store.state.mainSettingsPageState.pushNotificationsEnabled,
      calendarEnabled: store.state.mainSettingsPageState.calendarEnabled,
      firstName: store.state.mainSettingsPageState.firstName,
      lastName: store.state.mainSettingsPageState.lastName,
      businessName: store.state.mainSettingsPageState.businessName,
      profile: store.state.mainSettingsPageState.profile,
      isDeleteFinished: store.state.mainSettingsPageState.isDeleteFinished,
      isDeleteInProgress: store.state.mainSettingsPageState.isDeleteInProgress,
      onSignOutSelected: () {
        store.dispatch(RemoveDeviceTokenAction(store.state.mainSettingsPageState));
        store.dispatch(UpdateNavigateToHomeAction(store.state.loginPageState, false));
        store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, true));
        SembastDb.instance.deleteAllLocalData();
      },
      onPushNotificationsChanged: (enabled) => store.dispatch(SavePushNotificationSettingAction(store.state.mainSettingsPageState, enabled)),
      onCalendarChanged: (enabled) => store.dispatch(SaveCalendarSettingAction(store.state.mainSettingsPageState, enabled)),
      onFirstNameChanged: (firstName) => store.dispatch(SetFirstNameAction(store.state.mainSettingsPageState, firstName)),
      onLastNameChanged: (lastName) => store.dispatch(SetLastNameAction(store.state.mainSettingsPageState, lastName)),
      onBusinessNameChanged: (businessName) => store.dispatch(SetBusinessNameAction(store.state.mainSettingsPageState, businessName)),
      onSaveUpdatedProfile: () => store.dispatch(SaveUpdatedUserProfileAction(store.state.mainSettingsPageState)),
      onSendSuggestionSelected: (suggestion) => store.dispatch(SendSuggestionAction(store.state.mainSettingsPageState, suggestion)),
      onDeleteAccountSelected: () => store.dispatch(DeleteAccountAction(store.state.mainSettingsPageState)),
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
      onSendSuggestionSelected.hashCode ^
      onDeleteAccountSelected.hashCode ^
      isDeleteFinished.hashCode ^
      isDeleteInProgress.hashCode ^
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
              onSendSuggestionSelected == other.onSendSuggestionSelected &&
              onDeleteAccountSelected == other.onDeleteAccountSelected &&
              isDeleteFinished == other.isDeleteFinished &&
              isDeleteInProgress == other.isDeleteInProgress &&
              onSignOutSelected == other.onSignOutSelected;
}