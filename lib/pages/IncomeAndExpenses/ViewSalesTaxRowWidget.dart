import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../models/Invoice.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/styles/Styles.dart';

class ViewSalesTaxRowWidget extends StatelessWidget{
  final Invoice invoice;
  ViewSalesTaxRowWidget(this.invoice);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Sales tax',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w400,
                    color: Color(
                        ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                    color:Color(
                        ColorConstants.getPrimaryColor()
                    ),
                    borderRadius: BorderRadius.circular(24.0)
                ),
                width: 64.0,
                height: 28.0,
                child: TextButton(
                  style: Styles.getButtonStyle(),
                  onPressed: () {
                    UserOptionsUtil.showSelectSalesTaxRateDialog(context);
                  },
                  child: Text(
                      invoice.salesTaxRate.toString() + '%',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.getPrimaryWhite()),
                    ),
                  ),
                ),
              ),
              Text(
                TextFormatterUtil.formatSimpleCurrency(invoice.salesTaxAmount.toInt()),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(
                      ColorConstants.getPrimaryBlack()
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      );
  }

}