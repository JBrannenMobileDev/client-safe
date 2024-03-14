import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';

import '../../widgets/TextDandyLight.dart';

class ViewInvoiceSubtotalRowWidget extends StatelessWidget{
  final Invoice invoice;

  ViewInvoiceSubtotalRowWidget(this.invoice);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 0.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 112.0),
            child: TextDandyLight(
              type: TextDandyLight.MEDIUM_TEXT,
              text: 'Subtotal',
              textAlign: TextAlign.start,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
          TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: '\$' + invoice.total!.toInt().toString(),
            textAlign: TextAlign.start,
            color: Color(ColorConstants.getPrimaryBlack()),
          ),
        ],
      ),
    );
  }
}