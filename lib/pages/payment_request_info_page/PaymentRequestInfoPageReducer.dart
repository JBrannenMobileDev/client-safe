import 'package:dandylight/pages/payment_request_info_page/PaymentRequestInfoPageState.dart';
import 'package:redux/redux.dart';

import 'PaymentRequestInfoPageActions.dart';

final paymentRequestInfoPageReducer = combineReducers<PaymentRequestInfoPageState>([
  TypedReducer<PaymentRequestInfoPageState, SaveZelleStateAction>(_saveZelleState),
  TypedReducer<PaymentRequestInfoPageState, SaveVenmoStateAction>(_saveVenmoState),
  TypedReducer<PaymentRequestInfoPageState, SaveCashAppStateAction>(_saveCashAppState),
  TypedReducer<PaymentRequestInfoPageState, SaveApplePayStateAction>(_saveApplePayState),
  TypedReducer<PaymentRequestInfoPageState, SaveCashStateAction>(_saveCashState),
  TypedReducer<PaymentRequestInfoPageState, SetZellePhoneEmailTextAction>(_setZellePhoneEmailText),
  TypedReducer<PaymentRequestInfoPageState, SetZelleFullNameTextAction>(_setZelleFullNameText),
  TypedReducer<PaymentRequestInfoPageState, SetVenmoLinkTextAction>(_setVenmoLinkText),
  TypedReducer<PaymentRequestInfoPageState, SetCashAppLinkTextAction>(_setCashAppLinkText),
  TypedReducer<PaymentRequestInfoPageState, SetApplePayPhoneTextAction>(_setApplePayPhoneText),
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