import 'package:intl/intl.dart';

class TextFormatterUtil {
  static String formatCurrency(int value){
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(value);
  }

  static String formatSimpleCurrency(int value){
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    return formatter.format(value);
  }

  static String formatLargeNumber(double value){
    final formatter = NumberFormat('#,##,###.##');
    return formatter.format(value);
  }

  static String formatLargeNumberOneDecimal(double value){
    final formatter = NumberFormat('#,##,###.#');
    return formatter.format(value);
  }

  static String formatSimpleCurrencyNoNumberSign(double value){
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);
    return formatter.format(value);
  }

  static String formatDecimalCurrency(double value){
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }

  static String formatDecimalCurrencyFromString(String value){
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(double.parse(value));
  }

  static String formatDecimalDigitsCurrency(double value, int digits){
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: digits);
    return formatter.format(value);
  }

  static String formatDateStandard(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatPhoneOrEmail(String textToFormat) {
    if(textToFormat == null) return "";
    String numsOnly = textToFormat.replaceAll(RegExp('[^0-9]+'), "");
    bool isPhone = numsOnly.length == 10 || numsOnly.length == 11;
    bool isEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(textToFormat);
    if(isEmail) return textToFormat;
    if(isPhone) return formatPhoneNum(textToFormat);
    return textToFormat;
  }

  static bool isPhone(String input) {
    String numsOnly = input.replaceAll(RegExp('[^0-9]+'), "");
    return numsOnly.length == 10 || numsOnly.length == 11;
  }

  static bool isEmail(String input) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
  }

  static String formatPhoneNum(String phoneToFormat) {
    if(phoneToFormat == null) return "";
    String resultNum = "";
    String numsOnly = phoneToFormat.replaceAll(RegExp('[^0-9]+'), "");
    numsOnly = numsOnly.replaceAll(" ", "");

    if(numsOnly.length == 10){
      resultNum = "(" + numsOnly.substring(0, 3) + ") " + numsOnly.substring(3, 6) + "-" + numsOnly.substring(6, numsOnly.length);
    }else if(numsOnly.length == 11){
      resultNum = "+" + numsOnly.substring(0,1) + "(" + numsOnly.substring(1, 4) + ") " + numsOnly.substring(4, 7) + "-" + numsOnly.substring(7, numsOnly.length);
    }else{
      resultNum = numsOnly;
    }
    return resultNum;
  }
}