import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/main_settings_page/MainSettingsPageActions.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';

class MainSettingsPageState{
  final bool pushNotificationsEnabled;
  final bool calendarEnabled;
  final String firstName;
  final String lastName;
  final String businessName;
  final String discountCode;
  final Profile profile;
  final bool isDeleteInProgress;
  final bool isDeleteFinished;
  final bool isAdmin;
  final String password;
  final String passwordErrorMessage;
  final String instaUrl;
  final Function() onSignOutSelected;
  final Function(bool) onPushNotificationsChanged;
  final Function(bool) onCalendarChanged;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onBusinessNameChanged;
  final Function() onSaveUpdatedProfile;
  final Function(String) onSendSuggestionSelected;
  final Function() onDeleteAccountSelected;
  final Function(String) onPasswordChanged;
  final Function() generate50DiscountCode;
  final Function() generateFreeDiscountCode;
  final Function(String) onInstaUrlChanged;

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
    @required this.password,
    @required this.onPasswordChanged,
    @required this.passwordErrorMessage,
    @required this.discountCode,
    @required this.generate50DiscountCode,
    @required this.isAdmin,
    @required this.generateFreeDiscountCode,
    @required this.onInstaUrlChanged,
    @required this.instaUrl,
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
    bool isAdmin,
    String password,
    String passwordErrorMessage,
    String discountCode,
    String instaUrl,
    Function(String) onFirstNameChanged,
    Function(String) onLastNameChanged,
    Function(String) onBusinessNameChanged,
    Function() onSignOutSelected,
    Function(bool) onPushNotificationsChanged,
    Function(bool) onCalendarChanged,
    Function() onSaveUpdatedProfile,
    Function(String) onSendSuggestionSelected,
    Function() onDeleteAccountSelected,
    Function(String) onPasswordChanged,
    Function() generate50DiscountCode,
    Function() generateFreeDiscountCode,
    Function(String) onInstaUrlChanged,
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
      isDeleteInProgress: isDeleteInProgress ?? this.isDeleteInProgress,
      password: password ?? this.password,
      onPasswordChanged: onPasswordChanged ?? this.onPasswordChanged,
      passwordErrorMessage: passwordErrorMessage ?? this.passwordErrorMessage,
      discountCode: discountCode ?? this.discountCode,
      generate50DiscountCode: generate50DiscountCode ?? this.generate50DiscountCode,
      isAdmin: isAdmin ?? this.isAdmin,
      generateFreeDiscountCode: generateFreeDiscountCode ?? this.generateFreeDiscountCode,
      onInstaUrlChanged: onInstaUrlChanged?? this.onInstaUrlChanged,
      instaUrl: instaUrl ?? this.instaUrl,
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
    password: '',
    onPasswordChanged: null,
    passwordErrorMessage: '',
    generate50DiscountCode: null,
    discountCode: '',
    isAdmin: false,
    generateFreeDiscountCode: null,
    onInstaUrlChanged: null,
    instaUrl: '',
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
      password: store.state.mainSettingsPageState.password,
      passwordErrorMessage: store.state.mainSettingsPageState.passwordErrorMessage,
      discountCode: store.state.mainSettingsPageState.discountCode,
      isAdmin: store.state.mainSettingsPageState.isAdmin,
      instaUrl: store.state.mainSettingsPageState.instaUrl,
      onSignOutSelected: () {
        store.dispatch(RemoveDeviceTokenAction(store.state.mainSettingsPageState));
        store.dispatch(ResetLoginState(store.state.loginPageState));
        SembastDb.instance.deleteAllLocalData();
        EventSender().reset();
      },
      onPushNotificationsChanged: (enabled) => store.dispatch(SavePushNotificationSettingAction(store.state.mainSettingsPageState, enabled)),
      onCalendarChanged: (enabled) => store.dispatch(SaveCalendarSettingAction(store.state.mainSettingsPageState, enabled)),
      onFirstNameChanged: (firstName) => store.dispatch(SetFirstNameAction(store.state.mainSettingsPageState, firstName)),
      onLastNameChanged: (lastName) => store.dispatch(SetLastNameAction(store.state.mainSettingsPageState, lastName)),
      onBusinessNameChanged: (businessName) => store.dispatch(SetBusinessNameAction(store.state.mainSettingsPageState, businessName)),
      onSaveUpdatedProfile: () => store.dispatch(SaveUpdatedUserProfileAction(store.state.mainSettingsPageState)),
      onSendSuggestionSelected: (suggestion) => store.dispatch(SendSuggestionAction(store.state.mainSettingsPageState, suggestion)),
      onDeleteAccountSelected: () => store.dispatch(DeleteAccountAction(store.state.mainSettingsPageState)),
      onPasswordChanged: (password) => store.dispatch(SavePasswordAction(store.state.mainSettingsPageState, password)),
      generate50DiscountCode: () => store.dispatch(Generate50DiscountCodeAction(store.state.mainSettingsPageState)),
      generateFreeDiscountCode: () => store.dispatch(GenerateFreeDiscountCodeAction(store.state.mainSettingsPageState)),
      onInstaUrlChanged: (url) => store.dispatch(SetUrlToStateAction(store.state.mainSettingsPageState, url)),
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
      password.hashCode ^
      onPasswordChanged.hashCode ^
      instaUrl.hashCode ^
      passwordErrorMessage.hashCode ^
      generate50DiscountCode.hashCode ^
      discountCode.hashCode ^
      generateFreeDiscountCode.hashCode ^
      isAdmin.hashCode ^
      onInstaUrlChanged.hashCode ^
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
              instaUrl == other.instaUrl &&
              onFirstNameChanged == other.onFirstNameChanged &&
              onLastNameChanged == other.onLastNameChanged &&
              onBusinessNameChanged == other.onBusinessNameChanged &&
              onSaveUpdatedProfile == other.onSaveUpdatedProfile &&
              profile == other.profile &&
              onSendSuggestionSelected == other.onSendSuggestionSelected &&
              onDeleteAccountSelected == other.onDeleteAccountSelected &&
              isDeleteFinished == other.isDeleteFinished &&
              isDeleteInProgress == other.isDeleteInProgress &&
              password == other.password &&
              onPasswordChanged == other.onPasswordChanged &&
              passwordErrorMessage == other.passwordErrorMessage &&
              generate50DiscountCode == other.generate50DiscountCode &&
              discountCode == other.discountCode &&
              isAdmin == other.isAdmin &&
              generateFreeDiscountCode == other.generateFreeDiscountCode &&
              onInstaUrlChanged == other.onInstaUrlChanged &&
              onSignOutSelected == other.onSignOutSelected;
}