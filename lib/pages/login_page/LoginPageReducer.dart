import 'package:dandylight/pages/login_page/ShowAccountCreatedDialog.dart';
import 'package:redux/redux.dart';
import 'LoginPageActions.dart';
import 'LoginPageState.dart';

final loginPageReducer = combineReducers<LoginPageState>([
  TypedReducer<LoginPageState, UpdateFirstNameAction>(_updateFirstName),
  TypedReducer<LoginPageState, UpdateLastNameAction>(_updateLastName),
  TypedReducer<LoginPageState, UpdateBusinessNameAction>(_updateBusinessName),
  TypedReducer<LoginPageState, UpdateEmailAddressAction>(_updateEmailAddress),
  TypedReducer<LoginPageState, UpdatePasswordAction>(_updatePassword),
  TypedReducer<LoginPageState, UpdateMainButtonsVisibleAction>(_updateMainButtonVisibility),
  TypedReducer<LoginPageState, UpdateShowResendMessageAction>(_updateShowResendMessage),
  TypedReducer<LoginPageState, UpdateNavigateToHomeAction>(_updateNavigateToHome),
  TypedReducer<LoginPageState, SetSignInErrorMessageAction>(_setSignInError),
  TypedReducer<LoginPageState, SetCreateAccountErrorMessageAction>(_setCreateAccountError),
  TypedReducer<LoginPageState, ClearErrorMessagesAction>(_clearErrorMessages),
  TypedReducer<LoginPageState, SetShowAccountCreatedDialogAction>(_setShowAccountCreatedDialogAction),
  TypedReducer<LoginPageState, ClearShowAccountCreatedDialogFlagAction>(_resetShowAccountCreatedDialogFlag),
]);

LoginPageState _resetShowAccountCreatedDialogFlag(LoginPageState previousState, ClearShowAccountCreatedDialogFlagAction action) {
  return previousState.copyWith(
    shouldShowAccountCreatedDialog: false,
    user: null,
    mainButtonsVisible: false,
  );
}

LoginPageState _setShowAccountCreatedDialogAction(LoginPageState previousState, SetShowAccountCreatedDialogAction action) {
  return previousState.copyWith(
    shouldShowAccountCreatedDialog: action.showAccountCreatedDialog,
    user: action.user,
  );
}

LoginPageState _clearErrorMessages(LoginPageState previousState, ClearErrorMessagesAction action) {
  return previousState.copyWith(
    loginErrorMessage: '',
  );
}

LoginPageState _setSignInError(LoginPageState previousState, SetSignInErrorMessageAction action) {
  return previousState.copyWith(
    loginErrorMessage: action.errorMessage,
  );
}

LoginPageState _setCreateAccountError(LoginPageState previousState, SetCreateAccountErrorMessageAction action) {
  return previousState.copyWith(
    createAccountErrorMessage: action.errorMessage,
  );
}

LoginPageState _updateNavigateToHome(LoginPageState previousState, UpdateNavigateToHomeAction action) {
  return previousState.copyWith(
    navigateToHome: action.navigateToHome,
  );
}

LoginPageState _updateMainButtonVisibility(LoginPageState previousState, UpdateMainButtonsVisibleAction action) {
  return previousState.copyWith(
    mainButtonsVisible: action.mainButtonsVisible,
  );
}

LoginPageState _updateShowResendMessage(LoginPageState previousState, UpdateShowResendMessageAction action) {
  return previousState.copyWith(
    showResendMessage: action.showResendMessage,
  );
}

LoginPageState _updateFirstName(LoginPageState previousState, UpdateFirstNameAction action) {
  return previousState.copyWith(
      firstName: action.firstName,
  );
}

LoginPageState _updateLastName(LoginPageState previousState, UpdateLastNameAction action) {
  return previousState.copyWith(
    lastName: action.lastName,
  );
}

LoginPageState _updateBusinessName(LoginPageState previousState, UpdateBusinessNameAction action) {
  return previousState.copyWith(
    businessName: action.businessName,
  );
}

LoginPageState _updateEmailAddress(LoginPageState previousState, UpdateEmailAddressAction action) {
  return previousState.copyWith(
    emailAddress: action.emailAddress,
  );
}

LoginPageState _updatePassword(LoginPageState previousState, UpdatePasswordAction action) {
  return previousState.copyWith(
    password: action.password,
  );
}
