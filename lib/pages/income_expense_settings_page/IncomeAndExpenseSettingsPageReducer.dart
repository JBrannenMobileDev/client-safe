import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:redux/redux.dart';

import '../../utils/analytics/EventNames.dart';
import '../../utils/analytics/EventSender.dart';
import 'IncomeAndExpenseSettingsPageActions.dart';

final incomeAndExpenseSettingsPageReducer = combineReducers<IncomeAndExpenseSettingsPageState>([
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveZelleStateAction>(_saveZelleState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveVenmoStateAction>(_saveVenmoState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveCashAppStateAction>(_saveCashAppState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SaveApplePayStateAction>(_saveApplePayState),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetZellePhoneEmailTextAction>(_setZellePhoneEmailText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetZelleFullNameTextAction>(_setZelleFullNameText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetVenmoLinkTextAction>(_setVenmoLinkText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetCashAppLinkTextAction>(_setCashAppLinkText),
  TypedReducer<IncomeAndExpenseSettingsPageState, SetApplePayPhoneTextAction>(_setApplePayPhoneText),
]);

IncomeAndExpenseSettingsPageState _setZellePhoneEmailText(IncomeAndExpenseSettingsPageState previousState, SetZellePhoneEmailTextAction action){
  return previousState.copyWith(
    zellePhoneEmail: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setZelleFullNameText(IncomeAndExpenseSettingsPageState previousState, SetZelleFullNameTextAction action){
  return previousState.copyWith(
    zelleFullName: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setVenmoLinkText(IncomeAndExpenseSettingsPageState previousState, SetVenmoLinkTextAction action){
  return previousState.copyWith(
    venmoLink: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setCashAppLinkText(IncomeAndExpenseSettingsPageState previousState, SetCashAppLinkTextAction action){
  return previousState.copyWith(
    cashAppLink: action.input,
  );
}

IncomeAndExpenseSettingsPageState _setApplePayPhoneText(IncomeAndExpenseSettingsPageState previousState, SetApplePayPhoneTextAction action){
  return previousState.copyWith(
    applePayPhone: action.input,
  );
}

IncomeAndExpenseSettingsPageState _saveZelleState(IncomeAndExpenseSettingsPageState previousState, SaveZelleStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Zelle",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled,
  });
  return previousState.copyWith(
    zelleEnabled: action.enabled,
  );
}

IncomeAndExpenseSettingsPageState _saveVenmoState(IncomeAndExpenseSettingsPageState previousState, SaveVenmoStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Venmo",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled,
  });
  return previousState.copyWith(
    venmoEnabled: action.enabled,
  );
}

IncomeAndExpenseSettingsPageState _saveCashAppState(IncomeAndExpenseSettingsPageState previousState, SaveCashAppStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Cash App",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled,
  });
  return previousState.copyWith(
    cashAppEnabled: action.enabled,
  );
}

IncomeAndExpenseSettingsPageState _saveApplePayState(IncomeAndExpenseSettingsPageState previousState, SaveApplePayStateAction action){
  EventSender().sendEvent(eventName: EventNames.PAYMENT_LINK_ADDED, properties: {
    EventNames.LINK_ADDED_PARAM_NAME : "Apple Pay",
    EventNames.LINK_ADDED_PARAM_ENABLED : action.enabled,
  });
  return previousState.copyWith(
    applePayEnabled: action.enabled,
  );
}