import 'package:dandylight/models/Client.dart';
import 'package:dandylight/models/Job.dart';
import 'package:dandylight/utils/JobUtil.dart';
import 'package:redux/redux.dart';

import 'LoginPageActions.dart';
import 'LoginPageState.dart';

final loginPageReducer = combineReducers<LoginPageState>([
  TypedReducer<LoginPageState, UpdateFirstNameAction>(_updateFirstName),
  TypedReducer<LoginPageState, UpdateLastNameAction>(_updateLastName),
  TypedReducer<LoginPageState, UpdateBusinessNameAction>(_updateBusinessName),
  TypedReducer<LoginPageState, UpdateEmailAddressAction>(_updateEmailAddress),
  TypedReducer<LoginPageState, UpdatePasswordAction>(_updatePassword),
]);

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
