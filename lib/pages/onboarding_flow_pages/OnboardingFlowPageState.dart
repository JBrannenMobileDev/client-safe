import 'package:dandylight/data_layer/local_db/SembastDb.dart';
import 'package:dandylight/models/Profile.dart';
import 'package:dandylight/pages/login_page/LoginPageActions.dart';
import 'package:dandylight/pages/onboarding_flow_pages/OnBoardingFlowPageActions.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/JobType.dart';
import '../../models/PriceProfile.dart';

class OnBoardingFlowPageState{
  final bool pushNotificationsEnabled;
  final bool calendarEnabled;
  final Profile profile;
  final bool termsAndPrivacyChecked;
  final bool showTermsAndPrivacyError;
  final int pagerIndex;
  final List<JobType> jobTypes;
  final List<PriceProfile> priceProfiles;
  final Function(bool) onTermsAndPrivacyChecked;
  final Function() onSkipAllSelected;
  final Function() onSkipStepSelected;
  final Function() onBackSelected;
  final Function(bool) onPushNotificationsChanged;
  final Function(bool) onCalendarChanged;
  final Function() onLetsGetStartedSelected;
  final Function() onNextSelected;
  final Function() onBoardingComplete;

  OnBoardingFlowPageState({
    @required this.pushNotificationsEnabled,
    @required this.calendarEnabled,
    @required this.onPushNotificationsChanged,
    @required this.onCalendarChanged,
    @required this.profile,
    @required this.termsAndPrivacyChecked,
    @required this.showTermsAndPrivacyError,
    @required this.pagerIndex,
    @required this.onTermsAndPrivacyChecked,
    @required this.onSkipAllSelected,
    @required this.onSkipStepSelected,
    @required this.onBackSelected,
    @required this.onLetsGetStartedSelected,
    @required this.onNextSelected,
    @required this.onBoardingComplete,
    @required this.jobTypes,
    @required this.priceProfiles,
  });

  OnBoardingFlowPageState copyWith({
    bool pushNotificationsEnabled,
    bool calendarEnabled,
    Profile profile,
    Function(bool) onPushNotificationsChanged,
    Function(bool) onCalendarChanged,
    bool termsAndPrivacyChecked,
    bool showTermsAndPrivacyError,
    int pagerIndex,
    List<JobType> jobTypes,
    List<PriceProfile> priceProfiles,
    Function(bool) onTermsAndPrivacyChecked,
    Function() onSkipAllSelected,
    Function() onSkipStepSelected,
    Function() onBackSelected,
    Function() onLetsGetStartedSelected,
    Function() onNextSelected,
    Function() onBoardingComplete,
  }){
    return OnBoardingFlowPageState(
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      calendarEnabled: calendarEnabled ?? this.calendarEnabled,
      onPushNotificationsChanged: onPushNotificationsChanged ?? this.onPushNotificationsChanged,
      onCalendarChanged: onCalendarChanged ?? this.onCalendarChanged,
      profile: profile ?? this.profile,
      termsAndPrivacyChecked: termsAndPrivacyChecked ?? this.termsAndPrivacyChecked,
      showTermsAndPrivacyError: showTermsAndPrivacyError ?? this.showTermsAndPrivacyError,
      pagerIndex: pagerIndex ?? this.pagerIndex,
      onTermsAndPrivacyChecked: onTermsAndPrivacyChecked ?? this.onTermsAndPrivacyChecked,
      onSkipAllSelected: onSkipAllSelected ?? this.onSkipAllSelected,
      onSkipStepSelected: onSkipStepSelected ?? this.onSkipStepSelected,
      onBackSelected: onBackSelected ?? this.onBackSelected,
      onLetsGetStartedSelected: onLetsGetStartedSelected ?? this.onLetsGetStartedSelected,
      onNextSelected: onNextSelected ?? this.onNextSelected,
      onBoardingComplete: onBoardingComplete ?? this.onBoardingComplete,
      jobTypes: jobTypes ?? this.jobTypes,
      priceProfiles: priceProfiles ?? this.priceProfiles,
    );
  }

  factory OnBoardingFlowPageState.initial() => OnBoardingFlowPageState(
    onPushNotificationsChanged: null,
    onCalendarChanged: null,
    pushNotificationsEnabled: false,
    calendarEnabled: false,
    profile: null,
    termsAndPrivacyChecked: false,
    showTermsAndPrivacyError: false,
    pagerIndex: 0,
    onTermsAndPrivacyChecked: null,
    onSkipStepSelected: null,
    onSkipAllSelected: null,
    onBackSelected: null,
    onLetsGetStartedSelected: null,
    onNextSelected: null,
    onBoardingComplete: null,
    jobTypes: [],
    priceProfiles: [],
  );

  factory OnBoardingFlowPageState.fromStore(Store<AppState> store) {
    return OnBoardingFlowPageState(
      pushNotificationsEnabled: store.state.onBoardingFlowPageState.pushNotificationsEnabled,
      calendarEnabled: store.state.onBoardingFlowPageState.calendarEnabled,
      profile: store.state.onBoardingFlowPageState.profile,
      termsAndPrivacyChecked: store.state.onBoardingFlowPageState.termsAndPrivacyChecked,
      showTermsAndPrivacyError: store.state.onBoardingFlowPageState.showTermsAndPrivacyError,
      pagerIndex: store.state.onBoardingFlowPageState.pagerIndex,
      jobTypes: store.state.onBoardingFlowPageState.jobTypes,
      priceProfiles: store.state.onBoardingFlowPageState.priceProfiles,
      onTermsAndPrivacyChecked: (isChecked) => store.dispatch(SaveTermsAndPrivacyStateAction(store.state.onBoardingFlowPageState, isChecked)),
      onSkipAllSelected: () => store.dispatch(SaveSkipAllStateAction(store.state.onBoardingFlowPageState)),
      onSkipStepSelected: () => store.dispatch(IncrementPagerIndexAction(store.state.onBoardingFlowPageState)),
      onBackSelected: () => store.dispatch(DecrementPagerIndexAction(store.state.onBoardingFlowPageState)),
      onPushNotificationsChanged: (enabled) => store.dispatch(SavePushNotificationSettingActionOnBoarding(store.state.onBoardingFlowPageState, enabled)),
      onCalendarChanged: (enabled) => store.dispatch(SaveCalendarSettingActionOnBoarding(store.state.onBoardingFlowPageState, enabled)),
      onLetsGetStartedSelected: () => store.dispatch(ValidateStateForNextStepAction(store.state.onBoardingFlowPageState)),
      onNextSelected: () => store.dispatch(IncrementPagerIndexAction(store.state.onBoardingFlowPageState)),
      onBoardingComplete: () => store.dispatch(SaveOnBoardingCompleteAction(store.state.onBoardingFlowPageState)),
    );
  }

  @override
  int get hashCode =>
      termsAndPrivacyChecked.hashCode ^
      showTermsAndPrivacyError.hashCode ^
      pagerIndex.hashCode ^
      onTermsAndPrivacyChecked.hashCode ^
      onSkipAllSelected.hashCode ^
      onSkipStepSelected.hashCode ^
      onBackSelected.hashCode ^
      pushNotificationsEnabled.hashCode ^
      calendarEnabled.hashCode ^
      onPushNotificationsChanged.hashCode ^
      onCalendarChanged.hashCode ^
      onLetsGetStartedSelected.hashCode ^
      onNextSelected.hashCode ^
      onBoardingComplete.hashCode ^
      profile.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OnBoardingFlowPageState &&
              termsAndPrivacyChecked == other.termsAndPrivacyChecked &&
              showTermsAndPrivacyError == other.showTermsAndPrivacyError &&
              pagerIndex == other.pagerIndex &&
              onTermsAndPrivacyChecked == other.onTermsAndPrivacyChecked &&
              onSkipStepSelected == other.onSkipStepSelected &&
              onSkipAllSelected == other.onSkipAllSelected &&
              onBackSelected == other.onBackSelected &&
              onLetsGetStartedSelected == other.onLetsGetStartedSelected &&
              pushNotificationsEnabled == other.pushNotificationsEnabled &&
              calendarEnabled == other.calendarEnabled &&
              onPushNotificationsChanged == other.onPushNotificationsChanged &&
              onCalendarChanged == other.onCalendarChanged &&
              onNextSelected == other.onNextSelected &&
              onBoardingComplete == other.onBoardingComplete &&
              profile == other.profile;
}