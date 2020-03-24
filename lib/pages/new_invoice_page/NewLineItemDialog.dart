import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/job_details_page/JobDetailsPageState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:client_safe/pages/new_job_page/NewJobPageState.dart';
import 'package:client_safe/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/VibrateUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
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
                          pageState.onNewLineItemCanceled();
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
                        child: Text(
                          'New Line Item',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w600,
                            color: Color(
                                ColorConstants.getPrimaryBlack()),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          controller: textController,
                          hintText: '',
                          inputType: TextInputType.text,
                          height: 60.0,
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
                              height: 60.0,
                              onTextInputChanged: pageState.onNewLineItemRateTextChanged,
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
                              height: 60.0,
                              onTextInputChanged: pageState.onNewLineItemQuantityTextChanged,
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
                            FlatButton(
                              onPressed: () {
                                pageState.onNewLineItemCanceled();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                pageState.onNewLineItemSaveSelected();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorConstants.primary_black),
                                ),
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
