import 'dart:io';

import 'package:dandylight/AppState.dart';
import 'package:dandylight/pages/new_pricing_profile_page/dandylightTextField.dart';
import 'package:dandylight/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:dandylight/utils/ColorConstants.dart';
import 'package:dandylight/utils/InputDoneView.dart';
import 'package:dandylight/utils/TextFormatterUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

import '../../widgets/TextDandyLight.dart';
import 'CostTextField.dart';

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
  var flatRateTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '.', thousandSeparator: ',');
  final FocusNode depositInputFocusNode = new FocusNode();
  var depositTextController = MoneyMaskedTextController(leftSymbol: '\$ ', decimalSeparator: '.', thousandSeparator: ',');
  final FocusNode taxPercentFocusNode = new FocusNode();
  var taxPercentController = MoneyMaskedTextController(rightSymbol: '\%', decimalSeparator: '.', thousandSeparator: ',');
  int selectorIndex = 0;

  _RateTypeSelection(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StoreConnector<AppState, NewPricingProfilePageState>(
      onInit: (appState) {
        flatRateTextController.updateValue(appState.state.pricingProfilePageState.flatRate);
        depositTextController.updateValue(appState.state.pricingProfilePageState.deposit);
        taxPercentController.updateValue(appState.state.pricingProfilePageState.taxPercent);

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

        depositInputFocusNode.addListener(() {

          bool hasFocus = depositInputFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        taxPercentFocusNode.addListener(() {

          bool hasFocus = taxPercentFocusNode.hasFocus;
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
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      text: 'How much do you want to charge for this price package?',
                      textAlign: TextAlign.start,
                      color: Color(ColorConstants.getPrimaryBlack()),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      child: CostTextField(
                        flatRateTextController,
                        "\$ 0.0",
                        TextInputType.number,
                        66.0,
                        pageState.onFlatRateTextChanged,
                        null,
                        TextInputAction.next,
                                          flatRateInputFocusNode,
                        null,
                        TextCapitalization.none,
                        null,
                        'Price',
                        250,
                        true
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: CostTextField(
                        depositTextController,
                        "\$ 0.0",
                        TextInputType.number,
                        66.0,
                        pageState.onDepositTextChanged,
                        null,
                        TextInputAction.done,
                        depositInputFocusNode,
                        null,
                        TextCapitalization.none,
                        null,
                        'Deposit',
                        250,
                      true
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextDandyLight(
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: 'Include Sales Tax',
                          textAlign: TextAlign.center,
                          color: Color(ColorConstants.getPrimaryBlack()),
                        ),
                        Platform.isIOS?
                        CupertinoSwitch(
                          trackColor: Color(ColorConstants.getBlueLight()),
                          activeColor: Color(ColorConstants.getBlueDark()),
                          onChanged: (enabled) {
                            pageState.onIncludesSalesTaxChanged(enabled);
                          },
                          value: pageState.includeSalesTax,
                        ) : Switch(
                          activeTrackColor: Color(ColorConstants.getBlueLight()),
                          inactiveTrackColor: Color(ColorConstants.getBlueLight()),
                          activeColor: Color(ColorConstants.getBlueDark()),
                          onChanged: (enabled) {
                            pageState.onIncludesSalesTaxChanged(enabled);
                          },
                          value: pageState.includeSalesTax,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 48.0, right: 48.0, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CostTextField(
                            taxPercentController,
                            "0.0\%",
                            TextInputType.number,
                            66.0,
                            pageState.onTaxPercentChanged,
                            null,
                            TextInputAction.done,
                            taxPercentFocusNode,
                            null,
                            TextCapitalization.none,
                            null,
                            'Tax \%',
                            116,
                            pageState.includeSalesTax,
                        ),
                        TextDandyLight(
                          color: Color(pageState.includeSalesTax ? ColorConstants.getPrimaryBlack() : ColorConstants.getBlueLight()),
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: '=',
                        ),
                        TextDandyLight(
                          color: Color(pageState.includeSalesTax ? ColorConstants.getPrimaryBlack() : ColorConstants.getBlueLight()),
                          type: TextDandyLight.MEDIUM_TEXT,
                          text: TextFormatterUtil.formatDecimalCurrency(pageState.taxAmount),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(left: 48.0, right: 48.0, top: 16),
                    width: MediaQuery.of(context).size.width,
                    child: TextDandyLight(
                      type: TextDandyLight.MEDIUM_TEXT,
                      color: Color(pageState.includeSalesTax ? ColorConstants.getPrimaryBlack() : ColorConstants.getBlueLight()),
                      text: 'Total Price  =  ' + TextFormatterUtil.formatDecimalCurrency(pageState.total),
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
