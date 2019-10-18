import 'package:client_safe/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:redux/redux.dart';
import 'ClientDetailsPageState.dart';

final clientDetailsPageReducer = combineReducers<ClientDetailsPageState>([
  TypedReducer<ClientDetailsPageState, InitializeClientDetailsAction>(_setClient),

]);

ClientDetailsPageState _setClient(ClientDetailsPageState previousState, InitializeClientDetailsAction action){
  return previousState.copyWith(
    client: action.client,
    clientJobs: action.client.jobs,
  );
}