import 'package:intl/intl.dart';

class TextFormatterUtil {
  static String formatCurrency(int value){
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(value);
  }
}