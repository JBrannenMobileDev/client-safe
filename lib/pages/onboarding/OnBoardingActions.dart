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

