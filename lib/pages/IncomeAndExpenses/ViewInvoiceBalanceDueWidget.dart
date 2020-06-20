import 'package:dandylight/models/Invoice.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';

class ViewInvoiceBalanceDueWidget extends StatelessWidget{
  final Invoice invoice;

  ViewInvoiceBalanceDueWidget(this.invoice);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 0.0, top: 16.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 112.0),
            child: Text(
              'Balance Due' ,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'simple',
                fontWeight: FontWeight.w800,
                color: Color(
                    ColorConstants.getPrimaryBlack()),
              ),
            ),
          ),
          Text(
            '\$' +
                invoice.unpaidAmount.toInt().toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'simple',
              fontWeight: FontWeight.w600,
              color: Color(ColorConstants.getPrimaryBlack()),
            ),
          ),
        ],
      ),
    );
  }

}