class InputValidatorUtil{
  static bool isEmailValid(String email){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid || email.isEmpty;
  }

  static bool isPhoneNumberValid(String phoneNumber){
    return phoneNumber.length == 14 || phoneNumber.length == 16 || phoneNumber.isEmpty;
  }

  static bool isInstagramUrlValid(String instagramUrl){
    return instagramUrl.contains('https://instagram.com/') || instagramUrl.isEmpty;
  }
}