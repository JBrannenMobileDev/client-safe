import 'package:dandylight/models/Proposal.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import '../../models/Contract.dart';
import '../../models/Invoice.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import 'ClientPortalActions.dart';

class ClientPortalPageState{
  final Proposal? proposal;
  final Job? job;
  final Profile? profile;
  final Invoice? invoice;
  final String? userId;
  final String? jobId;
  final String? errorMsg;
  final bool? isLoading;
  final bool? isLoadingInitial;
  final bool? isBrandingPreview;
  final Function(String, Contract)? onClientSignatureSaved;
  final Function(bool)? onMarkAsPaidSelected;
  final Function(bool)? onMarkAsPaidDepositSelected;
  final Function(Contract)? onDownloadContractSelected;
  final Function()? onDownloadInvoiceSelected;
  final Function()? resetErrorMsg;
  final Function()? updateQuestionnaires;

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
    @required this.isBrandingPreview,
    @required this.isLoadingInitial,
    @required this.updateQuestionnaires,
  });

  ClientPortalPageState copyWith({
    Proposal? proposal,
    Job? job,
    Profile? profile,
    Invoice? invoice,
    String? userId,
    String? jobId,
    String? errorMsg,
    bool? isLoading,
    bool? isBrandingPreview,
    bool? isLoadingInitial,
    Function(String, Contract)? onClientSignatureSaved,
    Function(bool)? onMarkAsPaidSelected,
    Function(bool)? onMarkAsPaidDepositSelected,
    Function(Contract)? onDownloadContractSelected,
    Function()? onDownloadInvoiceSelected,
    Function()? resetErrorMsg,
    Function()? updateQuestionnaires,
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
      isBrandingPreview: isBrandingPreview ?? this.isBrandingPreview,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      updateQuestionnaires: updateQuestionnaires ?? this.updateQuestionnaires,
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
    isBrandingPreview: false,
    isLoadingInitial: true,
    updateQuestionnaires: null,
  );

  factory ClientPortalPageState.fromStore(Store<AppState> store) {
    return ClientPortalPageState(
      proposal: store.state.clientPortalPageState!.proposal,
      job: store.state.clientPortalPageState!.job,
      profile: store.state.clientPortalPageState!.profile,
      invoice: store.state.clientPortalPageState!.invoice,
      userId: store.state.clientPortalPageState!.userId,
      jobId: store.state.clientPortalPageState!.jobId,
      errorMsg: store.state.clientPortalPageState!.errorMsg,
      isLoading: store.state.clientPortalPageState!.isLoading,
      isBrandingPreview: store.state.clientPortalPageState!.isBrandingPreview,
      isLoadingInitial: store.state.clientPortalPageState!.isLoadingInitial,
      onClientSignatureSaved: (signature, contract) {
        store.dispatch(SetLoadingStateAction(store.state.clientPortalPageState, true));
        store.dispatch(SaveClientSignatureAction(store.state.clientPortalPageState, signature, contract));
      },
      onMarkAsPaidSelected: (isPaid) => store.dispatch(UpdateProposalInvoicePaidAction(store.state.clientPortalPageState, isPaid)),
      onMarkAsPaidDepositSelected: (isPaid) => store.dispatch(UpdateProposalInvoiceDepositPaidAction(store.state.clientPortalPageState, isPaid)),
      onDownloadInvoiceSelected: () => store.dispatch(GenerateInvoiceForClientAction(store.state.clientPortalPageState)),
      onDownloadContractSelected: (contract) => store.dispatch(GenerateContractForClientAction(store.state.clientPortalPageState, contract)),
      resetErrorMsg: () => store.dispatch(SetErrorStateAction(store.state.clientPortalPageState, '')),
      updateQuestionnaires: () => store.dispatch(FetchProposalDataAction(store.state.clientPortalPageState, store.state.clientPortalPageState!.userId, store.state.clientPortalPageState!.jobId, false)),
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
      isBrandingPreview.hashCode ^
      isLoadingInitial.hashCode ^
      updateQuestionnaires.hashCode ^
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
              isBrandingPreview == other.isBrandingPreview &&
              jobId == other.jobId &&
              errorMsg == other.errorMsg &&
              isLoading == other.isLoading &&
              resetErrorMsg == other.resetErrorMsg &&
              onClientSignatureSaved == other.onClientSignatureSaved &&
              onMarkAsPaidSelected == other.onMarkAsPaidSelected &&
              onDownloadInvoiceSelected == other.onDownloadInvoiceSelected &&
              onDownloadContractSelected == other.onDownloadContractSelected &&
              isLoadingInitial == other.isLoadingInitial &&
              updateQuestionnaires == other.updateQuestionnaires &&
              onMarkAsPaidDepositSelected == other.onMarkAsPaidDepositSelected;
}