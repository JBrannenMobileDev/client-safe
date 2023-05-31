import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';

class SetFeatureSelectedStateAction{
  final OnBoardingPageState pageState;
  final String featureName;
  final bool isSelected;
  SetFeatureSelectedStateAction(this.pageState, this.featureName, this.isSelected);
}

class SetPagerIndexAction{
  final OnBoardingPageState pageState;
  final int index;
  SetPagerIndexAction(this.pageState, this.index);
}

class SetJobForDetailsPage{
  final OnBoardingPageState pageState;
  SetJobForDetailsPage(this.pageState);
}

class SetHasJobAnswerAction {
  final OnBoardingPageState pageState;
  final String answer;
  SetHasJobAnswerAction(this.pageState, this.answer);
}

class SetSelectedLeadSourceAction {
  final OnBoardingPageState pageState;
  final String leadSource;
  SetSelectedLeadSourceAction(this.pageState, this.leadSource);
}
