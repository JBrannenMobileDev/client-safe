
import 'package:dandylight/models/Proposal.dart';

import '../../models/Invoice.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import 'ClientPortalPageState.dart';

class FetchProposalDataAction{
  final ClientPortalPageState pageState;
  final String userId;
  final String jobId;
  FetchProposalDataAction(this.pageState, this.userId, this.jobId);
}

class SaveClientSignatureAction{
  final ClientPortalPageState pageState;
  final String signature;
  SaveClientSignatureAction(this.pageState, this.signature);
}

class SetProposalAction {
  final ClientPortalPageState pageState;
  final Proposal proposal;
  SetProposalAction(this.pageState, this.proposal);
}

class SetErrorStateAction {
  final ClientPortalPageState pageState;
  final String errorMsg;
  SetErrorStateAction(this.pageState, this.errorMsg);
}

class SetLoadingStateAction {
  final ClientPortalPageState pageState;
  final bool isLoading;
  SetLoadingStateAction(this.pageState, this.isLoading);
}

class SetJobAction {
  final ClientPortalPageState pageState;
  final Job job;
  SetJobAction(this.pageState, this.job);
}

class SetProfileAction {
  final ClientPortalPageState pageState;
  final Profile profile;
  SetProfileAction(this.pageState, this.profile);
}

class SetInvoiceAction {
  final ClientPortalPageState pageState;
  final Invoice invoice;
  SetInvoiceAction(this.pageState, this.invoice);
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
