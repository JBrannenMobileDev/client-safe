import 'package:dandylight/models/Discount.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

final newInvoicePageReducer = combineReducers<NewInvoicePageState>([
  TypedReducer<NewInvoicePageState, SetAllJobsAction>(_setJobs),
  TypedReducer<NewInvoicePageState, SetShouldClearAction>(_setShouldClear),
  TypedReducer<NewInvoicePageState, SaveSelectedJobAction>(_saveSelectedJob),
  TypedReducer<NewInvoicePageState, ClearNewInvoiceStateAction>(_clearState),
  TypedReducer<NewInvoicePageState, IncrementPageViewIndex>(_incrementPageViewIndex),
  TypedReducer<NewInvoicePageState, DecrementPageViewIndex>(_decrementPageViewIndex),
  TypedReducer<NewInvoicePageState, FilterJobList>(_filterJobs),
  TypedReducer<NewInvoicePageState, UpdateFlatRateText>(_updateFlatRate),
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
  TypedReducer<NewInvoicePageState, SetSelectedDueDate>(_setDueDate),
  TypedReducer<NewInvoicePageState, SetSelectedDepositDueDate>(_setDepositDueDate),
  TypedReducer<NewInvoicePageState, SetDepositCheckBoxStateAction>(_setDepositCheckState),
  TypedReducer<NewInvoicePageState, SetSalesTaxCheckBoxStateAction>(_setSalesTaxCheckState),
  TypedReducer<NewInvoicePageState, SetSelectedSalesTaxRate>(_setSalesTaxRate),
]);

NewInvoicePageState _setSalesTaxRate(NewInvoicePageState previousState, SetSelectedSalesTaxRate action) {
  double rateValue = double.parse(action.rate!.replaceFirst(r'%', ''));
  return previousState.copyWith(
    salesTaxPercent: rateValue,
    unpaidAmount: calculateRemainingBalance(previousState, previousState.discountValue!, previousState.isSalesTaxChecked!, rateValue),
    total: _calculateTotal(previousState, previousState.discountValue!, previousState.isSalesTaxChecked!, rateValue),
    subtotal: _calculateSubtotal(previousState),
  );
}

NewInvoicePageState _setSalesTaxCheckState(NewInvoicePageState previousState, SetSalesTaxCheckBoxStateAction action) {
  return previousState.copyWith(
    isSalesTaxChecked: action.isChecked,
      unpaidAmount: calculateRemainingBalance(previousState, previousState.discountValue!, action.isChecked!, previousState.salesTaxPercent!),
      total: _calculateTotal(previousState, previousState.discountValue!, action.isChecked!, previousState.salesTaxPercent!),
      subtotal: _calculateSubtotal(previousState),
  );
}

NewInvoicePageState _setDepositCheckState(NewInvoicePageState previousState, SetDepositCheckBoxStateAction action) {
  return previousState.copyWith(
    isDepositChecked: action.isChecked,
  );
}

NewInvoicePageState _setPdfSavedFlag(NewInvoicePageState previousState, UpdatePdfSavedFlag action) {
  return previousState.copyWith(
    invoicePdfSaved: true,
  );
}

NewInvoicePageState _setDueDate(NewInvoicePageState previousState, SetSelectedDueDate action) {
  return previousState.copyWith(
    dueDate: action.selectedDueDate,
  );
}

NewInvoicePageState _setDepositDueDate(NewInvoicePageState previousState, SetSelectedDepositDueDate action) {
  return previousState.copyWith(
    depositDueDate: action.selectedDueDate,
  );
}

NewInvoicePageState _setShouldClear(NewInvoicePageState previousState, SetShouldClearAction action) {
  return previousState.copyWith(
    pageViewIndex: 1,
  );
}

double calculateDiscount(NewInvoicePageState previousState, double subtotal){
    double discountRate = previousState.newDiscountRate!.length > 0 ? double.parse(previousState.newDiscountRate!.replaceFirst(r'$', '')) : 0;
    double discountPercentage = previousState.newDiscountPercentage!.length > 0 ? double.parse(previousState.newDiscountPercentage!.replaceFirst(r'%', '')) : 0;
    Discount discount = Discount(
      selectedFilter: previousState.newDiscountFilter,
      rate: discountRate,
      percentage: discountPercentage,
    );
    double discountValue = 0.0;
    switch(discount.selectedFilter){
      case NewDiscountDialog.SELECTOR_TYPE_FIXED:
        discountValue = discount.rate!;
        break;
      case NewDiscountDialog.SELECTOR_TYPE_PERCENTAGE:
        discountValue = (subtotal.truncate() * (discountPercentage/100)).truncate().toDouble();
        break;
    }
  return discountValue;
}

NewInvoicePageState _saveNewDiscount(NewInvoicePageState previousState, SaveNewDiscountAction action) {
  double discountRate = previousState.newDiscountRate!.length > 0 ? double.parse(previousState.newDiscountRate!.replaceFirst(r'$', '')) : 0;
  double discountPercentage = previousState.newDiscountPercentage!.length > 0 ? double.parse(previousState.newDiscountPercentage!.replaceFirst(r'%', '')) : 0;
  Discount discount = Discount(
    selectedFilter: previousState.newDiscountFilter,
    rate: discountRate,
    percentage: discountPercentage,
  );
  double discountValue = 0.0;
  switch(discount.selectedFilter){
    case NewDiscountDialog.SELECTOR_TYPE_FIXED:
      discountValue = discount.rate!;
      break;
    case NewDiscountDialog.SELECTOR_TYPE_PERCENTAGE:
      discountValue = (previousState.subtotal! * (discountPercentage/100)).toDouble();
      break;
  }
  double remainingBalance = calculateRemainingBalance(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!);
  return previousState.copyWith(
    newDiscountFilter: discount.selectedFilter,
    discountValue: discountValue,
    discount: discount,
    unpaidAmount: remainingBalance,
    total: _calculateTotal(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!),
    subtotal: _calculateSubtotal(previousState),
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
  NumberFormat numberFormat = NumberFormat("#,##0.0", "en_US");
  return previousState.copyWith(
    newDiscountPercentage: numberFormat.format(double.parse(action.percentage!)),
  );
}

NewInvoicePageState _deleteDiscount(NewInvoicePageState previousState, DeleteDiscountAction action) {
  return previousState.copyWith(
    discount: null,
    discountValue: 0.0,
    unpaidAmount: calculateRemainingBalance(previousState, 0.0, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!),
    total: _calculateTotal(previousState, 0.0, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!),
    subtotal: _calculateSubtotal(previousState),
    newDiscountRate: '',
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
  previousState.lineItems!.removeAt(action.index!);
  double discountValue = calculateDiscount(previousState, _calculateSubtotal(previousState));
  double remainingBalance = calculateRemainingBalance(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!);
  return previousState.copyWith(
    lineItems: previousState.lineItems,
    total: _calculateTotal(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!),
    subtotal: _calculateSubtotal(previousState),
    unpaidAmount: remainingBalance,
    discountValue: discountValue,
  );
}

NewInvoicePageState _clearNewLineItem(NewInvoicePageState previousState, ClearNewLineItemAction action) {
  return previousState.copyWith(
    newLineItemName: '',
    newLineItemRate: '',
    newLineItemQuantity: '',
  );
}

NewInvoicePageState _saveNewLineItem(NewInvoicePageState previousState, SaveNewLineItemAction action) {
  double rate = double.parse(previousState.newLineItemRate!.replaceFirst(r'$', ''));
  LineItem newLineItem = LineItem(
    itemName: previousState.newLineItemName,
    itemPrice: rate,
    itemQuantity: previousState.newLineItemQuantity!.length > 0 ? int.parse(previousState.newLineItemQuantity!) : 1,
  );
  previousState.lineItems!.add(newLineItem);
  double discountValue = calculateDiscount(previousState, _calculateSubtotal(previousState));
  double remainingBalance = calculateRemainingBalance(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!);
  return previousState.copyWith(
    newLineItemName: '',
    newLineItemRate: '',
    newLineItemQuantity: '',
    lineItems: previousState.lineItems,
    total: _calculateTotal(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!),
    subtotal: _calculateSubtotal(previousState),
    unpaidAmount: remainingBalance,
    discountValue: discountValue,
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
  String flatRate = action.flatRateText!.replaceFirst(r'$', '');
  previousState.lineItems!.elementAt(0).itemPrice = double.parse(flatRate);
  double discountValue = calculateDiscount(previousState, _calculateSubtotal(previousState));
  double remainingBalance = calculateRemainingBalance(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!);
  return previousState.copyWith(
    lineItems: previousState.lineItems,
      flatRateText: action.flatRateText,
      total: _calculateTotal(previousState, discountValue, previousState.isSalesTaxChecked!, previousState.salesTaxPercent!),
      subtotal: _calculateSubtotal(previousState),
      discountValue: discountValue,
      unpaidAmount: remainingBalance,
  );
}

NewInvoicePageState _saveSelectedJob(NewInvoicePageState previousState, SaveSelectedJobAction action) {
  List<LineItem> lineItems = [];
  Job selectedJob = action.selectedJob!;
  double depositAmount = selectedJob.priceProfile!.deposit!.toDouble();
  double remainingBalance;
  double total;
  Discount? discount;
  double discountAmount = previousState.discountValue!;

  if(selectedJob.invoice != null && selectedJob.invoice!.lineItems!.length > 0){
    total = selectedJob.invoice!.total!;
    lineItems = selectedJob.invoice!.lineItems!;
    remainingBalance = selectedJob.invoice!.unpaidAmount!;
    discount = Discount(rate: selectedJob.invoice!.discount, selectedFilter: NewDiscountDialog.SELECTOR_TYPE_FIXED);
    discountAmount = calculateDiscount(previousState, selectedJob.invoice!.subtotal!);
  } else {
    total = selectedJob.getJobCost();
    LineItem rateLineItem = LineItem(
        itemName: selectedJob.priceProfile!.profileName,
        itemPrice: selectedJob.priceProfile!.flatRate,
        itemQuantity: 1
    );
    lineItems.add(rateLineItem);
    if(selectedJob.addOnCost != null && selectedJob.addOnCost! > 0) {
      LineItem addOnLineItem = LineItem(
          itemName: 'Add-on cost',
          itemPrice: selectedJob.addOnCost,
          itemQuantity: 1
      );
      lineItems.add(addOnLineItem);
    }
    remainingBalance = calculateRemainingBalanceInit(0, selectedJob.priceProfile!.includeSalesTax!, selectedJob.priceProfile!.salesTaxPercent!, selectedJob.isDepositPaid(), depositAmount, _calculateSubtotalByLineItem(lineItems));
  }
  
  double subtotal = _calculateSubtotalByLineItem(lineItems);

  return previousState.copyWith(
    isSalesTaxChecked: selectedJob.priceProfile!.includeSalesTax,
    selectedJob: action.selectedJob,
    isDepositChecked: action.selectedJob!.isDepositPaid(),
    flatRateText: selectedJob.priceProfile!.flatRate.toString(),
    depositValue: depositAmount,
    discountValue: discountAmount,
    discount: discount,
    newDiscountFilter: NewDiscountDialog.SELECTOR_TYPE_FIXED,
    dueDate: action.selectedJob?.invoice?.dueDate,
    lineItems: lineItems,
    hourlyRate: selectedJob.priceProfile!.hourlyRate.toString(),
    hourlyQuantity: '0',
    itemRate: selectedJob.priceProfile!.itemRate.toString(),
    itemQuantity: '0',
    unpaidAmount: remainingBalance,
    total: _calculateTotalWithSubtotalByLineItem(previousState, discountAmount, selectedJob.priceProfile!.includeSalesTax! , selectedJob.priceProfile!.salesTaxPercent!, _calculateSubtotalByLineItem(lineItems)),
    subtotal: subtotal,
  );
}

NewInvoicePageState _clearState(NewInvoicePageState previousState, ClearNewInvoiceStateAction action) {
  return NewInvoicePageState.initial();
}

NewInvoicePageState _setJobs(NewInvoicePageState previousState, SetAllJobsAction action) {
  action.allJobs!.retainWhere((job) => job.priceProfile != null);
  return previousState.copyWith(
    jobs: action.allJobs,
    filteredJobs: action.allJobs,
    allClients: action.allClients,
    invoiceNumber: action.newInvoiceNumber,
    isFinishedFetchingClients: true,
    salesTaxPercent: action.salesTaxRate,
  );
}

NewInvoicePageState _incrementPageViewIndex(NewInvoicePageState previousState, IncrementPageViewIndex action) {
  return previousState.copyWith(
      pageViewIndex: (previousState.pageViewIndex! + 1),
  );
}

NewInvoicePageState _decrementPageViewIndex(NewInvoicePageState previousState, DecrementPageViewIndex action) {
  return previousState.copyWith(
    pageViewIndex: (previousState.pageViewIndex! - 1),
  );
}

NewInvoicePageState _filterJobs(NewInvoicePageState previousState, FilterJobList action) {
  List<Job>? filteredJobs = action.searchText!.length! > 0
      ? previousState.jobs!
      .where((job) => job
      .jobTitle!
      .toLowerCase()
      .contains(action.searchText!.toLowerCase()))
      .toList()
      : previousState.jobs;
  return previousState.copyWith(
    filteredJobs: filteredJobs,
  );
}

double calculateRemainingBalance(NewInvoicePageState previousState, double discountAmount, bool includeTax, double taxRate) {
  double subtotal = _calculateSubtotal(previousState);
  double taxableAmount = subtotal - discountAmount;
  return taxableAmount - (previousState.selectedJob!.isDepositPaid() ? previousState.selectedJob!.priceProfile!.deposit! : 0) + (includeTax ? (taxableAmount * (taxRate/100)) : 0.0);
}
//TODO fix pdf sales tax amount && when marking as paid, profile gets wiped in Database
double calculateRemainingBalanceInit(double discountAmount, bool includeTax, double taxRate, bool isDepositPaid, double depositAmount, double subtotal) {
  double taxableAmount = subtotal - discountAmount;
  return taxableAmount - (isDepositPaid ? depositAmount : 0) + (includeTax ? (taxableAmount * (taxRate/100)) : 0.0);
}

double _calculateTotal(NewInvoicePageState previousState, double discountAmount, bool includeTax, double taxRate) {
  double taxableAmount = _calculateSubtotal(previousState) - discountAmount;
  return taxableAmount + (includeTax ? (taxableAmount * (taxRate/100)) : 0.0);
}

double _calculateTotalWithSubtotalByLineItem(NewInvoicePageState previousState, double discountAmount, bool includeTax, double taxRate, double subtotal) {
  double taxableAmount = subtotal - discountAmount;
  return taxableAmount + (includeTax ? (taxableAmount * (taxRate/100)) : 0.0);
}

double _calculateSubtotal(NewInvoicePageState previousState) {
  double subtotal = 0.0;
  for(LineItem lineItem in previousState.lineItems!){
    subtotal = subtotal + (lineItem.itemPrice! * lineItem.itemQuantity!);
  }
  return subtotal;
}

double _calculateSubtotalByLineItem(List<LineItem> lineItems) {
  double subtotal = 0.0;
  for(LineItem lineItem in lineItems){
    subtotal = subtotal + (lineItem.itemPrice! * lineItem.itemQuantity!);
  }
  return subtotal;
}