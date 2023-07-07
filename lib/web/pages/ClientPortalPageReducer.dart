import 'package:redux/redux.dart';
import 'ClientPortalActions.dart';
import 'ClientPortalPageState.dart';

final clientPortalReducer = combineReducers<ClientPortalPageState>([
  TypedReducer<ClientPortalPageState, SetUpdatedProposalAction>(_setProposal),
]);

ClientPortalPageState _setProposal(ClientPortalPageState previousState, SetUpdatedProposalAction action){
  return previousState.copyWith(
    proposal: action.proposal,
  );
}
