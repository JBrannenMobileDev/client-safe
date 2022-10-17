import 'package:dandylight/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscountRowWidget extends StatelessWidget{
  final NewInvoicePageState pageState;
  DiscountRowWidget(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 4.0),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
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
                  pageState.discountValue == 0.0 ?
                  Container(
                    margin: EdgeInsets.only(left: 8.0),
                    decoration: BoxDecoration(
                        color: Color(ColorConstants.getPrimaryColor()),
                        borderRadius: BorderRadius.circular(24.0)
                    ),
                    width: 64.0,
                    height: 28.0,
                    child: TextButton(
                      style: Styles.getButtonStyle(),
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  pageState.discountValue > 0.0  && pageState.pageViewIndex != 3 ? Container(
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
                  pageState.discountValue > 0.0 ? Text(
                    (pageState.discountValue.toInt() > 0 ? '-' : '') + TextFormatterUtil.formatSimpleCurrency (pageState.discountValue.toInt()),
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
            ],
          ),
    );
  }
}