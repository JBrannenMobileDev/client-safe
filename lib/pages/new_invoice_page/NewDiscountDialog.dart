import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/job_details_page/JobDetailsPageState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:dandylight/pages/new_job_page/NewJobPageState.dart';
import 'package:dandylight/pages/new_job_page/widgets/NewJobTextField.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:dandylight/utils/VibrateUtil.dart';
import 'package:dandylight/utils/styles/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/TextDandyLight.dart';

class NewDiscountDialog extends StatefulWidget {
  static const String SELECTOR_TYPE_FIXED = "Fixed";
  static const String SELECTOR_TYPE_PERCENTAGE = "Percentage";

  @override
  _NewDiscountDialogState createState() {
    return _NewDiscountDialogState();
  }
}

class _NewDiscountDialogState extends State<NewDiscountDialog>
    with AutomaticKeepAliveClientMixin {
  final FocusNode itemRateInputFocusNode = FocusNode();
  final FocusNode itemQuantityFocusNode = FocusNode();
  var rateTextController = TextEditingController(text: '\$');
  var percentageTextController = TextEditingController(text: '');
  int selectorIndex = 0;
  Map<int, Widget> breakdownTypes;
  var enteredRate = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    super.build(context);
    if(rateTextController.text.length == 0) rateTextController = TextEditingController(text: '\$');
    breakdownTypes = <int, Widget>{
      0: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: NewDiscountDialog.SELECTOR_TYPE_FIXED,
        color: Color(selectorIndex == 0
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
      1: TextDandyLight(
        type: TextDandyLight.MEDIUM_TEXT,
        text: NewDiscountDialog.SELECTOR_TYPE_PERCENTAGE,
        color: Color(selectorIndex == 1
            ? ColorConstants.getPrimaryWhite()
            : ColorConstants.getPrimaryBlack()),
      ),
    };
    return StoreConnector<AppState, NewInvoicePageState>(
      converter: (store) => NewInvoicePageState.fromStore(store),
      onInit: (appState) {
        if (enteredRate != null) {
          rateTextController = TextEditingController(text: '\$' + enteredRate);
        }
      },
      onDidChange: (previous, current) {
        rateTextController.text = enteredRate.length == 0 ? '\$' : '\$' + enteredRate.replaceFirst(r'$', '');
        rateTextController.selection = TextSelection.fromPosition(TextPosition(offset: rateTextController.text.length));
      },
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              height: 314.0,
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
                          pageState.onDeleteDiscountSelected();
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
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'New Discount',
                          textAlign: TextAlign.start,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                      ),
                      Container(
                        width: 300.0,
                        margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0, bottom: 16.0),
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor: Colors.transparent,
                          thumbColor: Color(ColorConstants.getPrimaryColor()),
                          children: breakdownTypes,
                          onValueChanged: (int filterTypeIndex) {
                            setState(() {
                              selectorIndex = filterTypeIndex;
                            });
                            pageState.onNewDiscountFilterChanged(filterTypeIndex == 0 ? NewDiscountDialog.SELECTOR_TYPE_FIXED : NewDiscountDialog.SELECTOR_TYPE_PERCENTAGE);
                          },
                          groupValue: selectorIndex,
                        ),
                      ),
                      selectorIndex == 0 ? Container(
                        margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          controller: rateTextController,
                          hintText: '',
                          inputType: TextInputType.number,
                          height: 64.0,
                          autoFocus: true,
                          onTextInputChanged: (input) {
                            pageState.onNewDiscountRateTextChanged(input);
                            setState(() {
                              enteredRate = input;
                            });
                          },
                          capitalization: TextCapitalization.none,
                          keyboardAction: TextInputAction.next,
                          labelText: 'Rate',
                        ),
                      ) :
                      Container(
                        margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 16.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          controller: percentageTextController,
                          hintText: '',
                          inputType: TextInputType.number,
                          height: 64.0,
                          autoFocus: true,
                          onTextInputChanged: pageState.onNewDiscountPercentageTextChanged,
                          capitalization: TextCapitalization.none,
                          keyboardAction: TextInputAction.next,
                          labelText: 'Percentage',
                        ),
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
                                pageState.onNewDiscountCancelSelected();
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
                                text: 'Cancel',
                                textAlign: TextAlign.center,
                                color: Color(ColorConstants.getPrimaryBlack()),
                              ),
                            ),
                            TextButton(
                              style: Styles.getButtonStyle(),
                              onPressed: () {
                                pageState.onNewDiscountSavedSelected();
                                Navigator.of(context).pop();
                              },
                              child: TextDandyLight(
                                type: TextDandyLight.MEDIUM_TEXT,
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
