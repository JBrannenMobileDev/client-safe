import 'package:dandylight/pages/income_expense_settings_page/IncomeAndExpenseSettingsPageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/NavigationUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../AppState.dart';
import '../../utils/UserOptionsUtil.dart';
import '../../widgets/TextDandyLight.dart';

class RequestPaymentLinksDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RequestPaymentLinksDialogPage();
  }
}

class _RequestPaymentLinksDialogPage extends State<RequestPaymentLinksDialog> {
  final notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IncomeAndExpenseSettingsPageState>(
      converter: (store) => IncomeAndExpenseSettingsPageState.fromStore(store),
      builder: (BuildContext context, IncomeAndExpenseSettingsPageState pageState) =>
          Dialog(
            insetPadding: EdgeInsets.only(left: 16.0, right: 16.0),
            backgroundColor: Colors.transparent,
            child: Container(
              height: 448,
              width: 450,
              decoration: BoxDecoration(
                color: Color(ColorConstants.getPrimaryWhite()),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.center,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Payment Info',
                      textAlign: TextAlign.center,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 24.0, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Before we create the invoice, would you like to include your payment info?',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 24.0, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'Payment info will be included in the invoice so that your customer knows how to pay you.',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 24.0, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'We currently support these forms of payment: Zelle, Venmo, Cash App, Apple Pay',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16.0),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 24.0, right: 24),
                    child: TextDandyLight(
                      type: TextDandyLight.SMALL_TEXT,
                      text: 'Payment info can also be set in the Income and Expenses page settings.',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          UserOptionsUtil.showNewInvoiceDialog(context, null);
                        },
                        child: Container(
                          height: 78.0,
                          width: 78.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPeachDark())
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'NO',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          UserOptionsUtil.showNewInvoiceDialog(context, null);
                          NavigationUtil.onPaymentRequestInfoSelected(context);
                        },
                        child: Container(
                          height: 78.0,
                          width: 78.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(ColorConstants.getPrimaryColor())
                          ),
                          child: TextDandyLight(
                            type: TextDandyLight.LARGE_TEXT,
                            text: 'YES',
                            textAlign: TextAlign.center,
                            color: Color(ColorConstants.getPrimaryWhite()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void onAction(){
    _notesFocusNode.unfocus();
  }
}
