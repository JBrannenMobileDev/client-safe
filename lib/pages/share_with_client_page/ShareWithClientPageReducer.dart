import 'package:redux/redux.dart';

import 'ShareWithClientActions.dart';
import 'ShareWithClientPageState.dart';

final shareWithClientReducer = combineReducers<ShareWithClientPageState>([
  TypedReducer<ShareWithClientPageState, SetClientMessageAction>(_setClientMessage),
  TypedReducer<ShareWithClientPageState, SetContractCheckBox>(_setContractChecked),
  TypedReducer<ShareWithClientPageState, SetInvoiceCheckBox>(_setInvoiceChecked),
  TypedReducer<ShareWithClientPageState, SetPosesCheckBox>(_setPosesChecked),
  TypedReducer<ShareWithClientPageState, SetProfileShareWIthClientAction>(_setProfile),
  TypedReducer<ShareWithClientPageState, SetJobShareWithClientAction>(_setJob),
]);

ShareWithClientPageState _setJob(ShareWithClientPageState previousState, SetJobShareWithClientAction action){
  return previousState.copyWith(
    job: action.job,
  );
}

ShareWithClientPageState _setProfile(ShareWithClientPageState previousState, SetProfileShareWIthClientAction action){
  return previousState.copyWith(
    profile: action.profile,
  );
}

ShareWithClientPageState _setClientMessage(ShareWithClientPageState previousState, SetClientMessageAction action){
  return previousState.copyWith(
    clientMessage: action.clientMessage,
  );
}

ShareWithClientPageState _setContractChecked(ShareWithClientPageState previousState, SetContractCheckBox action){
  return previousState.copyWith(
    contractSelected: action.checked,
  );
}

ShareWithClientPageState _setInvoiceChecked(ShareWithClientPageState previousState, SetInvoiceCheckBox action){
  return previousState.copyWith(
    invoiceSelected: action.checked,
  );
}

ShareWithClientPageState _setPosesChecked(ShareWithClientPageState previousState, SetPosesCheckBox action){
  return previousState.copyWith(
    posesSelected: action.checked,
  );
}
