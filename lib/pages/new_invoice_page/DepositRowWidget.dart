import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:flutter/material.dart';

class DepositRowWidget extends StatefulWidget{
  final NewInvoicePageState pageState;

  DepositRowWidget(this.pageState);

  @override
  State<StatefulWidget> createState() {
    return _DepositRowWidgetPageState(pageState);
  }
}

class _DepositRowWidgetPageState extends State<DepositRowWidget>
    with TickerProviderStateMixin {
  TextEditingController passwordTextController = TextEditingController();

  final NewInvoicePageState pageState;
  bool isChecked = false;

  _DepositRowWidgetPageState(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  value: pageState.selectedJob.isDepositPaid(),
                  activeColor: Color(ColorConstants.error_red),
                  onChanged: (bool value) {
                    setState(() {
                      isChecked = value;
                    });
                    pageState.onDepositActionPressed();
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
                : '') + '\$' +
                pageState.depositValue.toInt().toString(),
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
    );
  }

}