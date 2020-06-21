import 'package:dandylight/models/Action.dart';
import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/models/Notifications.dart';
import 'package:dandylight/pages/client_details_page/ClientDetailsPageActions.dart';
import 'package:dandylight/pages/dashboard_page/DashboardPageActions.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsActions.dart';
import 'package:dandylight/pages/new_contact_pages/NewContactPageActions.dart';
import 'package:redux/redux.dart';
import '../../AppState.dart';
import 'LoginPageActions.dart';

class LoginPageState {
  final String firstName;
  final String lastName;
  final String businessName;
  final String emailAddress;
  final String password;
  final Function(String) onFirstNameChanged;
  final Function(String) onLastNameChanged;
  final Function(String) onBusinessNameChanged;
  final Function(String) onEmailAddressNameChanged;
  final Function(String) onPasswordChanged;
  final Function() onCreateAccountSubmitted;
  final Function() onContinueWithGoogleSubmitted;
  final Function() onLoginSelected;
  final Function() onForgotPasswordSelected;

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
  });

  LoginPageState copyWith({
  String firstName,
  String lastName,
  String businessName,
  String emailAddress,
  String password,
  Function(String) onFirstNameChanged,
  Function(String) onLastNameChanged,
  Function(String) onBusinessNameChanged,
  Function(String) onEmailAddressNameChanged,
  Function(String) onPasswordChanged,
  Function() onCreateAccountSubmitted,
  Function() onContinueWithGoogleSubmitted,
  Function() onLoginSelected,
  Function() onForgotPasswordSelected,
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
    );
  }

  static LoginPageState fromStore(Store<AppState> store) {
    return LoginPageState(
      firstName: store.state.loginPageState.firstName,
      lastName: store.state.loginPageState.lastName,
      businessName: store.state.loginPageState.businessName,
      emailAddress: store.state.loginPageState.emailAddress,
      password: store.state.loginPageState.password,
      onFirstNameChanged: (firstName) => store.dispatch(UpdateFirstNameAction(store.state.loginPageState, firstName)),
      onLastNameChanged: (lastName) => store.dispatch(UpdateLastNameAction(store.state.loginPageState, lastName)),
      onBusinessNameChanged: (businessName) => store.dispatch(UpdateBusinessNameAction(store.state.loginPageState, businessName)),
      onEmailAddressNameChanged: (email) => store.dispatch(UpdateEmailAddressAction(store.state.loginPageState, email)),
      onPasswordChanged: (password) => store.dispatch(UpdatePasswordAction(store.state.loginPageState, password)),
      onCreateAccountSubmitted: () => store.dispatch(CreateAccountAction(store.state.loginPageState)),
      onContinueWithGoogleSubmitted: () => store.dispatch(ContinueWithGoogleAction(store.state.loginPageState)),
      onLoginSelected: () => store.dispatch(LoginAction(store.state.loginPageState)),
      onForgotPasswordSelected: () => store.dispatch(ForgotPasswordSelectedAction(store.state.loginPageState)),
    );
  }

  factory LoginPageState.initial() => LoginPageState(
    firstName: '',
    lastName: '',
    businessName: '',
    emailAddress: '',
    password: '',
    onFirstNameChanged: null,
    onLastNameChanged: null,
    onBusinessNameChanged: null,
    onEmailAddressNameChanged: null,
    onPasswordChanged: null,
    onCreateAccountSubmitted: null,
    onContinueWithGoogleSubmitted: null,
    onLoginSelected: null,
    onForgotPasswordSelected: null,
  );

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      businessName.hashCode ^
      emailAddress.hashCode ^
      password.hashCode ^
      onFirstNameChanged.hashCode ^
      onLastNameChanged.hashCode ^
      onBusinessNameChanged.hashCode ^
      onEmailAddressNameChanged.hashCode ^
      onPasswordChanged.hashCode ^
      onCreateAccountSubmitted.hashCode ^
      onContinueWithGoogleSubmitted.hashCode ^
      onLoginSelected.hashCode ^
      onForgotPasswordSelected.hashCode ;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoginPageState &&
              firstName == other.firstName &&
              lastName == other.lastName &&
              businessName == other.businessName &&
              emailAddress == other.emailAddress &&
              password == other.password &&
              onFirstNameChanged == other.onFirstNameChanged &&
              onLastNameChanged == other.onLastNameChanged &&
              onBusinessNameChanged == other.onBusinessNameChanged &&
              onEmailAddressNameChanged == other.onEmailAddressNameChanged &&
              onPasswordChanged == other.onPasswordChanged &&
              onCreateAccountSubmitted == other.onCreateAccountSubmitted &&
              onContinueWithGoogleSubmitted == other.onContinueWithGoogleSubmitted &&
              onLoginSelected == other.onLoginSelected &&
              onForgotPasswordSelected == other.onForgotPasswordSelected;
}
