import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/pages/login_page/LoginPageState.dart';


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