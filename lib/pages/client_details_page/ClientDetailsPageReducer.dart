import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:redux/redux.dart';
import '../../models/ImportantDate.dart';
import 'ClientDetailsPageState.dart';

final clientDetailsPageReducer = combineReducers<ClientDetailsPageState>([
  TypedReducer<ClientDetailsPageState, InitializeClientDetailsAction>(_setClient),
  TypedReducer<ClientDetailsPageState, SetClientJobsAction>(_setJobs),
  TypedReducer<ClientDetailsPageState, SetTempLeadSourceAction>(_setLeadSource),
  TypedReducer<ClientDetailsPageState, UpdateTempCustomLeadNameAction>(_setCustomLeadSourceName),
  TypedReducer<ClientDetailsPageState, SetNotesAction>(_setNotes),
  TypedReducer<ClientDetailsPageState, AddClientDetailsImportantDateAction>(_addImportantDate),
  TypedReducer<ClientDetailsPageState, RemoveClientDetailsImportantDateAction>(_removeImportantDate),
]);

ClientDetailsPageState _removeImportantDate(ClientDetailsPageState previousState, RemoveClientDetailsImportantDateAction action) {
  for(ImportantDate date in previousState.importantDates){
    if(date.chipIndex == action.chipIndex){
      previousState.importantDates.remove(date);
      break;
    }
  }
  return previousState.copyWith(
      importantDates: previousState.importantDates
  );
}

ClientDetailsPageState _addImportantDate(ClientDetailsPageState previousState, AddClientDetailsImportantDateAction action) {
  previousState.importantDates.add(action.importantDate);
  return previousState.copyWith(
      importantDates: previousState.importantDates
  );
}

ClientDetailsPageState _setNotes(ClientDetailsPageState previousState, SetNotesAction action){
  return previousState.copyWith(
    notes: action.notes,
  );
}

ClientDetailsPageState _setCustomLeadSourceName(ClientDetailsPageState previousState, UpdateTempCustomLeadNameAction action){
  return previousState.copyWith(
    customLeadSourceName: action.customName,
  );
}

ClientDetailsPageState _setLeadSource(ClientDetailsPageState previousState, SetTempLeadSourceAction action){
  return previousState.copyWith(
    leadSource: action.leadSource,
    customLeadSourceName: '',
  );
}

ClientDetailsPageState _setClient(ClientDetailsPageState previousState, InitializeClientDetailsAction action){
  return previousState.copyWith(
    client: action.client,
    leadSource: action.client.leadSource,
    customLeadSourceName: action.client.customLeadSourceName,
    importantDates: action.client.importantDates,
  );
}

ClientDetailsPageState _setJobs(ClientDetailsPageState previousState, SetClientJobsAction action){
  if(previousState.client != null) {
    return previousState.copyWith(
      clientJobs: action.clientJobs.where((job) => job.clientDocumentId == previousState.client.documentId).toList(),
    );
  }
  return previousState;
}