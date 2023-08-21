import 'package:redux/redux.dart';
import 'ClientPortalActions.dart';
import 'ClientPortalPageState.dart';

final clientPortalReducer = combineReducers<ClientPortalPageState>([
  TypedReducer<ClientPortalPageState, SetProposalAction>(_setProposal),
  TypedReducer<ClientPortalPageState, SetJobAction>(_setJob),
  TypedReducer<ClientPortalPageState, SetProfileAction>(_setProfile),
]);

ClientPortalPageState _setProposal(ClientPortalPageState previousState, SetProposalAction action){
  return previousState.copyWith(
    proposal: action.proposal,
  );
}

ClientPortalPageState _setJob(ClientPortalPageState previousState, SetJobAction action){
  return previousState.copyWith(
    job: action.job,
  );
}

ClientPortalPageState _setProfile(ClientPortalPageState previousState, SetProfileAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}
