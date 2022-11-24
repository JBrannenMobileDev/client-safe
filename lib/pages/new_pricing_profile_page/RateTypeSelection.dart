import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/dandylightTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputDoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class RateTypeSelection extends StatefulWidget {
  static const String SELECTOR_TYPE_FLAT_RATE = "Flat rate";
  static const String SELECTOR_TYPE_HOURLY = "Hourly";
  static const String SELECTOR_TYPE_QUANTITY = "Quantity";
  final GlobalKey<ScaffoldState> scaffoldKey;

  RateTypeSelection(this.scaffoldKey);

  @override
  _RateTypeSelection createState() {
    return _RateTypeSelection(scaffoldKey);
  }
}

class _RateTypeSelection extends State<RateTypeSelection> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey;
  OverlayEntry overlayEntry;
  final FocusNode flatRateInputFocusNode = new FocusNode();
  var flatRateTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '', thousandSeparator: ',', precision: 0);
  int selectorIndex = 0;

  _RateTypeSelection(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewPricingProfilePageState>(
      onInit: (appState) {
        flatRateTextController.text = '\$' + (appState.state.pricingProfilePageState.flatRate.toInt() > 0 ? appState.state.pricingProfilePageState.flatRate.toInt().toString() : '');
       KeyboardVisibilityNotification().addNewListener(
            onShow: () {
              showOverlay(context);
            },
            onHide: () {
              removeOverlay();
            }
        );

        flatRateInputFocusNode.addListener(() {

          bool hasFocus = flatRateInputFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });
      },
      converter: (store) => NewPricingProfilePageState.fromStore(store),
      builder: (BuildContext context, NewPricingProfilePageState pageState) =>
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
                    child: Text(
                      'How much do you want to charge for this price package?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'simple',
                        fontWeight: FontWeight.w600,
                        color: Color(ColorConstants.primary_black),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: DandyLightTextField(
                      controller: flatRateTextController,
                      hintText: "\$",
                      inputType: TextInputType.number,
                      focusNode: flatRateInputFocusNode,
                      height: 66.0,
                      onTextInputChanged: pageState.onFlatRateTextChanged,
                      capitalization: TextCapitalization.none,
                      keyboardAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
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

  @override
  bool get wantKeepAlive => true;
}
