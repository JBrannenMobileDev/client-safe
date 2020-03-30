import 'package:client_safe/models/Discount.dart';
import 'package:client_safe/models/Invoice.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/LineItem.dart';
import 'package:client_safe/pages/new_invoice_page/NewDiscountDialog.dart';
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
  TypedReducer<NewInvoicePageState, UpdateLineItemNameAction>(_updateLineItemName),
  TypedReducer<NewInvoicePageState, UpdateLineItemRateAction>(_updateLineItemRate),
  TypedReducer<NewInvoicePageState, UpdateLineItemQuantityAction>(_updateLineItemQuantity),
  TypedReducer<NewInvoicePageState, SaveNewLineItemAction>(_saveNewLineItem),
  TypedReducer<NewInvoicePageState, ClearNewLineItemAction>(_clearNewLineItem),
  TypedReducer<NewInvoicePageState, DeleteLineItemAction>(_deleteLineItem),
  TypedReducer<NewInvoicePageState, ClearNewDiscountAction>(_clearDiscountState),
  TypedReducer<NewInvoicePageState, DeleteDiscountAction>(_deleteDiscount),
  TypedReducer<NewInvoicePageState, UpdateNewDiscountPercentageTextAction>(_updateDiscountPercentage),
  TypedReducer<NewInvoicePageState, UpdateNewDiscountRateTextAction>(_updateDiscountRate),
  TypedReducer<NewInvoicePageState, SaveNewDiscountAction>(_saveNewDiscount),
  TypedReducer<NewInvoicePageState, UpdateNewDiscountSelectorAction>(_updateDiscountSelector),
]);

NewInvoicePageState _saveNewDiscount(NewInvoicePageState previousState, SaveNewDiscountAction action) {
  double discountRate = previousState.newDiscountRate.length > 0 ? double.parse(previousState.newDiscountRate.replaceFirst(r'$', '')) : 0;
  double discountPercentage = previousState.newDiscountPercentage.length > 0 ? double.parse(previousState.newDiscountPercentage.replaceFirst(r'%', '')) : 0;
  Discount discount = Discount(
    selectedFilter: previousState.newDiscountFilter,
    rate: discountRate,
    percentage: discountPercentage,
  );
  double discountValue = 0.0;
  switch(discount.selectedFilter){
    case NewDiscountDialog.SELECTOR_TYPE_FIXED:
      discountValue = discount.rate;
      break;
    case NewDiscountDialog.SELECTOR_TYPE_PERCENTAGE:
      discountValue = (previousState.total * (discountPercentage/100)).toDouble();
      break;
  }
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - discountValue;
  return previousState.copyWith(
    newDiscountFilter: NewDiscountDialog.SELECTOR_TYPE_FIXED,
    newDiscountRate: '',
    newDiscountPercentage: '',
    discountValue: discountValue,
    discount: discount,
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateDiscountRate(NewInvoicePageState previousState, UpdateNewDiscountRateTextAction action) {
  return previousState.copyWith(
    newDiscountRate: action.rate,
  );
}

NewInvoicePageState _updateDiscountSelector(NewInvoicePageState previousState, UpdateNewDiscountSelectorAction action) {
  return previousState.copyWith(
    newDiscountFilter: action.selectorName,
  );
}

NewInvoicePageState _updateDiscountPercentage(NewInvoicePageState previousState, UpdateNewDiscountPercentageTextAction action) {
  return previousState.copyWith(
    newDiscountPercentage: action.percentage,
  );
}

NewInvoicePageState _deleteDiscount(NewInvoicePageState previousState, DeleteDiscountAction action) {
  return previousState.copyWith(
    discount: null,
    discountValue: 0.0,
  );
}

NewInvoicePageState _clearDiscountState(NewInvoicePageState previousState, ClearNewDiscountAction action) {
  return previousState.copyWith(
    newDiscountPercentage: '',
    newDiscountRate: '',
    newDiscountFilter: NewDiscountDialog.SELECTOR_TYPE_FIXED,
  );
}

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
    subtotal = subtotal + (lineItem.itemPrice * lineItem.itemQuantity);
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

NewInvoicePageState _updateFlatRate(NewInvoicePageState previousState, UpdateFlatRateText action) {
  String flatRate = action.flatRateText.replaceFirst(r'$', '');
  previousState.lineItems.elementAt(0).itemPrice = double.parse(flatRate);
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    lineItems: previousState.lineItems,
      flatRateText: action.flatRateText,
      total: _calculateSubtotal(previousState),
      unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateHourlyRate(NewInvoicePageState previousState, UpdateNewInvoiceHourlyRateTextAction action) {
  String hourlyRateString = action.hourlyRate.replaceFirst(r'$', '');
  previousState.lineItems.elementAt(0).itemPrice = hourlyRateString.length > 0 ? double.parse(hourlyRateString) : 0.0;
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    hourlyRate: action.hourlyRate,
    total: _calculateSubtotal(previousState),
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateHourlyQuantity(NewInvoicePageState previousState, UpdateNewInvoiceHourlyQuantityTextAction action) {
  previousState.lineItems.elementAt(0).itemQuantity = action.hourlyQuantity.length > 0 ? int.parse(action.hourlyQuantity) : 0;
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    hourlyQuantity: action.hourlyQuantity,
    total: _calculateSubtotal(previousState),
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateItemRate(NewInvoicePageState previousState, UpdateNewInvoiceItemTextAction action) {
  String itemRateString = action.itemRate.replaceFirst(r'$', '');
  previousState.lineItems.elementAt(0).itemPrice = itemRateString.length > 0 ? double.parse(itemRateString) : 0.0;
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    itemRate: action.itemRate,
    total: _calculateSubtotal(previousState),
    unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _updateItemQuantity(NewInvoicePageState previousState, UpdateNewInvoiceItemQuantityAction action) {
  previousState.lineItems.elementAt(0).itemQuantity = action.itemQuantity.length > 0 ? int.parse(action.itemQuantity) : 0;
  double remainingBalance = _calculateSubtotal(previousState) - (previousState.selectedJob.isDepositPaid() ? previousState.depositValue : 0) - previousState.discountValue;
  return previousState.copyWith(
    itemQuantity: action.itemQuantity,
    total: _calculateSubtotal(previousState),
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
      remainingBalance = selectedJob.priceProfile.flatRate - (selectedJob.isDepositPaid() ? depositAmount : 0);
      total = selectedJob.priceProfile.flatRate;
      LineItem rateLineItem = LineItem(
        itemName: 'Flat rate',
        itemPrice: selectedJob.priceProfile.flatRate,
        itemQuantity: 1
      );
      lineItems.add(rateLineItem);
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      remainingBalance = 0 - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      total = 0;
      LineItem rateLineItem = LineItem(
          itemName: 'Hourly rate',
          itemPrice: selectedJob.priceProfile.hourlyRate,
          itemQuantity: 0
      );
      lineItems.add(rateLineItem);
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      remainingBalance = 0 - (selectedJob.isDepositPaid() ? depositAmount : 0);
      total = 0;
      LineItem rateLineItem = LineItem(
          itemName: 'Quantity rate',
          itemPrice: selectedJob.priceProfile.itemRate,
          itemQuantity: 0
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
  double remainingBalance = 0.0;
  switch(action.selectedFilter){
    case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
      previousState.lineItems.elementAt(0).itemName = 'Flat rate';
      previousState.lineItems.elementAt(0).itemQuantity = 1;
      previousState.lineItems.elementAt(0).itemPrice = previousState.flatRateText.length > 0 ? double.parse(previousState.flatRateText.replaceFirst(r'$', '')) : 0.0;
      remainingBalance = _calculateSubtotal(previousState) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      break;
    case RateTypeSelection.SELECTOR_TYPE_HOURLY:
      previousState.lineItems.elementAt(0).itemName = 'Hourly rate';
      previousState.lineItems.elementAt(0).itemPrice = previousState.hourlyRate.length > 0 ? double.parse(previousState.hourlyRate.replaceFirst(r'$', '')) : 0.0;
      previousState.lineItems.elementAt(0).itemQuantity = previousState.hourlyQuantity.length > 0 ? int.parse(previousState.hourlyQuantity) : 0;
      remainingBalance = _calculateSubtotal(previousState) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      break;
    case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
      previousState.lineItems.elementAt(0).itemName = 'Quantity rate';
      previousState.lineItems.elementAt(0).itemPrice = previousState.itemRate.length > 0 ? double.parse(previousState.itemRate.replaceFirst(r'$', '')) : 0.0;
      previousState.lineItems.elementAt(0).itemQuantity = previousState.itemQuantity.length > 0 ? int.parse(previousState.itemQuantity) : 0;
      remainingBalance = _calculateSubtotal(previousState) - (selectedJob.isDepositPaid() ? depositAmount : 0) - previousState.discountValue;
      break;
  }
  return previousState.copyWith(
    filterType: action.selectedFilter,
    total: _calculateSubtotal(previousState),
    lineItems: previousState.lineItems,
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