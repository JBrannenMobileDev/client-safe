import 'package:dandylight/models/Proposal.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'ClientPortalActions.dart';

class ClientPortalPageState{
  final Proposal proposal;
  final Function(String) onClientSignatureChanged;
  final Function() onContractSigned;
  final Function(bool) onMarkAsPaidSelected;
  final Function(bool) onMarkAsPaidDepositSelected;

  ClientPortalPageState({
    @required this.proposal,
    @required this.onClientSignatureChanged,
    @required this.onContractSigned,
    @required this.onMarkAsPaidSelected,
    @required this.onMarkAsPaidDepositSelected,
  });

  ClientPortalPageState copyWith({
    Proposal proposal,
    Function(String) onClientSignatureChanged,
    Function() onContractSigned,
    Function(bool) onMarkAsPaidSelected,
    Function(bool) onMarkAsPaidDepositSelected,
  }){
    return ClientPortalPageState(
      proposal: proposal?? this.proposal,
      onClientSignatureChanged: onClientSignatureChanged?? this.onClientSignatureChanged,
      onContractSigned: onContractSigned?? this.onContractSigned,
      onMarkAsPaidSelected: onMarkAsPaidSelected?? this.onMarkAsPaidSelected,
      onMarkAsPaidDepositSelected: onMarkAsPaidDepositSelected ?? this.onMarkAsPaidDepositSelected,
    );
  }

  factory ClientPortalPageState.initial() => ClientPortalPageState(
    proposal: null,
    onClientSignatureChanged: null,
    onContractSigned: null,
    onMarkAsPaidSelected: null,
    onMarkAsPaidDepositSelected: null,
  );

  factory ClientPortalPageState.fromStore(Store<AppState> store) {
    return ClientPortalPageState(
      proposal: store.state.clientPortalPageState.proposal,
      onClientSignatureChanged: (signature) => store.dispatch(SetClientSignatureAction(store.state.clientPortalPageState, signature)),
      onContractSigned: () => store.dispatch(UpdateProposalContractSignedAction(store.state.clientPortalPageState)),
      onMarkAsPaidSelected: (isPaid) => store.dispatch(UpdateProposalInvoicePaidAction(store.state.clientPortalPageState, isPaid)),
      onMarkAsPaidDepositSelected: (isPaid) => store.dispatch(UpdateProposalInvoiceDepositPaidAction(store.state.clientPortalPageState, isPaid)),
    );
  }

  @override
  int get hashCode =>
      proposal.hashCode ^
      onClientSignatureChanged.hashCode ^
      onContractSigned.hashCode ^
      onMarkAsPaidSelected.hashCode ^
      onMarkAsPaidDepositSelected.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClientPortalPageState &&
              proposal == other.proposal &&
              onClientSignatureChanged == other.onClientSignatureChanged &&
              onContractSigned == other.onContractSigned &&
              onMarkAsPaidSelected == other.onMarkAsPaidSelected &&
              onMarkAsPaidDepositSelected == other.onMarkAsPaidDepositSelected;
}