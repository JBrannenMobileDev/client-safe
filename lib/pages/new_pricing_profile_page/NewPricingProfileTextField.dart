import 'package:client_safe/AppState.dart';
import 'package:client_safe/pages/new_contact_pages/NewContactPageState.dart';
import 'package:client_safe/pages/new_pricing_profile_page/NewPricingProfilePageState.dart';
import 'package:client_safe/utils/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class NewPricingProfileTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String hintText;
  final TextInputType inputType;
  final double height;
  final String inputTypeError;
  final Function(String) onTextInputChanged;
  final TextInputAction keyboardAction;
  final FocusNode focusNode;
  final Function onFocusAction;
  final TextCapitalization capitalization;
  final List<TextInputFormatter> inputFormatter;

  NewPricingProfileTextField(this._controller, this.hintText, this.inputType,
      this.height, this.onTextInputChanged, this.inputTypeError, this.keyboardAction,
      this.focusNode, this.onFocusAction, this.capitalization, this.inputFormatter);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NewPricingProfilePageState>(
      converter: (store) => NewPricingProfilePageState.fromStore(store),
      builder: (BuildContext context, NewPricingProfilePageState pageState) =>
          Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: height,
              child: TextFormField(
                focusNode: focusNode,
                textInputAction: keyboardAction,
                maxLines: 24,
                controller: _controller,
                onChanged: (text) {
                  onTextInputChanged(text);
                  pageState.onErrorStateChanged(NewContactPageState.NO_ERROR);
                },
                onFieldSubmitted: (term){
                  onFocusAction();
                },
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: hintText,
                  hintText: hintText,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: pageState.errorState !=
                                  NewContactPageState.NO_ERROR &&
                              inputTypeError == pageState.errorState
                          ? Colors.red
                          : Color(ColorConstants.getPrimaryColor()),
                      width: 1.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: pageState.errorState !=
                          NewContactPageState.NO_ERROR &&
                          inputTypeError == pageState.errorState
                          ? Colors.red
                          : Color(ColorConstants.getPrimaryColor()),
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: pageState.errorState !=
                          NewContactPageState.NO_ERROR &&
                          inputTypeError == pageState.errorState
                          ? Colors.red
                          : Color(ColorConstants.getPrimaryColor()),
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: inputType,
                textCapitalization: capitalization,
                inputFormatters: inputFormatter != null ? inputFormatter : null,
                style: new TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w600,
                    color:
                        pageState.errorState != NewContactPageState.NO_ERROR
                            && (inputTypeError == pageState.errorState
                            || inputTypeError == NewPricingProfilePageState.ERROR_PROFILE_NAME_MISSING)
                            ? Colors.red
                            : Color(ColorConstants.primary_black)),
              )),
    );
  }
}
