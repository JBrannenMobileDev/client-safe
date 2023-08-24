import 'package:dandylight/AppState.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Discount.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobStage.dart';
import 'package:dandylight/models/LineItem.dart';
import 'package:dandylight/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:dandylight/pages/new_invoice_page/PriceBreakdownForm.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

@immutable
class NewInvoicePageState {
  static const String NO_ERROR = "noError";
  static const String ERROR_JOB_TITLE_MISSING = "missingJobTitle";
  static const String DISCOUNT_STAGE_NO_STAGE = 'noStage';
  static const String DISCOUNT_STAGE_TYPE_SELECTION = 'typeSelection';
  static const String DISCOUNT_STAGE_AMOUNT_SELECTION = 'amountSelection';
  static const String DISCOUNT_STAGE_STAGE_ADDED = 'stageAdded';

  final int id;
  final int invoiceNumber;
  final String invoiceDocumentId;
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final bool isFinishedFetchingClients;
  final bool isInEditMode;
  final double total;
  final double subtotal;
  final double depositValue;
  final bool isDepositChecked;
  final double salesTaxPercent;
  final bool isSalesTaxChecked;
  final double unpaidAmount;
  final double discountValue;
  final Job selectedJob;
  final String jobSearchText;
  final String flatRateText;
  final String hourlyRate;
  final String hourlyQuantity;
  final String itemRate;
  final String itemQuantity;
  final List<Job> jobs;
  final bool showPriceEdit;
  final List<Job> filteredJobs;
  final List<Client> allClients;
  final List<LineItem> lineItems;
  final String newLineItemName;
  final String newLineItemRate;
  final String newLineItemQuantity;
  final String newDiscountRate;
  final String newDiscountPercentage;
  final String newDiscountFilter;
  final Discount discount;
  final DateTime dueDate;
  final bool invoicePdfSaved;
  final Function(DateTime) onDueDateSelected;
  final Function() onEditSelected;
  final Function() onDeleteDiscountSelected;
  final Function(String) onNewDiscountFilterChanged;
  final Function(String) onNewDiscountRateTextChanged;
  final Function(String) onNewDiscountPercentageTextChanged;
  final Function() onNewDiscountSavedSelected;
  final Function() onNewDiscountCancelSelected;
  final Function(String) onNewLineItemNameTextChanged;
  final Function(String) onNewLineItemRateTextChanged;
  final Function(String) onNewLineItemQuantityTextChanged;
  final Function() onNewLineItemSaveSelected;
  final Function() onNewLineItemCanceled;
  final Function(int) onLineItemDeleted;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(Job) onJobSelected;
  final Function(String) onJobSearchTextChanged;
  final Function() onClearInputSelected;
  final Function(String) onFlatRateTextChanged;
  final Function(bool) onDepositActionPressed;
  final Function() generateInvoicePdf;
  final Function(bool) onDepositChecked;
  final Function(bool) onSalesTaxChecked;
  final Function(String) onSalesTaxRateChanged;
  final Function() onInvoiceSent;

  NewInvoicePageState({
    @required this.id,
    @required this.invoiceDocumentId,
    @required this.invoiceNumber,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.isFinishedFetchingClients,
    @required this.unpaidAmount,
    @required this.total,
    @required this.discountValue,
    @required this.depositValue,
    @required this.selectedJob,
    @required this.jobSearchText,
    @required this.jobs,
    @required this.filteredJobs,
    @required this.allClients,
    @required this.lineItems,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.onNextPressed,
    @required this.onBackPressed,
    @required this.onJobSelected,
    @required this.onJobSearchTextChanged,
    @required this.onClearInputSelected,
    @required this.flatRateText,
    @required this.hourlyRate,
    @required this.hourlyQuantity,
    @required this.itemRate,
    @required this.itemQuantity,
    @required this.invoicePdfSaved,
    @required this.onFlatRateTextChanged,
    @required this.newLineItemRate,
    @required this.newLineItemName,
    @required this.newLineItemQuantity,
    @required this.onNewLineItemCanceled,
    @required this.onNewLineItemNameTextChanged,
    @required this.onNewLineItemQuantityTextChanged,
    @required this.onNewLineItemRateTextChanged,
    @required this.onNewLineItemSaveSelected,
    @required this.onLineItemDeleted,
    @required this.newDiscountRate,
    @required this.newDiscountPercentage,
    @required this.onNewDiscountCancelSelected,
    @required this.onNewDiscountSavedSelected,
    @required this.onNewDiscountPercentageTextChanged,
    @required this.onNewDiscountRateTextChanged,
    @required this.onNewDiscountFilterChanged,
    @required this.onDeleteDiscountSelected,
    @required this.discount,
    @required this.newDiscountFilter,
    @required this.isInEditMode,
    @required this.onEditSelected,
    @required this.dueDate,
    @required this.onDueDateSelected,
    @required this.onDepositActionPressed,
    @required this.generateInvoicePdf,
    @required this.showPriceEdit,
    @required this.isDepositChecked,
    @required this.salesTaxPercent,
    @required this.isSalesTaxChecked,
    @required this.onDepositChecked,
    @required this.onSalesTaxChecked,
    @required this.onSalesTaxRateChanged,
    @required this.onInvoiceSent,
    @required this.subtotal,
  });

  NewInvoicePageState copyWith({
    int id,
    String invoiceDocumentId,
    int invoiceNumber,
    int pageViewIndex,
    bool saveButtonEnabled,
    bool shouldClear,
    bool isFinishedFetchingClients,
    bool isInEditMode,
    double total,
    double depositValue,
    double unpaidAmount,
    double discountValue,
    Job selectedJob,
    String jobSearchText,
    String flatRateText,
    String hourlyRate,
    String hourlyQuantity,
    String itemRate,
    String itemQuantity,
    List<Job> jobs,
    List<Job> filteredJobs,
    List<Client> allClients,
    List<LineItem> lineItems,
    String newLineItemName,
    String newLineItemRate,
    String newLineItemQuantity,
    String newDiscountRate,
    String newDiscountPercentage,
    Discount discount,
    String newDiscountFilter,
    bool invoicePdfSaved,
    DateTime dueDate,
    double subtotal,
    Function(DateTime) dueDateSelected,
    Function() onEditSelected,
    Function(String) onNewDiscountFilterChanged,
    Function(String) onNewDiscountRateTextChanged,
    Function(String) onNewDiscountPercentageTextChanged,
    Function() onNewDiscountSavedSelected,
    Function() onNewDiscountCancelSelected,
    Function(String) onNewLineItemNameTextChanged,
    Function(String) onNewLineItemRateTextChanged,
    Function(String) onNewLineItemQuantityTextChanged,
    Function() onNewLineItemSaveSelected,
    Function() onNewLineItemCanceled,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(Job) onJobSelected,
    Function(String) onJobSearchTextChanged,
    Function() onClearInputSelected,
    Function(String) onFlatRateTextChanged,
    Function(int) onLineItemDeleted,
    Function() onDeleteDiscountSelected,
    Function(bool) onDepositActionPressed,
    Function() generateInvoicePdf,
    bool showPriceEdit,
    double salesTaxPercent,
    bool isSalesTaxChecked,
    bool isDepositChecked,
    Function(bool) onDepositChecked,
    Function(bool) onSalesTaxChecked,
    Function(String) onSalesTaxRateChanged,
    Function() onInvoiceSent,
  }){
    return NewInvoicePageState(
      id: id?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      isFinishedFetchingClients: isFinishedFetchingClients?? this.isFinishedFetchingClients,
      isInEditMode: isInEditMode ?? this.isInEditMode,
      total: total ?? this.total,
      depositValue: depositValue ?? this.depositValue,
      unpaidAmount: unpaidAmount ?? this.unpaidAmount,
      selectedJob: selectedJob ?? this.selectedJob,
      jobSearchText: jobSearchText ?? this.jobSearchText,
      jobs: jobs ?? this.jobs,
      discountValue: discountValue ?? this.discountValue,
      filteredJobs:  filteredJobs ?? this.filteredJobs,
      allClients: allClients ?? this.allClients,
      lineItems: lineItems ?? this.lineItems,
      onSavePressed: onSavePressed?? this.onSavePressed,
      onCancelPressed: onCancelPressed?? this.onCancelPressed,
      onNextPressed: onNextPressed?? this.onNextPressed,
      onBackPressed: onBackPressed?? this.onBackPressed,
      onJobSelected: onJobSelected ?? this.onJobSelected,
      onJobSearchTextChanged: onJobSearchTextChanged ?? this.onJobSearchTextChanged,
      onClearInputSelected: onClearInputSelected?? this.onClearInputSelected,
      flatRateText: flatRateText ?? this.flatRateText,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      hourlyQuantity: hourlyQuantity ?? this.hourlyQuantity,
      itemRate: itemRate ?? this.itemRate,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      newLineItemName: newLineItemName ?? this.newLineItemName,
      newLineItemRate: newLineItemRate ?? this.newLineItemRate,
      invoicePdfSaved: invoicePdfSaved ?? this.invoicePdfSaved,
      newLineItemQuantity: newLineItemQuantity ?? this.newLineItemQuantity,
      onNewLineItemCanceled: onNewLineItemCanceled ?? this.onNewLineItemCanceled,
      onNewLineItemNameTextChanged: onNewLineItemNameTextChanged ?? this.onNewLineItemNameTextChanged,
      onNewLineItemQuantityTextChanged: onNewLineItemQuantityTextChanged ?? this.onNewLineItemQuantityTextChanged,
      onNewLineItemRateTextChanged: onNewLineItemRateTextChanged ?? this.onNewLineItemRateTextChanged,
      onNewLineItemSaveSelected: onNewLineItemSaveSelected ?? this.onNewLineItemSaveSelected,
      onFlatRateTextChanged: onFlatRateTextChanged ?? this.onFlatRateTextChanged,
      onLineItemDeleted: onLineItemDeleted ?? this.onLineItemDeleted,
      newDiscountPercentage: newDiscountPercentage ?? this.newDiscountPercentage,
      newDiscountRate: newDiscountRate ?? this.newDiscountRate,
      onNewDiscountCancelSelected: onNewDiscountCancelSelected ?? this.onNewDiscountCancelSelected,
      onNewDiscountSavedSelected: onNewDiscountSavedSelected ?? this.onNewDiscountSavedSelected,
      onNewDiscountPercentageTextChanged: onNewDiscountPercentageTextChanged ?? this.onNewDiscountPercentageTextChanged,
      onNewDiscountRateTextChanged: onNewDiscountRateTextChanged ?? this.onNewDiscountRateTextChanged,
      onNewDiscountFilterChanged: onNewDiscountFilterChanged ?? this.onNewDiscountFilterChanged,
      onDeleteDiscountSelected: onDeleteDiscountSelected ?? this.onDeleteDiscountSelected,
      discount: discount ?? this.discount,
      newDiscountFilter: newDiscountFilter ?? this.newDiscountFilter,
      onEditSelected: onEditSelected ?? this.onEditSelected,
      dueDate: dueDate ?? this.dueDate,
      onDueDateSelected:  onDueDateSelected ?? this.onDueDateSelected,
      onDepositActionPressed: onDepositActionPressed ?? this.onDepositActionPressed,
      generateInvoicePdf: generateInvoicePdf ?? this.generateInvoicePdf,
      invoiceDocumentId: invoiceDocumentId ?? this.invoiceDocumentId,
      showPriceEdit: showPriceEdit ?? this.showPriceEdit,
      isDepositChecked: isDepositChecked ?? this.isDepositChecked,
      salesTaxPercent: salesTaxPercent ?? this.salesTaxPercent,
      isSalesTaxChecked: isSalesTaxChecked ?? this.isSalesTaxChecked,
      onDepositChecked: onDepositChecked ?? this.onDepositChecked,
      onSalesTaxChecked: onSalesTaxChecked ?? this.onSalesTaxChecked,
      onSalesTaxRateChanged: onSalesTaxRateChanged ?? this.onSalesTaxRateChanged,
      onInvoiceSent: onInvoiceSent ?? this.onInvoiceSent,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  factory NewInvoicePageState.initial() {
    List<JobStage> selectedStagesInitial = [];
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED));
    return NewInvoicePageState(
        id: null,
        invoiceDocumentId: '',
        invoiceNumber: 0,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        isFinishedFetchingClients: false,
        total: 0.0,
        depositValue: 0.0,
        unpaidAmount: 0.0,
        selectedJob: null,
        jobSearchText: '',
        jobs: [],
        filteredJobs: [],
        allClients: [],
        lineItems: [],
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onJobSelected: null,
        onJobSearchTextChanged: null,
        onClearInputSelected: null,
        flatRateText: '',
        hourlyRate: '',
        hourlyQuantity: '',
        itemRate: '',
        itemQuantity: '',
        onFlatRateTextChanged: null,
        newLineItemName: '',
        newLineItemRate: '',
        newLineItemQuantity: '',
        onNewLineItemCanceled: null,
        onNewLineItemNameTextChanged: null,
        onNewLineItemQuantityTextChanged: null,
        onNewLineItemRateTextChanged: null,
        onNewLineItemSaveSelected: null,
        onLineItemDeleted: null,
        newDiscountRate: '',
        newDiscountPercentage: '',
        onNewDiscountRateTextChanged: null,
        onNewDiscountPercentageTextChanged: null,
        onNewDiscountSavedSelected: null,
        onNewDiscountCancelSelected: null,
        onNewDiscountFilterChanged: null,
        onDeleteDiscountSelected: null,
        discount: null,
        newDiscountFilter: NewDiscountDialog.SELECTOR_TYPE_FIXED,
        discountValue: 0.0,
        isInEditMode: false,
        onEditSelected: null,
        dueDate: null,
        onDueDateSelected: null,
        onDepositActionPressed: null,
        invoicePdfSaved: null,
        generateInvoicePdf: null,
        showPriceEdit: false,
        isDepositChecked: false,
        isSalesTaxChecked: false,
        salesTaxPercent: 0,
        onDepositChecked: null,
        onSalesTaxChecked: null,
        onSalesTaxRateChanged: null,
        onInvoiceSent: null,
        subtotal: 0,
      );
  }

  factory NewInvoicePageState.fromStore(Store<AppState> store) {
    return NewInvoicePageState(
      id: store.state.newInvoicePageState.id,
      invoiceNumber: store.state.newInvoicePageState.invoiceNumber,
      pageViewIndex: store.state.newInvoicePageState.pageViewIndex,
      saveButtonEnabled: store.state.newInvoicePageState.saveButtonEnabled,
      shouldClear: store.state.newInvoicePageState.shouldClear,
      isFinishedFetchingClients: store.state.newInvoicePageState.isFinishedFetchingClients,
      selectedJob: store.state.newInvoicePageState.selectedJob,
      jobSearchText: store.state.newInvoicePageState.jobSearchText,
      jobs: store.state.newInvoicePageState.jobs,
      filteredJobs: store.state.newInvoicePageState.filteredJobs,
      allClients: store.state.newInvoicePageState.allClients,
      flatRateText: store.state.newInvoicePageState.flatRateText,
      hourlyRate: store.state.newInvoicePageState.hourlyRate,
      hourlyQuantity: store.state.newInvoicePageState.hourlyQuantity,
      itemRate: store.state.newInvoicePageState.itemRate,
      itemQuantity: store.state.newInvoicePageState.itemQuantity,
      total: store.state.newInvoicePageState.total,
      depositValue: store.state.newInvoicePageState.depositValue,
      unpaidAmount: store.state.newInvoicePageState.unpaidAmount,
      lineItems: store.state.newInvoicePageState.lineItems,
      newLineItemName: store.state.newInvoicePageState.newLineItemName,
      newLineItemRate: store.state.newInvoicePageState.newLineItemRate,
      newLineItemQuantity: store.state.newInvoicePageState.newLineItemQuantity,
      newDiscountPercentage: store.state.newInvoicePageState.newDiscountPercentage,
      newDiscountRate: store.state.newInvoicePageState.newDiscountRate,
      discount: store.state.newInvoicePageState.discount,
      newDiscountFilter: store.state.newInvoicePageState.newDiscountFilter,
      discountValue: store.state.newInvoicePageState.discountValue,
      isInEditMode: store.state.newInvoicePageState.isInEditMode,
      dueDate: store.state.newInvoicePageState.dueDate,
      invoicePdfSaved: store.state.newInvoicePageState.invoicePdfSaved,
      invoiceDocumentId: store.state.newInvoicePageState.invoiceDocumentId,
      showPriceEdit: store.state.newInvoicePageState.showPriceEdit,
      isDepositChecked: store.state.newInvoicePageState.isDepositChecked,
      salesTaxPercent: store.state.newInvoicePageState.salesTaxPercent,
      isSalesTaxChecked: store.state.newInvoicePageState.isSalesTaxChecked,
      subtotal: store.state.newInvoicePageState.subtotal,
      onDueDateSelected: (dueDate) => store.dispatch(SetSelectedDueDate(store.state.newInvoicePageState, dueDate)),
      onNewDiscountFilterChanged: (selectorName) => store.dispatch(UpdateNewDiscountSelectorAction(store.state.newInvoicePageState, selectorName)),
      onNewDiscountCancelSelected: () => store.dispatch(ClearNewDiscountAction(store.state.newInvoicePageState)),
      onNewDiscountSavedSelected: () => store.dispatch(SaveNewDiscountAction(store.state.newInvoicePageState)),
      onNewDiscountPercentageTextChanged: (percentage) => store.dispatch(UpdateNewDiscountPercentageTextAction(store.state.newInvoicePageState, percentage)),
      onNewDiscountRateTextChanged: (rate) => store.dispatch(UpdateNewDiscountRateTextAction(store.state.newInvoicePageState, rate)),
      onNewLineItemSaveSelected: () => store.dispatch(SaveNewLineItemAction(store.state.newInvoicePageState)),
      onNewLineItemCanceled: () => store.dispatch(ClearNewLineItemAction(store.state.newInvoicePageState)),
      onNewLineItemNameTextChanged: (name) => store.dispatch(UpdateLineItemNameAction(store.state.newInvoicePageState, name)),
      onNewLineItemRateTextChanged: (rate) => store.dispatch(UpdateLineItemRateAction(store.state.newInvoicePageState, rate)),
      onNewLineItemQuantityTextChanged: (quantity) => store.dispatch(UpdateLineItemQuantityAction(store.state.newInvoicePageState, quantity)),
      onSavePressed: () => store.dispatch(SaveNewInvoiceAction(store.state.newInvoicePageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newInvoicePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newInvoicePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newInvoicePageState)),
      onJobSelected: (selectedJob) => store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, selectedJob)),
      onJobSearchTextChanged: (searchText) => store.dispatch(FilterJobList(store.state.newInvoicePageState, searchText)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newInvoicePageState)),
      onFlatRateTextChanged: (flatRateText) => store.dispatch(UpdateFlatRateText(store.state.newInvoicePageState, flatRateText)),
      onLineItemDeleted: (index) => store.dispatch(DeleteLineItemAction(store.state.newInvoicePageState, index)),
      onDeleteDiscountSelected: () => store.dispatch(DeleteDiscountAction(store.state.newInvoicePageState)),
      onDepositActionPressed: (isChecked) => store.dispatch(UpdateDepositStatusAction(store.state.newInvoicePageState, isChecked)),
      generateInvoicePdf: () => store.dispatch(GenerateInvoicePdfAction(store.state.newInvoicePageState)),
      onEditSelected: null,
      onDepositChecked: (isChecked) => store.dispatch(SetDepositCheckBoxStateAction(store.state.newInvoicePageState, isChecked)),
      onSalesTaxChecked: (isChecked) => store.dispatch(SetSalesTaxCheckBoxStateAction(store.state.newInvoicePageState, isChecked)),
      onSalesTaxRateChanged: (rate) => store.dispatch(SetSelectedSalesTaxRate(store.state.newInvoicePageState, rate)),
      onInvoiceSent: () => store.dispatch(UpdateJobOnInvoiceSent(store.state.newInvoicePageState)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      invoiceDocumentId.hashCode ^
      invoicePdfSaved.hashCode ^
      invoiceNumber.hashCode ^
      onDepositActionPressed.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      isFinishedFetchingClients.hashCode ^
      selectedJob.hashCode ^
      jobSearchText.hashCode ^
      filteredJobs.hashCode ^
      allClients.hashCode ^
      lineItems.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onJobSelected.hashCode ^
      onJobSearchTextChanged.hashCode ^
      onClearInputSelected.hashCode ^
      jobs.hashCode ^
      total.hashCode ^
      discountValue.hashCode ^
      flatRateText.hashCode ^
      subtotal.hashCode^
      hourlyRate.hashCode ^
      hourlyQuantity.hashCode ^
      itemRate.hashCode ^
      itemQuantity.hashCode ^
      depositValue.hashCode ^
      unpaidAmount.hashCode ^
      newDiscountRate.hashCode ^
      newDiscountPercentage.hashCode ^
      onNewDiscountRateTextChanged.hashCode ^
      onNewDiscountPercentageTextChanged.hashCode ^
      onNewDiscountSavedSelected.hashCode ^
      onNewDiscountCancelSelected.hashCode ^
      onNewDiscountFilterChanged.hashCode ^
      discount.hashCode ^
      isInEditMode.hashCode ^
      onEditSelected.hashCode ^
      dueDate.hashCode ^
      onDueDateSelected.hashCode ^
      generateInvoicePdf.hashCode ^
      showPriceEdit.hashCode ^
      isDepositChecked.hashCode ^
      salesTaxPercent.hashCode ^
      isSalesTaxChecked.hashCode ^
      isDepositChecked.hashCode ^
      isSalesTaxChecked.hashCode ^
      onSalesTaxRateChanged.hashCode ^
      onInvoiceSent.hashCode ^
      newDiscountFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewInvoicePageState &&
          id == other.id &&
          invoiceDocumentId == other.invoiceDocumentId &&
          invoicePdfSaved == other.invoicePdfSaved &&
          invoiceNumber == other.invoiceNumber &&
          onDepositActionPressed == other.onDepositActionPressed &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          isFinishedFetchingClients == other.isFinishedFetchingClients &&
          selectedJob == other.selectedJob &&
          jobSearchText == other.jobSearchText &&
          filteredJobs == other.filteredJobs &&
          allClients == other.allClients &&
          lineItems == other.lineItems &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onJobSelected == other.onJobSelected &&
          discountValue == other.discountValue &&
          subtotal == other.subtotal &&
          onJobSearchTextChanged == other.onJobSearchTextChanged &&
          onClearInputSelected == other.onClearInputSelected &&
          jobs == other.jobs &&
          total == other.total &&
          flatRateText == other.flatRateText &&
          hourlyRate == other.hourlyRate &&
          hourlyQuantity == other.hourlyQuantity &&
          itemRate == other.itemRate &&
          itemQuantity == other.itemQuantity &&
          depositValue == other.depositValue &&
          unpaidAmount == other.depositValue &&
          newDiscountPercentage == other.newDiscountPercentage &&
          newDiscountRate == other.newDiscountRate &&
          onNewDiscountCancelSelected == other.onNewDiscountCancelSelected &&
          onNewDiscountSavedSelected == other.onNewDiscountSavedSelected &&
          onNewDiscountRateTextChanged == other.onNewDiscountRateTextChanged &&
          onNewDiscountPercentageTextChanged == other.onNewDiscountPercentageTextChanged &&
          onNewDiscountFilterChanged == other.onNewDiscountFilterChanged &&
          discount == other.discount &&
          isInEditMode == other.isInEditMode &&
          onEditSelected == other.onEditSelected &&
          dueDate == other.dueDate &&
          generateInvoicePdf == other.generateInvoicePdf &&
          onDueDateSelected == other.onDueDateSelected &&
          showPriceEdit == other.showPriceEdit &&
          isDepositChecked == other.isDepositChecked &&
          salesTaxPercent == other.salesTaxPercent &&
          isSalesTaxChecked == other.isSalesTaxChecked &&
          isDepositChecked == other.isDepositChecked &&
          isSalesTaxChecked == other.isSalesTaxChecked &&
          onSalesTaxRateChanged == other.onSalesTaxRateChanged &&
          onInvoiceSent == other.onInvoiceSent &&
          newDiscountFilter == other.newDiscountFilter;
}
