import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class InputDoneViewNewInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topRight,
          child: FlatButton(
            padding: EdgeInsets.only(right: 0.0, top: 8.0, bottom: 0.0),
            onPressed: () {
              if(pageState.discountValue > 0) {
                if (pageState.isDiscountFixedRate) {
                  pageState.onFixedDiscountSelectionCompleted();
                } else {
                  pageState.onPercentageDiscountSelectionCompleted();
                }
              }else{
                pageState.onDeleteDiscountPressed();
              }
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text("Done",
                  style: TextStyle(
                      color: Color(ColorConstants.getPrimaryWhite()),
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
