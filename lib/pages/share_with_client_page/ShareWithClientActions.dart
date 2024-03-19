import '../../models/Job.dart';
import '../../models/Profile.dart';
import 'ShareWithClientPageState.dart';

class SetClientMessageAction{
  final ShareWithClientPageState? pageState;
  final String? clientMessage;
  SetClientMessageAction(this.pageState, this.clientMessage);
}

class SetClientShareMessageAction{
  final ShareWithClientPageState? pageState;
  final String? clientMessage;
  SetClientShareMessageAction(this.pageState, this.clientMessage);
}

class ProposalSharedAction{
  final ShareWithClientPageState? pageState;
  ProposalSharedAction(this.pageState);
}

class SetContractCheckBox{
  final ShareWithClientPageState? pageState;
  final bool? checked;
  SetContractCheckBox(this.pageState, this.checked);
}

class SetInvoiceCheckBox{
  final ShareWithClientPageState? pageState;
  final bool? checked;
  SetInvoiceCheckBox(this.pageState, this.checked);
}

class SetPosesCheckBox{
  final ShareWithClientPageState? pageState;
  final bool? checked;
  SetPosesCheckBox(this.pageState, this.checked);
}

class SaveProposalAction {
  final ShareWithClientPageState? pageState;
  SaveProposalAction(this.pageState);
}

class UpdateContractCheckInProgressStateAction {
  final ShareWithClientPageState? pageState;
  final bool? inProgress;
  UpdateContractCheckInProgressStateAction(this.pageState, this.inProgress);
}

class UpdateInvoiceCheckInProgressStateAction {
  final ShareWithClientPageState? pageState;
  final bool? inProgress;
  UpdateInvoiceCheckInProgressStateAction(this.pageState, this.inProgress);
}

class UpdatePosesCheckInProgressStateAction {
  final ShareWithClientPageState? pageState;
  final bool? inProgress;
  UpdatePosesCheckInProgressStateAction(this.pageState, this.inProgress);
}

class FetchProfileAction{
  final ShareWithClientPageState? pageState;
  FetchProfileAction(this.pageState);
}

class SetProfileShareWIthClientAction{
  final ShareWithClientPageState? pageState;
  final Profile? profile;
  SetProfileShareWIthClientAction(this.pageState, this.profile);
}

class SetJobShareWithClientAction{
  final ShareWithClientPageState? pageState;
  final Job? job;
  SetJobShareWithClientAction(this.pageState, this.job);
}

class SetAllJobsAction {
  final ShareWithClientPageState? pageState;
  final List<Job>? jobs;
  SetAllJobsAction(this.pageState, this.jobs);
}
