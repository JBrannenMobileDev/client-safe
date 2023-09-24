import 'package:redux/redux.dart';

import '../../models/Contract.dart';
import 'ShareWithClientActions.dart';
import 'ShareWithClientPageState.dart';

final shareWithClientReducer = combineReducers<ShareWithClientPageState>([
  TypedReducer<ShareWithClientPageState, SetClientMessageAction>(_setClientMessage),
  TypedReducer<ShareWithClientPageState, SetContractCheckBox>(_setContractChecked),
  TypedReducer<ShareWithClientPageState, SetInvoiceCheckBox>(_setInvoiceChecked),
  TypedReducer<ShareWithClientPageState, SetPosesCheckBox>(_setPosesChecked),
  TypedReducer<ShareWithClientPageState, SetProfileShareWIthClientAction>(_setProfile),
  TypedReducer<ShareWithClientPageState, SetJobShareWithClientAction>(_setJob),
  TypedReducer<ShareWithClientPageState, SaveProposalAction>(_setAreChangesSavedState),
]);

ShareWithClientPageState _setAreChangesSavedState(ShareWithClientPageState previousState, SaveProposalAction action){
  return previousState.copyWith(
    areChangesSaved: true,
  );
}

ShareWithClientPageState _setJob(ShareWithClientPageState previousState, SetJobShareWithClientAction action){
  return previousState.copyWith(
    job: action.job,
    invoiceSelected: action.job.proposal.includeInvoice,
    contractSelected: action.job.proposal.includeContract,
    posesSelected: action.job.proposal.includePoses,
    clientMessage: action.job.proposal.detailsMessage,
  );
}

ShareWithClientPageState _setProfile(ShareWithClientPageState previousState, SetProfileShareWIthClientAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

ShareWithClientPageState _setClientMessage(ShareWithClientPageState previousState, SetClientMessageAction action){
  action.pageState.job.proposal.detailsMessage = action.clientMessage;
  return previousState.copyWith(
    clientMessage: action.clientMessage,
    job: action.pageState.job,
    areChangesSaved: false,
  );
}

ShareWithClientPageState _setContractChecked(ShareWithClientPageState previousState, SetContractCheckBox action){
  action.pageState.job.proposal.includeContract = action.checked;
  return previousState.copyWith(
    contractSelected: action.checked,
    job: action.pageState.job,
    areChangesSaved: false,
  );
}

ShareWithClientPageState _setInvoiceChecked(ShareWithClientPageState previousState, SetInvoiceCheckBox action){
  action.pageState.job.proposal.includeInvoice = action.checked;
  return previousState.copyWith(
    invoiceSelected: action.checked,
    job: action.pageState.job,
    areChangesSaved: false,
  );
}

ShareWithClientPageState _setPosesChecked(ShareWithClientPageState previousState, SetPosesCheckBox action){
  action.pageState.job.proposal.includePoses = action.checked;
  return previousState.copyWith(
    posesSelected: action.checked,
    job: action.pageState.job,
    areChangesSaved: false,
  );
}
