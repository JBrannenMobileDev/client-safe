import 'dart:async';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/DandyLightTextFieldOld.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputDoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../utils/styles/Styles.dart';
import '../../widgets/TextDandyLight.dart';

class SelectSalesTaxRateDialog extends StatefulWidget {

  @override
  _SelectSalesTaxRateDialog createState() {
    return _SelectSalesTaxRateDialog();
  }
}

class _SelectSalesTaxRateDialog extends State<SelectSalesTaxRateDialog> with AutomaticKeepAliveClientMixin {
  OverlayEntry? overlayEntry;
  final FocusNode taxRateFocusNode = new FocusNode();
  var taxRateTextController = TextEditingController();
  String enteredRate = '';
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        if(visible) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {
        taxRateTextController.text = appState.state.newInvoicePageState!.salesTaxPercent.toString() + '\%';
        taxRateFocusNode.addListener(() {

          bool hasFocus = taxRateFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });
      },
      onDidChange: (prev, pageState) {
        if(pageState.salesTaxPercent == 0) {
          taxRateTextController.text = '\%';
        } else {
          taxRateTextController.text = taxRateTextController.text.replaceFirst('\%', '') + '\%';
        }
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: 375.0,
                padding: EdgeInsets.only(top: 26.0, bottom: 18.0),
                decoration: new BoxDecoration(
                    color: Color(ColorConstants.white),
                    borderRadius: new BorderRadius.all(Radius.circular(16.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: TextDandyLight(
                        type: TextDandyLight.LARGE_TEXT,
                        text: "Enter Sales Tax Rate",
                        textAlign: TextAlign.center,
                        color: Color(ColorConstants.getPrimaryBlack()),
                      ),
                    ),
                    Container(
                          padding: EdgeInsets.only(left: 24.0, right: 24.0),
                          child: DandyLightTextFieldOld(
                            controller: taxRateTextController,
                            hintText: "\%",
                            inputType: TextInputType.numberWithOptions(decimal: true),
                            focusNode: taxRateFocusNode,
                            height: 66.0,
                            onTextInputChanged: saveEnteredRateLocal,
                            capitalization: TextCapitalization.none,
                            keyboardAction: TextInputAction.done,
                          ),
                        ),
                    Padding(
                      padding: EdgeInsets.only(left: 26.0, right: 26.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            style: Styles.getButtonStyle(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Cancel',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                          TextButton(
                            style: Styles.getButtonStyle(
                              color: Color(ColorConstants.getPrimaryWhite()),
                              textColor: Color(ColorConstants.getPrimaryBlack()),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            onPressed: () {
                              pageState.onSalesTaxRateChanged!(enteredRate);
                              Navigator.of(context).pop();
                            },
                            child: TextDandyLight(
                              type: TextDandyLight.MEDIUM_TEXT,
                              text: 'Save',
                              textAlign: TextAlign.start,
                              color: Color(ColorConstants.getPrimaryBlack()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void saveEnteredRateLocal(String rate) {
    enteredRate = rate;
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  void vibrate() async {
    HapticFeedback.mediumImpact();
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
