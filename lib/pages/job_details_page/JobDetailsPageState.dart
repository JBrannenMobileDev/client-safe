import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Event.dart';
import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/JobReminder.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/models/PriceProfile.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/pages/jobs_page/JobsPageActions.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageActions.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Reminder.dart';

class JobDetailsPageState {
  final Job job;
  final Client client;
  final DateTime sunsetTime;
  final int newStagAnimationIndex;
  final double stageScrollOffset;
  final List<Event> eventList;
  final List<Job> jobs;
  final List<JobReminder> reminders;
  final String jobTitleText;
  final int unsavedDepositAmount;
  final int unsavedTipAmount;
  final List<Location> locations;
  final Location selectedLocation;
  final Function(Location) onLocationSelected;
  final List<int> expandedIndexes;
  final String jobTypeIcon;
  final String documentPath;
  final PriceProfile selectedPriceProfile;
  final List<PriceProfile> priceProfiles;
  final List<DocumentItem> documents;
  final Invoice invoice;
  final Function(PriceProfile) onPriceProfileSelected;
  final Function() onSaveUpdatedPriceProfileSelected;
  final Function(String) onJobTypeSelected;
  final Function(Job, int) onStageCompleted;
  final Function(Job, int) onStageUndo;
  final Function(int) setNewIndexForStageAnimation;
  final Function(int) addExpandedIndex;
  final Function(int) removeExpandedIndex;
  final Function() onDeleteSelected;
  final Function() onInstagramSelected;
  final Function(double) onScrollOffsetChanged;
  final Function(DateTime) onNewTimeSelected;
  final Function(DateTime) onNewDateSelected;
  final Function(Client) onClientClicked;
  final Function(Job) onJobClicked;
  final Function(Location) onLocationSaveSelected;
  final Function(String) onJobTitleTextChanged;
  final Function() onNameChangeSaved;
  final Function() onJobTypeSaveSelected;
  final Function(int) onAddToDeposit;
  final Function() onSaveDepositChange;
  final Function() onClearUnsavedDeposit;
  final Function(int) onAddToTip;
  final Function() onSaveTipChange;
  final Function() onClearUnsavedTip;
  final Function() onAddInvoiceSelected;
  final Function(Invoice) onDeleteInvoiceSelected;
  final Function(Invoice) onInvoiceSent;
  final Function() onBackPressed;
  final Function(JobReminder) onDeleteReminderSelected;

  JobDetailsPageState({
    @required this.job,
    @required this.client,
    @required this.sunsetTime,
    @required this.eventList,
    @required this.jobs,
    @required this.documentPath,
    @required this.jobTitleText,
    @required this.locations,
    @required this.selectedLocation,
    @required this.onLocationSelected,
    @required this.expandedIndexes,
    @required this.stageScrollOffset,
    @required this.onStageCompleted,
    @required this.invoice,
    @required this.newStagAnimationIndex,
    @required this.onStageUndo,
    @required this.setNewIndexForStageAnimation,
    @required this.addExpandedIndex,
    @required this.removeExpandedIndex,
    @required this.onDeleteSelected,
    @required this.onInstagramSelected,
    @required this.onScrollOffsetChanged,
    @required this.onNewTimeSelected,
    @required this.onNewDateSelected,
    @required this.onClientClicked,
    @required this.onJobClicked,
    @required this.onLocationSaveSelected,
    @required this.onJobTitleTextChanged,
    @required this.onNameChangeSaved,
    @required this.jobTypeIcon,
    @required this.onJobTypeSelected,
    @required this.onJobTypeSaveSelected,
    @required this.selectedPriceProfile,
    @required this.priceProfiles,
    @required this.onPriceProfileSelected,
    @required this.onSaveUpdatedPriceProfileSelected,
    @required this.unsavedDepositAmount,
    @required this.onAddToDeposit,
    @required this.onSaveDepositChange,
    @required this.onClearUnsavedDeposit,
    @required this.onAddInvoiceSelected,
    @required this.documents,
    @required this.onDeleteInvoiceSelected,
    @required this.onInvoiceSent,
    @required this.unsavedTipAmount,
    @required this.onAddToTip,
    @required this.onSaveTipChange,
    @required this.onClearUnsavedTip,
    @required this.onBackPressed,
    @required this.reminders,
    @required this.onDeleteReminderSelected,
  });

  JobDetailsPageState copyWith({
    Job job,
    Client client,
    int newStagAnimationIndex,
    double stageScrollOffset,
    List<Event> eventList,
    List<Job> jobs,
    String jobTitleText,
    List<Location> locations,
    List<JobReminder> reminders,
    Location selectedLocation,
    Function(Location) onLocationSelected,
    List<int> expandedIndexes,
    String jobTypeIcon,
    String documentPath,
    Invoice invoice,
    PriceProfile selectedPriceProfile,
    List<PriceProfile> priceProfiles,
    Function(PriceProfile) onPriceProfileSelected,
    Function() onSaveUpdatedPriceProfileSelected,
    Function(String) onJobTypeSelected,
    Function(Job, int) onStageCompleted,
    Function(Job, int) onStageUndo,
    Function(int) setNewIndexForStageAnimation,
    Function(int) addExpandedIndex,
    Function(int) removeExpandedIndex,
    Function() onDeleteSelected,
    Function() onInstagramSelected,
    DateTime sunsetTime,
    Function(double) onScrollOffsetChanged,
    Function(DateTime) onNewTimeSelected,
    Function(DateTime) onNewDateSelected,
    Function(Client) onClientClicked,
    Function(Job) onJobClicked,
    Function(Location) onLocationSaveSelected,
    Function(String) onJobTitleTextChanged,
    Function() onNameChangeSaved,
    Function() onJobTypeSaveSelected,
    int unsavedDepositAmount,
    Function(int) onAddToDeposit,
    Function() onSaveDepositChange,
    Function() onClearUnsavedDeposit,
    Function() onAddInvoiceSelected,
    List<DocumentItem> documents,
    Function(Invoice) onDeleteInvoiceSelected,
    Function(Invoice) onInvoiceSent,
    Function(int) onAddToTip,
    Function() onSaveTipChange,
    Function() onClearUnsavedTip,
    int unsavedTipAmount,
    Function() onBackPressed,
    Function(JobReminder) onDeleteReminderSelected,
  }){
    return JobDetailsPageState(
      job: job ?? this.job,
      client: client ?? this.client,
      onAddToTip: onAddToTip ?? this.onAddToTip,
      onSaveTipChange: onSaveTipChange ?? this.onSaveTipChange,
      onClearUnsavedTip: onClearUnsavedTip ?? this.onClearUnsavedTip,
      sunsetTime: sunsetTime ?? this.sunsetTime,
      stageScrollOffset: stageScrollOffset ?? this.stageScrollOffset,
      eventList: eventList ?? this.eventList,
      jobs: jobs ?? this.jobs,
      reminders: reminders ?? this.reminders,
      documentPath: documentPath ?? this.documentPath,
      jobTitleText: jobTitleText ?? this.jobTitleText,
      locations: locations ?? this.locations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      onLocationSelected: onLocationSelected ?? this.onLocationSelected,
      expandedIndexes: expandedIndexes ?? this.expandedIndexes,
      onStageCompleted: onStageCompleted ?? this.onStageCompleted,
      onStageUndo: onStageUndo ?? this.onStageUndo,
      newStagAnimationIndex: newStagAnimationIndex ?? this.newStagAnimationIndex,
      setNewIndexForStageAnimation: setNewIndexForStageAnimation ?? this.setNewIndexForStageAnimation,
      addExpandedIndex: addExpandedIndex ?? this.addExpandedIndex,
      removeExpandedIndex: removeExpandedIndex ?? this.removeExpandedIndex,
      onDeleteSelected: onDeleteSelected ?? this.onDeleteSelected,
      onInstagramSelected: onInstagramSelected ?? this.onInstagramSelected,
      onScrollOffsetChanged: onScrollOffsetChanged ?? this.onScrollOffsetChanged,
      onNewTimeSelected: onNewTimeSelected ?? this.onNewTimeSelected,
      onNewDateSelected: onNewDateSelected ?? this.onNewDateSelected,
      onClientClicked: onClientClicked ?? this.onClientClicked,
      onJobClicked: onJobClicked ?? this.onJobClicked,
      onLocationSaveSelected: onLocationSaveSelected ?? this.onLocationSaveSelected,
      onJobTitleTextChanged: onJobTitleTextChanged ?? this.onJobTitleTextChanged,
      onNameChangeSaved: onNameChangeSaved ?? this.onNameChangeSaved,
      onJobTypeSelected: onJobTypeSelected ?? this.onJobTypeSelected,
      jobTypeIcon: jobTypeIcon ?? this.jobTypeIcon,
      onJobTypeSaveSelected: onJobTypeSaveSelected ?? this.onJobTypeSaveSelected,
      selectedPriceProfile: selectedPriceProfile ?? this.selectedPriceProfile,
      priceProfiles: priceProfiles ?? this.priceProfiles,
      unsavedTipAmount: unsavedTipAmount ?? this.unsavedTipAmount,
      onPriceProfileSelected: onPriceProfileSelected ?? this.onPriceProfileSelected,
      onSaveUpdatedPriceProfileSelected: onSaveUpdatedPriceProfileSelected ?? this.onSaveUpdatedPriceProfileSelected,
      unsavedDepositAmount: unsavedDepositAmount ?? this.unsavedDepositAmount,
      onAddToDeposit: onAddToDeposit ?? this.onAddToDeposit,
      onSaveDepositChange:  onSaveDepositChange ?? this.onSaveDepositChange,
      onClearUnsavedDeposit: onClearUnsavedDeposit ?? this.onClearUnsavedDeposit,
      onAddInvoiceSelected: onAddInvoiceSelected ?? this.onAddInvoiceSelected,
      documents: documents ?? this.documents,
      onDeleteInvoiceSelected: onDeleteInvoiceSelected ?? this.onDeleteInvoiceSelected,
      invoice: invoice ?? this.invoice,
      onInvoiceSent: onInvoiceSent ?? this.onInvoiceSent,
      onBackPressed: onBackPressed ?? this.onBackPressed,
      onDeleteReminderSelected: onDeleteReminderSelected?? this.onDeleteReminderSelected,
    );
  }

  static JobDetailsPageState fromStore(Store<AppState> store) {
    return JobDetailsPageState(
        job: store.state.jobDetailsPageState.job,
        client: store.state.jobDetailsPageState.client,
        sunsetTime: store.state.jobDetailsPageState.sunsetTime,
        stageScrollOffset: store.state.jobDetailsPageState.stageScrollOffset,
        eventList: store.state.jobDetailsPageState.eventList,
        jobs: store.state.jobDetailsPageState.jobs,
        jobTitleText: store.state.jobDetailsPageState.jobTitleText,
        locations: store.state.jobDetailsPageState.locations,
        selectedLocation: store.state.jobDetailsPageState.selectedLocation,
        expandedIndexes: store.state.jobDetailsPageState.expandedIndexes,
        newStagAnimationIndex: store.state.jobDetailsPageState.newStagAnimationIndex,
        jobTypeIcon: store.state.jobDetailsPageState.jobTypeIcon,
        selectedPriceProfile: store.state.jobDetailsPageState.selectedPriceProfile,
        priceProfiles: store.state.jobDetailsPageState.priceProfiles,
        unsavedDepositAmount: store.state.jobDetailsPageState.unsavedDepositAmount,
        unsavedTipAmount: store.state.jobDetailsPageState.unsavedTipAmount,
        documentPath: store.state.jobDetailsPageState.documentPath,
        documents: store.state.jobDetailsPageState.documents,
        invoice: store.state.jobDetailsPageState.invoice,
        reminders: store.state.jobDetailsPageState.reminders,
        onAddToTip: (amountToAdd) => store.dispatch(AddToTipAction(store.state.jobDetailsPageState, amountToAdd)),
        onSaveTipChange: () => store.dispatch(SaveTipChangeAction(store.state.jobDetailsPageState)),
        onClearUnsavedTip: () => store.dispatch(ClearUnsavedTipAction(store.state.jobDetailsPageState)),
        onStageUndo: (job, stageIndex) => store.dispatch(UndoStageAction(store.state.jobDetailsPageState, job, stageIndex)),
        onStageCompleted: (job, stageIndex) => store.dispatch(SaveStageCompleted(store.state.jobDetailsPageState, job, stageIndex)),
        setNewIndexForStageAnimation: (index) => store.dispatch(SetNewStagAnimationIndex(store.state.jobDetailsPageState, index)),
        addExpandedIndex: (index) => store.dispatch(SetExpandedIndexAction(store.state.jobDetailsPageState, index)),
        removeExpandedIndex: (index) => store.dispatch(RemoveExpandedIndexAction(store.state.jobDetailsPageState, index)),
        onDeleteSelected: () => store.dispatch(DeleteJobAction(store.state.jobDetailsPageState)),
        onInstagramSelected: () => store.dispatch(JobInstagramSelectedAction(store.state.jobDetailsPageState)),
        onScrollOffsetChanged: (offset) => store.dispatch(UpdateScrollOffset(store.state.jobDetailsPageState, offset)),
        onNewTimeSelected: (newTime) => store.dispatch(UpdateJobTimeAction(store.state.jobDetailsPageState, newTime)),
        onNewDateSelected: (newDate) => store.dispatch(UpdateJobDateAction(store.state.jobDetailsPageState, newDate)),
        onClientClicked: (client) => store.dispatch(InitializeClientDetailsAction(store.state.clientDetailsPageState, client)),
        onJobClicked: (job) => store.dispatch(SetJobInfo(store.state.jobDetailsPageState, job)),
        onLocationSelected: (location) => store.dispatch(SetNewSelectedLocation(store.state.jobDetailsPageState, location)),
        onLocationSaveSelected: (location) => store.dispatch(UpdateNewLocationAction(store.state.jobDetailsPageState, location)),
        onJobTitleTextChanged: (newText) => store.dispatch(UpdateJobNameAction(store.state.jobDetailsPageState, newText)),
        onNameChangeSaved: () => store.dispatch(SaveJobNameChangeAction(store.state.jobDetailsPageState)),
        onJobTypeSelected: (jobType) => store.dispatch(UpdateSelectedJobTypeAction(store.state.jobDetailsPageState, jobType)),
        onJobTypeSaveSelected: () => store.dispatch(SaveUpdatedJobTypeAction(store.state.jobDetailsPageState)),
        onPriceProfileSelected: (priceProfile) => store.dispatch(UpdateSelectedPricePackageAction(store.state.jobDetailsPageState, priceProfile)),
        onSaveUpdatedPriceProfileSelected: () => store.dispatch(SaveUpdatedPricePackageAction(store.state.jobDetailsPageState)),
        onAddToDeposit: (amountToAdd) => store.dispatch(AddToDepositAction(store.state.jobDetailsPageState, amountToAdd)),
        onSaveDepositChange: () => store.dispatch(SaveDepositChangeAction(store.state.jobDetailsPageState)),
        onClearUnsavedDeposit: () => store.dispatch(ClearUnsavedDepositAction(store.state.jobDetailsPageState)),
        onAddInvoiceSelected: () {
          store.dispatch(SetShouldClearAction(store.state.newInvoicePageState, false));
          store.dispatch(SaveSelectedJobAction(store.state.newInvoicePageState, store.state.jobDetailsPageState.job));
        },
        onDeleteInvoiceSelected: (invoice) => store.dispatch(OnDeleteInvoiceSelectedAction(store.state.jobDetailsPageState, invoice)),
        onInvoiceSent: (invoice) => store.dispatch(InvoiceSentAction(store.state.jobDetailsPageState, invoice)),
        onBackPressed: () => store.dispatch(FetchJobsAction(store.state.jobsPageState)),
        onDeleteReminderSelected: (reminder) => store.dispatch(DeleteReminderFromJobAction(store.state.jobDetailsPageState, reminder)),
    );
  }

  factory JobDetailsPageState.initial() => JobDetailsPageState(
    job: null,
    client: null,
    sunsetTime: null,
    stageScrollOffset: 200.0,
    newStagAnimationIndex: 2,
    eventList: [],
    jobs: [],
    jobTitleText: "",
    onDeleteInvoiceSelected: null,
    documents: [],
    onLocationSaveSelected: null,
    setNewIndexForStageAnimation: null,
    locations: [],
    onInvoiceSent: null,
    selectedLocation: null,
    expandedIndexes: [],
    onStageCompleted: null,
    onStageUndo: null,
    addExpandedIndex: null,
    removeExpandedIndex: null,
    onDeleteSelected: null,
    onInstagramSelected: null,
    onScrollOffsetChanged: null,
    onNewTimeSelected: null,
    onNewDateSelected: null,
    onClientClicked: null,
    onJobClicked: null,
    onLocationSelected: null,
    onJobTitleTextChanged: null,
    onNameChangeSaved: null,
    documentPath: '',
    jobTypeIcon: 'assets/images/job_types/other.png',
    onJobTypeSelected: null,
    onJobTypeSaveSelected: null,
    selectedPriceProfile: null,
    priceProfiles: [],
    onPriceProfileSelected: null,
    onSaveUpdatedPriceProfileSelected: null,
    unsavedDepositAmount: 0,
    onAddToDeposit: null,
    onSaveDepositChange: null,
    onClearUnsavedDeposit: null,
    onAddInvoiceSelected: null,
    invoice: null,
    unsavedTipAmount: 0,
    onAddToTip: null,
    onSaveTipChange: null,
    onClearUnsavedTip: null,
    reminders: [],
  );

  @override
  int get hashCode =>
      unsavedTipAmount.hashCode ^
      onAddToTip.hashCode ^
      onSaveTipChange.hashCode ^
      onClearUnsavedTip.hashCode ^
      unsavedDepositAmount.hashCode ^
      onAddToDeposit.hashCode ^
      onSaveDepositChange.hashCode ^
      job.hashCode ^
      documentPath.hashCode ^
      client.hashCode ^
      sunsetTime.hashCode ^
      stageScrollOffset.hashCode ^
      eventList.hashCode ^
      jobs.hashCode ^
      invoice.hashCode ^
      onAddInvoiceSelected.hashCode ^
      jobTitleText.hashCode ^
      onNameChangeSaved.hashCode ^
      selectedLocation.hashCode ^
      onLocationSelected.hashCode ^
      locations.hashCode ^
      expandedIndexes.hashCode ^
      newStagAnimationIndex.hashCode ^
      onStageCompleted.hashCode ^
      onStageUndo.hashCode ^
      addExpandedIndex.hashCode ^
      removeExpandedIndex.hashCode ^
      onDeleteSelected.hashCode ^
      onInstagramSelected.hashCode ^
      onScrollOffsetChanged.hashCode ^
      onNewTimeSelected.hashCode ^
      onNewDateSelected.hashCode ^
      onClientClicked.hashCode ^
      onJobClicked.hashCode ^
      onJobTitleTextChanged.hashCode ^
      jobTypeIcon.hashCode ^
      onJobTypeSelected.hashCode ^
      onJobTypeSaveSelected.hashCode ^
      priceProfiles.hashCode ^
      selectedPriceProfile.hashCode ^
      onPriceProfileSelected.hashCode ^
      onSaveUpdatedPriceProfileSelected.hashCode ^
      onClearUnsavedDeposit.hashCode ^
      reminders.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobDetailsPageState &&
              unsavedDepositAmount == other.unsavedDepositAmount &&
              onAddToDeposit == other.onAddToDeposit &&
              onAddInvoiceSelected == other.onAddInvoiceSelected &&
              onSaveDepositChange == other.onSaveDepositChange &&
              job == other.job &&
              unsavedTipAmount == other.unsavedTipAmount &&
              onAddToTip == other.onAddToTip &&
              onSaveTipChange == other.onSaveTipChange &&
              onClearUnsavedTip == other.onClearUnsavedTip &&
              documentPath == other.documentPath &&
              client == other.client &&
              sunsetTime == other.sunsetTime &&
              stageScrollOffset == other.stageScrollOffset &&
              eventList == other.eventList &&
              jobs == other.jobs &&
              reminders == other.reminders &&
              invoice == other.invoice &&
              jobTitleText == other.jobTitleText &&
              onNameChangeSaved == other.onNameChangeSaved &&
              selectedLocation == other.selectedLocation &&
              onLocationSelected == other.onLocationSelected &&
              locations == other.locations &&
              expandedIndexes == other.expandedIndexes &&
              newStagAnimationIndex == other.newStagAnimationIndex &&
              onStageCompleted == other.onStageCompleted &&
              onStageUndo == other.onStageUndo &&
              addExpandedIndex == other.addExpandedIndex &&
              removeExpandedIndex ==other.removeExpandedIndex &&
              onDeleteSelected == other.onDeleteSelected &&
              onInstagramSelected == other.onInstagramSelected &&
              onScrollOffsetChanged == other.onScrollOffsetChanged &&
              onNewTimeSelected == other.onNewTimeSelected &&
              onNewDateSelected == other.onNewDateSelected &&
              onClientClicked == other.onClientClicked &&
              onJobClicked == other.onJobClicked &&
              onJobTitleTextChanged == other.onJobTitleTextChanged &&
              jobTypeIcon == other.jobTypeIcon &&
              onJobTypeSelected == other.onJobTypeSelected &&
              onJobTypeSaveSelected == other.onJobTypeSaveSelected &&
              selectedPriceProfile == other.selectedPriceProfile &&
              priceProfiles == other.priceProfiles &&
              onPriceProfileSelected == other.onPriceProfileSelected &&
              onSaveUpdatedPriceProfileSelected == other.onSaveUpdatedPriceProfileSelected &&
              onClearUnsavedDeposit == other.onClearUnsavedDeposit;
}
