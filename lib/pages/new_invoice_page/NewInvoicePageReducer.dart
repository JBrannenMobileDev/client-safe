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
]);

NewInvoicePageState _updateFlatRate(NewInvoicePageState previousState, UpdateFlatRateText action) {
  String rate = action.flatRateText;
  if(rate.length == 0) rate = '\$';
  return previousState.copyWith(
      flatRateText: rate,
  );
}

NewInvoicePageState _saveSelectedJob(NewInvoicePageState previousState, SaveSelectedJobAction action) {
  return previousState.copyWith(
    selectedJob: action.selectedJob,
    flatRateText: '\$' + (action.selectedJob.priceProfile?.priceHundreds ?? 0 + action.selectedJob.priceProfile?.priceFives ?? 0).toString(),
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