import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/RateTypeSelection.dart';
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
  String total = previousState.flatRateText.replaceFirst(r'$', '');
  double remainingBalance = int.parse(total) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    discountStage: action.discountStage,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateFixedDiscountRate(NewInvoicePageState previousState, UpdateFixedDiscountPriceAction action) {
  String fixedDiscountRate = action.fixedDiscountRate.replaceFirst(r'$', '');
  return previousState.copyWith(
    discountValue: double.parse(fixedDiscountRate),
  );
}

NewInvoicePageState _savePercentageDiscountRate(NewInvoicePageState previousState, SavePercentageDiscountRateAction action) {
  String total = previousState.flatRateText.replaceFirst(r'$', '');
  double remainingBalance = int.parse(total) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    discountStage: action.discountStage,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updatePercentageDiscountRate(NewInvoicePageState previousState, UpdatePercentageDiscountPriceAction action) {
  String percentageDiscountRate = action.percentageDiscountRate.replaceFirst(r'%', '');
  double total = previousState.total;
  double discountValue = total * ((double.parse(percentageDiscountRate))/100);
  return previousState.copyWith(
    discountValue: discountValue,
    unpaidAmount: total - discountValue,
  );
}

NewInvoicePageState _updateDiscountStage(NewInvoicePageState previousState, SetDiscountStateAction action) {
  String total = previousState.flatRateText.replaceFirst(r'$', '');
  Job selectedJob = previousState.selectedJob;
  String rateType = selectedJob.priceProfile.rateType;
  int depositAmount = selectedJob.depositAmount;
  int remainingBalance;
  switch(rateType){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      remainingBalance = int.parse(total) - (selectedJob.isDepositPaid() ? depositAmount : 0);
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      remainingBalance = int.parse(total) - (selectedJob.isDepositPaid() ? depositAmount : 0);
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      remainingBalance = int.parse(total) - (selectedJob.isDepositPaid() ? depositAmount : 0);
      break;
  }
  return previousState.copyWith(
    discountValue: action.newStage == NewInvoicePageState.DISCOUNT_STAGE_NO_STAGE ? 0 : previousState.discountValue,
    discountStage: action.newStage,
    unpaidAmount: action.newStage == NewInvoicePageState.DISCOUNT_STAGE_NO_STAGE ? remainingBalance?.toDouble() : previousState.total,
  );
}

NewInvoicePageState _updateSelectedDiscountType(NewInvoicePageState previousState, SaveSelectedDiscountTypeAction action) {
  bool isDiscountFixedRate = true;
  switch(action.discountType){
    case Invoice.DISCOUNT_TYPE_FIXED_AMOUNT:
      isDiscountFixedRate = true;
      break;
    case Invoice.DISCOUNT_TYPE_PERCENTAGE:
      isDiscountFixedRate = false;
      break;
  }
  return previousState.copyWith(
    discountStage: NewInvoicePageState.DISCOUNT_STAGE_AMOUNT_SELECTION,
    discountType: action.discountType,
    isDiscountFixedRate: isDiscountFixedRate,
  );
}

NewInvoicePageState _updateFlatRate(NewInvoicePageState previousState, UpdateFlatRateText action) {
  String total = action.flatRateText.replaceFirst(r'$', '');
  double remainingBalance = int.parse(total) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
      flatRateText: action.flatRateText,
      total: double.parse(total),
      unpaidAmount: remainingBalance?.toDouble(),
  );
}

NewInvoicePageState _saveSelectedJob(NewInvoicePageState previousState, SaveSelectedJobAction action) {
  Job selectedJob = action.selectedJob;
  String rateType = selectedJob.priceProfile.rateType;
  int depositAmount = selectedJob.depositAmount;
  int remainingBalance;
  int total;
  switch(rateType){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      remainingBalance = selectedJob.priceProfile.flatRate.toInt() - (selectedJob.isDepositPaid() ? depositAmount : 0);
      total = selectedJob.priceProfile.flatRate.toInt();
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      remainingBalance = selectedJob.priceProfile.hourlyRate.toInt() - (selectedJob.isDepositPaid() ? depositAmount : 0);
      total = selectedJob.priceProfile.hourlyRate.toInt();
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      remainingBalance = selectedJob.priceProfile.itemRate.toInt() - (selectedJob.isDepositPaid() ? depositAmount : 0);
      total = selectedJob.priceProfile.itemRate.toInt();
      break;
  }
  return previousState.copyWith(
    selectedJob: action.selectedJob,
    flatRateText: selectedJob.priceProfile.flatRate.toString(),
    depositValue: depositAmount?.toDouble(),
    total: total.toDouble(),
    unpaidAmount: remainingBalance?.toDouble(),
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