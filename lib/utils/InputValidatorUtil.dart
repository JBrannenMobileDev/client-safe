class InputValidatorUtil{
  static bool isEmailValid(String email){
    return email.contains('@') || email.isEmpty;
  }

  static bool isPhoneNumberValid(String phoneNumber){
    return phoneNumber.length == 10 || phoneNumber.length == 11 || phoneNumber.isEmpty;
  }

  static bool isInstagramUrlValid(String instagramUrl){
    return instagramUrl.contains('https://instagram.com/') || instagramUrl.isEmpty;
  }
}