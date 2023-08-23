import 'package:dandylight/models/Proposal.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Invoice.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import 'ClientPortalActions.dart';

class ClientPortalPageState{
  final Proposal proposal;
  final Job job;
  final Profile profile;
  final Invoice invoice;
  final String userId;
  final String jobId;
  final String errorMsg;
  final bool isLoading;
  final Function(String) onClientSignatureSaved;
  final Function(bool) onMarkAsPaidSelected;
  final Function(bool) onMarkAsPaidDepositSelected;
  final Function() onDownloadContractSelected;
  final Function() onDownloadInvoiceSelected;
  final Function() resetErrorMsg;

  ClientPortalPageState({
    @required this.proposal,
    @required this.onClientSignatureSaved,
    @required this.onMarkAsPaidSelected,
    @required this.onMarkAsPaidDepositSelected,
    @required this.onDownloadContractSelected,
    @required this.onDownloadInvoiceSelected,
    @required this.job,
    @required this.profile,
    @required this.invoice,
    @required this.userId,
    @required this.jobId,
    @required this.errorMsg,
    @required this.isLoading,
    @required this.resetErrorMsg,
  });

  ClientPortalPageState copyWith({
    Proposal proposal,
    Job job,
    Profile profile,
    Invoice invoice,
    String userId,
    String jobId,
    String errorMsg,
    bool isLoading,
    Function(String) onClientSignatureSaved,
    Function(bool) onMarkAsPaidSelected,
    Function(bool) onMarkAsPaidDepositSelected,
    Function() onDownloadContractSelected,
    Function() onDownloadInvoiceSelected,
    Function() resetErrorMsg,
  }){
    return ClientPortalPageState(
      proposal: proposal?? this.proposal,
      onClientSignatureSaved: onClientSignatureSaved?? this.onClientSignatureSaved,
      onMarkAsPaidSelected: onMarkAsPaidSelected?? this.onMarkAsPaidSelected,
      onMarkAsPaidDepositSelected: onMarkAsPaidDepositSelected ?? this.onMarkAsPaidDepositSelected,
      onDownloadContractSelected: onDownloadContractSelected ?? this.onDownloadContractSelected,
      onDownloadInvoiceSelected: onDownloadInvoiceSelected ?? this.onDownloadInvoiceSelected,
      job: job ?? this.job,
      errorMsg: errorMsg ?? this.errorMsg,
      profile: profile ?? this.profile,
      invoice: invoice ?? this.invoice,
      userId: userId ?? this.userId,
      jobId: jobId ?? this.jobId,
      isLoading: isLoading ?? this.isLoading,
      resetErrorMsg: resetErrorMsg ?? this.resetErrorMsg,
    );
  }

  factory ClientPortalPageState.initial() => ClientPortalPageState(
    proposal: null,
    job: null,
    profile: null,
    invoice: null,
    userId: null,
    jobId: null,
    errorMsg: '',
    onClientSignatureSaved: null,
    onMarkAsPaidSelected: null,
    onMarkAsPaidDepositSelected: null,
    onDownloadContractSelected: null,
    onDownloadInvoiceSelected: null,
    isLoading: false,
    resetErrorMsg: null,
  );

  factory ClientPortalPageState.fromStore(Store<AppState> store) {
    return ClientPortalPageState(
      proposal: store.state.clientPortalPageState.proposal,
      job: store.state.clientPortalPageState.job,
      profile: store.state.clientPortalPageState.profile,
      invoice: store.state.clientPortalPageState.invoice,
      userId: store.state.clientPortalPageState.userId,
      jobId: store.state.clientPortalPageState.jobId,
      errorMsg: store.state.clientPortalPageState.errorMsg,
      isLoading: store.state.clientPortalPageState.isLoading,
      onClientSignatureSaved: (signature) {
        store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, true));
        store.dispatch(SaveClientSignatureAction(store.state.clientPortalPageState, signature));
      },
      onMarkAsPaidSelected: (isPaid) => store.dispatch(UpdateProposalInvoicePaidAction(store.state.clientPortalPageState, isPaid)),
      onMarkAsPaidDepositSelected: (isPaid) => store.dispatch(UpdateProposalInvoiceDepositPaidAction(store.state.clientPortalPageState, isPaid)),
      onDownloadInvoiceSelected: () => store.dispatch(GenerateInvoiceForClientAction(store.state.clientPortalPageState)),
      onDownloadContractSelected: () => store.dispatch(GenerateContractForClientAction(store.state.clientPortalPageState)),
      resetErrorMsg: () => store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, ''))
    );
  }

  @override
  int get hashCode =>
      proposal.hashCode ^
      job.hashCode ^
      profile.hashCode ^
      invoice.hashCode ^
      resetErrorMsg.hashCode ^
      onClientSignatureSaved.hashCode ^
      onMarkAsPaidSelected.hashCode ^
      onDownloadContractSelected.hashCode ^
      onDownloadInvoiceSelected.hashCode ^
      userId.hashCode ^
      jobId.hashCode^
      errorMsg.hashCode ^
      isLoading.hashCode ^
      onMarkAsPaidDepositSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClientPortalPageState &&
              proposal == other.proposal &&
              job == other.job &&
              proposal == other.proposal &&
              invoice == other.invoice &&
              userId == other.userId &&
              jobId == other.jobId &&
              errorMsg == other.errorMsg &&
              isLoading == other.isLoading &&
              resetErrorMsg == other.resetErrorMsg &&
              onClientSignatureSaved == other.onClientSignatureSaved &&
              onMarkAsPaidSelected == other.onMarkAsPaidSelected &&
              onDownloadInvoiceSelected == other.onDownloadInvoiceSelected &&
              onDownloadContractSelected == other.onDownloadContractSelected &&
              onMarkAsPaidDepositSelected == other.onMarkAsPaidDepositSelected;
}