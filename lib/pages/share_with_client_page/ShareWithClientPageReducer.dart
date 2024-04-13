import 'package:redux/redux.dart';

import '../../models/Contract.dart';
import '../../models/Job.dart';
import 'ShareWithClientActions.dart';
import 'ShareWithClientPageState.dart';

final shareWithClientReducer = combineReducers<ShareWithClientPageState>([
  TypedReducer<ShareWithClientPageState, SetClientMessageAction>(_setClientMessage),
  TypedReducer<ShareWithClientPageState, SetClientShareMessageAction>(_setClientShareMessage),
  TypedReducer<ShareWithClientPageState, SetContractCheckBox>(_setContractChecked),
  TypedReducer<ShareWithClientPageState, SetInvoiceCheckBox>(_setInvoiceChecked),
  TypedReducer<ShareWithClientPageState, SetPosesCheckBox>(_setPosesChecked),
  TypedReducer<ShareWithClientPageState, SetQuestionnairesCheckBox>(_setQuestionnairesChecked),
  TypedReducer<ShareWithClientPageState, SetProfileShareWIthClientAction>(_setProfile),
  TypedReducer<ShareWithClientPageState, SetJobShareWithClientAction>(_setJob),
  TypedReducer<ShareWithClientPageState, SaveProposalAction>(_setAreChangesSavedState),
  TypedReducer<ShareWithClientPageState, SetAllJobsAction>(_setAllJobs),
  TypedReducer<ShareWithClientPageState, UpdateContractCheckInProgressStateAction>(_setContractInProgressState),
  TypedReducer<ShareWithClientPageState, UpdatePosesCheckInProgressStateAction>(_setPosesInProgressState),
  TypedReducer<ShareWithClientPageState, UpdateInvoiceCheckInProgressStateAction>(_setInvoiceInProgressState),
  TypedReducer<ShareWithClientPageState, UpdateQuestionnairesCheckInProgressStateAction>(_setQuestionnairesInProgressState),
]);

ShareWithClientPageState _setQuestionnairesInProgressState(ShareWithClientPageState previousState, UpdateQuestionnairesCheckInProgressStateAction action){
  return previousState.copyWith(
    updateQuestionnairesCheckInProgress: action.inProgress,
  );
}

ShareWithClientPageState _setContractInProgressState(ShareWithClientPageState previousState, UpdateContractCheckInProgressStateAction action){
  return previousState.copyWith(
    updateContractCheckInProgress: action.inProgress,
  );
}

ShareWithClientPageState _setPosesInProgressState(ShareWithClientPageState previousState, UpdatePosesCheckInProgressStateAction action){
  return previousState.copyWith(
    updatePosesCheckInProgress: action.inProgress,
  );
}

ShareWithClientPageState _setInvoiceInProgressState(ShareWithClientPageState previousState, UpdateInvoiceCheckInProgressStateAction action){
  return previousState.copyWith(
    updateInvoiceCheckInProgress: action.inProgress,
  );
}

ShareWithClientPageState _setAllJobs(ShareWithClientPageState previousState, SetAllJobsAction action){
  List<Job> jobsWithShareMessage = action.jobs!.where((job) => job.proposal!.shareMessage!.isNotEmpty).toList();
  return previousState.copyWith(
    jobs: action.jobs,
    jobsWithShareMessage: jobsWithShareMessage,
  );
}

ShareWithClientPageState _setAreChangesSavedState(ShareWithClientPageState previousState, SaveProposalAction action){
  return previousState.copyWith(
    areChangesSaved: true,
  );
}

ShareWithClientPageState _setJob(ShareWithClientPageState previousState, SetJobShareWithClientAction action){
  return previousState.copyWith(
    job: action.job,
    invoiceSelected: action.job!.proposal!.includeInvoice,
    contractSelected: action.job!.proposal!.includeContract,
    posesSelected: action.job!.proposal!.includePoses,
    clientMessage: action.job!.proposal!.detailsMessage,
  );
}

ShareWithClientPageState _setProfile(ShareWithClientPageState previousState, SetProfileShareWIthClientAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

ShareWithClientPageState _setClientMessage(ShareWithClientPageState previousState, SetClientMessageAction action){
  action.pageState!.job!.proposal!.detailsMessage = action.clientMessage;
  return previousState.copyWith(
    clientMessage: action.clientMessage,
    job: action.pageState!.job,
    areChangesSaved: false,
  );
}

ShareWithClientPageState _setClientShareMessage(ShareWithClientPageState previousState, SetClientShareMessageAction action){
  action.pageState!.job!.proposal!.shareMessage = action.clientMessage;
  return previousState.copyWith(
    clientShareMessage: action.clientMessage,
    job: action.pageState!.job,
    areChangesSaved: false,
  );
}

ShareWithClientPageState _setContractChecked(ShareWithClientPageState previousState, SetContractCheckBox action){
  action.pageState!.job!.proposal!.includeContract = action.checked;
  return previousState.copyWith(
    contractSelected: action.checked,
    job: action.pageState!.job,
    areChangesSaved: false,
    updateContractCheckInProgress: false,
  );
}

ShareWithClientPageState _setInvoiceChecked(ShareWithClientPageState previousState, SetInvoiceCheckBox action){
  action.pageState!.job!.proposal!.includeInvoice = action.checked;
  return previousState.copyWith(
    invoiceSelected: action.checked,
    job: action.pageState!.job,
    areChangesSaved: false,
    updateInvoiceCheckInProgress: false,
  );
}

ShareWithClientPageState _setPosesChecked(ShareWithClientPageState previousState, SetPosesCheckBox action){
  action.pageState!.job!.proposal!.includePoses = action.checked;
  return previousState.copyWith(
    posesSelected: action.checked,
    job: action.pageState!.job,
    areChangesSaved: false,
    updatePosesCheckInProgress: false,
  );
}

ShareWithClientPageState _setQuestionnairesChecked(ShareWithClientPageState previousState, SetQuestionnairesCheckBox action){
  action.pageState.job.proposal.includeQuestionnaires = action.checked;
  return previousState.copyWith(
    questionnairesSelected: action.checked,
    job: action.pageState.job,
    areChangesSaved: false,
    updateQuestionnairesCheckInProgress: false,
  );
}
