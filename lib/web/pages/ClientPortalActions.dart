
import 'package:dandylight/models/Proposal.dart';

import 'ClientPortalPageState.dart';

class FetchProposalAction{
  final ClientPortalPageState pageState;
  final String proposalId;
  FetchProposalAction(this.pageState, this.proposalId);
}

class SaveClientSignatureAction{
  final ClientPortalPageState pageState;
  final String signature;
  SaveClientSignatureAction(this.pageState, this.signature);
}

class SetUpdatedProposalAction {
  final ClientPortalPageState pageState;
  final Proposal proposal;
  SetUpdatedProposalAction(this.pageState, this.proposal);
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
