import 'package:dandylight/models/Proposal.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'ClientPortalActions.dart';

class ClientPortalPageState{
  final Proposal proposal;
  final Function(String) onClientSignatureSaved;
  final Function(bool) onMarkAsPaidSelected;
  final Function(bool) onMarkAsPaidDepositSelected;
  final Function() onDownloadContractSelected;
  final Function() onDownloadInvoiceSelected;

  ClientPortalPageState({
    @required this.proposal,
    @required this.onClientSignatureSaved,
    @required this.onMarkAsPaidSelected,
    @required this.onMarkAsPaidDepositSelected,
    @required this.onDownloadContractSelected,
    @required this.onDownloadInvoiceSelected,
  });

  ClientPortalPageState copyWith({
    Proposal proposal,
    Function(String) onClientSignatureSaved,
    Function(bool) onMarkAsPaidSelected,
    Function(bool) onMarkAsPaidDepositSelected,
    Function() onDownloadContractSelected,
    Function() onDownloadInvoiceSelected,
  }){
    return ClientPortalPageState(
      proposal: proposal?? this.proposal,
      onClientSignatureSaved: onClientSignatureSaved?? this.onClientSignatureSaved,
      onMarkAsPaidSelected: onMarkAsPaidSelected?? this.onMarkAsPaidSelected,
      onMarkAsPaidDepositSelected: onMarkAsPaidDepositSelected ?? this.onMarkAsPaidDepositSelected,
      onDownloadContractSelected: onDownloadContractSelected ?? this.onDownloadContractSelected,
      onDownloadInvoiceSelected: onDownloadInvoiceSelected ?? this.onDownloadInvoiceSelected,
    );
  }

  factory ClientPortalPageState.initial() => ClientPortalPageState(
    proposal: null,
    onClientSignatureSaved: null,
    onMarkAsPaidSelected: null,
    onMarkAsPaidDepositSelected: null,
    onDownloadContractSelected: null,
    onDownloadInvoiceSelected: null,
  );

  factory ClientPortalPageState.fromStore(Store<AppState> store) {
    return ClientPortalPageState(
      proposal: store.state.clientPortalPageState.proposal,
      onClientSignatureSaved: (signature) => store.dispatch(SaveClientSignatureAction(store.state.clientPortalPageState, signature)),
      onMarkAsPaidSelected: (isPaid) => store.dispatch(UpdateProposalInvoicePaidAction(store.state.clientPortalPageState, isPaid)),
      onMarkAsPaidDepositSelected: (isPaid) => store.dispatch(UpdateProposalInvoiceDepositPaidAction(store.state.clientPortalPageState, isPaid)),
      onDownloadInvoiceSelected: () => store.dispatch(GenerateInvoiceForClientAction(store.state.clientPortalPageState)),
      onDownloadContractSelected: () => store.dispatch(GenerateContractForClientAction(store.state.clientPortalPageState)),
    );
  }

  @override
  int get hashCode =>
      proposal.hashCode ^
      onClientSignatureSaved.hashCode ^
      onMarkAsPaidSelected.hashCode ^
      onDownloadContractSelected.hashCode ^
      onDownloadInvoiceSelected.hashCode ^
      onMarkAsPaidDepositSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClientPortalPageState &&
              proposal == other.proposal &&
              onClientSignatureSaved == other.onClientSignatureSaved &&
              onMarkAsPaidSelected == other.onMarkAsPaidSelected &&
              onDownloadInvoiceSelected == other.onDownloadInvoiceSelected &&
              onDownloadContractSelected == other.onDownloadContractSelected &&
              onMarkAsPaidDepositSelected == other.onMarkAsPaidDepositSelected;
}