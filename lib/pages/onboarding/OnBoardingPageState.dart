import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'OnBoardingActions.dart';

class OnBoardingPageState{
  static const String JOB_TRACKING = "job_tracking";
  static const String INCOME_EXPENSES = "income_expenses";
  static const String POSES = "poses";
  static const String MILEAGE_TRACKING = "mileage_tracking";
  static const String INVOICES = "invoices";
  static const String BUSINESS_ANALYTICS = "business_analytics";

  final bool jobTrackingSelected;
  final bool incomeExpensesSelected;
  final bool posesSelected;
  final bool mileageTrackingSelected;
  final bool invoicesSelected;
  final bool analyticsSelected;
  final bool featuresContinueEnabled;
  final int pagerIndex;
  final Function(String, bool) onFeatureSelected;
  final Function(int) setPagerIndex;
  final Function() onViewSampleJobSelected;

  OnBoardingPageState({
    @required this.jobTrackingSelected,
    @required this.incomeExpensesSelected,
    @required this.posesSelected,
    @required this.invoicesSelected,
    @required this.analyticsSelected,
    @required this.featuresContinueEnabled,
    @required this.onFeatureSelected,
    @required this.setPagerIndex,
    @required this.pagerIndex,
    @required this.mileageTrackingSelected,
    @required this.onViewSampleJobSelected,
  });

  OnBoardingPageState copyWith({
    bool jobTrackingSelected,
    bool incomeExpensesSelected,
    bool posesSelected,
    bool invoicesSelected,
    bool analyticsSelected,
    bool featuresContinueEnabled,
    bool mileageTrackingSelected,
    int pagerIndex,
    Function(String, bool) onFeatureSelected,
    Function(int) setPagerIndex,
    Function() onViewSampleJobSelected,
  }){
    return OnBoardingPageState(
      jobTrackingSelected: jobTrackingSelected?? this.jobTrackingSelected,
      incomeExpensesSelected: incomeExpensesSelected?? this.incomeExpensesSelected,
      posesSelected: posesSelected?? this.posesSelected,
      invoicesSelected: invoicesSelected?? this.invoicesSelected,
      analyticsSelected: analyticsSelected?? this.analyticsSelected,
      featuresContinueEnabled: featuresContinueEnabled?? this.featuresContinueEnabled,
      onFeatureSelected: onFeatureSelected?? this.onFeatureSelected,
      setPagerIndex: setPagerIndex ?? this.setPagerIndex,
      pagerIndex: pagerIndex ?? this.pagerIndex,
      mileageTrackingSelected: mileageTrackingSelected ?? this.mileageTrackingSelected,
      onViewSampleJobSelected: onViewSampleJobSelected ?? this.onViewSampleJobSelected,
    );
  }

  factory OnBoardingPageState.initial() => OnBoardingPageState(
    jobTrackingSelected: false,
    incomeExpensesSelected: false,
    posesSelected: false,
    invoicesSelected: false,
    analyticsSelected: false,
    featuresContinueEnabled: false,
    onFeatureSelected: null,
    setPagerIndex: null,
    pagerIndex: 0,
    mileageTrackingSelected: false,
    onViewSampleJobSelected: null,
  );

  factory OnBoardingPageState.fromStore(Store<AppState> store) {
    return OnBoardingPageState(
      jobTrackingSelected: store.state.onBoardingPageState.jobTrackingSelected,
      incomeExpensesSelected: store.state.onBoardingPageState.incomeExpensesSelected,
      posesSelected: store.state.onBoardingPageState.posesSelected,
      invoicesSelected: store.state.onBoardingPageState.invoicesSelected,
      analyticsSelected: store.state.onBoardingPageState.analyticsSelected,
      featuresContinueEnabled: store.state.onBoardingPageState.featuresContinueEnabled,
      pagerIndex: store.state.onBoardingPageState.pagerIndex,
      mileageTrackingSelected: store.state.onBoardingPageState.mileageTrackingSelected,
      onFeatureSelected: (featureName, isSelected) => store.dispatch(SetFeatureSelectedStateAction(store.state.onBoardingPageState, featureName, isSelected)),
      setPagerIndex: (index) => store.dispatch(SetPagerIndexAction(store.state.onBoardingPageState, index)),
      onViewSampleJobSelected: () => store.dispatch(SetJobForDetailsPage(store.state.onBoardingPageState)),
    );
  }

  @override
  int get hashCode =>
      jobTrackingSelected.hashCode ^
      posesSelected.hashCode ^
      invoicesSelected.hashCode ^
      analyticsSelected.hashCode ^
      featuresContinueEnabled.hashCode ^
      onFeatureSelected.hashCode ^
      setPagerIndex.hashCode ^
      pagerIndex.hashCode ^
      mileageTrackingSelected.hashCode ^
      onViewSampleJobSelected.hashCode ^
      incomeExpensesSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OnBoardingPageState &&
              jobTrackingSelected == other.jobTrackingSelected &&
              posesSelected == other.posesSelected &&
              invoicesSelected == other.invoicesSelected &&
              analyticsSelected == other.analyticsSelected &&
              featuresContinueEnabled == other.featuresContinueEnabled &&
              onFeatureSelected == other.onFeatureSelected &&
              setPagerIndex == other.setPagerIndex &&
              pagerIndex == other.pagerIndex &&
              onViewSampleJobSelected == other.onViewSampleJobSelected &&
              mileageTrackingSelected == other.mileageTrackingSelected &&
              incomeExpensesSelected == other.incomeExpensesSelected;
}