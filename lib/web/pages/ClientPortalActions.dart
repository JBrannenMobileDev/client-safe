
import 'package:dandylight/models/Proposal.dart';

import '../../models/Contract.dart';
import '../../models/Invoice.dart';
import '../../models/Job.dart';
import '../../models/Profile.dart';
import 'ClientPortalPageState.dart';

class FetchProposalDataAction{
  final ClientPortalPageState? pageState;
  final String? userId;
  final String? jobId;
  final bool? isBrandingPreview;
  FetchProposalDataAction(this.pageState, this.userId, this.jobId, this.isBrandingPreview);
}

class SetBrandingPreviewStateAction{
  final ClientPortalPageState? pageState;
  final bool? isBrandingPreview;
  SetBrandingPreviewStateAction(this.pageState, this.isBrandingPreview);
}

class SaveClientSignatureAction{
  final ClientPortalPageState? pageState;
  final String? signature;
  final Contract contract;
  SaveClientSignatureAction(this.pageState, this.signature, this.contract);
}

class SetProposalAction {
  final ClientPortalPageState? pageState;
  final Proposal? proposal;
  SetProposalAction(this.pageState, this.proposal);
}

class SetErrorStateAction {
  final ClientPortalPageState? pageState;
  final String? errorMsg;
  SetErrorStateAction(this.pageState, this.errorMsg);
}

class SetLoadingStateAction {
  final ClientPortalPageState? pageState;
  final bool? isLoading;
  SetLoadingStateAction(this.pageState, this.isLoading);
}

class SetInitialLoadingStateAction {
  final ClientPortalPageState? pageState;
  final bool? isLoading;
  SetInitialLoadingStateAction(this.pageState, this.isLoading);
}

class SetJobAction {
  final ClientPortalPageState? pageState;
  final Job? job;
  SetJobAction(this.pageState, this.job);
}

class SetProfileAction {
  final ClientPortalPageState? pageState;
  final Profile? profile;
  SetProfileAction(this.pageState, this.profile);
}

class SetInvoiceAction {
  final ClientPortalPageState? pageState;
  final Invoice? invoice;
  SetInvoiceAction(this.pageState, this.invoice);
}

class UpdateProposalInvoicePaidAction{
  final ClientPortalPageState? pageState;
  final bool? isPaid;
  UpdateProposalInvoicePaidAction(this.pageState, this.isPaid);
}

class UpdateProposalInvoiceDepositPaidAction{
  final ClientPortalPageState? pageState;
  final bool? isPaid;
  UpdateProposalInvoiceDepositPaidAction(this.pageState, this.isPaid);
}

class GenerateInvoiceForClientAction {
  final ClientPortalPageState? pageState;
  GenerateInvoiceForClientAction(this.pageState);
}

class GenerateContractForClientAction {
  final ClientPortalPageState? pageState;
  final Contract contract;
  GenerateContractForClientAction(this.pageState, this.contract);
}
