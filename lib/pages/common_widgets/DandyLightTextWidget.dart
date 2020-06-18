import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/TextFormatterUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DandyLightTextWidget extends StatelessWidget {

  @required
  double amount;
  double textSize = 14.0;
  Color textColor = Color(ColorConstants.getPrimaryBlack());
  FontWeight fontWeight = FontWeight.w600;
  int decimalPlaces = 2;
  bool isCurrency = false;

  DandyLightTextWidget({this.amount, this.textSize, this.textColor, this.fontWeight, this.isCurrency, this.decimalPlaces});

  @override
  Widget build(BuildContext context) {
    int whole = amount.toInt();
    int decimal = int.tryParse(amount.toString().split('.')[1]);

    //this adds a 0 to the end to fill in the hundredths decimal place
    if (decimal < 10) {
      decimal = decimal * 10;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isCurrency ? TextFormatterUtil.formatSimpleCurrency(whole) : NumberFormat("###,###,###,###").format(whole),
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: textSize,
            fontFamily: 'simple',
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
        Text(
          '.',
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: textSize / 1.25,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
        Text(
          decimal > 10 ? decimal.toString().substring(0, decimalPlaces) : decimal.toString(),
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: textSize,
            fontFamily: 'simple',
            fontWeight: fontWeight,
            color: textColor,
          ),
        )
      ],
    );
  }
}
  