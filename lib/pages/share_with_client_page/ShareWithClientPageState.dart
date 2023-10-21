import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import '../../models/Proposal.dart';
import 'ShareWithClientActions.dart';

class ShareWithClientPageState{
  final Profile profile;
  final Proposal proposal;
  final bool contractSelected;
  final bool invoiceSelected;
  final bool posesSelected;
  final bool areChangesSaved;
  final String clientMessage;
  final Job job;
  final List<Job> jobs;
  final Function(String) onMessageChanged;
  final Function() onProposalShared;
  final Function(bool) onContractCheckBoxSelected;
  final Function(bool) onInvoiceCheckBoxSelected;
  final Function(bool) onPosesCheckBoxSelected;
  final Function() saveProposal;


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
  });

  ShareWithClientPageState copyWith({
    Profile profile,
    Proposal proposal,
    bool contractSelected,
    bool invoiceSelected,
    bool posesSelected,
    bool areChangesSaved,
    String clientMessage,
    Job job,
    List<Job> jobs,
    Function(String) onMessageChanged,
    Function() onProposalShared,
    Function(bool) onContractCheckBoxSelected,
    Function(bool) onInvoiceCheckBoxSelected,
    Function(bool) onPosesCheckBoxSelected,
    Function() saveProposal,
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
    );
  }

  factory ShareWithClientPageState.initial() => ShareWithClientPageState(
    profile: null,
    proposal: null,
    contractSelected: false,
    invoiceSelected: false,
    posesSelected: false,
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
  );

  factory ShareWithClientPageState.fromStore(Store<AppState> store) {
    return ShareWithClientPageState(
      profile: store.state.shareWithClientPageState.profile,
      proposal: store.state.shareWithClientPageState.proposal,
      contractSelected: store.state.shareWithClientPageState.contractSelected,
      invoiceSelected: store.state.shareWithClientPageState.invoiceSelected,
      posesSelected: store.state.shareWithClientPageState.posesSelected,
      clientMessage: store.state.shareWithClientPageState.clientMessage,
      job: store.state.shareWithClientPageState.job,
      areChangesSaved: store.state.shareWithClientPageState.areChangesSaved,
      jobs: store.state.shareWithClientPageState.jobs,
      onMessageChanged: (message) => store.dispatch(SetClientMessageAction(store.state.shareWithClientPageState, message)),
      onProposalShared: () => store.dispatch(ProposalSharedAction(store.state.shareWithClientPageState)),
      onContractCheckBoxSelected: (checked) => store.dispatch(SetContractCheckBox(store.state.shareWithClientPageState, checked)),
      onInvoiceCheckBoxSelected: (checked) => store.dispatch(SetInvoiceCheckBox(store.state.shareWithClientPageState, checked)),
      onPosesCheckBoxSelected: (checked) => store.dispatch(SetPosesCheckBox(store.state.shareWithClientPageState, checked)),
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
      saveProposal.hashCode ^
      areChangesSaved.hashCode ^
      jobs.hashCode ^
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
              saveProposal == other.saveProposal &&
              areChangesSaved == other.areChangesSaved &&
              jobs == other.jobs &&
              onPosesCheckBoxSelected == other.onPosesCheckBoxSelected;
}