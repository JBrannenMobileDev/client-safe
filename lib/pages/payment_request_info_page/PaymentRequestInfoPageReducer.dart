import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageState.dart';
import 'package:redux/redux.dart';

import 'PaymentRequestInfoPageActions.dart';

final paymentRequestInfoPageReducer = combineReducers<PaymentRequestInfoPageState>([
  TypedReducer<PaymentRequestInfoPageState, SaveZelleStateAction>(_saveZelleState),
  TypedReducer<PaymentRequestInfoPageState, SaveVenmoStateAction>(_saveVenmoState),
  TypedReducer<PaymentRequestInfoPageState, SaveCashAppStateAction>(_saveCashAppState),
  TypedReducer<PaymentRequestInfoPageState, SaveApplePayStateAction>(_saveApplePayState),
  TypedReducer<PaymentRequestInfoPageState, SaveCashStateAction>(_saveCashState),
  TypedReducer<PaymentRequestInfoPageState, SaveOtherStateAction>(_saveOtherState),
  TypedReducer<PaymentRequestInfoPageState, SaveWireStateAction>(_saveWireState),
  TypedReducer<PaymentRequestInfoPageState, SetZellePhoneEmailTextAction>(_setZellePhoneEmailText),
  TypedReducer<PaymentRequestInfoPageState, SetZelleFullNameTextAction>(_setZelleFullNameText),
  TypedReducer<PaymentRequestInfoPageState, SetVenmoLinkTextAction>(_setVenmoLinkText),
  TypedReducer<PaymentRequestInfoPageState, SetCashAppLinkTextAction>(_setCashAppLinkText),
  TypedReducer<PaymentRequestInfoPageState, SetApplePayPhoneTextAction>(_setApplePayPhoneText),
  TypedReducer<PaymentRequestInfoPageState, SetOtherTextAction>(_setOtherText),
  TypedReducer<PaymentRequestInfoPageState, SetWireTextAction>(_setWireText),
  TypedReducer<PaymentRequestInfoPageState, SetCashTextAction>(_setCashText),
]);

PaymentRequestInfoPageState _setZellePhoneEmailText(PaymentRequestInfoPageState previousState, SetZellePhoneEmailTextAction action){
  return previousState.copyWith(
    zellePhoneEmail: action.input,
  );
}

PaymentRequestInfoPageState _setZelleFullNameText(PaymentRequestInfoPageState previousState, SetZelleFullNameTextAction action){
  return previousState.copyWith(
    zelleFullName: action.input,
  );
}

PaymentRequestInfoPageState _setVenmoLinkText(PaymentRequestInfoPageState previousState, SetVenmoLinkTextAction action){
  return previousState.copyWith(
    venmoLink: action.input,
  );
}

PaymentRequestInfoPageState _setCashAppLinkText(PaymentRequestInfoPageState previousState, SetCashAppLinkTextAction action){
  return previousState.copyWith(
    cashAppLink: action.input,
  );
}

PaymentRequestInfoPageState _setApplePayPhoneText(PaymentRequestInfoPageState previousState, SetApplePayPhoneTextAction action){
  return previousState.copyWith(
    applePayPhone: action.input,
  );
}

PaymentRequestInfoPageState _setOtherText(PaymentRequestInfoPageState previousState, SetOtherTextAction action){
  return previousState.copyWith(
    otherMessage: action.input,
  );
}

PaymentRequestInfoPageState _setWireText(PaymentRequestInfoPageState previousState, SetWireTextAction action){
  return previousState.copyWith(
    wireMessage: action.input,
  );
}

PaymentRequestInfoPageState _setCashText(PaymentRequestInfoPageState previousState, SetCashTextAction action){
  return previousState.copyWith(
    cashMessage: action.input,
  );
}

PaymentRequestInfoPageState _saveZelleState(PaymentRequestInfoPageState previousState, SaveZelleStateAction action){
  return previousState.copyWith(
    zelleEnabled: action.enabled,
  );
}

PaymentRequestInfoPageState _saveVenmoState(PaymentRequestInfoPageState previousState, SaveVenmoStateAction action){
  return previousState.copyWith(
    venmoEnabled: action.enabled,
  );
}

PaymentRequestInfoPageState _saveCashAppState(PaymentRequestInfoPageState previousState, SaveCashAppStateAction action){
  return previousState.copyWith(
    cashAppEnabled: action.enabled,
  );
}

PaymentRequestInfoPageState _saveApplePayState(PaymentRequestInfoPageState previousState, SaveApplePayStateAction action){
  return previousState.copyWith(
    applePayEnabled: action.enabled,
  );
}

PaymentRequestInfoPageState _saveCashState(PaymentRequestInfoPageState previousState, SaveCashStateAction action){
  return previousState.copyWith(
    cashEnabled: action.enabled,
  );
}

PaymentRequestInfoPageState _saveOtherState(PaymentRequestInfoPageState previousState, SaveOtherStateAction action){
  return previousState.copyWith(
    otherEnabled: action.enabled,
  );
}

PaymentRequestInfoPageState _saveWireState(PaymentRequestInfoPageState previousState, SaveWireStateAction action){
  return previousState.copyWith(
    wireEnabled: action.enabled,
  );
}