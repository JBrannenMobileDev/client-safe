import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../utils/styles/Styles.dart';

class SalesTaxRowWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SalesTaxRowWidgetPageState();
  }
}

class _SalesTaxRowWidgetPageState extends State<SalesTaxRowWidget> with TickerProviderStateMixin {
  TextEditingController passwordTextController = TextEditingController();

  bool isChecked = false;

  _SalesTaxRowWidgetPageState();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewInvoicePageState>(
        onInit: (appState) {
          isChecked = appState.state.newInvoicePageState.selectedJob.isDepositPaid();
        },
        converter: (store) => NewInvoicePageState.fromStore(store),
        builder: (BuildContext context, NewInvoicePageState pageState) =>
        Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0),
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
                pageState.pageViewIndex != 3 ? Checkbox(
                  value: pageState.isSalesTaxChecked,
                  activeColor: Color(ColorConstants.getPeachDark()),
                  onChanged: (bool isChecked) {
                    setState(() {
                      isChecked = isChecked;
                    });
                    pageState.onSalesTaxChecked(isChecked);
                  },
                ) : SizedBox(),
              ],
          ),
          Row(
            children: [
              pageState.isSalesTaxChecked && pageState.pageViewIndex == 1 ? Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                decoration: BoxDecoration(
                    color:Color(
                        pageState.isSalesTaxChecked
                            ? ColorConstants.getPrimaryColor()
                            : ColorConstants
                            .getPrimaryBackgroundGrey()),
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
                      pageState.salesTaxPercent > 0 ? pageState.salesTaxPercent.toString() + '%' : '0%',
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
              pageState.isSalesTaxChecked ? Text(
                pageState.salesTaxPercent > 0 ? TextFormatterUtil.formatSimpleCurrency((pageState.total * (pageState.salesTaxPercent/100)).toInt()) : '\$0',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(
                      pageState.salesTaxPercent > 0.0
                          ? ColorConstants.getPrimaryBlack()
                          : ColorConstants
                          .getPrimaryBackgroundGrey()),
                ),
              ) : SizedBox(),
            ],
          ),
        ],
      ),
    ),
    );
  }

}