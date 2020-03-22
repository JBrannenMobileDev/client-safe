import 'package:client_safe/AppState.dart';
import 'package:client_safe/models/Client.dart';
import 'package:client_safe/models/Job.dart';
import 'package:client_safe/models/JobStage.dart';
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
  final int pageViewIndex;
  final bool saveButtonEnabled;
  final bool shouldClear;
  final bool isFinishedFetchingClients;
  final bool isDiscountFixedRate;
  final double discountValue;
  final double total;
  final double depositValue;
  final double unpaidAmount;
  final Job selectedJob;
  final String jobSearchText;
  final String filterType;
  final String flatRateText;
  final String hourlyRate;
  final String hourlyQuantity;
  final String itemRate;
  final String itemQuantity;
  final String discountStage;
  final String discountType;
  final List<Job> jobs;
  final List<Job> filteredJobs;
  final List<Client> allClients;
  final Function() onSavePressed;
  final Function() onCancelPressed;
  final Function() onNextPressed;
  final Function() onBackPressed;
  final Function(Job) onJobSelected;
  final Function(String) onJobSearchTextChanged;
  final Function() onClearInputSelected;
  final Function(String) onFilterChanged;
  final Function(String) onFlatRateTextChanged;
  final Function() onAddDiscountPressed;
  final Function(String) onDiscountTypeSelected;
  final Function() onDeleteDiscountPressed;
  final Function() onFixedDiscountSelectionCompleted;
  final Function(String) onFixedDiscountTextChanged;
  final Function() onPercentageDiscountSelectionCompleted;
  final Function(String) onPercentageDiscountTextChanged;
  final Function(String) onHourlyRateTextChanged;
  final Function(String) onHourlyQuantityTextChanged;
  final Function(String) onItemRateTextChanged;
  final Function(String) onItemQuantityTextChanged;

  NewInvoicePageState({
    @required this.id,
    @required this.pageViewIndex,
    @required this.saveButtonEnabled,
    @required this.shouldClear,
    @required this.isFinishedFetchingClients,
    @required this.isDiscountFixedRate,
    @required this.discountValue,
    @required this.unpaidAmount,
    @required this.total,
    @required this.depositValue,
    @required this.selectedJob,
    @required this.jobSearchText,
    @required this.filterType,
    @required this.jobs,
    @required this.discountStage,
    @required this.discountType,
    @required this.filteredJobs,
    @required this.allClients,
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
    @required this.onFlatRateTextChanged,
    @required this.onAddDiscountPressed,
    @required this.onDeleteDiscountPressed,
    @required this.onDiscountTypeSelected,
    @required this.onFixedDiscountSelectionCompleted,
    @required this.onFixedDiscountTextChanged,
    @required this.onPercentageDiscountSelectionCompleted,
    @required this.onPercentageDiscountTextChanged,
    @required this.onHourlyRateTextChanged,
    @required this.onHourlyQuantityTextChanged,
    @required this.onItemRateTextChanged,
    @required this.onItemQuantityTextChanged,
  });

  NewInvoicePageState copyWith({
    int id,
    int pageViewIndex,
    bool saveButtonEnabled,
    bool shouldClear,
    bool isFinishedFetchingClients,
    bool isDiscountFixedRate,
    double discountValue,
    double total,
    double depositValue,
    double unpaidAmount,
    Job selectedJob,
    String jobSearchText,
    String filterType,
    String flatRateText,
    String hourlyRate,
    String hourlyQuantity,
    String itemRate,
    String itemQuantity,
    String discountStage,
    String discountType,
    List<Job> jobs,
    List<Job> filteredJobs,
    List<Client> allClients,
    Function() onSavePressed,
    Function() onCancelPressed,
    Function() onNextPressed,
    Function() onBackPressed,
    Function(Job) onJobSelected,
    Function(String) onJobSearchTextChanged,
    Function() onClearInputSelected,
    Function(String) onFilterChanged,
    Function(String) onFlatRateTextChanged,
    Function() onAddDiscountPressed,
    Function() onDeleteDiscountPressed,
    Function(String) onDiscountTypeSelected,
    Function() onFixedDiscountSelectionCompleted,
    Function(String) onFixedDiscountTextChanged,
    Function() onPercentageDiscountSelectionCompleted,
    Function(String) onPercentageDiscountTextChanged,
    Function(String) onHourlyRateTextChanged,
    Function(String) onHourlyQuantityTextChanged,
    Function(String) onItemRateTextChanged,
    Function(String) onItemQuantityTextChanged,
  }){
    return NewInvoicePageState(
      id: id?? this.id,
      pageViewIndex: pageViewIndex?? this.pageViewIndex,
      saveButtonEnabled: saveButtonEnabled?? this.saveButtonEnabled,
      shouldClear: shouldClear?? this.shouldClear,
      isFinishedFetchingClients: isFinishedFetchingClients?? this.isFinishedFetchingClients,
      isDiscountFixedRate: isDiscountFixedRate ?? this.isDiscountFixedRate,
      discountValue: discountValue ?? this.discountValue,
      total: total ?? this.total,
      depositValue: depositValue ?? this.depositValue,
      unpaidAmount: unpaidAmount ?? this.unpaidAmount,
      selectedJob: selectedJob ?? this.selectedJob,
      jobSearchText: jobSearchText ?? this.jobSearchText,
      filterType: filterType ?? this.filterType,
      jobs: jobs ?? this.jobs,
      discountStage: discountStage ?? this.discountStage,
      discountType: discountType ?? this.discountType,
      filteredJobs:  filteredJobs ?? this.filteredJobs,
      allClients: allClients?? this.allClients,
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
      onFlatRateTextChanged: onFlatRateTextChanged ?? this.onFlatRateTextChanged,
      onAddDiscountPressed: onAddDiscountPressed ?? this.onAddDiscountPressed,
      onDeleteDiscountPressed: onDeleteDiscountPressed ?? this.onDeleteDiscountPressed,
      onDiscountTypeSelected: onDiscountTypeSelected ?? this.onDiscountTypeSelected,
      onFixedDiscountSelectionCompleted: onFixedDiscountSelectionCompleted ?? this.onFixedDiscountSelectionCompleted,
      onFixedDiscountTextChanged: onFixedDiscountTextChanged ?? this.onFixedDiscountTextChanged,
      onPercentageDiscountSelectionCompleted: onPercentageDiscountSelectionCompleted ?? this.onPercentageDiscountSelectionCompleted,
      onPercentageDiscountTextChanged: onPercentageDiscountTextChanged ?? this.onPercentageDiscountTextChanged,
      onHourlyQuantityTextChanged: onHourlyQuantityTextChanged ?? this.onHourlyQuantityTextChanged,
      onHourlyRateTextChanged: onHourlyRateTextChanged ?? this.onHourlyRateTextChanged,
      onItemRateTextChanged: onItemRateTextChanged ?? this.onItemRateTextChanged,
      onItemQuantityTextChanged: onItemQuantityTextChanged ?? this.onItemQuantityTextChanged,
    );
  }

  factory NewInvoicePageState.initial() {
    List<JobStage> selectedStagesInitial = List();
    selectedStagesInitial.add(JobStage(stage: JobStage.STAGE_1_INQUIRY_RECEIVED, value: 1));
    return NewInvoicePageState(
        id: null,
        pageViewIndex: 0,
        saveButtonEnabled: false,
        shouldClear: true,
        isFinishedFetchingClients: false,
        isDiscountFixedRate: true,
        discountValue: 0.0,
        total: 0.0,
        depositValue: 0.0,
        unpaidAmount: 0.0,
        selectedJob: null,
        jobSearchText: '',
        filterType: PriceBreakdownForm.SELECTOR_TYPE_FLAT_RATE,
        jobs: List(),
        discountStage: DISCOUNT_STAGE_NO_STAGE,
        discountType: null,
        filteredJobs: List(),
        allClients: List(),
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
        hourlyQuantity: '1',
        itemRate: '',
        itemQuantity: '1',
        onFlatRateTextChanged: null,
        onAddDiscountPressed: null,
        onDeleteDiscountPressed: null,
        onDiscountTypeSelected: null,
        onFixedDiscountTextChanged: null,
        onFixedDiscountSelectionCompleted: null,
        onPercentageDiscountTextChanged: null,
        onPercentageDiscountSelectionCompleted: null,
        onHourlyRateTextChanged: null,
        onHourlyQuantityTextChanged: null,
        onItemQuantityTextChanged: null,
        onItemRateTextChanged: null,
      );
  }

  factory NewInvoicePageState.fromStore(Store<AppState> store) {
    return NewInvoicePageState(
      id: store.state.newInvoicePageState.id,
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
      isDiscountFixedRate: store.state.newInvoicePageState.isDiscountFixedRate,
      discountValue: store.state.newInvoicePageState.discountValue,
      total: store.state.newInvoicePageState.total,
      discountStage: store.state.newInvoicePageState.discountStage,
      depositValue: store.state.newInvoicePageState.depositValue,
      unpaidAmount: store.state.newInvoicePageState.unpaidAmount,
      discountType: store.state.newInvoicePageState.discountType,
      onSavePressed: () => store.dispatch(SaveNewJobAction(store.state.newInvoicePageState)),
      onCancelPressed: () => store.dispatch(ClearStateAction(store.state.newInvoicePageState)),
      onNextPressed: () => store.dispatch(IncrementPageViewIndex(store.state.newInvoicePageState)),
      onBackPressed: () => store.dispatch(DecrementPageViewIndex(store.state.newInvoicePageState)),
      onJobSelected: (selectedJob) => store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, selectedJob)),
      onJobSearchTextChanged: (searchText) => store.dispatch(FilterJobList(store.state.newInvoicePageState, searchText)),
      onClearInputSelected: () => store.dispatch(ClearSearchInputActon(store.state.newInvoicePageState)),
      onFilterChanged: (selectedFilter) => store.dispatch(SaveSelectedFilter(store.state.newInvoicePageState, selectedFilter)),
      onFlatRateTextChanged: (flatRateText) => store.dispatch(UpdateFlatRateText(store.state.newInvoicePageState, flatRateText)),
      onAddDiscountPressed: () => store.dispatch(SetDiscountStateAction(store.state.newInvoicePageState, DISCOUNT_STAGE_TYPE_SELECTION)),
      onDiscountTypeSelected: (discountType) => store.dispatch(SaveSelectedDiscountTypeAction(store.state.newInvoicePageState, discountType)),
      onDeleteDiscountPressed: () => store.dispatch(SetDiscountStateAction(store.state.newInvoicePageState, DISCOUNT_STAGE_NO_STAGE)),
      onFixedDiscountSelectionCompleted: () => store.dispatch(SaveFixedDiscountRateAction(store.state.newInvoicePageState, DISCOUNT_STAGE_STAGE_ADDED)),
      onFixedDiscountTextChanged: (fixedDiscountRate) => store.dispatch(UpdateFixedDiscountPriceAction(store.state.newInvoicePageState, fixedDiscountRate)),
      onPercentageDiscountSelectionCompleted: () => store.dispatch(SavePercentageDiscountRateAction(store.state.newInvoicePageState, DISCOUNT_STAGE_STAGE_ADDED)),
      onPercentageDiscountTextChanged: (percentageDiscountRate) => store.dispatch(UpdatePercentageDiscountPriceAction(store.state.newInvoicePageState, percentageDiscountRate)),
      onHourlyRateTextChanged: (hourlyRate) => store.dispatch(UpdateNewInvoiceHourlyRateTextAction(store.state.newInvoicePageState, hourlyRate)),
      onHourlyQuantityTextChanged: (hourlyQuantity) => store.dispatch(UpdateNewInvoiceHourlyQuantityTextAction(store.state.newInvoicePageState, hourlyQuantity)),
      onItemRateTextChanged: (itemRate) => store.dispatch(UpdateNewInvoiceItemTextAction(store.state.newInvoicePageState, itemRate)),
      onItemQuantityTextChanged: (itemQuantity) => store.dispatch(UpdateNewInvoiceItemQuantityAction(store.state.newInvoicePageState, itemQuantity)),
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      pageViewIndex.hashCode ^
      saveButtonEnabled.hashCode ^
      shouldClear.hashCode ^
      isFinishedFetchingClients.hashCode ^
      selectedJob.hashCode ^
      jobSearchText.hashCode ^
      filteredJobs.hashCode ^
      allClients.hashCode ^
      onSavePressed.hashCode ^
      onCancelPressed.hashCode ^
      onNextPressed.hashCode ^
      onBackPressed.hashCode ^
      onJobSelected.hashCode ^
      onJobSearchTextChanged.hashCode ^
      onClearInputSelected.hashCode ^
      jobs.hashCode ^
      discountStage.hashCode ^
      onFilterChanged.hashCode ^
      isDiscountFixedRate.hashCode ^
      discountValue.hashCode ^
      total.hashCode ^
      flatRateText.hashCode ^
      hourlyRate.hashCode ^
      hourlyQuantity.hashCode ^
      itemRate.hashCode ^
      itemQuantity.hashCode ^
      depositValue.hashCode ^
      unpaidAmount.hashCode ^
      filterType.hashCode ^
      onAddDiscountPressed.hashCode ^
      onDeleteDiscountPressed.hashCode ^
      discountType.hashCode ^
      onHourlyRateTextChanged.hashCode ^
      onHourlyQuantityTextChanged.hashCode ^
      onItemQuantityTextChanged.hashCode ^
      onItemRateTextChanged.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewInvoicePageState &&
          id == other.id &&
          pageViewIndex == other.pageViewIndex &&
          saveButtonEnabled == other.saveButtonEnabled &&
          shouldClear == other.shouldClear &&
          isFinishedFetchingClients == other.isFinishedFetchingClients &&
          selectedJob == other.selectedJob &&
          jobSearchText == other.jobSearchText &&
          filteredJobs == other.filteredJobs &&
          allClients == other.allClients &&
          onSavePressed == other.onSavePressed &&
          onCancelPressed == other.onCancelPressed &&
          onNextPressed == other.onNextPressed &&
          onBackPressed == other.onBackPressed &&
          onJobSelected == other.onJobSelected &&
          onJobSearchTextChanged == other.onJobSearchTextChanged &&
          onClearInputSelected == other.onClearInputSelected &&
          jobs == other.jobs &&
          discountStage == other.discountStage &&
          onFilterChanged == other.onFilterChanged &&
          isDiscountFixedRate == other.isDiscountFixedRate &&
          discountValue == other.discountValue &&
          total == other.total &&
          flatRateText == other.flatRateText &&
          hourlyRate == other.hourlyRate &&
          hourlyQuantity == other.hourlyQuantity &&
          itemRate == other.itemRate &&
          itemQuantity == other.itemQuantity &&
          depositValue == other.depositValue &&
          unpaidAmount == other.depositValue &&
          filterType == other.filterType &&
          onAddDiscountPressed == other.onAddDiscountPressed &&
          onDeleteDiscountPressed == other.onDeleteDiscountPressed &&
          discountType == other.discountType &&
          onHourlyQuantityTextChanged == other.onHourlyQuantityTextChanged &&
          onHourlyRateTextChanged == other.onHourlyRateTextChanged &&
          onItemRateTextChanged == other.onItemRateTextChanged &&
          onItemQuantityTextChanged == other.onItemQuantityTextChanged;
}
