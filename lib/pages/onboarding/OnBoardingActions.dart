import 'package:dandylight/pages/onboarding/OnBoardingPageState.dart';

class SetFeatureSelectedStateAction{
  final OnBoardingPageState? pageState;
  final String? featureName;
  final bool? isSelected;
  SetFeatureSelectedStateAction(this.pageState, this.featureName, this.isSelected);
}

class SetPagerIndexAction{
  final OnBoardingPageState? pageState;
  final int? index;
  SetPagerIndexAction(this.pageState, this.index);
}

class SetJobForDetailsPage{
  final OnBoardingPageState? pageState;
  SetJobForDetailsPage(this.pageState);
}

class SetHasJobAnswerAction {
  final OnBoardingPageState? pageState;
  final String? answer;
  SetHasJobAnswerAction(this.pageState, this.answer);
}

class SetOtherDescriptionAction {
  final OnBoardingPageState? pageState;
  final String? otherMessage;
  SetOtherDescriptionAction(this.pageState, this.otherMessage);
}

class SetSelectedJobCountAction {
  final OnBoardingPageState? pageState;
  final String? jobCount;
  SetSelectedJobCountAction(this.pageState, this.jobCount);
}

class SetSelectedZoomOptionAction {
  final OnBoardingPageState? pageState;
  final String? zoomOption;
  SetSelectedZoomOptionAction(this.pageState, this.zoomOption);
}

