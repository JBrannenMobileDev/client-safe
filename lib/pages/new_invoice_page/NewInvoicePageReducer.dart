import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/LineItem.dart';
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
  TypedReducer<NewInvoicePageState, UpdateNewInvoiceHourlyRateTextAction>(_updateHourlyRate),
  TypedReducer<NewInvoicePageState, UpdateNewInvoiceHourlyQuantityTextAction>(_updateHourlyQuantity),
  TypedReducer<NewInvoicePageState, UpdateNewInvoiceItemTextAction>(_updateItemRate),
  TypedReducer<NewInvoicePageState, UpdateNewInvoiceItemQuantityAction>(_updateItemQuantity),
  TypedReducer<NewInvoicePageState, SetDiscountStateAction>(_updateDiscountStage),
  TypedReducer<NewInvoicePageState, SaveSelectedDiscountTypeAction>(_updateSelectedDiscountType),
  TypedReducer<NewInvoicePageState, SaveFixedDiscountRateAction>(_saveFixedDiscountRate),
  TypedReducer<NewInvoicePageState, UpdateFixedDiscountPriceAction>(_updateFixedDiscountRate),
  TypedReducer<NewInvoicePageState, SavePercentageDiscountRateAction>(_savePercentageDiscountRate),
  TypedReducer<NewInvoicePageState, UpdatePercentageDiscountPriceAction>(_updatePercentageDiscountRate),
  TypedReducer<NewInvoicePageState, UpdateLineItemNameAction>(_updateLineItemName),
  TypedReducer<NewInvoicePageState, UpdateLineItemRateAction>(_updateLineItemRate),
  TypedReducer<NewInvoicePageState, UpdateLineItemQuantityAction>(_updateLineItemQuantity),
  TypedReducer<NewInvoicePageState, SaveNewLineItemAction>(_saveNewLineItem),
  TypedReducer<NewInvoicePageState, ClearNewLineItemAction>(_clearNewLineItem),
  TypedReducer<NewInvoicePageState, DeleteLineItemAction>(_deleteLineItem),
]);

NewInvoicePageState _deleteLineItem(NewInvoicePageState previousState, DeleteLineItemAction action) {
  previousState.lineItems.removeAt(action.index);
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    lineItems: previousState.lineItems,
    total: _calculateSubtotal(previousState),
    unpaidAmount: remainingBalance,
  );
}

double _calculateSubtotal(NewInvoicePageState previousState) {
  double subtotal = 0.0;
  for(LineItem lineItem in previousState.lineItems){
    subtotal = subtotal + lineItem.itemPrice;
  }
  return subtotal;
}

NewInvoicePageState _clearNewLineItem(NewInvoicePageState previousState, ClearNewLineItemAction action) {
  return previousState.copyWith(
    newLineItemName: '',
    newLineItemRate: '',
    newLineItemQuantity: '',
  );
}

NewInvoicePageState _saveNewLineItem(NewInvoicePageState previousState, SaveNewLineItemAction action) {
  double rate = double.parse(previousState.newLineItemRate.replaceFirst(r'$', ''));
  LineItem newLineItem = LineItem(
    itemName: previousState.newLineItemName,
    itemPrice: rate,
    itemQuantity: previousState.newLineItemQuantity.length > 0 ? int.parse(previousState.newLineItemQuantity) : 1,
  );
  previousState.lineItems.add(newLineItem);
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    newLineItemName: '',
    newLineItemRate: '',
    newLineItemQuantity: '',
    lineItems: previousState.lineItems,
    total: _calculateSubtotal(previousState),
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateLineItemName(NewInvoicePageState previousState, UpdateLineItemNameAction action) {
  return previousState.copyWith(
    newLineItemName: action.name,
  );
}

NewInvoicePageState _updateLineItemRate(NewInvoicePageState previousState, UpdateLineItemRateAction action) {
  return previousState.copyWith(
    newLineItemRate: action.rate,
  );
}

NewInvoicePageState _updateLineItemQuantity(NewInvoicePageState previousState, UpdateLineItemQuantityAction action) {
  return previousState.copyWith(
    newLineItemQuantity: action.quantity,
  );
}

NewInvoicePageState _saveFixedDiscountRate(NewInvoicePageState previousState, SaveFixedDiscountRateAction action) {
  double total = 0.0;
  switch(previousState.filterType){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      total = double.parse(previousState.flatRateText.replaceFirst(r'$', ''));
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      total = double.parse(previousState.hourlyRate.replaceFirst(r'$', '')) * double.parse(previousState.hourlyQuantity);
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      total = double.parse(previousState.itemRate.replaceFirst(r'$', '')) * double.parse(previousState.itemQuantity);
      break;
  }
  double remainingBalance = total - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
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
  double total = 0.0;
  switch(previousState.filterType){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      total = double.parse(previousState.flatRateText.replaceFirst(r'$', ''));
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      total = double.parse(previousState.hourlyRate.replaceFirst(r'$', '')) * double.parse(previousState.hourlyQuantity);
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      total = double.parse(previousState.itemRate.replaceFirst(r'$', '')) * double.parse(previousState.itemQuantity);
      break;
  }
  double remainingBalance = total - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
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
  Job selectedJob = previousState.selectedJob;
  String rateType = previousState.filterType;
  int depositAmount = selectedJob.depositAmount;
  double remainingBalance = 0.0;
  switch(rateType){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      remainingBalance = (previousState.flatRateText.length > 0 ? double.parse(previousState.flatRateText.replaceFirst(r'$', '')) : 0.0) - (selectedJob.isDepositPaid() ? depositAmount : 0);
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      remainingBalance = ((previousState.hourlyRate.length > 0 ? double.parse(previousState.hourlyRate.replaceFirst(r'$', '')) : 0.0) * double.parse(previousState.hourlyQuantity)) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      remainingBalance = ((previousState.itemRate.length > 0 ? double.parse(previousState.itemRate.replaceFirst(r'$', '')) : 0.0) * double.parse(previousState.itemQuantity)) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      break;
  }
  return previousState.copyWith(
    discountValue: action.newStage == NewInvoicePageState.DISCOUNT_STAGE_NO_STAGE ? 0 : previousState.discountValue,
    discountStage: action.newStage,
    unpaidAmount: action.newStage == NewInvoicePageState.DISCOUNT_STAGE_NO_STAGE ? remainingBalance : previousState.total,
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
  double remainingBalance = double.parse(total) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
      flatRateText: action.flatRateText,
      total: double.parse(total),
      unpaidAmount: remainingBalance?.toDouble(),
  );
}

NewInvoicePageState _updateHourlyRate(NewInvoicePageState previousState, UpdateNewInvoiceHourlyRateTextAction action) {
  String hourlyRateString = action.hourlyRate.replaceFirst(r'$', '');
  double total = double.parse(hourlyRateString) * double.parse(previousState.hourlyQuantity);
  double remainingBalance = total - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    hourlyRate: action.hourlyRate,
    total: total,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateHourlyQuantity(NewInvoicePageState previousState, UpdateNewInvoiceHourlyQuantityTextAction action) {
  String hourlyRateString = previousState.hourlyRate.replaceFirst(r'$', '');
  double total = double.parse(hourlyRateString) * double.parse(action.hourlyQuantity);
  double remainingBalance = total - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    hourlyQuantity: action.hourlyQuantity,
    total: total,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateItemRate(NewInvoicePageState previousState, UpdateNewInvoiceItemTextAction action) {
  String itemRateString = action.itemRate.replaceFirst(r'$', '');
  double total = double.parse(itemRateString) * double.parse(previousState.itemQuantity);
  double remainingBalance = total - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    itemRate: action.itemRate,
    total: total,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateItemQuantity(NewInvoicePageState previousState, UpdateNewInvoiceItemQuantityAction action) {
  String itemRateString = previousState.itemRate.replaceFirst(r'$', '');
  double total = double.parse(itemRateString) * double.parse(action.itemQuantity);
  double remainingBalance = total - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    itemQuantity: action.itemQuantity,
    total: total,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _saveSelectedJob(NewInvoicePageState previousState, SaveSelectedJobAction action) {
  List<LineItem> lineItems = List();
  Job selectedJob = action.selectedJob;
  String rateType = selectedJob.priceProfile.rateType;
  double depositAmount = selectedJob.depositAmount?.toDouble();
  double remainingBalance;
  double total;
  switch(rateType){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      remainingBalance = selectedJob.priceProfile.flatRate.toDouble() - (selectedJob.isDepositPaid() ? depositAmount : 0);
      total = selectedJob.priceProfile.flatRate.toDouble();
      LineItem rateLineItem = LineItem(
        itemName: 'Flat rate',
        itemPrice: selectedJob.priceProfile.flatRate,
        itemQuantity: 1
      );
      lineItems.add(rateLineItem);
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      remainingBalance = (double.parse(previousState.hourlyRate.replaceFirst(r'$', '')) * double.parse(previousState.hourlyQuantity)) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      total = selectedJob.priceProfile.hourlyRate.toDouble();
      LineItem rateLineItem = LineItem(
          itemName: 'Hourly rate',
          itemPrice: selectedJob.priceProfile.hourlyRate,
          itemQuantity: 1
      );
      lineItems.add(rateLineItem);
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      remainingBalance = selectedJob.priceProfile.itemRate.toDouble() - (selectedJob.isDepositPaid() ? depositAmount : 0);
      total = selectedJob.priceProfile.itemRate.toDouble();
      LineItem rateLineItem = LineItem(
          itemName: 'Quantity rate',
          itemPrice: selectedJob.priceProfile.itemRate,
          itemQuantity: 1
      );
      lineItems.add(rateLineItem);
      break;
  }
  return previousState.copyWith(
    selectedJob: action.selectedJob,
    flatRateText: selectedJob.priceProfile.flatRate.toString(),
    depositValue: depositAmount,
    total: total,
    filterType: rateType,
    lineItems: lineItems,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _saveSelectedFilter(NewInvoicePageState previousState, SaveSelectedFilter action) {
  Job selectedJob = previousState.selectedJob;
  int depositAmount = selectedJob.depositAmount;
  double total = 0.0;
  double remainingBalance = 0.0;
  switch(action.selectedFilter){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      total = double.parse(previousState.flatRateText.replaceFirst(r'$', ''));
      remainingBalance = double.parse(previousState.flatRateText.replaceFirst(r'$', '')) - (selectedJob.isDepositPaid() ? depositAmount : 0);
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      total = (previousState.hourlyRate.length > 0 ? double.parse(previousState.hourlyRate.replaceFirst(r'$', '')) : 0.0) * double.parse(previousState.hourlyQuantity);
      remainingBalance = ((previousState.hourlyRate.length > 0 ? double.parse(previousState.hourlyRate.replaceFirst(r'$', '')) : 0.0) * double.parse(previousState.hourlyQuantity)) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      total = (previousState.itemRate.length > 0 ? double.parse(previousState.itemRate.replaceFirst(r'$', '')) : 0.0) * double.parse(previousState.itemQuantity);
      remainingBalance = ((previousState.itemRate.length > 0 ? double.parse(previousState.itemRate.replaceFirst(r'$', '')) : 0.0) * double.parse(previousState.itemQuantity)) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      break;
  }
  return previousState.copyWith(
    filterType: action.selectedFilter,
    total: total,
    unpaidAmount: remainingBalance,
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