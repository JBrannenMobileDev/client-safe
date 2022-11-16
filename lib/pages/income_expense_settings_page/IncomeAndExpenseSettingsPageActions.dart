import 'IncomeAndExpenseSettingsPageState.dart';

class SaveZelleStateAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final bool enabled;
  SaveZelleStateAction(this.pageState, this.enabled);
}

class LoadPaymentSettingsFromProfile{
  final IncomeAndExpenseSettingsPageState pageState;
  LoadPaymentSettingsFromProfile(this.pageState);
}

class SaveVenmoStateAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final bool enabled;
  SaveVenmoStateAction(this.pageState, this.enabled);
}

class SaveCashAppStateAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final bool enabled;
  SaveCashAppStateAction(this.pageState, this.enabled);
}

class SaveApplePayStateAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final bool enabled;
  SaveApplePayStateAction(this.pageState, this.enabled);
}

class SetZellePhoneEmailTextAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final String input;
  SetZellePhoneEmailTextAction(this.pageState, this.input);
}

class SetZelleFullNameTextAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final String input;
  SetZelleFullNameTextAction(this.pageState, this.input);
}

class SetVenmoLinkTextAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final String input;
  SetVenmoLinkTextAction(this.pageState, this.input);
}

class SetCashAppLinkTextAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final String input;
  SetCashAppLinkTextAction(this.pageState, this.input);
}

class SetApplePayPhoneTextAction{
  final IncomeAndExpenseSettingsPageState pageState;
  final String input;
  SetApplePayPhoneTextAction(this.pageState, this.input);
}

class SaveZellePhoneEmailInput{
  final IncomeAndExpenseSettingsPageState pageState;
  SaveZellePhoneEmailInput(this.pageState);
}

class SaveZelleFullNameInput{
  final IncomeAndExpenseSettingsPageState pageState;
  SaveZelleFullNameInput(this.pageState);
}

class SaveVenmoInput{
  final IncomeAndExpenseSettingsPageState pageState;
  SaveVenmoInput(this.pageState);
}

class SaveCashAppInput{
  final IncomeAndExpenseSettingsPageState pageState;
  SaveCashAppInput(this.pageState);
}

class SaveApplePayInput{
  final IncomeAndExpenseSettingsPageState pageState;
  SaveApplePayInput(this.pageState);
}