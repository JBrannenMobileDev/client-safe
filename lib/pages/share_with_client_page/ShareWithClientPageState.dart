import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../models/Proposal.dart';
import 'ShareWithClientActions.dart';

class ShareWithClientPageState{
  final Profile? profile;
  final Proposal? proposal;
  final bool? contractSelected;
  final bool? invoiceSelected;
  final bool? posesSelected;
  final bool? questionnairesSelected;
  final bool? areChangesSaved;
  final String? clientMessage;//Message in client portal
  final String? clientShareMessage;//Message in the share message (SMS/Email)
  final Job? job;
  final bool? updateContractCheckInProgress;
  final bool? updateInvoiceCheckInProgress;
  final bool? updatePosesCheckInProgress;
  final bool? updateQuestionnairesCheckInProgress;
  final List<Job>? jobs;
  final List<String>? previousShareMessages;
  final List<Job>? jobsWithShareMessage;
  final Function(String)? onMessageChanged;
  final Function(String)? onShareMessageChanged;
  final Function()? onProposalShared;
  final Function(bool)? onContractCheckBoxSelected;
  final Function(bool)? onInvoiceCheckBoxSelected;
  final Function(bool)? onPosesCheckBoxSelected;
  final Function(bool)? onQuestionnairesCheckBoxSelected;
  final Function()? saveProposal;


  ShareWithClientPageState({
    @required this.profile,
    @required this.proposal,
    @required this.contractSelected,
    @required this.invoiceSelected,
    @required this.posesSelected,
    @required this.onMessageChanged,
    @required this.onProposalShared,
    @required this.onContractCheckBoxSelected,
    @required this.onInvoiceCheckBoxSelected,
    @required this.onPosesCheckBoxSelected,
    @required this.clientMessage,
    @required this.job,
    @required this.saveProposal,
    @required this.areChangesSaved,
    @required this.jobs,
    @required this.updateContractCheckInProgress,
    @required this.updateInvoiceCheckInProgress,
    @required this.updatePosesCheckInProgress,
    @required this.clientShareMessage,
    @required this.onShareMessageChanged,
    @required this.previousShareMessages,
    @required this.jobsWithShareMessage,
    @required this.updateQuestionnairesCheckInProgress,
    @required this.onQuestionnairesCheckBoxSelected,
    @required this.questionnairesSelected,
  });

  ShareWithClientPageState copyWith({
    Profile? profile,
    Proposal? proposal,
    bool? contractSelected,
    bool? invoiceSelected,
    bool? posesSelected,
    bool? questionnairesSelected,
    bool? areChangesSaved,
    String? clientMessage,
    String? clientShareMessage,
    Job? job,
    List<Job>? jobs,
    List<String>? previousShareMessages,
    List<Job>? jobsWithShareMessage,
    bool? updateContractCheckInProgress,
    bool? updateInvoiceCheckInProgress,
    bool? updatePosesCheckInProgress,
    bool? updateQuestionnairesCheckInProgress,
    Function(String)? onMessageChanged,
    Function(String)? onShareMessageChanged,
    Function()? onProposalShared,
    Function(bool)? onContractCheckBoxSelected,
    Function(bool)? onInvoiceCheckBoxSelected,
    Function(bool)? onPosesCheckBoxSelected,
    Function(bool)? onQuestionnairesCheckBoxSelected,
    Function()? saveProposal,
  }){
    return ShareWithClientPageState(
      profile: profile ?? this.profile,
      proposal: proposal ?? this.proposal,
      contractSelected: contractSelected ?? this.contractSelected,
      invoiceSelected: invoiceSelected ?? this.invoiceSelected,
      posesSelected: posesSelected ?? this.posesSelected,
      onMessageChanged: onMessageChanged ?? this.onMessageChanged,
      onProposalShared: onProposalShared ?? this.onProposalShared,
      onContractCheckBoxSelected: onContractCheckBoxSelected ?? this.onContractCheckBoxSelected,
      onInvoiceCheckBoxSelected: onInvoiceCheckBoxSelected ?? this.onInvoiceCheckBoxSelected,
      onPosesCheckBoxSelected: onPosesCheckBoxSelected ?? this.onPosesCheckBoxSelected,
      clientMessage: clientMessage ?? this.clientMessage,
      job: job ?? this.job,
      saveProposal: saveProposal ?? this.saveProposal,
      areChangesSaved: areChangesSaved ?? this.areChangesSaved,
      jobs: jobs ?? this.jobs,
      updateContractCheckInProgress: updateContractCheckInProgress ?? this.updateContractCheckInProgress,
      updateInvoiceCheckInProgress: updateInvoiceCheckInProgress ?? this.updateInvoiceCheckInProgress,
      updatePosesCheckInProgress: updatePosesCheckInProgress ?? this.updatePosesCheckInProgress,
      onShareMessageChanged: onShareMessageChanged ?? this.onShareMessageChanged,
      clientShareMessage: clientShareMessage ?? this.clientShareMessage,
      previousShareMessages: previousShareMessages ?? this.previousShareMessages,
      jobsWithShareMessage: jobsWithShareMessage ?? this.jobsWithShareMessage,
      updateQuestionnairesCheckInProgress: updateQuestionnairesCheckInProgress ?? this.updateQuestionnairesCheckInProgress,
      onQuestionnairesCheckBoxSelected: onQuestionnairesCheckBoxSelected ?? this.onQuestionnairesCheckBoxSelected,
      questionnairesSelected: questionnairesSelected ?? this.questionnairesSelected,
    );
  }

  factory ShareWithClientPageState.initial() => ShareWithClientPageState(
    profile: null,
    proposal: null,
    contractSelected: false,
    invoiceSelected: false,
    posesSelected: false,
    questionnairesSelected: false,
    onMessageChanged: null,
    onProposalShared: null,
    onContractCheckBoxSelected: null,
    onInvoiceCheckBoxSelected: null,
    onPosesCheckBoxSelected: null,
    clientMessage: '',
    job: null,
    saveProposal: null,
    areChangesSaved: true,
    jobs: [],
    updateContractCheckInProgress: false,
    updatePosesCheckInProgress: false,
    updateInvoiceCheckInProgress: false,
    updateQuestionnairesCheckInProgress: false,
    onQuestionnairesCheckBoxSelected: null,
    clientShareMessage: '',
    onShareMessageChanged: null,
    previousShareMessages: [],
    jobsWithShareMessage: [],
  );

  factory ShareWithClientPageState.fromStore(Store<AppState> store) {
    return ShareWithClientPageState(
      profile: store.state.shareWithClientPageState!.profile,
      proposal: store.state.shareWithClientPageState!.proposal,
      contractSelected: store.state.shareWithClientPageState!.contractSelected,
      invoiceSelected: store.state.shareWithClientPageState!.invoiceSelected,
      posesSelected: store.state.shareWithClientPageState!.posesSelected,
      clientMessage: store.state.shareWithClientPageState!.clientMessage,
      job: store.state.shareWithClientPageState!.job,
      areChangesSaved: store.state.shareWithClientPageState!.areChangesSaved,
      jobs: store.state.shareWithClientPageState!.jobs,
      updateContractCheckInProgress: store.state.shareWithClientPageState!.updateContractCheckInProgress,
      updateInvoiceCheckInProgress: store.state.shareWithClientPageState!.updateInvoiceCheckInProgress,
      updatePosesCheckInProgress: store.state.shareWithClientPageState!.updatePosesCheckInProgress,
      clientShareMessage: store.state.shareWithClientPageState!.clientShareMessage,
      previousShareMessages: store.state.shareWithClientPageState!.previousShareMessages,
      jobsWithShareMessage: store.state.shareWithClientPageState!.jobsWithShareMessage,
      questionnairesSelected: store.state.shareWithClientPageState!.questionnairesSelected,
      updateQuestionnairesCheckInProgress: store.state.shareWithClientPageState!.updateQuestionnairesCheckInProgress,
      onMessageChanged: (message) => store.dispatch(SetClientMessageAction(store.state.shareWithClientPageState, message)),
      onShareMessageChanged: (message) => store.dispatch(SetClientShareMessageAction(store.state.shareWithClientPageState, message)),
      onProposalShared: () => store.dispatch(ProposalSharedAction(store.state.shareWithClientPageState)),
      onContractCheckBoxSelected: (checked) => store.dispatch(SetContractCheckBox(store.state.shareWithClientPageState, checked)),
      onInvoiceCheckBoxSelected: (checked) => store.dispatch(SetInvoiceCheckBox(store.state.shareWithClientPageState, checked)),
      onPosesCheckBoxSelected: (checked) => store.dispatch(SetPosesCheckBox(store.state.shareWithClientPageState, checked)),
      onQuestionnairesCheckBoxSelected: (checked) => store.dispatch(SetQuestionnairesCheckBox(store.state.shareWithClientPageState, checked)),
      saveProposal: () => store.dispatch(SaveProposalAction(store.state.shareWithClientPageState)),
    );
  }

  @override
  int get hashCode =>
      profile.hashCode ^
      proposal.hashCode ^
      contractSelected.hashCode ^
      invoiceSelected.hashCode ^
      posesSelected.hashCode ^
      onMessageChanged.hashCode ^
      onProposalShared.hashCode ^
      onContractCheckBoxSelected.hashCode ^
      onInvoiceCheckBoxSelected.hashCode ^
      clientMessage.hashCode ^
      job.hashCode ^
      updateContractCheckInProgress.hashCode ^
      updateInvoiceCheckInProgress.hashCode ^
      updatePosesCheckInProgress.hashCode ^
      saveProposal.hashCode ^
      areChangesSaved.hashCode ^
      jobs.hashCode ^
      clientShareMessage.hashCode ^
      previousShareMessages.hashCode^
      jobsWithShareMessage.hashCode^
      onShareMessageChanged.hashCode ^
      updateQuestionnairesCheckInProgress.hashCode ^
      onQuestionnairesCheckBoxSelected.hashCode ^
      questionnairesSelected.hashCode ^
      onPosesCheckBoxSelected.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShareWithClientPageState &&
              profile == other.profile &&
              proposal == other.proposal &&
              job == other.job &&
              contractSelected == other.contractSelected &&
              invoiceSelected == other.invoiceSelected &&
              posesSelected == other.posesSelected &&
              onMessageChanged == other.onMessageChanged &&
              onProposalShared == other.onProposalShared &&
              onContractCheckBoxSelected == other.onContractCheckBoxSelected &&
              onInvoiceCheckBoxSelected == other.onInvoiceCheckBoxSelected &&
              clientMessage == other.clientMessage &&
              updateContractCheckInProgress == other.updateContractCheckInProgress &&
              updateInvoiceCheckInProgress == other.updateInvoiceCheckInProgress &&
              updatePosesCheckInProgress == other.updatePosesCheckInProgress &&
              saveProposal == other.saveProposal &&
              previousShareMessages == other.previousShareMessages &&
              jobsWithShareMessage == other.jobsWithShareMessage &&
              areChangesSaved == other.areChangesSaved &&
              jobs == other.jobs &&
              clientShareMessage == other.clientShareMessage &&
              onShareMessageChanged == other.onShareMessageChanged &&
              onQuestionnairesCheckBoxSelected == other.onQuestionnairesCheckBoxSelected &&
              updateQuestionnairesCheckInProgress == other.updateQuestionnairesCheckInProgress &&
              questionnairesSelected == other.questionnairesSelected &&
              onPosesCheckBoxSelected == other.onPosesCheckBoxSelected;
}