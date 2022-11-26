import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:redux/redux.dart';
import 'ClientDetailsPageState.dart';

final clientDetailsPageReducer = combineReducers<ClientDetailsPageState>([
  TypedReducer<ClientDetailsPageState, InitializeClientDetailsAction>(_setClient),
  TypedReducer<ClientDetailsPageState, SetClientJobsAction>(_setJobs),
  TypedReducer<ClientDetailsPageState, SetTempLeadSourceAction>(_setLeadSource),
  TypedReducer<ClientDetailsPageState, UpdateTempCustomLeadNameAction>(_setCustomLeadSourceName),
]);

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