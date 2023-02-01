import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/TextDandyLight.dart';

class ViewInvoiceDiscountRowWidget extends StatelessWidget{
  final Invoice invoice;
  ViewInvoiceDiscountRowWidget(this.invoice);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: invoice.salesTaxRate > 0 ? 4.0 : 16.0, top: 4.0),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 112.0),
                child: TextDandyLight(
                  type: TextDandyLight.MEDIUM_TEXT,
                  text: 'Discount',
                  textAlign: TextAlign.start,
                  color: Color(ColorConstants.getPrimaryBlack()),
                ),
              ),
          invoice.discount > 0.0 ? TextDandyLight(
            type: TextDandyLight.MEDIUM_TEXT,
            text: (invoice.discount.toInt() > 0 ? '-' : '') + '\$' +
                (invoice.discount.toInt().toString()),
            textAlign: TextAlign.start,
            color: Color(invoice.discount.toInt() > 0 ? ColorConstants
                .getPrimaryBlack() : ColorConstants
                .getPrimaryBackgroundGrey()),
          ) : SizedBox(),
    ],
      ),
    );
  }
}