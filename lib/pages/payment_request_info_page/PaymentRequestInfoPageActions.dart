import 'PaymentRequestInfoPageState.dart';

class SaveZelleStateAction{
  final PaymentRequestInfoPageState pageState;
  final bool enabled;
  SaveZelleStateAction(this.pageState, this.enabled);
}

class LoadPaymentSettingsFromProfile{
  final PaymentRequestInfoPageState pageState;
  LoadPaymentSettingsFromProfile(this.pageState);
}

class SaveVenmoStateAction{
  final PaymentRequestInfoPageState pageState;
  final bool enabled;
  SaveVenmoStateAction(this.pageState, this.enabled);
}

class SaveCashAppStateAction{
  final PaymentRequestInfoPageState pageState;
  final bool enabled;
  SaveCashAppStateAction(this.pageState, this.enabled);
}

class SaveApplePayStateAction{
  final PaymentRequestInfoPageState pageState;
  final bool enabled;
  SaveApplePayStateAction(this.pageState, this.enabled);
}

class SetZellePhoneEmailTextAction{
  final PaymentRequestInfoPageState pageState;
  final String input;
  SetZellePhoneEmailTextAction(this.pageState, this.input);
}

class SetZelleFullNameTextAction{
  final PaymentRequestInfoPageState pageState;
  final String input;
  SetZelleFullNameTextAction(this.pageState, this.input);
}

class SetVenmoLinkTextAction{
  final PaymentRequestInfoPageState pageState;
  final String input;
  SetVenmoLinkTextAction(this.pageState, this.input);
}

class SetCashAppLinkTextAction{
  final PaymentRequestInfoPageState pageState;
  final String input;
  SetCashAppLinkTextAction(this.pageState, this.input);
}

class SetApplePayPhoneTextAction{
  final PaymentRequestInfoPageState pageState;
  final String input;
  SetApplePayPhoneTextAction(this.pageState, this.input);
}

class SaveZellePhoneEmailInput{
  final PaymentRequestInfoPageState pageState;
  SaveZellePhoneEmailInput(this.pageState);
}

class SaveZelleFullNameInput{
  final PaymentRequestInfoPageState pageState;
  SaveZelleFullNameInput(this.pageState);
}

class SaveVenmoInput{
  final PaymentRequestInfoPageState pageState;
  SaveVenmoInput(this.pageState);
}

class SaveCashAppInput{
  final PaymentRequestInfoPageState pageState;
  SaveCashAppInput(this.pageState);
}

class SaveApplePayInput{
  final PaymentRequestInfoPageState pageState;
  SaveApplePayInput(this.pageState);
}
