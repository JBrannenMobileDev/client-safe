import 'PaymentRequestInfoPageState.dart';

class SaveZelleStateAction{
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  SaveZelleStateAction(this.pageState, this.enabled);
}

class UpdateProfileWithZelleStateAction {
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  UpdateProfileWithZelleStateAction(this.pageState, this.enabled);
}

class UpdateProfileWithVenmoStateAction {
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  UpdateProfileWithVenmoStateAction(this.pageState, this.enabled);
}

class UpdateProfileWithCashAppStateAction {
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  UpdateProfileWithCashAppStateAction(this.pageState, this.enabled);
}

class UpdateProfileWithApplePayStateAction {
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  UpdateProfileWithApplePayStateAction(this.pageState, this.enabled);
}

class UpdateProfileWithCashStateAction {
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  UpdateProfileWithCashStateAction(this.pageState, this.enabled);
}

class UpdateProfileWithOtherStateAction {
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  UpdateProfileWithOtherStateAction(this.pageState, this.enabled);
}

class UpdateProfileWithWireStateAction {
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  UpdateProfileWithWireStateAction(this.pageState, this.enabled);
}

class LoadPaymentSettingsFromProfile{
  final PaymentRequestInfoPageState? pageState;
  LoadPaymentSettingsFromProfile(this.pageState);
}

class SaveVenmoStateAction{
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  SaveVenmoStateAction(this.pageState, this.enabled);
}

class SaveCashAppStateAction{
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  SaveCashAppStateAction(this.pageState, this.enabled);
}

class SaveOtherStateAction{
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  SaveOtherStateAction(this.pageState, this.enabled);
}

class SaveWireStateAction{
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  SaveWireStateAction(this.pageState, this.enabled);
}

class SaveApplePayStateAction{
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  SaveApplePayStateAction(this.pageState, this.enabled);
}

class SaveCashStateAction{
  final PaymentRequestInfoPageState? pageState;
  final bool? enabled;
  SaveCashStateAction(this.pageState, this.enabled);
}

class SetZellePhoneEmailTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetZellePhoneEmailTextAction(this.pageState, this.input);
}

class SetOtherTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetOtherTextAction(this.pageState, this.input);
}

class SetWireTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetWireTextAction(this.pageState, this.input);
}

class SetCashTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetCashTextAction(this.pageState, this.input);
}

class SetZelleFullNameTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetZelleFullNameTextAction(this.pageState, this.input);
}

class SetVenmoLinkTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetVenmoLinkTextAction(this.pageState, this.input);
}

class SetCashAppLinkTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetCashAppLinkTextAction(this.pageState, this.input);
}

class SetApplePayPhoneTextAction{
  final PaymentRequestInfoPageState? pageState;
  final String? input;
  SetApplePayPhoneTextAction(this.pageState, this.input);
}

class SaveZellePhoneEmailInput{
  final PaymentRequestInfoPageState? pageState;
  SaveZellePhoneEmailInput(this.pageState);
}

class SaveZelleFullNameInput{
  final PaymentRequestInfoPageState? pageState;
  SaveZelleFullNameInput(this.pageState);
}

class SaveVenmoInput{
  final PaymentRequestInfoPageState? pageState;
  SaveVenmoInput(this.pageState);
}

class SaveCashAppInput{
  final PaymentRequestInfoPageState? pageState;
  SaveCashAppInput(this.pageState);
}

class SaveOtherInput{
  final PaymentRequestInfoPageState? pageState;
  SaveOtherInput(this.pageState);
}

class SaveWireInput{
  final PaymentRequestInfoPageState? pageState;
  SaveWireInput(this.pageState);
}

class SaveCashInput{
  final PaymentRequestInfoPageState? pageState;
  SaveCashInput(this.pageState);
}

class SaveApplePayInput{
  final PaymentRequestInfoPageState? pageState;
  SaveApplePayInput(this.pageState);
}
