import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/dandylightTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputDoneView.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../utils/styles/Styles.dart';

class SelectSalesTaxRateDialog extends StatefulWidget {

  @override
  _SelectSalesTaxRateDialog createState() {
    return _SelectSalesTaxRateDialog();
  }
}

class _SelectSalesTaxRateDialog extends State<SelectSalesTaxRateDialog> with AutomaticKeepAliveClientMixin {
  OverlayEntry overlayEntry;
  final FocusNode taxRateFocusNode = new FocusNode();
  var taxRateTextController = TextEditingController();
  String enteredRate = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {
        taxRateTextController.text = appState.state.newInvoicePageState.salesTaxPercent.toString() + '\%';
       KeyboardVisibilityNotification().addNewListener(
            onShow: () {
              showOverlay(context);
            },
            onHide: () {
              removeOverlay();
            }
        );

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
                      child: Text(
                        "Enter Sales Tax Rate",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.0,
                          fontFamily: 'simple',
                          fontWeight: FontWeight.w600,
                          color: Color(ColorConstants.primary_black),
                        ),
                      ),
                    ),
                    Container(
                          padding: EdgeInsets.only(left: 24.0, right: 24.0),
                          child: DandyLightTextField(
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
                              color: Colors.white,
                              textColor: Color(ColorConstants.primary_black),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'simple',
                                fontWeight: FontWeight.w600,
                                color: Color(ColorConstants.primary_black),
                              ),
                            ),
                          ),
                          TextButton(
                            style: Styles.getButtonStyle(
                              color: Colors.white,
                              textColor: Color(ColorConstants.primary_black),
                              left: 8.0,
                              top: 8.0,
                              right: 8.0,
                              bottom: 8.0,
                            ),
                            onPressed: () {
                              pageState.onSalesTaxRateChanged(enteredRate);
                              showSuccessAnimation();
                            },
                            child: Text(
                              'Save',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.0,
                                fontFamily: 'simple',
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

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  void showSuccessAnimation(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(96.0),
          child: FlareActor(
            "assets/animations/success_check.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "show_check",
            callback: onFlareCompleted,
          ),
        );
      },
    );
  }

  void onFlareCompleted(String unused) {
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }

  @override
  bool get wantKeepAlive => true;
}
