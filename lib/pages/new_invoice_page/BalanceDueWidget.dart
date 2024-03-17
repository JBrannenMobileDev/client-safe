import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/TextDandyLight.dart';

class BalanceDueWidget extends StatelessWidget{
  final NewInvoicePageState pageState;

  BalanceDueWidget(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 32.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 112.0),
            child: TextDandyLight(
              type: TextDandyLight.LARGE_TEXT,
              text: 'Balance Due' ,
              textAlign: TextAlign.start,
              color: Color(
                  ColorConstants.getPrimaryBlack()),
            ),
          ),
          TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: TextFormatterUtil.formatDecimalDigitsCurrency(pageState.unpaidAmount!, 2),
            textAlign: TextAlign.start,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ],
      ),
    );
  }

}