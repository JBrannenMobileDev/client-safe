import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';

class DepositRowWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _DepositRowWidgetPageState();
  }
}

class _DepositRowWidgetPageState extends State<DepositRowWidget> with TickerProviderStateMixin {
  TextEditingController passwordTextController = TextEditingController();

  bool isChecked = false;

  _DepositRowWidgetPageState();

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
          left: 16.0, right: 16.0, top: 4.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 96.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                pageState.pageViewIndex != 3 ? Checkbox(
                  value: isChecked,
                  activeColor: Color(ColorConstants.error_red),
                  onChanged: (bool isChecked) {
                    setState(() {
                      isChecked = isChecked;
                    });
                    pageState.onDepositActionPressed(isChecked);
                  },
                ) : SizedBox(),
                Text(
                  'Deposit  ',
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
          ),
          Text(
            (pageState.selectedJob.isDepositPaid()
                ? '-'
                : '') + TextFormatterUtil.formatSimpleCurrency(pageState.depositValue.toInt()),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'simple',
              fontWeight: FontWeight.w600,
              color: Color(
                  pageState.selectedJob.isDepositPaid()
                      ? ColorConstants.getPrimaryBlack()
                      : ColorConstants
                      .getPrimaryBackgroundGrey()),
            ),
          ),
        ],
      ),
    ),
    );
  }

}