import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';

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
          Padding(
            padding: EdgeInsets.only(right: 112.0),
            child: Text(
              'Subtotal',
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
            '\$' + pageState.total.toInt().toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'simple',
              fontWeight: FontWeight.w800,
              color: Color(
                  ColorConstants.getPrimaryBlack()),
            ),
          ),
        ],
      ),
    );
  }
}