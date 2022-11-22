import 'OnboardingFlowPageState.dart';

class SaveTermsAndPrivacyStateAction{
  final OnBoardingFlowPageState pageState;
  final bool isChecked;
  SaveTermsAndPrivacyStateAction(this.pageState, this.isChecked);
}

class SaveSkipAllStateAction {
  final OnBoardingFlowPageState pageState;
  SaveSkipAllStateAction(this.pageState);
}

class IncrementPagerIndexAction{
  final OnBoardingFlowPageState pageState;
  IncrementPagerIndexAction(this.pageState);
}

class SaveOnBoardingCompleteAction{
  final OnBoardingFlowPageState pageState;
  SaveOnBoardingCompleteAction(this.pageState);
}

class DecrementPagerIndexAction{
  final OnBoardingFlowPageState pageState;
  DecrementPagerIndexAction(this.pageState);
}

class UpdatePushNotificationEnabled{
  final OnBoardingFlowPageState pageState;
  final bool enabled;
  UpdatePushNotificationEnabled(this.pageState, this.enabled);
}

class UpdateCalendarEnabled{
  final OnBoardingFlowPageState pageState;
  final bool enabled;
  UpdateCalendarEnabled(this.pageState, this.enabled);
}

class LoadSettingsFromProfileOnBoarding{
  final OnBoardingFlowPageState pageState;
  LoadSettingsFromProfileOnBoarding(this.pageState);
}

class SavePushNotificationSettingActionOnBoarding{
  final OnBoardingFlowPageState pageState;
  final bool enabled;
  SavePushNotificationSettingActionOnBoarding(this.pageState, this.enabled);
}

class SaveCalendarSettingActionOnBoarding{
  final OnBoardingFlowPageState pageState;
  final bool enabled;
  SaveCalendarSettingActionOnBoarding(this.pageState, this.enabled);
}

class ValidateStateForNextStepAction{
  final OnBoardingFlowPageState pageState;
  ValidateStateForNextStepAction(this.pageState);
}

