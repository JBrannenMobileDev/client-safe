import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'LoginPageActions.dart';

class LoginPageState {
  final String firstName;
  final String lastName;
  final String businessName;
  final String emailAddress;
  final String password;
  final String loginErrorMessage;
  final String createAccountErrorMessage;
  final bool mainButtonsVisible;
  final bool showResendMessage;
  final bool navigateToHome;
  final bool shouldShowAccountCreatedDialog;
  final bool showCreateAccountLoadingAnimation;
  final bool showLoginLoadingAnimation;
  final bool showLoginErrorAnimation;
  final bool isUserVerified;
  final FirebaseUser user;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onBusinessNameChanged;
  final Function(String) onEmailAddressNameChanged;
  final Function(String) onPasswordChanged;
  final Function() onCreateAccountSubmitted;
  final Function() onContinueWithGoogleSubmitted;
  final Function() onLoginSelected;
  final Function() onForgotPasswordSelected;
  final Function() onResendEmailVerificationSelected;
  final Function(bool) updateMainButtonVisible;
  final Function() onClearErrorMessages;
  final Function() resetShouldShowSuccessDialog;
  final Function(String) onLoginPasswordChanged;
  final Function(String) onLoginEmailChanged;
  final Function() onClearLoginErrorShake;

  LoginPageState({
    this.firstName,
    this.lastName,
    this.businessName,
    this.emailAddress,
    this.password,
    this.onFirstNameChanged,
    this.onLastNameChanged,
    this.onBusinessNameChanged,
    this.onEmailAddressNameChanged,
    this.onPasswordChanged,
    this.onCreateAccountSubmitted,
    this.onContinueWithGoogleSubmitted,
    this.onLoginSelected,
    this.onForgotPasswordSelected,
    this.onResendEmailVerificationSelected,
    this.mainButtonsVisible,
    this.showResendMessage,
    this.updateMainButtonVisible,
    this.navigateToHome,
    this.loginErrorMessage,
    this.createAccountErrorMessage,
    this.onClearErrorMessages,
    this.shouldShowAccountCreatedDialog,
    this.user,
    this.resetShouldShowSuccessDialog,
    this.showCreateAccountLoadingAnimation,
    this.showLoginLoadingAnimation,
    this.onLoginEmailChanged,
    this.onLoginPasswordChanged,
    this.showLoginErrorAnimation,
    this.onClearLoginErrorShake,
    this.isUserVerified,
  });

  LoginPageState copyWith({
    String firstName,
    String lastName,
    String businessName,
    String emailAddress,
    String password,
    String loginErrorMessage,
    String createAccountErrorMessage,
    bool mainButtonsVisible,
    bool showResendMessage,
    bool navigateToHome,
    bool shouldShowAccountCreatedDialog,
    bool showLoginErrorAnimation,
    FirebaseUser user,
    Function(String) onFirstNameChanged,
    Function(String) onLastNameChanged,
    Function(String) onBusinessNameChanged,
    Function(String) onEmailAddressNameChanged,
    Function(String) onPasswordChanged,
    Function() onCreateAccountSubmitted,
    Function() onContinueWithGoogleSubmitted,
    Function() onLoginSelected,
    Function() onForgotPasswordSelected,
    Function() onResendEmailVerificationSelected,
    Function(bool) updateMainButtonVisible,
    Function() onClearErrorMessages,
    Function() resetShouldShowSuccessDialog,
    bool showCreateAccountLoadingAnimation,
    bool showLoginLoadingAnimation,
    Function(String) onLoginEmailChanged,
    Function(String) onLoginPasswordChanged,
    Function() onClearLoginErrorShake,
    bool isUserVerified,
  }){
    return LoginPageState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName:  businessName ?? this.businessName,
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      onFirstNameChanged: onFirstNameChanged ?? this.onFirstNameChanged,
      onLastNameChanged: onLastNameChanged ?? this.onLastNameChanged,
      onBusinessNameChanged: onBusinessNameChanged ?? this.onBusinessNameChanged,
      onEmailAddressNameChanged: onEmailAddressNameChanged ?? this.onEmailAddressNameChanged,
      onPasswordChanged: onPasswordChanged ?? this.onPasswordChanged,
      onCreateAccountSubmitted: onCreateAccountSubmitted ?? this.onCreateAccountSubmitted,
      onContinueWithGoogleSubmitted: onContinueWithGoogleSubmitted ?? this.onContinueWithGoogleSubmitted,
      onLoginSelected: onLoginSelected ?? this.onLoginSelected,
      onForgotPasswordSelected: onForgotPasswordSelected ?? this.onForgotPasswordSelected,
      onResendEmailVerificationSelected: onResendEmailVerificationSelected ?? this.onResendEmailVerificationSelected,
      mainButtonsVisible: mainButtonsVisible ?? this.mainButtonsVisible,
      showResendMessage: showResendMessage ?? this.showResendMessage,
      updateMainButtonVisible: updateMainButtonVisible ?? this.updateMainButtonVisible,
      navigateToHome: navigateToHome ?? this.navigateToHome,
      loginErrorMessage: loginErrorMessage ?? this.loginErrorMessage,
      createAccountErrorMessage: createAccountErrorMessage ?? this.createAccountErrorMessage,
      onClearErrorMessages: onClearErrorMessages ?? this.onClearErrorMessages,
      shouldShowAccountCreatedDialog: shouldShowAccountCreatedDialog ?? this.shouldShowAccountCreatedDialog,
      user: user ?? this.user,
      resetShouldShowSuccessDialog: resetShouldShowSuccessDialog ?? this.resetShouldShowSuccessDialog,
      showCreateAccountLoadingAnimation: showCreateAccountLoadingAnimation ?? this.showCreateAccountLoadingAnimation,
      showLoginLoadingAnimation: showLoginLoadingAnimation ?? this.showLoginLoadingAnimation,
      onLoginEmailChanged: onLoginPasswordChanged ?? this.onLoginEmailChanged,
      onLoginPasswordChanged: onLoginPasswordChanged ?? this.onLoginPasswordChanged,
      showLoginErrorAnimation: showLoginErrorAnimation ?? this.showLoginErrorAnimation,
      onClearLoginErrorShake: onClearLoginErrorShake ?? this.onClearLoginErrorShake,
      isUserVerified: isUserVerified ?? this.isUserVerified,
    );
  }

  static LoginPageState fromStore(Store<AppState> store) {
    return LoginPageState(
      firstName: store.state.loginPageState.firstName,
      lastName: store.state.loginPageState.lastName,
      businessName: store.state.loginPageState.businessName,
      emailAddress: store.state.loginPageState.emailAddress,
      password: store.state.loginPageState.password,
      mainButtonsVisible: store.state.loginPageState.mainButtonsVisible,
      showResendMessage: store.state.loginPageState.showResendMessage,
      navigateToHome: store.state.loginPageState.navigateToHome,
      loginErrorMessage: store.state.loginPageState.loginErrorMessage,
      createAccountErrorMessage: store.state.loginPageState.createAccountErrorMessage,
      shouldShowAccountCreatedDialog: store.state.loginPageState.shouldShowAccountCreatedDialog,
      user: store.state.loginPageState.user,
      showCreateAccountLoadingAnimation: store.state.loginPageState.showCreateAccountLoadingAnimation,
      showLoginLoadingAnimation: store.state.loginPageState.showLoginLoadingAnimation,
      showLoginErrorAnimation: store.state.loginPageState.showLoginErrorAnimation,
      isUserVerified: store.state.loginPageState.isUserVerified,
      onFirstNameChanged: (firstName) => store.dispatch(UpdateFirstNameAction(store.state.loginPageState, firstName)),
      onLastNameChanged: (lastName) => store.dispatch(UpdateLastNameAction(store.state.loginPageState, lastName)),
      onBusinessNameChanged: (businessName) => store.dispatch(UpdateBusinessNameAction(store.state.loginPageState, businessName)),
      onEmailAddressNameChanged: (email) => store.dispatch(UpdateEmailAddressAction(store.state.loginPageState, email)),
      onPasswordChanged: (password) => store.dispatch(UpdatePasswordAction(store.state.loginPageState, password)),
      onCreateAccountSubmitted: () => store.dispatch(CreateAccountAction(store.state.loginPageState)),
      onContinueWithGoogleSubmitted: () => store.dispatch(ContinueWithGoogleAction(store.state.loginPageState)),
      onLoginSelected: () => store.dispatch(LoginAction(store.state.loginPageState)),
      onForgotPasswordSelected: () => store.dispatch(ForgotPasswordSelectedAction(store.state.loginPageState)),
      onResendEmailVerificationSelected: () {
        store.dispatch(ResendEmailVerificationAction(store.state.loginPageState));
        store.dispatch(UpdateShowResendMessageAction(store.state.loginPageState, false));
      },
      updateMainButtonVisible: (visible) => store.dispatch(UpdateMainButtonsVisibleAction(store.state.loginPageState, visible)),
      onClearErrorMessages: () => store.dispatch(ClearErrorMessagesAction(store.state.loginPageState)),
      resetShouldShowSuccessDialog: () => store.dispatch((ClearShowAccountCreatedDialogFlagAction(store.state.loginPageState))),
      onLoginEmailChanged: (email) => store.dispatch(UpdateLoginEmailAction(store.state.loginPageState, email)),
      onLoginPasswordChanged: (password) => store.dispatch(UpdateLoginPasswordAction(store.state.loginPageState, password)),
      onClearLoginErrorShake: () => store.dispatch(ClearLoginErrorShake(store.state.loginPageState)),
    );
  }

  factory LoginPageState.initial() => LoginPageState(
    firstName: '',
    lastName: '',
    businessName: '',
    emailAddress: '',
    password: '',
    isUserVerified: false,
    showLoginErrorAnimation: false,
    onLoginEmailChanged: null,
    onLoginPasswordChanged: null,
    navigateToHome: false,
    mainButtonsVisible: true,
    showResendMessage: false,
    onClearLoginErrorShake: null,
    onFirstNameChanged: null,
    onLastNameChanged: null,
    onBusinessNameChanged: null,
    onEmailAddressNameChanged: null,
    onPasswordChanged: null,
    shouldShowAccountCreatedDialog: false,
    onCreateAccountSubmitted: null,
    onContinueWithGoogleSubmitted: null,
    showCreateAccountLoadingAnimation: false,
    showLoginLoadingAnimation: false,
    onLoginSelected: null,
    user: null,
    resetShouldShowSuccessDialog: null,
    onForgotPasswordSelected: null,
    onResendEmailVerificationSelected: null,
    updateMainButtonVisible: null,
    loginErrorMessage:'',
    createAccountErrorMessage: '',
    onClearErrorMessages: null,
  );

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      onLoginPasswordChanged.hashCode ^
      onLoginEmailChanged.hashCode ^
      businessName.hashCode ^
      showLoginErrorAnimation.hashCode ^
      emailAddress.hashCode ^
      password.hashCode ^
      onClearErrorMessages.hashCode ^
      mainButtonsVisible.hashCode ^
      isUserVerified.hashCode ^
      showResendMessage.hashCode ^
      updateMainButtonVisible.hashCode ^
      onFirstNameChanged.hashCode ^
      onClearLoginErrorShake.hashCode ^
      showCreateAccountLoadingAnimation.hashCode ^
      showLoginLoadingAnimation.hashCode ^
      onLastNameChanged.hashCode ^
      onBusinessNameChanged.hashCode ^
      onEmailAddressNameChanged.hashCode ^
      onPasswordChanged.hashCode ^
      onCreateAccountSubmitted.hashCode ^
      onContinueWithGoogleSubmitted.hashCode ^
      onLoginSelected.hashCode ^
      onResendEmailVerificationSelected.hashCode ^
      navigateToHome.hashCode ^
      resetShouldShowSuccessDialog.hashCode ^
      loginErrorMessage.hashCode ^
      user.hashCode ^
      shouldShowAccountCreatedDialog.hashCode ^
      createAccountErrorMessage.hashCode ^
      onForgotPasswordSelected.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoginPageState &&
              isUserVerified == other.isUserVerified &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              businessName == other.businessName &&
              showCreateAccountLoadingAnimation == other.showCreateAccountLoadingAnimation &&
              showLoginLoadingAnimation == other.showLoginLoadingAnimation &&
              emailAddress == other.emailAddress &&
              password == other.password &&
              onClearLoginErrorShake == other.onClearLoginErrorShake &&
              onLoginPasswordChanged == other.onLoginPasswordChanged &&
              onLoginEmailChanged == other.onLoginEmailChanged &&
              mainButtonsVisible == other.mainButtonsVisible &&
              showResendMessage == other.showResendMessage &&
              onResendEmailVerificationSelected == other.onResendEmailVerificationSelected &&
              onFirstNameChanged == other.onFirstNameChanged &&
              onLastNameChanged == other.onLastNameChanged &&
              user == other.user &&
              showLoginErrorAnimation == other.showLoginErrorAnimation &&
              shouldShowAccountCreatedDialog == other.shouldShowAccountCreatedDialog &&
              onBusinessNameChanged == other.onBusinessNameChanged &&
              onEmailAddressNameChanged == other.onEmailAddressNameChanged &&
              onPasswordChanged == other.onPasswordChanged &&
              onCreateAccountSubmitted == other.onCreateAccountSubmitted &&
              onContinueWithGoogleSubmitted == other.onContinueWithGoogleSubmitted &&
              onLoginSelected == other.onLoginSelected &&
              navigateToHome == other.navigateToHome &&
              resetShouldShowSuccessDialog == other.resetShouldShowSuccessDialog &&
              loginErrorMessage == other.loginErrorMessage &&
              createAccountErrorMessage == other.createAccountErrorMessage &&
              updateMainButtonVisible == other.updateMainButtonVisible &&
              onClearErrorMessages == other.onClearErrorMessages &&
              onForgotPasswordSelected == other.onForgotPasswordSelected;
}
