import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:redux/redux.dart';

final newInvoicePageReducer = combineReducers<NewInvoicePageState>([
  TypedReducer<NewInvoicePageState, SetAllJobsAction>(_setJobs),
  TypedReducer<NewInvoicePageState, SaveSelectedJobAction>(_saveSelectedJob),
  TypedReducer<NewInvoicePageState, ClearStateAction>(_clearState),
  TypedReducer<NewInvoicePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewInvoicePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewInvoicePageState, FilterJobList>(_filterJobs),
  TypedReducer<NewInvoicePageState, SaveSelectedFilter>(_saveSelectedFilter),
  TypedReducer<NewInvoicePageState, UpdateFlatRateText>(_updateFlatRate),
  TypedReducer<NewInvoicePageState, SetDiscountStateAction>(_updateDiscountStage),
  TypedReducer<NewInvoicePageState, SaveSelectedDiscountTypeAction>(_updateSelectedDiscountType),
  TypedReducer<NewInvoicePageState, SaveFixedDiscountRateAction>(_saveFixedDiscountRate),
  TypedReducer<NewInvoicePageState, UpdateFixedDiscountPriceAction>(_updateFixedDiscountRate),
  TypedReducer<NewInvoicePageState, SavePercentageDiscountRateAction>(_savePercentageDiscountRate),
  TypedReducer<NewInvoicePageState, UpdatePercentageDiscountPriceAction>(_updatePercentageDiscountRate),
]);

NewInvoicePageState _saveFixedDiscountRate(NewInvoicePageState previousState, SaveFixedDiscountRateAction action) {
  return previousState.copyWith(
    discountStage: action.discountStage,
  );
}

NewInvoicePageState _updateFixedDiscountRate(NewInvoicePageState previousState, UpdateFixedDiscountPriceAction action) {
  return previousState.copyWith(
    discountValue: double.parse(action.fixedDiscountRate),
  );
}

NewInvoicePageState _savePercentageDiscountRate(NewInvoicePageState previousState, SavePercentageDiscountRateAction action) {
  return previousState.copyWith(
    discountStage: action.discountStage,
  );
}

NewInvoicePageState _updatePercentageDiscountRate(NewInvoicePageState previousState, UpdatePercentageDiscountPriceAction action) {
  double total = previousState.total;
  double discountValue = total * ((double.parse(action.percentageDiscountRate))/100);
  return previousState.copyWith(
    discountValue: discountValue,
  );
}

NewInvoicePageState _updateDiscountStage(NewInvoicePageState previousState, SetDiscountStateAction action) {
  return previousState.copyWith(
    discountStage: action.newStage,
  );
}

NewInvoicePageState _updateSelectedDiscountType(NewInvoicePageState previousState, SaveSelectedDiscountTypeAction action) {
  return previousState.copyWith(
    discountStage: NewInvoicePageState.DISCOUNT_STAGE_AMOUNT_SELECTION,
    discountType: action.discountType,
  );
}

NewInvoicePageState _updateFlatRate(NewInvoicePageState previousState, UpdateFlatRateText action) {
  return previousState.copyWith(
      flatRateText: action.flatRateText,
  );
}

NewInvoicePageState _saveSelectedJob(NewInvoicePageState previousState, SaveSelectedJobAction action) {
  return previousState.copyWith(
    selectedJob: action.selectedJob,
//    flatRateText: '\$' + (action.selectedJob.priceProfile?.priceHundreds ?? 0 + action.selectedJob.priceProfile?.priceFives ?? 0).toString(),
//    depositValue: action.selectedJob.depositAmount,
//    total: (action.selectedJob.priceProfile?.priceHundreds ?? 0 + action.selectedJob.priceProfile?.priceFives ?? 0).toDouble(),
//    unpaidAmount: (action.selectedJob.priceProfile?.priceHundreds ?? 0 + action.selectedJob.priceProfile?.priceFives ?? 0).toDouble() - action.selectedJob.depositAmount,
  );
}

NewInvoicePageState _saveSelectedFilter(NewInvoicePageState previousState, SaveSelectedFilter action) {
  return previousState.copyWith(
    filterType: action.selectedFilter,
  );
}

NewInvoicePageState _clearState(NewInvoicePageState previousState, ClearStateAction action) {
  return NewInvoicePageState.initial();
}

NewInvoicePageState _setJobs(NewInvoicePageState previousState, SetAllJobsAction action) {
  return previousState.copyWith(
    jobs: action.allJobs,
    filteredJobs: action.allJobs,
    allClients: action.allClients,
    isFinishedFetchingClients: true,
  );
}

NewInvoicePageState _incrementPageViewIndex(NewInvoicePageState previousState, IncrementPageViewIndex action) {
  return previousState.copyWith(
      pageViewIndex: (previousState.pageViewIndex + 1),
  );
}

NewInvoicePageState _decrementPageViewIndex(NewInvoicePageState previousState, DecrementPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: (previousState.pageViewIndex - 1),
  );
}

NewInvoicePageState _filterJobs(NewInvoicePageState previousState, FilterJobList action) {
  List<Job> filteredJobs = action.searchText.length > 0
      ? previousState.jobs
      .where((job) => job
      .jobTitle
      .toLowerCase()
      .contains(action.searchText.toLowerCase()))
      .toList()
      : previousState.jobs;
  return previousState.copyWith(
    filteredJobs: filteredJobs,
  );
}