import 'package:dandylight/pages/new_invoice_page/NewDiscountDialog.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/UserOptionsUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/TextDandyLight.dart';

class DiscountRowWidget extends StatelessWidget{
  final NewInvoicePageState pageState;
  DiscountRowWidget(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0, top: 4.0),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: 'Discount' + (pageState.discount?.selectedFilter == NewDiscountDialog.SELECTOR_TYPE_PERCENTAGE && pageState.discountValue > 0.0
                        ? ' (' +
                        pageState.discount.percentage.truncate().toString() + '%)'
                        : ''),
                    textAlign: TextAlign.start,
                    color: Color(ColorConstants.getPrimaryBlack()),
                  ),
                  pageState.discountValue > 0.0  && pageState.pageViewIndex != 3 ? Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        pageState.onDeleteDiscountSelected();
                      },
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: 'X  ',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPeachDark()),
                      ),
                    ),
                  ) : SizedBox(),
                  pageState.discountValue == 0.0 ?
                  Container(
                    margin: EdgeInsets.only(left: 16.0),
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
                      child: TextDandyLight(
                        type: TextDandyLight.MEDIUM_TEXT,
                        text: 'Add',
                        textAlign: TextAlign.start,
                        color: Color(ColorConstants.getPrimaryWhite()),
                      ),
                    ),
                  ) : SizedBox(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  pageState.discountValue > 0.0 ? TextDandyLight(
                    type: TextDandyLight.LARGE_TEXT,
                    text: (pageState.discountValue.toInt() > 0 ? '-' : '') + TextFormatterUtil.formatDecimalDigitsCurrency (pageState.discountValue, 2),
                    textAlign: TextAlign.start,
                    color: Color(pageState.discountValue.toInt() > 0 ? ColorConstants
                        .getPrimaryBlack() : ColorConstants
                        .getPrimaryBackgroundGrey()),
                  ) : SizedBox(),
                ],
              ),
            ],
          ),
    );
  }
}