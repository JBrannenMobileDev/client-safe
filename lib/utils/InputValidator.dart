class InputValidator {
  static const String login_invalid_password_error_msg = "Include 8 or more characters, 1 upper case, 1 lowercase, 1 number and one special character (!@#\$%\^&\*)";

  static bool isValidEmailAddress(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  static bool isValidPasswordStrong(String password) {
    return RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})").hasMatch(password);
  }

  static bool isValidPasswordMedium(String password) {
    return RegExp(r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[0-9])))(?=.{8,})").hasMatch(password);
  }
}
