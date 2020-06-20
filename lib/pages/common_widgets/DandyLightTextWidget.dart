import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
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
    String decimalString = amount.toString().split('.')[1];
    if(decimalString.length == 0){
      decimalString = '00';
    }
    if(decimalString.length == 1){
      decimalString = decimalString + '0';
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
          decimalString.substring(0, decimalPlaces),
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
  