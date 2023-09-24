import '../../models/Job.dart';
import '../../models/Profile.dart';
import 'ShareWithClientPageState.dart';

class SetClientMessageAction{
  final ShareWithClientPageState pageState;
  final String clientMessage;
  SetClientMessageAction(this.pageState, this.clientMessage);
}

class ProposalSharedAction{
  final ShareWithClientPageState pageState;
  ProposalSharedAction(this.pageState);
}

class SetContractCheckBox{
  final ShareWithClientPageState pageState;
  final bool checked;
  SetContractCheckBox(this.pageState, this.checked);
}

class SetInvoiceCheckBox{
  final ShareWithClientPageState pageState;
  final bool checked;
  SetInvoiceCheckBox(this.pageState, this.checked);
}

class SetPosesCheckBox{
  final ShareWithClientPageState pageState;
  final bool checked;
  SetPosesCheckBox(this.pageState, this.checked);
}

class SaveProposalAction {
  final ShareWithClientPageState pageState;
  SaveProposalAction(this.pageState);
}

class FetchProfileAction{
  final ShareWithClientPageState pageState;
  FetchProfileAction(this.pageState);
}

class SetProfileShareWIthClientAction{
  final ShareWithClientPageState pageState;
  final Profile profile;
  SetProfileShareWIthClientAction(this.pageState, this.profile);
}

class SetJobShareWithClientAction{
  final ShareWithClientPageState pageState;
  final Job job;
  SetJobShareWithClientAction(this.pageState, this.job);
}
