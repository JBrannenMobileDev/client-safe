import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPriceProfileTextField.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/InputDoneView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
  final FocusNode hourlyRateInputFocusNode = new FocusNode();
  final FocusNode itemRateInputFocusNode = new FocusNode();
  var flatRateTextController = TextEditingController(text: '\$');
  var hourlyRateTextController = TextEditingController(text: '\$');
  var hourlyQuantityTextController = TextEditingController(text: '0');
  var quantityRateTextController = TextEditingController(text: '\$');
  var quantityQuantityTextController = TextEditingController(text: '0');
  int selectorIndex = 0;
  Map<int, Widget> rateTypes;

  _RateTypeSelection(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    rateTypes = <int, Widget>{
      0: Text(RateTypeSelection.SELECTOR_TYPE_FLAT_RATE,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      1: Text(RateTypeSelection.SELECTOR_TYPE_HOURLY,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      2: Text(RateTypeSelection.SELECTOR_TYPE_QUANTITY,
        style: TextStyle(
          fontFamily: 'Raleway',
          color: Color(selectorIndex == 2
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };
    if(flatRateTextController.text.length == 0) flatRateTextController = TextEditingController(text: '\$');
    if(hourlyQuantityTextController.text.length == 0) hourlyQuantityTextController = TextEditingController(text: '\$');
    if(quantityRateTextController.text.length == 0) quantityRateTextController = TextEditingController(text: '\$');
    return StoreConnector<AppState, NewPricingProfilePageState>(
      onInit: (appState) {
        flatRateTextController.text = '\$' + (appState.state.pricingProfilePageState.flatRate.toInt() > 0 ? appState.state.pricingProfilePageState.flatRate.toInt().toString() : '');
        hourlyRateTextController.text = '\$' + (appState.state.pricingProfilePageState.hourlyRate.toInt() > 0 ? appState.state.pricingProfilePageState.hourlyRate.toInt().toString() : '');
        quantityRateTextController.text = '\$' + (appState.state.pricingProfilePageState.itemRate.toInt() > 0 ? appState.state.pricingProfilePageState.itemRate.toInt().toString() : '');
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

        hourlyRateInputFocusNode.addListener(() {

          bool hasFocus = hourlyRateInputFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        itemRateInputFocusNode.addListener(() {

          bool hasFocus = itemRateInputFocusNode.hasFocus;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });
      },
      onDidChange: (pageState) {
        if(pageState.flatRate == 0) flatRateTextController.text = '\$';
        if(pageState.hourlyRate == 0) hourlyRateTextController.text = '\$';
        if(pageState.itemRate == 0) quantityRateTextController.text = '\$';
      },
      converter: (store) => NewPricingProfilePageState.fromStore(store),
      builder: (BuildContext context, NewPricingProfilePageState pageState) =>
          Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Price Breakdown',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w600,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Text(
                    'Select one',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w400,
                      color: Color(ColorConstants.primary_black),
                    ),
                  ),
                  Container(
                    width: 300.0,
                    margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
                    child: CupertinoSlidingSegmentedControl<int>(
                      backgroundColor: Color(ColorConstants.getPrimaryBackgroundGrey()),
                      thumbColor: Color(ColorConstants.getPrimaryColor()),
                      children: rateTypes,
                      onValueChanged: (int filterTypeIndex) {
                        setState(() {
                          selectorIndex = filterTypeIndex;
                        });
                        pageState.onFilterChanged(
                            filterTypeIndex == 0 ? RateTypeSelection
                                .SELECTOR_TYPE_FLAT_RATE : filterTypeIndex == 1
                                ? RateTypeSelection.SELECTOR_TYPE_QUANTITY
                                : RateTypeSelection.SELECTOR_TYPE_QUANTITY);
                      },
                      groupValue: selectorIndex,
                    ),
                  ),
                  selectorIndex == 0 ? Container(
                    margin: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0, bottom: 16.0),
                    child: NewPriceProfileTextField(
                      controller: flatRateTextController,
                      hintText: "\$",
                      inputType: TextInputType.number,
                      focusNode: flatRateInputFocusNode,
                      height: 60.0,
                      onTextInputChanged: pageState.onFlatRateTextChanged,
                      capitalization: TextCapitalization.none,
                      keyboardAction: TextInputAction.done,
                      labelText: 'Rate',
                    ),
                  ) : selectorIndex == 1 ?
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 112.0,
                          margin: EdgeInsets.only(left: 15.0, bottom: 16.0),
                          child: NewPriceProfileTextField(
                            controller: hourlyRateTextController,
                            hintText: "\$",
                            inputType: TextInputType.number,
                            focusNode: hourlyRateInputFocusNode,
                            height: 60.0,
                            onTextInputChanged: pageState.onHourlyRateTextChanged,
                            capitalization: TextCapitalization.none,
                            keyboardAction: TextInputAction.done,
                            labelText: 'Hour',
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
                            tooltip: 'delete',
                            onPressed: null,
                          ),
                        ),
                        Opacity(
                          opacity: 0.35,
                          child: Container(
                            width: 112.0,
                            margin: EdgeInsets.only(right: 15.0, bottom: 16.0),
                            child: NewPriceProfileTextField(
                              controller: hourlyQuantityTextController,
                              hintText: "0",
                              inputType: TextInputType.number,
                              height: 60.0,
                              capitalization: TextCapitalization.none,
                              keyboardAction: TextInputAction.done,
                              labelText: 'Quantity',
                              enabled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 112.0,
                          margin: EdgeInsets.only(left: 15.0),
                          child: NewPriceProfileTextField(
                            controller: quantityRateTextController,
                            hintText: "\$",
                            inputType: TextInputType.number,
                            focusNode: itemRateInputFocusNode,
                            height: 60.0,
                            onTextInputChanged: pageState.onItemRateTextChanged,
                            capitalization: TextCapitalization.none,
                            keyboardAction: TextInputAction.done,
                            labelText: 'Item',
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: IconButton(
                            icon: Icon(
                                Icons.close,
                                color: Color(ColorConstants.getPrimaryBlack())
                            ),
                            tooltip: 'delete',
                            onPressed: null,
                          ),
                        ),
                        Opacity(
                          opacity: 0.35,
                          child: Container(
                            width: 112.0,
                            margin: EdgeInsets.only(right: 15.0),
                            child: NewPriceProfileTextField(
                              enabled: false,
                              controller: quantityQuantityTextController,
                              hintText: "0",
                              inputType: TextInputType.number,
                              height: 60.0,
                              capitalization: TextCapitalization.none,
                              keyboardAction: TextInputAction.done,
                              labelText: 'Quantity',
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
    );
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
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
