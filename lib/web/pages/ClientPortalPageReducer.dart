import 'package:redux/redux.dart';
import 'ClientPortalActions.dart';
import 'ClientPortalPageState.dart';

final clientPortalReducer = combineReducers<ClientPortalPageState>([
  TypedReducer<ClientPortalPageState, SetProposalAction>(_setProposal),
  TypedReducer<ClientPortalPageState, SetJobAction>(_setJob),
  TypedReducer<ClientPortalPageState, SetProfileAction>(_setProfile),
  TypedReducer<ClientPortalPageState, SetErrorStateAction>(_setErrorMsg),
  TypedReducer<ClientPortalPageState, SetLoadingStateAction>(_setLoadingState),
  TypedReducer<ClientPortalPageState, SetInitialLoadingStateAction>(_setInitialLoadingState),
  TypedReducer<ClientPortalPageState, SetBrandingPreviewStateAction>(_setBrandingPreviewState),
]);

ClientPortalPageState _setBrandingPreviewState(ClientPortalPageState previousState, SetBrandingPreviewStateAction action){
  return previousState.copyWith(
    isBrandingPreview: action.isBrandingPreview,
  );
}

ClientPortalPageState _setLoadingState(ClientPortalPageState previousState, SetLoadingStateAction action){
  return previousState.copyWith(
    isLoading: action.isLoading,
  );
}

ClientPortalPageState _setInitialLoadingState(ClientPortalPageState previousState, SetInitialLoadingStateAction action){
  return previousState.copyWith(
    isLoadingInitial: action.isLoading,
  );
}

ClientPortalPageState _setErrorMsg(ClientPortalPageState previousState, SetErrorStateAction action){
  return previousState.copyWith(
    errorMsg: action.errorMsg,
  );
}

ClientPortalPageState _setProposal(ClientPortalPageState previousState, SetProposalAction action){
  return previousState.copyWith(
    proposal: action.proposal,
  );
}

ClientPortalPageState _setJob(ClientPortalPageState previousState, SetJobAction action){
  return previousState.copyWith(
    job: action.job,
    jobId: action.job!.documentId,
    invoice: action.job!.invoice,
  );
}

ClientPortalPageState _setProfile(ClientPortalPageState previousState, SetProfileAction action){
  return previousState.copyWith(
    profile: action.profile,
    userId: action.profile!.uid
  );
}
