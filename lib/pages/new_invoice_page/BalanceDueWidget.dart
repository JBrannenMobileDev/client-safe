import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';

class BalanceDueWidget extends StatelessWidget{
  final NewInvoicePageState pageState;

  BalanceDueWidget(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 32.0, top: 16.0),
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
                pageState.unpaidAmount.toInt().toString(),
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