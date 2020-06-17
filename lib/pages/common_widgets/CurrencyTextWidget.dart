import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/TextFormatterUtil.dart';
import 'package:flutter/cupertino.dart';

class CurrencyTextWidget extends StatelessWidget {

  final double amount;
  final double textSize;
  final Color textColor;
  final FontWeight fontWeight;

  CurrencyTextWidget({this.amount, this.textSize, this.textColor, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    int whole = amount.toInt();
    int decimal = int.tryParse(amount.toString().split('.')[1]);

    //this adds a 0 to the end to fill in the hundredths decimal place 
    if(decimal < 10) {
      decimal = decimal * 10;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TextFormatterUtil.formatSimpleCurrency(whole),
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
            fontSize: textSize/1.25,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
        Text(
          decimal.toString(),
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