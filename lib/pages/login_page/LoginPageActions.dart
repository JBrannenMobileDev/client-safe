import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/login_page/LoginPageState.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UpdateFirstNameAction{
  final LoginPageState item;
  final String firstName;
  UpdateFirstNameAction(this.item, this.firstName);
}

class UpdateLastNameAction{
  final LoginPageState item;
  final String lastName;
  UpdateLastNameAction(this.item, this.lastName);
}

class UpdateBusinessNameAction{
  final LoginPageState pageState;
  final String businessName;
  UpdateBusinessNameAction(this.pageState, this.businessName);
}

class UpdateEmailAddressAction{
  final LoginPageState pageState;
  final String emailAddress;
  UpdateEmailAddressAction(this.pageState, this.emailAddress);
}

class UpdatePasswordAction{
  final LoginPageState pageState;
  final String password;
  UpdatePasswordAction(this.pageState, this.password);
}

class CreateAccountAction{
  final LoginPageState pageState;
  CreateAccountAction(this.pageState);
}

class ContinueWithGoogleAction{
  final LoginPageState pageState;
  ContinueWithGoogleAction(this.pageState);
}

class LoginAction{
  final LoginPageState pageState;
  LoginAction(this.pageState);
}

class ForgotPasswordSelectedAction{
  final LoginPageState pageState;
  ForgotPasswordSelectedAction(this.pageState);
}

class CheckForCurrentUserAction{
  final LoginPageState pageState;
  CheckForCurrentUserAction(this.pageState);
}

class ResendEmailVerificationAction{
  final LoginPageState pageState;
  ResendEmailVerificationAction(this.pageState);
}

class UpdateMainButtonsVisibleAction{
  final LoginPageState pageState;
  final bool mainButtonsVisible;
  UpdateMainButtonsVisibleAction(this.pageState, this.mainButtonsVisible);
}

class UpdateShowResendMessageAction{
  final LoginPageState pageState;
  final bool showResendMessage;
  UpdateShowResendMessageAction(this.pageState, this.showResendMessage);
}

class UpdateNavigateToHomeAction{
  final LoginPageState pageState;
  final bool navigateToHome;
  UpdateNavigateToHomeAction(this.pageState, this.navigateToHome);
}

class SetSignInErrorMessageAction{
  final LoginPageState pageState;
  final String errorMessage;
  SetSignInErrorMessageAction(this.pageState, this.errorMessage);
}

class SetCreateAccountErrorMessageAction{
  final LoginPageState pageState;
  final String errorMessage;
  SetCreateAccountErrorMessageAction(this.pageState, this.errorMessage);
}

class SetShowAccountCreatedDialogAction{
  final LoginPageState pageState;
  final bool showAccountCreatedDialog;
  final FirebaseUser user;
  SetShowAccountCreatedDialogAction(this.pageState, this.showAccountCreatedDialog, this.user);
}

class ClearErrorMessagesAction{
  final LoginPageState pageState;
  ClearErrorMessagesAction(this.pageState);
}

class ClearShowAccountCreatedDialogFlagAction{
  final LoginPageState pageState;
  ClearShowAccountCreatedDialogFlagAction(this.pageState);
}