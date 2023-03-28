import 'package:dandylight/utils/analytics/EventNames.dart';
import 'package:dandylight/utils/analytics/EventSender.dart';
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
  TypedReducer<LoginPageState, UpdateForgotPasswordVisibleAction>(_updateForgotPasswordVisibility),
  TypedReducer<LoginPageState, UpdateShowResendMessageAction>(_updateShowResendMessage),
  TypedReducer<LoginPageState, UpdateNavigateToHomeAction>(_updateNavigateToHome),
  TypedReducer<LoginPageState, SetSignInErrorMessageAction>(_setSignInError),
  TypedReducer<LoginPageState, SetCreateAccountErrorMessageAction>(_setCreateAccountError),
  TypedReducer<LoginPageState, ClearErrorMessagesAction>(_clearErrorMessages),
  TypedReducer<LoginPageState, SetShowAccountCreatedDialogAction>(_setShowAccountCreatedDialogAction),
  TypedReducer<LoginPageState, SetResetPasswordSentDialogAction>(_setShowResetPasswordSentDialogAction),
  TypedReducer<LoginPageState, ClearShowAccountCreatedDialogFlagAction>(_resetShowAccountCreatedDialogFlag),
  TypedReducer<LoginPageState, ClearShowResetPasswordSentDialogFlagAction>(_resetShowResetPasswordSentDialogFlag),
  TypedReducer<LoginPageState, UpdateShowCreateAccountAnimation>(_updateShowCreateAccountAnimation),
  TypedReducer<LoginPageState, UpdateShowLoginAnimation>(_updateShowLoginAnimation),
  TypedReducer<LoginPageState, UpdateLoginEmailAction>(_updateLoginEmail),
  TypedReducer<LoginPageState, UpdateLoginPasswordAction>(_updateLoginPassword),
  TypedReducer<LoginPageState, AnimateLoginErrorMessageAction>(_animateLoginError),
  TypedReducer<LoginPageState, ClearLoginErrorShake>(_clearLoginShake),
  TypedReducer<LoginPageState, SetIsUserVerifiedAction>(_setIsVerified),
  TypedReducer<LoginPageState, ResetLoginState>(_resetState),
  TypedReducer<LoginPageState, SetCurrentUserCheckState>(_updateUserCheckStatus),
  TypedReducer<LoginPageState, SetIsLoginWithAppleAvailableAction>(_setIsAppleLoginAvailable),
  TypedReducer<LoginPageState, SetShowLoadingAnimationAction>(_setShowLoadingAnimation),
]);

LoginPageState _setShowLoadingAnimation(LoginPageState previousState, SetShowLoadingAnimationAction action) {
  return previousState.copyWith(
    showLoadingAnimation: action.show,
  );
}

LoginPageState _setIsAppleLoginAvailable(LoginPageState previousState, SetIsLoginWithAppleAvailableAction action) {
  return previousState.copyWith(
    isLoginWithAppleAvailable: action.isAppleLoginAvailable,
  );
}

LoginPageState _updateUserCheckStatus(LoginPageState previousState, SetCurrentUserCheckState action) {
  return previousState.copyWith(
    isCurrentUserCheckComplete: action.isUserCheckFinished,
  );
}

LoginPageState _resetState(LoginPageState previousState, ResetLoginState action) {
  return LoginPageState.initial();
}

LoginPageState _setIsVerified(LoginPageState previousState, SetIsUserVerifiedAction action) {
  return previousState.copyWith(
    isUserVerified: action.isVerified,
  );
}

LoginPageState _clearLoginShake(LoginPageState previousState, ClearLoginErrorShake action) {
  return previousState.copyWith(
    showLoginErrorAnimation: false,
  );
}

LoginPageState _animateLoginError(LoginPageState previousState, AnimateLoginErrorMessageAction action) {
  return previousState.copyWith(
    showLoginErrorAnimation: action.show,
  );
}

LoginPageState _updateLoginEmail(LoginPageState previousState, UpdateLoginEmailAction action) {
  return previousState.copyWith(
    emailAddress: action.email,
  );
}

LoginPageState _updateLoginPassword(LoginPageState previousState, UpdateLoginPasswordAction action) {
  return previousState.copyWith(
    password: action.password,
  );
}

LoginPageState _updateShowLoginAnimation(LoginPageState previousState, UpdateShowLoginAnimation action) {
  return previousState.copyWith(
    showLoginLoadingAnimation: action.show,
  );
}

LoginPageState _updateShowCreateAccountAnimation(LoginPageState previousState, UpdateShowCreateAccountAnimation action) {
  return previousState.copyWith(
    showCreateAccountLoadingAnimation: action.show,
  );
}

LoginPageState _resetShowAccountCreatedDialogFlag(LoginPageState previousState, ClearShowAccountCreatedDialogFlagAction action) {
  return previousState.copyWith(
    shouldShowAccountCreatedDialog: false,
    mainButtonsVisible: false,
  );
}

LoginPageState _resetShowResetPasswordSentDialogFlag(LoginPageState previousState, ClearShowResetPasswordSentDialogFlagAction action) {
  return previousState.copyWith(
    shouldShowResetPasswordSentDialog: false,
  );
}

LoginPageState _setShowAccountCreatedDialogAction(LoginPageState previousState, SetShowAccountCreatedDialogAction action) {
  return previousState.copyWith(
    shouldShowAccountCreatedDialog: action.showAccountCreatedDialog,
    user: action.user,
    showCreateAccountLoadingAnimation: false,
    showResendMessage: false,
  );
}

LoginPageState _setShowResetPasswordSentDialogAction(LoginPageState previousState, SetResetPasswordSentDialogAction action) {
  return previousState.copyWith(
    shouldShowResetPasswordSentDialog: action.showResetPasswordSentDialog,
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
    showCreateAccountLoadingAnimation: false,
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

LoginPageState _updateForgotPasswordVisibility(LoginPageState previousState, UpdateForgotPasswordVisibleAction action) {
  return previousState.copyWith(
    isForgotPasswordViewVisible: action.forgotPasswordViewVisible,
  );
}

LoginPageState _updateShowResendMessage(LoginPageState previousState, UpdateShowResendMessageAction action) {
  return previousState.copyWith(
    showResendMessage: action.showResendMessage,
  );
}

LoginPageState _updateFirstName(LoginPageState previousState, UpdateFirstNameAction action) {
  if(previousState.firstName.isEmpty && action.firstName.isNotEmpty) {
    EventSender().sendEvent(eventName: EventNames.FIRST_NAME_ENTERED);
  }
  return previousState.copyWith(
      firstName: action.firstName,
  );
}

LoginPageState _updateLastName(LoginPageState previousState, UpdateLastNameAction action) {
  if(previousState.lastName.isEmpty && action.lastName.isNotEmpty) {
    EventSender().sendEvent(eventName: EventNames.LAST_NAME_ENTERED);
  }
  return previousState.copyWith(
    lastName: action.lastName,
  );
}

LoginPageState _updateBusinessName(LoginPageState previousState, UpdateBusinessNameAction action) {
  if(previousState.businessName.isEmpty && action.businessName.isNotEmpty) {
    EventSender().sendEvent(eventName: EventNames.BUSINESS_NAME_ENTERED);
  }
  return previousState.copyWith(
    businessName: action.businessName,
  );
}

LoginPageState _updateEmailAddress(LoginPageState previousState, UpdateEmailAddressAction action) {
  if(previousState.emailAddress.isEmpty && action.emailAddress.isNotEmpty) {
    EventSender().sendEvent(eventName: EventNames.EMAIL_ENTERED);
  }
  return previousState.copyWith(
    emailAddress: action.emailAddress,
  );
}

LoginPageState _updatePassword(LoginPageState previousState, UpdatePasswordAction action) {
  if(previousState.password.isEmpty && action.password.isNotEmpty) {
    EventSender().sendEvent(eventName: EventNames.PASSWORD_ENTERED);
  }
  return previousState.copyWith(
    password: action.password,
  );
}
