import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:redux/redux.dart';
import 'ClientDetailsPageState.dart';

final clientDetailsPageReducer = combineReducers<ClientDetailsPageState>([
  TypedReducer<ClientDetailsPageState, InitializeClientDetailsAction>(_setClient),
  TypedReducer<ClientDetailsPageState, SetClientJobsAction>(_setJobs),
]);

ClientDetailsPageState _setClient(ClientDetailsPageState previousState, InitializeClientDetailsAction action){
  return previousState.copyWith(
    client: action.client,
  );
}

ClientDetailsPageState _setJobs(ClientDetailsPageState previousState, SetClientJobsAction action){
  return previousState.copyWith(
    clientJobs: action.clientJobs.where((job) => job.clientId == previousState.client.id).toList(),
  );
}