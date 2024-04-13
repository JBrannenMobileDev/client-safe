import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/TextDandyLight.dart';

class SubtotalRowWidget extends StatelessWidget{
  final NewInvoicePageState pageState;

  SubtotalRowWidget(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 0.0, top: 16.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                  text: 'Subtotal',
                  textAlign: TextAlign.start,
                color: Color(
                    ColorConstants.getPrimaryBlack()),
              ),
              TextDandyLight(
                type: TextDandyLight.LARGE_TEXT,
                text: TextFormatterUtil.formatDecimalDigitsCurrency(pageState.subtotal!, 2),
                textAlign: TextAlign.start,
                color: Color(
                    ColorConstants.getPrimaryBlack()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}