import 'package:dandylight/models/EventDandyLight.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Location.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/job_details_page/document_items/DocumentItem.dart';
import 'package:dandylight/pages/job_details_page/document_items/InvoiceDocument.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:redux/redux.dart';

final jobDetailsReducer = combineReducers<JobDetailsPageState>([
  TypedReducer<JobDetailsPageState, SetJobAction>(_setJobInfo),
  TypedReducer<JobDetailsPageState, SaveStageCompleted>(_saveStageCompleted),
  TypedReducer<JobDetailsPageState, SetNewStagAnimationIndex>(_setNewStagAnimationIndex),
  TypedReducer<JobDetailsPageState, SetExpandedIndexAction>(_setExpandedIndex),
  TypedReducer<JobDetailsPageState, RemoveExpandedIndexAction>(_removeExpandedIndex),
  TypedReducer<JobDetailsPageState, SetClientAction>(_setClient),
  TypedReducer<JobDetailsPageState, SetSunsetTimeForJobAction>(_setSunsetTime),
  TypedReducer<JobDetailsPageState, UpdateScrollOffset>(_updateScrollOffset),
  TypedReducer<JobDetailsPageState, SaveUpdatedJobAction>(_updateJob),
  TypedReducer<JobDetailsPageState, SetEventMapAction>(_setEventMap),
  TypedReducer<JobDetailsPageState, SetNewSelectedLocation>(_setSelectedLocation),
  TypedReducer<JobDetailsPageState, SetLocationsAction>(_setLocations),
  TypedReducer<JobDetailsPageState, UpdateJobNameAction>(_updateJobTitle),
  TypedReducer<JobDetailsPageState, UpdateSelectedJobTypeAction>(_updateJobType),
  TypedReducer<JobDetailsPageState, SetPricingProfiles>(_setPriceProfiles),
  TypedReducer<JobDetailsPageState, UpdateSelectedPricePackageAction>(_setSelectedPriceProfiles),
  TypedReducer<JobDetailsPageState, AddToAddOnCostAction>(_saveAddOnCost),
  TypedReducer<JobDetailsPageState, ClearUnsavedDepositAction>(_clearUnsavedDeposit),
  TypedReducer<JobDetailsPageState, AddToTipAction>(_addToUnsavedTip),
  TypedReducer<JobDetailsPageState, ClearUnsavedTipAction>(_clearUnsavedTip),
  TypedReducer<JobDetailsPageState, SetDocumentPathAction>(_setDocumentPath),
  TypedReducer<JobDetailsPageState, SetNewInvoice>(_setInvoiceDocument),
  TypedReducer<JobDetailsPageState, SetRemindersAction>(_setReminders),
  TypedReducer<JobDetailsPageState, SetDeviceEventsAction>(_setDeviceEvents),
  TypedReducer<JobDetailsPageState, SetJobDetailsSelectedDateAction>(_setSelectedDate),
  TypedReducer<JobDetailsPageState, SetAllJobTypesAction>(_setJobTypes),
  TypedReducer<JobDetailsPageState, DeleteInvoiceFromLocalStateAction>(_deleteInvoice),
  TypedReducer<JobDetailsPageState, ClearPreviousStateAction>(_clearState),
]);

JobDetailsPageState _clearState(JobDetailsPageState previousState, ClearPreviousStateAction action) {
  return JobDetailsPageState.initial();
}

JobDetailsPageState _deleteInvoice(JobDetailsPageState previousState, DeleteInvoiceFromLocalStateAction action) {
  List<DocumentItem> documents = previousState.documents;

  DocumentItem documentToReplace;
  for(DocumentItem documentItem in documents){
    if(documentItem.getDocumentType() == DocumentItem.DOCUMENT_TYPE_INVOICE){
      documentToReplace = documentItem;
    }
  }

  if(documentToReplace != null){
    documents.remove(documentToReplace);
  }

  action.pageState.job.invoice = null;

  return previousState.copyWith(
    job: action.pageState.job,
    invoice: null,
    documents: documents,
  );
}


JobDetailsPageState _setJobTypes(JobDetailsPageState previousState, SetAllJobTypesAction action) {
  return previousState.copyWith(
    jobTypes: action.jobTypes,
  );
}

JobDetailsPageState _setSelectedDate(JobDetailsPageState previousState, SetJobDetailsSelectedDateAction action) {
  return previousState.copyWith(
    selectedDate: action.selectedDate,
  );
}

JobDetailsPageState _setDeviceEvents(JobDetailsPageState previousState, SetDeviceEventsAction action) {
  List<EventDandyLight> eventList = [];
  for(Job job in previousState.jobs) {
    eventList.add(EventDandyLight.fromJob(job));
  }
  for(Event event in action.deviceEvents) {
    eventList.add(EventDandyLight.fromDeviceEvent(event));
  }
  return previousState.copyWith(
    eventList: eventList,
    deviceEvents: action.deviceEvents,
  );
}

JobDetailsPageState _setReminders(JobDetailsPageState previousState, SetRemindersAction action){
  return previousState.copyWith(
      reminders: action.reminders
  );
}

JobDetailsPageState _setInvoiceDocument(JobDetailsPageState previousState, SetNewInvoice action) {
  List<DocumentItem> documents = previousState.documents;

  DocumentItem documentToReplace;
  for(DocumentItem documentItem in documents){
    if(documentItem.getDocumentType() == DocumentItem.DOCUMENT_TYPE_INVOICE){
      documentToReplace = documentItem;
    }
  }

  if(documentToReplace != null){
    documents.remove(documentToReplace);
  }

  if(action.invoice != null) {
    documents.add(InvoiceDocument());
  }
  return previousState.copyWith(
    documents: documents,
    invoice: action.invoice,
  );
}

JobDetailsPageState _setDocumentPath(JobDetailsPageState previousState, SetDocumentPathAction action) {
  return previousState.copyWith(documentPath: action.documentPath);
}

JobDetailsPageState _clearUnsavedDeposit(JobDetailsPageState previousState, ClearUnsavedDepositAction action) {
  return previousState.copyWith(unsavedAddOnCostAmount: 0);
}

JobDetailsPageState _saveAddOnCost(JobDetailsPageState previousState, AddToAddOnCostAction action) {
  double newAmount = previousState.unsavedAddOnCostAmount + action.amountToAdd;
  return previousState.copyWith(unsavedAddOnCostAmount: newAmount);
}

JobDetailsPageState _clearUnsavedTip(JobDetailsPageState previousState, ClearUnsavedTipAction action) {
  return previousState.copyWith(unsavedTipAmount: 0);
}

JobDetailsPageState _addToUnsavedTip(JobDetailsPageState previousState, AddToTipAction action) {
  int newAmount = previousState.unsavedTipAmount + action.amountToAdd;
  return previousState.copyWith(unsavedTipAmount: newAmount);
}

JobDetailsPageState _setSelectedPriceProfiles(JobDetailsPageState previousState, UpdateSelectedPricePackageAction action) {
  return previousState.copyWith(selectedPriceProfile: action.selectedPriceProfile);
}

JobDetailsPageState _setPriceProfiles(JobDetailsPageState previousState, SetPricingProfiles action) {
  return previousState.copyWith(priceProfiles: action.priceProfiles);
}

JobDetailsPageState _updateJobTitle(JobDetailsPageState previousState, UpdateJobNameAction action) {
  return previousState.copyWith(jobTitleText: action.jobName);
}

JobDetailsPageState _updateJobType(JobDetailsPageState previousState, UpdateSelectedJobTypeAction action) {
  return previousState.copyWith(jobType: action.jobType);
}

JobDetailsPageState _setSelectedLocation(JobDetailsPageState previousState, SetNewSelectedLocation action) {
  Location newLocation;
  if(previousState.selectedLocation != action.location) newLocation = action.location;
  return previousState.copyWith(selectedLocation: newLocation);
}

JobDetailsPageState _setEventMap(JobDetailsPageState previousState, SetEventMapAction action) {
  List<EventDandyLight> eventList = [];
  for(Job job in action.upcomingJobs) {
    eventList.add(EventDandyLight.fromJob(job));
  }
  for(Event event in previousState.deviceEvents) {
    eventList.add(EventDandyLight.fromDeviceEvent(event));
  }
  return previousState.copyWith(
    eventList: eventList,
    jobs: action.upcomingJobs,
  );
}

JobDetailsPageState _updateJob(JobDetailsPageState previousState, SaveUpdatedJobAction action){
  return previousState.copyWith(
    job: action.job,
    unsavedAddOnCostAmount: 0,
  );
}

JobDetailsPageState _setLocations(JobDetailsPageState previousState, SetLocationsAction action){
  return previousState.copyWith(
    locations: action.locations,
    selectedLocation: null,
    imageFiles: action.imageFiles,
  );
}

JobDetailsPageState _setSunsetTime(JobDetailsPageState previousState, SetSunsetTimeForJobAction action){
  return previousState.copyWith(
    sunsetTime: action.sunset,
  );
}

JobDetailsPageState _updateScrollOffset(JobDetailsPageState previousState, UpdateScrollOffset action){
  return previousState.copyWith(
    stageScrollOffset: action.offset,
  );
}

JobDetailsPageState _setJobInfo(JobDetailsPageState previousState, SetJobAction action){
  List<DocumentItem> documents = [];
  if(action.job.invoice != null) {
    documents.add(InvoiceDocument());
  }
  action.job.completedStages.sort((a, b) => a.compareTo(b));
  Location newLocation = action.job.location != null ? action.job.location : Location(locationName: '');
  return previousState.copyWith(
    job: action.job,
    selectedLocation: newLocation,
    documents: documents,
    invoice: action.job.invoice,
    selectedDate: action.job.selectedDate,
    jobType: action.job.type,
  );
}

JobDetailsPageState _setClient(JobDetailsPageState previousState, SetClientAction action){
  return previousState.copyWith(
    client: action.client,
  );
}

JobDetailsPageState _saveStageCompleted(JobDetailsPageState previousState, SaveStageCompleted action){
  return previousState.copyWith(
    job: previousState.job,
  );
}
JobDetailsPageState _setNewStagAnimationIndex(JobDetailsPageState previousState, SetNewStagAnimationIndex action){
  return previousState.copyWith(newStagAnimationIndex: action.newStagAnimationIndex,
  );
}

JobDetailsPageState _setExpandedIndex(JobDetailsPageState previousState, SetExpandedIndexAction action){
  previousState.expandedIndexes.add(action.index);
  return previousState.copyWith(expandedIndexes: previousState.expandedIndexes,
  );
}

JobDetailsPageState _removeExpandedIndex(JobDetailsPageState previousState, RemoveExpandedIndexAction action){
  previousState.expandedIndexes.remove(action.index);
  return previousState.copyWith(expandedIndexes: previousState.expandedIndexes,
  );
}