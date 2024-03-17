import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class NewLineItemDialog extends StatefulWidget {
  @override
  _NewLineItemDialogState createState() {
    return _NewLineItemDialogState();
  }
}

class _NewLineItemDialogState extends State<NewLineItemDialog>
    with AutomaticKeepAliveClientMixin {
  final textController = TextEditingController();
  final FocusNode itemRateInputFocusNode = FocusNode();
  final FocusNode itemQuantityFocusNode = FocusNode();
  var rateTextController = TextEditingController(text: '\$');
  var quantityTextController = TextEditingController(text: '1');
  var enteredRate = '';
  var enteredQuantity = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(rateTextController.text.length == 0) rateTextController = TextEditingController(text: '\$');
    if(quantityTextController.text.length == 0) quantityTextController = TextEditingController(text: '1');
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
      onInit: (appState) {

        if (enteredRate != null) {
          rateTextController = TextEditingController(text: '\$' + enteredRate);
        }

        if (enteredQuantity != null) {
          quantityTextController = TextEditingController(text: '1' + enteredQuantity);
        }
      },
      onDidChange: (previous, current) {
        rateTextController.text = enteredRate.length == 0 ? '\$' : '\$' + enteredRate.replaceFirst(r'$', '');
        rateTextController.selection = TextSelection.fromPosition(TextPosition(offset: rateTextController.text.length));

        quantityTextController.text = enteredQuantity.length == 0 ? '1' : enteredQuantity;
        quantityTextController.selection = TextSelection.fromPosition(TextPosition(offset: 1));
      },
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 328.0,
              width: 350.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Color(ColorConstants.getPrimaryWhite()),
              ),
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Close',
                        color: Color(ColorConstants.getPrimaryColor()),
                        onPressed: () {
                          pageState.onNewLineItemCanceled!();
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: SizedBox(width: 10.0,),
                      ),
                    ],
                  ),
                  Column(

                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 32.0),
                        child: TextDandyLight(
                          type: TextDandyLight.SMALL_TEXT,
                          text: 'New Line Item',
                          textAlign: TextAlign.start,
                          color: Color(
                              ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          controller: textController,
                          hintText: '',
                          inputType: TextInputType.text,
                          height: 64.0,
                          autoFocus: true,
                          onTextInputChanged: pageState.onNewLineItemNameTextChanged,
                          capitalization: TextCapitalization.words,
                          keyboardAction: TextInputAction.next,
                          labelText: 'Item name',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 112.0,
                            margin: EdgeInsets.only(left: 15.0, bottom: 16.0),
                            child: NewInvoiceTextField(
                              focusNode: itemRateInputFocusNode,
                              controller: rateTextController,
                              hintText: "\$",
                              inputType: TextInputType.number,
                              height: 64.0,
                              onTextInputChanged: (input) {
                                pageState.onNewLineItemRateTextChanged!(input);
                                setState(() {
                                  enteredRate = input;
                                });
                              },
                                capitalization: TextCapitalization.none,
                                keyboardAction: TextInputAction.done,
                                labelText: 'Rate',
                                ),
                                ),
                                Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 16.0),
                                child: IconButton(
                                icon: Icon(
                                Icons.close,
                                color: Color(ColorConstants.getPrimaryBlack())
                                ),
                                tooltip: 'times',
                                onPressed: null,
                                ),
                                ),
                                Container(
                                width: 112.0,
                                margin: EdgeInsets.only(right: 15.0, bottom: 16.0),
                            child: NewInvoiceTextField(
                              focusNode: itemQuantityFocusNode,
                              controller: quantityTextController,
                              hintText: "1",
                              inputType: TextInputType.number,
                              height: 64.0,
                              onTextInputChanged: (input) {
                                pageState.onNewLineItemQuantityTextChanged!(input);
                                setState(() {
                                  enteredQuantity = input;
                                });
                              },
                              capitalization: TextCapitalization.none,
                              keyboardAction: TextInputAction.done,
                              labelText: 'Quantity',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0),
                        height: 64.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                pageState.onNewLineItemCanceled!();
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'Cancel',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                pageState.onNewLineItemSaveSelected!();
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.EXTRA_SMALL_TEXT,
                                text: 'Save',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                          ],
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

  @override
  bool get wantKeepAlive => true;
}
