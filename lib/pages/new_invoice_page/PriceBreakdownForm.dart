import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_invoice_page/InputDoneViewNewInvoice.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoicePageState.dart';
import 'package:client_safe/pages/new_invoice_page/NewInvoiceTextField.dart';
import 'package:client_safe/pages/new_pricing_profile_page/RateTypeSelection.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:client_safe/utils/UserOptionsUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class PriceBreakdownForm extends StatefulWidget {
  static const String SELECTOR_TYPE_FLAT_RATE = "Flat rate";
  static const String SELECTOR_TYPE_HOURLY = "Hourly";
  static const String SELECTOR_TYPE_QUANTITY = "Quantity";

  @override
  _PriceBreakdownFormState createState() {
    return _PriceBreakdownFormState();
  }
}

class _PriceBreakdownFormState extends State<PriceBreakdownForm> with AutomaticKeepAliveClientMixin {
  OverlayEntry overlayEntry;
  final FocusNode flatRateInputFocusNode = FocusNode();
  final FocusNode hourlyRateInputFocusNode = FocusNode();
  final FocusNode itemRateInputFocusNode = FocusNode();
  final FocusNode itemQuantityFocusNode = FocusNode();
  final FocusNode hourlyQuantityFocusNode = FocusNode();
  var flatRateTextController = TextEditingController(text: '\$');
  var hourlyRateTextController = TextEditingController(text: '\$');
  var hourlyQuantityTextController = TextEditingController(text: '');
  var quantityRateTextController = TextEditingController(text: '\$');
  var quantityQuantityTextController = TextEditingController(text: '');
  int selectorIndex = 0;
  Map<int, Widget> breakdownTypes;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    breakdownTypes = <int, Widget>{
      0: Text(PriceBreakdownForm.SELECTOR_TYPE_FLAT_RATE,
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'simple',
          color: Color(selectorIndex == 0
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      1: Text(PriceBreakdownForm.SELECTOR_TYPE_HOURLY,
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'simple',
          color: Color(selectorIndex == 1
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
      2: Text(PriceBreakdownForm.SELECTOR_TYPE_QUANTITY,
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'simple',
          color: Color(selectorIndex == 2
              ? ColorConstants.getPrimaryWhite()
              : ColorConstants.getPrimaryBlack()),
        ),),
    };



    if(flatRateTextController.text.length == 0) flatRateTextController = TextEditingController(text: '\$');
    if(hourlyRateTextController.text.length == 0) hourlyRateTextController = TextEditingController(text: '\$');
    if(quantityRateTextController.text.length == 0) quantityRateTextController = TextEditingController(text: '\$');
    return StoreConnector<AppState, NewInvoicePageState>(
      onInit: (appState) {
        switch(appState.state.newInvoicePageState.selectedJob.priceProfile.rateType){
          case PriceBreakdownForm.SELECTOR_TYPE_FLAT_RATE:
            selectorIndex = 0;
            break;
          case PriceBreakdownForm.SELECTOR_TYPE_HOURLY:
            selectorIndex = 1;
            break;
          case PriceBreakdownForm.SELECTOR_TYPE_QUANTITY:
            selectorIndex = 2;
            break;
        }

        breakdownTypes = <int, Widget>{
          0: Text(PriceBreakdownForm.SELECTOR_TYPE_FLAT_RATE,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'simple',
              color: Color(selectorIndex == 0
                  ? ColorConstants.getPrimaryWhite()
                  : ColorConstants.getPrimaryBlack()),
            ),),
          1: Text(PriceBreakdownForm.SELECTOR_TYPE_HOURLY,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'simple',
              color: Color(selectorIndex == 1
                  ? ColorConstants.getPrimaryWhite()
                  : ColorConstants.getPrimaryBlack()),
            ),),
          2: Text(PriceBreakdownForm.SELECTOR_TYPE_QUANTITY,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'simple',
              color: Color(selectorIndex == 2
                  ? ColorConstants.getPrimaryWhite()
                  : ColorConstants.getPrimaryBlack()),
            ),),
        };

        if(appState.state.newInvoicePageState.selectedJob?.priceProfile != null){
          flatRateTextController = TextEditingController(text: '\$' + appState.state.newInvoicePageState.selectedJob.priceProfile.flatRate.toInt().toString());
          hourlyRateTextController = TextEditingController(text: '\$' + (appState.state.newInvoicePageState.selectedJob.priceProfile.hourlyRate.toInt() > 0 ? appState.state.newInvoicePageState.selectedJob.priceProfile.hourlyRate.toInt().toString() : ''));
          quantityRateTextController = TextEditingController(text: '\$' + (appState.state.newInvoicePageState.selectedJob.priceProfile.itemRate.toInt() > 0 ? appState.state.newInvoicePageState.selectedJob.priceProfile.itemRate.toInt().toString() : ''));
        }

        KeyboardVisibilityNotification().addNewListener(
            onShow: () {
              showOverlay(context);
            },
            onHide: () {
              removeOverlay();
            }
        );

        flatRateInputFocusNode.addListener(() {

          bool hasFocus = overlayEntry != null;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        hourlyRateInputFocusNode.addListener(() {

          bool hasFocus = overlayEntry != null;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        itemRateInputFocusNode.addListener(() {

          bool hasFocus = overlayEntry != null;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        itemQuantityFocusNode.addListener(() {

          bool hasFocus = overlayEntry != null;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });

        hourlyQuantityFocusNode.addListener(() {

          bool hasFocus = overlayEntry != null;
          if (hasFocus)
            showOverlay(context);
          else
            removeOverlay();
        });
      },
      onDidChange: (pageState) {
        switch(pageState.filterType){
          case RateTypeSelection.SELECTOR_TYPE_FLAT_RATE:
            selectorIndex = 0;
            break;
          case RateTypeSelection.SELECTOR_TYPE_HOURLY:
            selectorIndex = 1;
            break;
          case RateTypeSelection.SELECTOR_TYPE_QUANTITY:
            selectorIndex = 2;
            break;
        }
        flatRateTextController.text = pageState.flatRateText.length == 0 ? '\$' : '\$' + double.parse(pageState.flatRateText.replaceFirst(r'$', '')).toInt().toString();
        flatRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: flatRateTextController.text.length));
        hourlyRateTextController.text = pageState.hourlyRate.length == 0 ? '\$' : '\$' + double.parse(pageState.hourlyRate.replaceFirst(r'$', '')).toInt().toString();
        hourlyRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: hourlyRateTextController.text.length));
        quantityRateTextController.text = pageState.itemRate.length == 0 ? '\$' : '\$' + double.parse(pageState.itemRate.replaceFirst(r'$', '')).toInt().toString();
        quantityRateTextController.selection = TextSelection.fromPosition(TextPosition(offset: quantityRateTextController.text.length));
      },
      converter: (store) => NewInvoicePageState.fromStore(store),
      builder: (BuildContext context, NewInvoicePageState pageState) =>
      Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Price Breakdown',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.primary_black),
                ),
              ),
              Text(
                '(' + pageState.selectedJob.priceProfile.profileName + ') price package',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'simple',
                  fontWeight: FontWeight.w600,
                  color: Color(ColorConstants.getPrimaryColor()),
                ),
              ),
              Container(
                width: 300.0,
                margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0, bottom: 6.0),
                child: CupertinoSlidingSegmentedControl<int>(
                  backgroundColor: Colors.transparent,
                  thumbColor: Color(ColorConstants.getPrimaryColor()),
                  children: breakdownTypes,
                  onValueChanged: (int filterTypeIndex) {
                    pageState.onFilterChanged(
                        filterTypeIndex == 0 ? PriceBreakdownForm
                            .SELECTOR_TYPE_FLAT_RATE : filterTypeIndex == 1
                            ? PriceBreakdownForm.SELECTOR_TYPE_HOURLY
                            : PriceBreakdownForm.SELECTOR_TYPE_QUANTITY);
                    setState(() {
                      selectorIndex = filterTypeIndex;
                    });
                  },
                  groupValue: selectorIndex,
                ),
              ),
              selectorIndex == 0 ? Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: NewInvoiceTextField(
                  focusNode: flatRateInputFocusNode,
                  controller: flatRateTextController,
                  hintText: "\$",
                  inputType: TextInputType.number,
                  height: 64.0,
                  onTextInputChanged: pageState.onFlatRateTextChanged,
                  capitalization: TextCapitalization.none,
                  keyboardAction: TextInputAction.done,
                  labelText: 'Rate',
                ),
              ) : selectorIndex == 1 ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 126.0,
                        margin: EdgeInsets.only(left: 15.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          focusNode: hourlyRateInputFocusNode,
                          controller: hourlyRateTextController,
                          hintText: "\$",
                          inputType: TextInputType.number,
                          height: 64.0,
                          onTextInputChanged: pageState.onHourlyRateTextChanged,
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
                          tooltip: 'delete',
                          onPressed: null,
                        ),
                      ),
                      Container(
                        width: 126.0,
                        margin: EdgeInsets.only(right: 15.0, bottom: 16.0),
                        child: NewInvoiceTextField(
                          focusNode: hourlyQuantityFocusNode,
                          controller: hourlyQuantityTextController,
                          hintText: '',
                          inputType: TextInputType.number,
                          height: 64.0,
                          onTextInputChanged: pageState.onHourlyQuantityTextChanged,
                          capitalization: TextCapitalization.none,
                          keyboardAction: TextInputAction.done,
                          labelText: 'Hours',
                        ),
                      ),
                    ],
                  ):
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 126.0,
                    margin: EdgeInsets.only(left: 15.0),
                    child: NewInvoiceTextField(
                      focusNode: itemRateInputFocusNode,
                      controller: quantityRateTextController,
                      hintText: "\$",
                      inputType: TextInputType.number,
                      height: 64.0,
                      onTextInputChanged: pageState.onItemRateTextChanged,
                      capitalization: TextCapitalization.none,
                      keyboardAction: TextInputAction.done,
                      labelText: 'Rate',
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
                  Container(
                    width: 126.0,
                    margin: EdgeInsets.only(right: 15.0),
                    child: NewInvoiceTextField(
                      focusNode: itemQuantityFocusNode,
                      controller: quantityQuantityTextController,
                      hintText: '',
                      inputType: TextInputType.number,
                      height: 64.0,
                      onTextInputChanged: pageState.onItemQuantityTextChanged,
                      capitalization: TextCapitalization.none,
                      keyboardAction: TextInputAction.done,
                      labelText: 'Quantity',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneViewNewInvoice());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  void onAddNewContactPressed() {
    Navigator.of(context).pop();
    UserOptionsUtil.showNewContactDialog(context);
  }

  @override
  bool get wantKeepAlive => true;
}