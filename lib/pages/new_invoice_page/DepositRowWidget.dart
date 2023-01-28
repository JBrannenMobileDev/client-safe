import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../widgets/TextDandyLight.dart';

class DepositRowWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _DepositRowWidgetPageState();
  }
}

class _DepositRowWidgetPageState extends State<DepositRowWidget> with TickerProviderStateMixin {
  TextEditingController passwordTextController = TextEditingController();

  _DepositRowWidgetPageState();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewInvoicePageState>(
        converter: (store) => NewInvoicePageState.fromStore(store),
        builder: (BuildContext context, NewInvoicePageState pageState) =>
        Padding(
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 96.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextDandyLight(
                  type: TextDandyLight.LARGE_TEXT,
                  text: 'Deposit',
                  textAlign: TextAlign.start,
                  color: Color(
                      ColorConstants.getPrimaryBlack()),
                ),
                pageState.pageViewIndex != 3 ? Padding(
                  padding: EdgeInsets.only(left: 13.0),
                  child: Checkbox(
                    value: pageState.isDepositChecked,
                    activeColor: Color(ColorConstants.getPeachDark()),
                    onChanged: (bool isChecked) {
                      pageState.onDepositChecked(isChecked);
                      pageState.onDepositActionPressed(isChecked);
                    },
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
          TextDandyLight(
            type: TextDandyLight.LARGE_TEXT,
            text: (pageState.selectedJob.isDepositPaid()
                ? '-'
                : '') + TextFormatterUtil.formatSimpleCurrency(pageState.depositValue.toInt()),
            textAlign: TextAlign.start,
            color: Color(
                pageState.selectedJob.isDepositPaid()
                    ? ColorConstants.getPrimaryBlack()
                    : ColorConstants
                    .getPrimaryBackgroundGrey()),
          ),
        ],
      ),
    ),
    );
  }

}