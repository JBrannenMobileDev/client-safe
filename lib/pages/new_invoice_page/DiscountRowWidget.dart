import 'package:client_safe/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscountRowWidget extends StatelessWidget{
  final NewInvoicePageState pageState;
  DiscountRowWidget(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 4.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              pageState.discountValue > 0.0 ?
              Container(
                margin: EdgeInsets.only(right: 4.0),
                child: GestureDetector(
                  onTap: () {
                    pageState.onDeleteDiscountSelected();
                  },
                  child: Text(
                    'X  ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontFamily: 'simple',
                      fontWeight: FontWeight.w800,
                      color: Color(ColorConstants.getPeachDark()),
                    ),
                  ),
                ),
              ) : SizedBox(),
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 0.0, right: 112.0),
                child: Text(
                  'Discount' + (pageState.discount?.selectedFilter == NewDiscountDialog.SELECTOR_TYPE_PERCENTAGE && pageState.discountValue > 0.0
                      ? ' (' +
                      pageState.discount.percentage.truncate().toString() + '%)'
                      : ''),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'simple',
                    fontWeight: FontWeight.w400,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                ),
              ),
            ],
          ),
          pageState.discountValue == 0.0 ?
          Container(
            decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryColor()),
                borderRadius: BorderRadius.circular(24.0)
            ),
            width: 64.0,
            height: 28.0,
            child: FlatButton(
              onPressed: () {
                UserOptionsUtil.showNewDiscountDialog(context);
              },
              child: Text(
                'Add',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryWhite()),
                ),
              ),
            ),
          ) : SizedBox(),
          pageState.discountValue > 0.0 ? Text(
            (pageState.discountValue.toInt() > 0 ? '-' : '') + '\$' +
                (pageState.discountValue.toInt().toString()),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'simple',
              fontWeight: FontWeight.w600,
              color: Color(pageState.discountValue.toInt() > 0 ? ColorConstants
                  .getPrimaryBlack() : ColorConstants
                  .getPrimaryBackgroundGrey()),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}