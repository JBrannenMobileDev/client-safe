
import 'package:dandylight/models/Proposal.dart';

import 'ClientPortalPageState.dart';

class FetchProposalAction{
  final ClientPortalPageState pageState;
  final String proposalId;
  FetchProposalAction(this.pageState, this.proposalId);
}

class SetClientSignatureAction{
  final ClientPortalPageState pageState;
  final String signature;
  SetClientSignatureAction(this.pageState, this.signature);
}

class SetUpdatedProposalAction {
  final ClientPortalPageState pageState;
  final Proposal proposal;
  SetUpdatedProposalAction(this.pageState, this.proposal);
}

class UpdateProposalContractSignedAction{
  final ClientPortalPageState pageState;
  UpdateProposalContractSignedAction(this.pageState);
}

class UpdateProposalInvoicePaidAction{
  final ClientPortalPageState pageState;
  final bool isPaid;
  UpdateProposalInvoicePaidAction(this.pageState, this.isPaid);
}

class UpdateProposalInvoiceDepositPaidAction{
  final ClientPortalPageState pageState;
  final bool isPaid;
  UpdateProposalInvoiceDepositPaidAction(this.pageState, this.isPaid);
}

class GenerateInvoiceForClientAction {
  final ClientPortalPageState pageState;
  GenerateInvoiceForClientAction(this.pageState);
}

class GenerateContractForClientAction {
  final ClientPortalPageState pageState;
  GenerateContractForClientAction(this.pageState);
}
