import 'package:dandylight/models/LeadSource.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'OnBoardingActions.dart';

class OnBoardingPageState{
  static const String TRACKING_MY_JOBS = "To track my jobs";
  static const String TRACK_INCOME_AND_EXPENSES = "To track income & expenses";
  static const String BOOKING_AND_AVAILABILITY = "Booking & availability";
  static const String POSES_FOR_INSPIRATION = "Poses for inspiration";
  static const String HAVING_EVERYTHING_IN_ONE_PLACE = "To have everything in one place";
  static const String LOOK_PROFESSIONAL = "To look professional to clients";
  static const String CLIENT_GALLERIES = "Client galleries";
  static const String CONTRACTS = "Branded Contracts";
  static const String INVOICES = "Branded Invoices";
  static const String QUESTIONNAIRES = "Branded Questionnaires";
  static const String CLIENT_GUIDES = "Client guides";
  static const String SUN_TRACKER = "Sun tracker";
  static const String TRACKING_MILES_FOR_TAXES = "To track miles for taxes";
  static const String OTHER = "Other";
  static const String LESS_THAN_5 = "Less than 5";
  static const String BETWEEN_5_15 = "Between 5 - 10";
  static const String MORE_THAN_15 = "More than 10";
  static const String APP_WALKTHROUGH = "App walkthrough (15min)";
  static const String FIRST_TIME_SETUP = "First time setup (15min)";
  static const String NEW_USER_SURVEY = "New user survey (3-5 min)";

  static const String HAS_JOB_YES = "has_job_yes";
  static const String HAS_JOB_NO = "has_job_no";

  final List<String>? selectedReasons;
  final int? pagerIndex;
  final String? selectedJobCount;
  final bool? featuresContinueEnabled;
  final bool? typeContinueEnable;
  final String? selectedOptionHasJob;
  final String? otherDescription;
  final String? selectedZoomOption;
  final List<LeadSource>? leadSources;
  final Function(String)? onHasJobAnswered;
  final Function(String, bool)? onFeatureSelected;
  final Function(int)? setPagerIndex;
  final Function()? onViewSampleJobSelected;
  final Function(String)? onOtherChanged;
  final Function(String)? onJobCountSelected;
  final Function(String)? onZoomOptionSelected;
  final Function()? setOnboardingComplete;

  OnBoardingPageState({
    @required this.onFeatureSelected,
    @required this.setPagerIndex,
    @required this.pagerIndex,
    @required this.onViewSampleJobSelected,
    @required this.selectedOptionHasJob,
    @required this.onHasJobAnswered,
    @required this.leadSources,
    @required this.otherDescription,
    @required this.onOtherChanged,
    @required this.selectedReasons,
    @required this.featuresContinueEnabled,
    @required this.typeContinueEnable,
    @required this.selectedJobCount,
    @required this.onJobCountSelected,
    @required this.selectedZoomOption,
    @required this.onZoomOptionSelected,
    @required this.setOnboardingComplete,
  });

  OnBoardingPageState copyWith({
    bool? featuresContinueEnabled,
    bool? typeContinueEnable,
    int? pagerIndex,
    String? selectedJobCount,
    String? selectedOptionHasJob,
    String? otherDescription,
    String? selectedZoomOption,
    List<LeadSource>? leadSources,
    List<String>? selectedReasons,
    Function(String, bool)? onFeatureSelected,
    Function(int)? setPagerIndex,
    Function()? onViewSampleJobSelected,
    Function(String)? onHasJobAnswered,
    Function(String)? onOtherChanged,
    Function(String)? onJobCountSelected,
    Function(String)? onZoomOptionSelected,
    Function()? setOnboardingComplete,
  }){
    return OnBoardingPageState(
      onFeatureSelected: onFeatureSelected?? this.onFeatureSelected,
      setPagerIndex: setPagerIndex ?? this.setPagerIndex,
      pagerIndex: pagerIndex ?? this.pagerIndex,
      onViewSampleJobSelected: onViewSampleJobSelected ?? this.onViewSampleJobSelected,
      onHasJobAnswered: onHasJobAnswered ?? this.onHasJobAnswered,
      selectedOptionHasJob: selectedOptionHasJob ?? this.selectedOptionHasJob,
      leadSources: leadSources ?? this.leadSources,
      otherDescription: otherDescription ?? this.otherDescription,
      onOtherChanged: onOtherChanged ?? this.onOtherChanged,
      selectedReasons: selectedReasons ?? this.selectedReasons,
      featuresContinueEnabled: featuresContinueEnabled ?? this.featuresContinueEnabled,
      typeContinueEnable: typeContinueEnable ?? this.typeContinueEnable,
      selectedJobCount: selectedJobCount ?? this.selectedJobCount,
      onJobCountSelected: onJobCountSelected ?? this.onJobCountSelected,
      selectedZoomOption: selectedZoomOption ?? this.selectedZoomOption,
      onZoomOptionSelected: onZoomOptionSelected ?? this.onZoomOptionSelected,
      setOnboardingComplete: setOnboardingComplete ?? this.setOnboardingComplete,
    );
  }

  factory OnBoardingPageState.initial() => OnBoardingPageState(
    onFeatureSelected: null,
    setPagerIndex: null,
    pagerIndex: 0,
    onViewSampleJobSelected: null,
    selectedOptionHasJob: "",
    onHasJobAnswered: null,
    leadSources: [],
    otherDescription: '',
    onOtherChanged: null,
    featuresContinueEnabled: false,
    typeContinueEnable: true,
    selectedReasons: [],
    selectedJobCount: '',
    onJobCountSelected: null,
    selectedZoomOption: '',
    onZoomOptionSelected: null,
    setOnboardingComplete: null,
  );

  factory OnBoardingPageState.fromStore(Store<AppState> store) {
    return OnBoardingPageState(
      pagerIndex: store.state.onBoardingPageState!.pagerIndex,
      selectedOptionHasJob: store.state.onBoardingPageState!.selectedOptionHasJob,
      leadSources: store.state.onBoardingPageState!.leadSources,
      otherDescription: store.state.onBoardingPageState!.otherDescription,
      selectedReasons: store.state.onBoardingPageState!.selectedReasons,
      featuresContinueEnabled: store.state.onBoardingPageState!.featuresContinueEnabled,
      typeContinueEnable: store.state.onBoardingPageState!.typeContinueEnable,
      selectedJobCount: store.state.onBoardingPageState!.selectedJobCount,
      selectedZoomOption: store.state.onBoardingPageState!.selectedZoomOption,
      onFeatureSelected: (featureName, isSelected) => store.dispatch(SetFeatureSelectedStateAction(store.state.onBoardingPageState, featureName, isSelected)),
      setPagerIndex: (index) => store.dispatch(SetPagerIndexAction(store.state.onBoardingPageState, index)),
      onViewSampleJobSelected: () => store.dispatch(SetJobForDetailsPage(store.state.onBoardingPageState)),
      onHasJobAnswered: (answer) => store.dispatch(SetHasJobAnswerAction(store.state.onBoardingPageState, answer)),
      onOtherChanged: (otherMessage) => store.dispatch(SetOtherDescriptionAction(store.state.onBoardingPageState, otherMessage)),
      onJobCountSelected: (jobCount) => store.dispatch(SetSelectedJobCountAction(store.state.onBoardingPageState, jobCount)),
      onZoomOptionSelected: (zoomOption) => store.dispatch(SetSelectedZoomOptionAction(store.state.onBoardingPageState, zoomOption)),
      setOnboardingComplete: () => store.dispatch(SetOnBoardingFinishedAction(store.state.onBoardingPageState)),
    );
  }

  @override
  int get hashCode =>
      onFeatureSelected.hashCode ^
      setPagerIndex.hashCode ^
      pagerIndex.hashCode ^
      leadSources.hashCode ^
      onViewSampleJobSelected.hashCode ^
      selectedOptionHasJob.hashCode ^
      onHasJobAnswered.hashCode ^
      otherDescription.hashCode ^
      onOtherChanged.hashCode ^
      featuresContinueEnabled.hashCode ^
      typeContinueEnable.hashCode ^
      onJobCountSelected.hashCode ^
      selectedJobCount.hashCode ^
      selectedZoomOption.hashCode ^
      onZoomOptionSelected.hashCode ^
      setOnboardingComplete.hashCode ^
      selectedReasons.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OnBoardingPageState &&
              onFeatureSelected == other.onFeatureSelected &&
              setPagerIndex == other.setPagerIndex &&
              pagerIndex == other.pagerIndex &&
              onViewSampleJobSelected == other.onViewSampleJobSelected &&
              selectedOptionHasJob == other.selectedOptionHasJob &&
              onHasJobAnswered == other.onHasJobAnswered &&
              leadSources == other.leadSources &&
              otherDescription == other.otherDescription &&
              onOtherChanged == other.onOtherChanged &&
              featuresContinueEnabled == other.featuresContinueEnabled &&
              typeContinueEnable == other.typeContinueEnable &&
              selectedJobCount == other.selectedJobCount &&
              onJobCountSelected == other.onJobCountSelected &&
              selectedZoomOption == other.selectedZoomOption &&
              onZoomOptionSelected == other.onZoomOptionSelected &&
              setOnboardingComplete == other.setOnboardingComplete &&
              selectedReasons == other.selectedReasons;
}