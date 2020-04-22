import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Discount.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
import 'package:client_safe/models/LineItem.dart';
import 'package:client_safe/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:client_safe/pages/new_invoice_page/PriceBreakdownForm.dart';
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
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final bool isFinishedFetchingClients;
  final bool isInEditMode;
  final double total;
  final double depositValue;
  final double unpaidAmount;
  final double discountValue;
  final Job selectedJob;
  final String jobSearchText;
  final String filterType;
  final String flatRateText;
  final String hourlyRate;
  final String hourlyQuantity;
  final String itemRate;
  final String itemQuantity;
  final List<Job> jobs;
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
  final Function(String) onFilterChanged;
  final Function(String) onFlatRateTextChanged;
  final Function(String) onHourlyRateTextChanged;
  final Function(String) onHourlyQuantityTextChanged;
  final Function(String) onItemRateTextChanged;
  final Function(String) onItemQuantityTextChanged;
  final Function() onDepositActionPressed;
  final Function() onViewPdfSelected;

  NewInvoicePageState({
    @required this.id,
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
    @required this.filterType,
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
    @required this.onFilterChanged,
    @required this.flatRateText,
    @required this.hourlyRate,
    @required this.hourlyQuantity,
    @required this.itemRate,
    @required this.itemQuantity,
    @required this.invoicePdfSaved,
    @required this.onFlatRateTextChanged,
    @required this.onHourlyRateTextChanged,
    @required this.onHourlyQuantityTextChanged,
    @required this.onItemRateTextChanged,
    @required this.onItemQuantityTextChanged,
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
    @required this.onViewPdfSelected,
  });

  NewInvoicePageState copyWith({
    int id,
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
    String filterType,
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
    Function(String) onFilterChanged,
    Function(String) onFlatRateTextChanged,
    Function(String) onHourlyRateTextChanged,
    Function(String) onHourlyQuantityTextChanged,
    Function(String) onItemRateTextChanged,
    Function(String) onItemQuantityTextChanged,
    Function(int) onLineItemDeleted,
    Function() onDeleteDiscountSelected,
    Function() onDepositActionPressed,
    Function() onViewPdfSelected,
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
      filterType: filterType ?? this.filterType,
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
      onFilterChanged: onFilterChanged?? this.onFilterChanged,
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
      onHourlyQuantityTextChanged: onHourlyQuantityTextChanged ?? this.onHourlyQuantityTextChanged,
      onHourlyRateTextChanged: onHourlyRateTextChanged ?? this.onHourlyRateTextChanged,
      onItemRateTextChanged: onItemRateTextChanged ?? this.onItemRateTextChanged,
      onItemQuantityTextChanged: onItemQuantityTextChanged ?? this.onItemQuantityTextChanged,
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
      onViewPdfSelected: onViewPdfSelected ?? this.onViewPdfSelected,
    );
  }

  factory NewInvoicePageState.initial() {
    List<JobStage> selectedStagesInitial = List();
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED, value: 1));
    return NewInvoicePageState(
        id: null,
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
        filterType: PriceBreakdownForm.SELECTOR_TYPE_FLAT_RATE,
        jobs: List(),
        filteredJobs: List(),
        allClients: List(),
        lineItems: List(),
        onSavePressed: null,
        onCancelPressed: null,
        onNextPressed: null,
        onBackPressed: null,
        onJobSelected: null,
        onJobSearchTextChanged: null,
        onClearInputSelected: null,
        onFilterChanged: null,
        flatRateText: '',
        hourlyRate: '',
        hourlyQuantity: '',
        itemRate: '',
        itemQuantity: '',
        onFlatRateTextChanged: null,
        onHourlyRateTextChanged: null,
        onHourlyQuantityTextChanged: null,
        onItemQuantityTextChanged: null,
        onItemRateTextChanged: null,
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
        onViewPdfSelected: null,
        invoicePdfSaved: null,
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
      filterType: store.state.newInvoicePageState.filterType,
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
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newInvoicePageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newInvoicePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newInvoicePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newInvoicePageState)),
      onJobSelected: (selectedJob) => store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, selectedJob)),
      onJobSearchTextChanged: (searchText) => store.dispatch(FilterJobList(store.state.newInvoicePageState, searchText)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newInvoicePageState)),
      onFilterChanged: (selectedFilter) => store.dispatch(SaveSelectedFilter(store.state.newInvoicePageState, selectedFilter)),
      onFlatRateTextChanged: (flatRateText) => store.dispatch(UpdateFlatRateText(store.state.newInvoicePageState, flatRateText)),
      onHourlyRateTextChanged: (hourlyRate) => store.dispatch(UpdateNewInvoiceHourlyRateTextAction(store.state.newInvoicePageState, hourlyRate)),
      onHourlyQuantityTextChanged: (hourlyQuantity) => store.dispatch(UpdateNewInvoiceHourlyQuantityTextAction(store.state.newInvoicePageState, hourlyQuantity)),
      onItemRateTextChanged: (itemRate) => store.dispatch(UpdateNewInvoiceItemTextAction(store.state.newInvoicePageState, itemRate)),
      onItemQuantityTextChanged: (itemQuantity) => store.dispatch(UpdateNewInvoiceItemQuantityAction(store.state.newInvoicePageState, itemQuantity)),
      onLineItemDeleted: (index) => store.dispatch(DeleteLineItemAction(store.state.newInvoicePageState, index)),
      onDeleteDiscountSelected: () => store.dispatch(DeleteDiscountAction(store.state.newInvoicePageState)),
      onDepositActionPressed: () => store.dispatch(UpdateDepositStatusAction(store.state.newInvoicePageState)),
      onViewPdfSelected: () => store.dispatch(GenerateInvoicePdfAction(store.state.newInvoicePageState)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
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
      onViewPdfSelected.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onJobSelected.hashCode ^
      onJobSearchTextChanged.hashCode ^
      onClearInputSelected.hashCode ^
      jobs.hashCode ^
      onFilterChanged.hashCode ^
      total.hashCode ^
      discountValue.hashCode ^
      flatRateText.hashCode ^
      hourlyRate.hashCode ^
      hourlyQuantity.hashCode ^
      itemRate.hashCode ^
      itemQuantity.hashCode ^
      depositValue.hashCode ^
      unpaidAmount.hashCode ^
      filterType.hashCode ^
      onHourlyRateTextChanged.hashCode ^
      onHourlyQuantityTextChanged.hashCode ^
      onItemQuantityTextChanged.hashCode ^
      onItemRateTextChanged.hashCode ^
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
      newDiscountFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewInvoicePageState &&
          id == other.id &&
          invoicePdfSaved == other.invoicePdfSaved &&
          invoiceNumber == other.invoiceNumber &&
          onViewPdfSelected == other.onViewPdfSelected &&
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
          onJobSearchTextChanged == other.onJobSearchTextChanged &&
          onClearInputSelected == other.onClearInputSelected &&
          jobs == other.jobs &&
          onFilterChanged == other.onFilterChanged &&
          total == other.total &&
          flatRateText == other.flatRateText &&
          hourlyRate == other.hourlyRate &&
          hourlyQuantity == other.hourlyQuantity &&
          itemRate == other.itemRate &&
          itemQuantity == other.itemQuantity &&
          depositValue == other.depositValue &&
          unpaidAmount == other.depositValue &&
          filterType == other.filterType &&
          onHourlyQuantityTextChanged == other.onHourlyQuantityTextChanged &&
          onHourlyRateTextChanged == other.onHourlyRateTextChanged &&
          onItemRateTextChanged == other.onItemRateTextChanged &&
          onItemQuantityTextChanged == other.onItemQuantityTextChanged &&
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
          onDueDateSelected == other.onDueDateSelected &&
          newDiscountFilter == other.newDiscountFilter;
}
