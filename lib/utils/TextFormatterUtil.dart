import 'package:intl/intl.dart';

class TextFormatterUtil {
  static String formatCurrency(int value){
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(value);
  }

  static String formatPhoneNum(String phoneToFormat) {
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